#!/usr/bin/env bash
# Version: 1.0.0 — first version: the tests of checks/launch.sh, the Launch the built bundle step's script
#
# checks/tests/test_launch.sh — the tests of checks/launch.sh.
#
# WHY THIS EXISTS
#   checks/launch.sh holds the rule the Launch the built bundle step used to carry inline: open the built
#   bundle once, then wait, for a fixed number of ticks, for the app's log to appear. A rule in a
#   workflow could not be run by a person or proved by a case; in a script it is both. These cases run
#   the REAL script, never a copy of its logic, from a scene that stands in for the product root, with a
#   recording `open`, a stand-in `sleep` and a temporary home. Nothing here launches a bundle or reads
#   the machine's home.
#   The technique is the shell packet's, minus its runner: this product has no Python, so the runner
#   is this file (docs/nfdr.md § 9 names the product's toolchains).
#
# USAGE
#   checks/tests/test_launch.sh
#   Refuses off a macOS virtual machine, as the script under test does (its refusal case is
#   test_refuses_off_vm_before_work, run here through the shared helper).
#
# THE CLOCK
#   The script waits with `sleep 0.25` in two places: the foreground loop that counts ticks, and the
#   child that polls for the log. The `sleep` on PATH here is a stand-in that returns at once but keeps
#   the two in step: it tells them apart by its parent (the foreground's is the script itself, whose pid
#   `open` records), numbers the foreground ticks, and lets the child's n-th poll happen only after the
#   foreground's n-th tick, and the foreground's n-th tick only after the child's (n-1)-th poll. So time
#   is fast, and a child that is slow to start cannot turn into a timeout. A case can create the log at
#   a chosen foreground tick, hold the child's first wait on a pipe that never fills (a file observation
#   that never returns), or make the last tick wait for the child to finish.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
LAUNCH_SH="$ROOT/checks/launch.sh"
# shellcheck source=checks/tests/support/vm_refusal.sh
source "$ROOT/checks/tests/support/vm_refusal.sh"

APP_PATH="target/release/bundle/macos/KA-Reader.app"
LOG_TAIL="Library/Containers/com.kensaiapp.ka-reader/Data/Library/Logs/ka-reader.log"
TICKS=240

WORK=""
SCENE=""
LOG=""
SCENE_COUNT=0
OUT=""
ERR=""
STATUS=0

CASES="
test_refuses_off_vm_before_work
test_admits_on_a_vm_reading
test_launches_the_built_bundle_once
test_already_present_log_succeeds
test_log_created_at_tick_12_succeeds
test_reader_completing_on_the_last_tick_succeeds
test_conflicting_inherited_timer_values_change_nothing
test_no_log_times_out_at_240_ticks
test_blocked_file_observation_times_out
test_timeout_leaves_no_reader_or_sleeper
test_open_failure_keeps_a_red_exit_and_starts_no_reader
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# A fresh scene: the product root (cwd), a home, and a PATH of stand-ins ahead of ordinary tools.
# Sets SCENE and LOG. $1 is the exit status the recording `open` gives (default 0).
new_scene() {
  SCENE_COUNT=$((SCENE_COUNT + 1))
  # Each case runs in its own subshell, so the count restarts: a scene is cleared before it is made.
  SCENE="$WORK/scene$SCENE_COUNT"
  rm -rf "$SCENE"
  mkdir -p "$SCENE/cwd" "$SCENE/bin" "$SCENE/home"
  LOG="$SCENE/home/$LOG_TAIL"
  : > "$SCENE/fg"
  : > "$SCENE/rd"
  : > "$SCENE/fg_args"
  : > "$SCENE/rd_sleepers"
  : > "$SCENE/rd_args"
  : > "$SCENE/open_calls"
  vmr_install_ordinary "$SCENE/ordinary"
  vmr_install_admission "$SCENE/bin"
  write_open "${1:-0}"
  write_sleep
  mkfifo "$SCENE/fifo"
}

# `open` records its arguments and its parent, which is the script under test.
write_open() {
  cat > "$SCENE/bin/open" <<EOF
#!/bin/bash
printf '%s\n' "\$*" >> '$SCENE/open_calls'
printf '%s' "\$PPID" > '$SCENE/main_pid'
exit $1
EOF
  chmod +x "$SCENE/bin/open"
}

# The stand-in clock; see THE CLOCK above. Its behaviour is chosen by marker files in the scene:
#   lockstep    the two waiters keep step (set by default)
#   create_at   a foreground tick number at which the log is created
#   finish_at   with create_at: that tick returns only once the child has finished
#   block       the child's first wait never returns
write_sleep() {
  cat > "$SCENE/bin/sleep" <<EOF
#!/bin/bash
S='$SCENE'
LOG='$LOG'
count() { local n; n=\$(wc -l < "\$1"); echo \$((n + 0)); }
if [ "\$PPID" = "\$(cat "\$S/main_pid" 2> /dev/null)" ]; then
  n=\$((\$(count "\$S/fg") + 1))
  printf '%s\n' "\$*" >> "\$S/fg_args"
  if [ -f "\$S/lockstep" ]; then
    while [ "\$(count "\$S/rd")" -lt \$((n - 1)) ] && kill -0 "\$(cat "\$S/rd_pid" 2> /dev/null)" 2> /dev/null; do
      /bin/sleep 0.002
    done
  fi
  if [ "\$n" = "\$(cat "\$S/create_at" 2> /dev/null)" ]; then
    mkdir -p "\$(dirname "\$LOG")"
    : > "\$LOG"
  fi
  echo "\$n" >> "\$S/fg"
  if [ -f "\$S/finish_at" ] && [ "\$n" = "\$(cat "\$S/create_at")" ]; then
    while kill -0 "\$(cat "\$S/rd_pid")" 2> /dev/null; do
      /bin/sleep 0.002
    done
  fi
else
  echo "\$\$" >> "\$S/rd_sleepers"
  printf '%s\n' "\$*" >> "\$S/rd_args"
  echo "\$PPID" > "\$S/rd_pid"
  if [ -f "\$S/block" ]; then
    read -r _ < "\$S/fifo"
  fi
  echo x >> "\$S/rd"
  m=\$(count "\$S/rd")
  if [ -f "\$S/lockstep" ]; then
    while [ "\$(count "\$S/fg")" -lt "\$m" ]; do
      /bin/sleep 0.002
    done
  fi
fi
exit 0
EOF
  chmod +x "$SCENE/bin/sleep"
  : > "$SCENE/lockstep"
}

# Runs the real script bare, from the scene's product root, with a home of its own and nothing the
# workflow would set. Extra environment as arguments. Sets STATUS, OUT and ERR.
run_launch() {
  (
    cd "$SCENE/cwd" || exit 99
    exec /usr/bin/env -i PATH="$SCENE/bin:$SCENE/ordinary" HOME="$SCENE/home" "$@" "$LAUNCH_SH"
  ) > "$SCENE/out" 2> "$SCENE/err"
  STATUS=$?
  OUT="$(cat "$SCENE/out")"
  ERR="$(cat "$SCENE/err")"
}

present_log() {
  mkdir -p "$(dirname "$LOG")"
  : > "$LOG"
}

fg_ticks() {
  wc -l < "$SCENE/fg" | tr -d ' '
}

timeout_line() {
  printf "ci: no log appeared at %s within 240 ticks of 0.25s. Reading the app's own container is known to wait on an operating-system consent prompt." "$LOG"
}

expect_status() {
  [ "$STATUS" -eq "$1" ] || fail "expected exit $1, got $STATUS. stdout: $OUT; stderr: $ERR"
}

# No `ci:` line and nothing else on stderr, nothing on stdout.
expect_silent() {
  [ -z "$ERR" ] || fail "expected nothing on stderr, got: $ERR" || return 1
  [ -z "$OUT" ] || fail "expected nothing on stdout, got: $OUT"
}

expect_timeout_line_only() {
  [ "$ERR" = "$(timeout_line)" ] || fail "expected only the timeout line on stderr. got: $ERR" || return 1
  [ -z "$OUT" ] || fail "expected nothing on stdout, got: $OUT"
}

# Every foreground wait was 0.25 seconds.
expect_quarter_second_ticks() {
  odd="$(grep -v -x '0.25' "$SCENE/fg_args" || true)"
  [ -z "$odd" ] || fail "a foreground wait was not 0.25 seconds: $odd"
}

# CP-793: the child looks for the log every 0.25 seconds — every wait it made between two looks was 0.25.
expect_quarter_second_polls() {
  [ -s "$SCENE/rd_args" ] || fail "the child never waited between two looks, so nothing was checked" || return 1
  odd="$(grep -v -x '0.25' "$SCENE/rd_args" || true)"
  [ -z "$odd" ] || fail "a wait of the child's between two looks was not 0.25 seconds: $odd"
}

# No process this run started is still alive: the child that polls, and every wait it made.
expect_nothing_left_running() {
  for pid in $(cat "$SCENE/rd_sleepers" "$SCENE/rd_pid" 2> /dev/null); do
    waited=0
    while kill -0 "$pid" 2> /dev/null; do
      waited=$((waited + 1))
      [ "$waited" -lt 200 ] || fail "process $pid is still running after the script ended" || return 1
      /bin/sleep 0.01
    done
  done
}

# --- cases ---

# QC-65 (CP-797, CP-799): off a macOS virtual machine launch.sh prints its one refusal line and does
# nothing else — no `open`, no log predicate, no timer wait, no `ci:` line — whatever it is given.
test_refuses_off_vm_before_work() {
  VMR_TMP="$WORK"
  scene="$WORK/refusal-scene"
  mkdir -p "$scene"
  VMR_SCENE="$scene"
  VMR_ENV=()

  vmr_assert_refusal "$LAUNCH_SH" launch.sh || return 1
  vmr_assert_refusal "$LAUNCH_SH" launch.sh --anything "an argument" || return 1
  for ticks in 1 0 abc ""; do
    VMR_ENV=("CONTAINER_WAIT_TICKS=$ticks")
    vmr_assert_refusal "$LAUNCH_SH" launch.sh || return 1
  done
}

# CP-798/CP-800: on a virtual machine's reading the admission adds no line and changes no verdict.
test_admits_on_a_vm_reading() {
  new_scene
  present_log
  run_launch

  expect_status 0 || return 1
  case "$ERR" in
    *refused*) fail "a refusal line appeared on a virtual machine's reading: $ERR" || return 1 ;;
  esac
  expect_silent
}

# CP-792: the built bundle is launched once, through `open`, by its path from the product root, with
# no environment the workflow set.
test_launches_the_built_bundle_once() {
  new_scene
  present_log
  run_launch

  expect_status 0 || return 1
  [ "$(cat "$SCENE/open_calls")" = "$APP_PATH" ] \
    || fail "expected exactly one open of $APP_PATH. calls: $(cat "$SCENE/open_calls")"
}

# CP-793: a log already there is a successful observation.
test_already_present_log_succeeds() {
  new_scene
  present_log
  run_launch

  expect_status 0 || return 1
  expect_silent
}

# CP-793: a log that appears at foreground tick 12 succeeds, and says nothing.
test_log_created_at_tick_12_succeeds() {
  new_scene
  echo 12 > "$SCENE/create_at"
  run_launch

  expect_status 0 || return 1
  expect_silent || return 1
  [ -f "$LOG" ] || fail "the stand-in clock never created the log"
}

# CP-793: a child that finishes at the last permitted observation is a success, not a timeout. The last
# tick returns only once the child has finished, so the outcome does not depend on scheduling.
test_reader_completing_on_the_last_tick_succeeds() {
  new_scene
  echo "$TICKS" > "$SCENE/create_at"
  : > "$SCENE/finish_at"
  run_launch

  expect_status 0 || return 1
  expect_silent || return 1
  [ "$(fg_ticks)" -eq "$TICKS" ] || fail "expected $TICKS foreground ticks, got $(fg_ticks)"
}

# CP-795: the bound lives in the script. Other inherited values change nothing.
test_conflicting_inherited_timer_values_change_nothing() {
  for value in 3 1000 0 abc; do
    new_scene
    run_launch "CONTAINER_WAIT_TICKS=$value"

    expect_status 1 || return 1
    expect_timeout_line_only || return 1
    [ "$(fg_ticks)" -eq "$TICKS" ] || fail "CONTAINER_WAIT_TICKS=$value: expected $TICKS foreground ticks, got $(fg_ticks)" || return 1
  done
}

# CP-793: no log in 240 ticks of 0.25 seconds: the exact line, with the home written out, and exit 1.
test_no_log_times_out_at_240_ticks() {
  new_scene
  run_launch

  expect_status 1 || return 1
  expect_timeout_line_only || return 1
  [ "$(fg_ticks)" -eq "$TICKS" ] || fail "expected $TICKS foreground ticks, got $(fg_ticks)" || return 1
  expect_quarter_second_ticks || return 1
  expect_quarter_second_polls
}

# CP-793: a file observation that never returns does not stop the count. The child's first wait blocks on
# a pipe nothing writes, and the foreground still reaches the bound, with the same line and exit 1.
test_blocked_file_observation_times_out() {
  new_scene
  rm -f "$SCENE/lockstep"
  : > "$SCENE/block"
  run_launch

  expect_status 1 || return 1
  expect_timeout_line_only || return 1
  [ "$(fg_ticks)" -eq "$TICKS" ] || fail "expected $TICKS foreground ticks, got $(fg_ticks)" || return 1
  expect_quarter_second_ticks
}

# CP-793: after a timeout nothing is left running, the child's pending wait included, and the shell
# adds no job-control diagnostic to stderr (the timeout line is the whole of it).
test_timeout_leaves_no_reader_or_sleeper() {
  new_scene
  run_launch

  expect_status 1 || return 1
  expect_timeout_line_only || return 1
  [ -s "$SCENE/rd_sleepers" ] || fail "the child never waited, so the case proves nothing" || return 1
  expect_nothing_left_running || return 1

  new_scene
  rm -f "$SCENE/lockstep"
  : > "$SCENE/block"
  run_launch

  expect_status 1 || return 1
  expect_timeout_line_only || return 1
  expect_nothing_left_running
}

# CP-793: an `open` that fails keeps a red exit and starts no child that reads the home.
test_open_failure_keeps_a_red_exit_and_starts_no_reader() {
  new_scene 3
  run_launch

  [ "$(cat "$SCENE/open_calls")" = "$APP_PATH" ] || fail "open was not called with $APP_PATH. calls: $(cat "$SCENE/open_calls")" || return 1
  [ "$STATUS" -eq 3 ] || fail "expected open's own red exit, 3, got $STATUS. stderr: $ERR" || return 1
  [ ! -s "$SCENE/rd_sleepers" ] || fail "a child was started after open failed" || return 1
  [ "$(fg_ticks)" -eq 0 ] || fail "the script waited after open failed" || return 1
  case "$ERR" in
    *"ci:"*) fail "a ci: line was printed for an open failure: $ERR" ;;
  esac
}

# --- the runner ---

WORK="$(mktemp -d)"
cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

failed=0
total=0
for case_name in $CASES; do
  total=$((total + 1))
  if result="$("$case_name" 2>&1)"; then
    echo "ok   $case_name"
  else
    echo "FAIL $case_name"
    [ -z "$result" ] || echo "$result"
    failed=$((failed + 1))
  fi
done

echo "$((total - failed)) of $total passed"
[ "$failed" -eq 0 ]

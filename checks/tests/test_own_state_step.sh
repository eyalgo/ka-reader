#!/usr/bin/env bash
# Version: 1.0.0 — first version: the tests of checks/own-state-step.sh, the Own state step's script
#
# checks/tests/test_own_state_step.sh — the tests of checks/own-state-step.sh.
#
# WHY THIS EXISTS
#   checks/own-state-step.sh holds the rule the Own state step used to carry inline: run
#   checks/own-state.sh, and give up on it after a fixed number of ticks. It adds no admission of its own
#   and no line of its own except the one for a run that gave up. These cases run the REAL step script,
#   never a copy of its logic, from a scene that stands in for the product root. The scene's
#   checks/own-state.sh is a stand-in child that behaves as each case needs, except in
#   test_real_child_refusal_off_vm, where it is a copy of the real script's bytes. Nothing here reads the
#   machine's home.
#   The technique is the shell packet's, minus its runner: this product has no Python, so the runner
#   is this file (docs/nfdr.md § 9 names the product's toolchains).
#
# USAGE
#   checks/tests/test_own_state_step.sh
#   Runs on any host: the script under test has no admission of its own, and the child is a stand-in
#   or refuses by itself.
#
# THE CLOCK
#   The step waits with `sleep 0.25` in one place, the foreground loop that counts ticks. The `sleep` on
#   PATH here is a stand-in that returns at once and keeps the foreground and the child in step: tick 1
#   returns only once the child has started (so a slow start cannot turn into a timeout), and a case can
#   make a chosen tick return only once the child has finished, with the child finishing only after that
#   tick has been counted. So time is fast and the outcome never depends on scheduling.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
STEP_SH="$ROOT/checks/own-state-step.sh"
REAL_OWN_STATE_SH="$ROOT/checks/own-state.sh"
# shellcheck source=checks/tests/support/vm_refusal.sh
source "$ROOT/checks/tests/support/vm_refusal.sh"

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
test_child_success_is_forwarded
test_child_condition_failure_is_forwarded
test_child_other_nonzero_status_is_forwarded
test_real_child_refusal_off_vm
test_child_finishing_on_the_last_tick_returns_its_result
test_hung_reader_times_out_at_240_ticks
test_timeout_stops_the_reader_and_its_descendants
test_completion_before_the_bound_never_enters_cleanup
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# A fresh scene: the product root (cwd) holding checks/, a home, and a PATH of stand-ins ahead of the
# ordinary tools. Sets SCENE and LOG.
new_scene() {
  # Each case runs in its own subshell, so the count restarts: a scene is cleared before it is made.
  SCENE_COUNT=$((SCENE_COUNT + 1))
  SCENE="$WORK/scene$SCENE_COUNT"
  rm -rf "$SCENE"
  mkdir -p "$SCENE/cwd/checks" "$SCENE/bin" "$SCENE/home"
  LOG="$SCENE/home/$LOG_TAIL"
  : > "$SCENE/fg"
  : > "$SCENE/fg_args"
  : > "$SCENE/descendants"
  vmr_install_ordinary "$SCENE/ordinary"
  vmr_install_admission "$SCENE/bin"
  write_sleep
  mkfifo "$SCENE/fifo"
}

# The stand-in clock; see THE CLOCK above. Marker file in the scene: finish_at, a tick number.
write_sleep() {
  cat > "$SCENE/bin/sleep" <<EOF
#!/bin/bash
S='$SCENE'
count() { local n; n=\$(wc -l < "\$1"); echo \$((n + 0)); }
n=\$((\$(count "\$S/fg") + 1))
printf '%s\n' "\$*" >> "\$S/fg_args"
if [ "\$n" = 1 ]; then
  while [ ! -s "\$S/pid" ]; do
    /bin/sleep 0.002
  done
fi
echo "\$n" >> "\$S/fg"
if [ -f "\$S/finish_at" ] && [ "\$n" = "\$(cat "\$S/finish_at")" ]; then
  while kill -0 "\$(cat "\$S/pid")" 2> /dev/null; do
    /bin/sleep 0.002
  done
fi
exit 0
EOF
  chmod +x "$SCENE/bin/sleep"
}

# The stand-in child, checks/own-state.sh in the scene. The body ($1) is what the case needs it to do;
# it first records its own pid.
write_child() {
  {
    echo '#!/bin/bash'
    echo "S='$SCENE'"
    echo 'echo "$$" > "$S/pid"'
    printf '%s\n' "$1"
  } > "$SCENE/cwd/checks/own-state.sh"
  chmod +x "$SCENE/cwd/checks/own-state.sh"
}

# Runs the real step script from the scene's product root with a home of its own. Extra environment as
# arguments. Sets STATUS, OUT and ERR.
run_step() {
  (
    cd "$SCENE/cwd" || exit 99
    exec /usr/bin/env -i PATH="$SCENE/bin:$SCENE/ordinary" HOME="$SCENE/home" "$@" "$STEP_SH"
  ) > "$SCENE/out" 2> "$SCENE/err"
  STATUS=$?
  OUT="$(cat "$SCENE/out")"
  ERR="$(cat "$SCENE/err")"
}

fg_ticks() {
  wc -l < "$SCENE/fg" | tr -d ' '
}

timeout_line() {
  printf "ci: checks/own-state.sh did not finish reading %s within 240 ticks of 0.25s. Reading the app's own container is known to wait on an operating-system consent prompt." "$LOG"
}

expect_status() {
  [ "$STATUS" -eq "$1" ] || fail "expected exit $1, got $STATUS. stdout: $OUT; stderr: $ERR"
}

expect_no_ci_line() {
  case "$ERR$OUT" in
    *"ci:"*) fail "a ci: line appeared. stdout: $OUT; stderr: $ERR" ;;
  esac
}

expect_timeout_line_only() {
  [ "$ERR" = "$(timeout_line)" ] || fail "expected only the timeout line on stderr. got: $ERR" || return 1
  [ -z "$OUT" ] || fail "expected nothing on stdout, got: $OUT"
}

# Every process a hung child started has stopped: the child itself and what it spawned.
expect_nothing_left_running() {
  for pid in $(cat "$SCENE/pid" "$SCENE/descendants" 2> /dev/null); do
    waited=0
    while kill -0 "$pid" 2> /dev/null; do
      waited=$((waited + 1))
      [ "$waited" -lt 200 ] || fail "process $pid is still running after the step ended" || return 1
      /bin/sleep 0.01
    done
  done
}

# A child that never finishes: it spawns a descendant doing the read, then blocks on a pipe nothing fills.
hung_child() {
  write_child '( exec /bin/sleep 600 ) &
echo "$!" >> "$S/descendants"
read -r _ < "$S/fifo"'
}

# --- cases ---

# CP-794: a child that succeeds: its stdout and status come through byte for byte, with no line added.
test_child_success_is_forwarded() {
  new_scene
  write_child 'echo "own state holds"'
  run_step

  expect_status 0 || return 1
  [ "$OUT" = "own state holds" ] || fail "stdout not forwarded. got: $OUT" || return 1
  [ -z "$ERR" ] || fail "expected nothing on stderr, got: $ERR" || return 1
  expect_no_ci_line
}

# CP-794: a child that fails a condition: its stream and status come through, with no line added.
test_child_condition_failure_is_forwarded() {
  new_scene
  write_child 'echo "own-state.sh: condition 1 failed: no log file at /somewhere" >&2
exit 1'
  run_step

  expect_status 1 || return 1
  [ "$ERR" = "own-state.sh: condition 1 failed: no log file at /somewhere" ] || fail "stderr not forwarded. got: $ERR" || return 1
  [ -z "$OUT" ] || fail "expected nothing on stdout, got: $OUT" || return 1
  expect_no_ci_line
}

# CP-794: any other non-zero status is the step's own.
test_child_other_nonzero_status_is_forwarded() {
  new_scene
  write_child 'exit 7'
  run_step

  expect_status 7 || return 1
  [ -z "$ERR$OUT" ] || fail "expected no output. stdout: $OUT; stderr: $ERR"
}

# CP-794/CP-796: the real guarded child on physical-host stand-ins: only its own refusal line, exit 1, and
# no line from the step - no wrapper refusal, no timeout.
test_real_child_refusal_off_vm() {
  new_scene
  cp "$REAL_OWN_STATE_SH" "$SCENE/cwd/checks/own-state.sh"
  vmr_install_standins "$SCENE/bin" "$SCENE/log" physical
  # The recorded stand-ins for compile and probe tools would shadow `sleep`; the step needs the clock.
  write_sleep
  echo 0 > "$SCENE/pid"
  run_step

  expect_status 1 || return 1
  [ "$ERR" = "$(vmr_expected_line own-state.sh)" ] || fail "expected only the child's refusal line. got: $ERR" || return 1
  [ -z "$OUT" ] || fail "expected nothing on stdout, got: $OUT" || return 1
  expect_no_ci_line
}

# CP-794: a child that finishes on the last tick returns its result, with no timeout. The last tick
# returns only once the child has finished, and the child finishes only after that tick is counted.
test_child_finishing_on_the_last_tick_returns_its_result() {
  new_scene
  echo "$TICKS" > "$SCENE/finish_at"
  write_child 'while [ "$(wc -l < "$S/fg")" -lt 240 ]; do
  /bin/sleep 0.002
done
echo "late result"
exit 4'
  run_step

  expect_status 4 || return 1
  [ "$OUT" = "late result" ] || fail "stdout not forwarded. got: $OUT" || return 1
  expect_no_ci_line || return 1
  [ "$(fg_ticks)" -eq "$TICKS" ] || fail "expected $TICKS foreground ticks, got $(fg_ticks)"
}

# CP-794: a child that never finishes is given up on after 240 ticks of 0.25 seconds, whatever the
# workflow's environment or an inherited timer value says: the exact line (the home written out), exit 1.
test_hung_reader_times_out_at_240_ticks() {
  for value in none 3 1000; do
    new_scene
    hung_child
    if [ "$value" = none ]; then
      run_step
    else
      run_step "CONTAINER_WAIT_TICKS=$value"
    fi

    expect_status 1 || return 1
    expect_timeout_line_only || return 1
    [ "$(fg_ticks)" -eq "$TICKS" ] || fail "CONTAINER_WAIT_TICKS=$value: expected $TICKS foreground ticks, got $(fg_ticks)" || return 1
    odd="$(grep -v -x '0.25' "$SCENE/fg_args" || true)"
    [ -z "$odd" ] || fail "a foreground wait was not 0.25 seconds: $odd" || return 1
  done
}

# CP-794: a timeout stops the reader and what it spawned, and the shell adds no job-control diagnostic
# (the timeout line is the whole of stderr).
test_timeout_stops_the_reader_and_its_descendants() {
  new_scene
  hung_child
  run_step

  expect_status 1 || return 1
  expect_timeout_line_only || return 1
  [ -s "$SCENE/descendants" ] || fail "the child spawned nothing, so the case proves nothing" || return 1
  expect_nothing_left_running
}

# CP-794: a child that finishes before the bound is never cleaned up after: what it left running is left
# running, which is what no termination attempt looks like from outside. (The child spawns a detached wait
# of its own, finishes, and that wait must still be alive when the step has returned.)
test_completion_before_the_bound_never_enters_cleanup() {
  new_scene
  write_child '( exec /bin/sleep 30 ) &
echo "$!" >> "$S/descendants"
echo "done"'
  run_step

  expect_status 0 || return 1
  [ "$OUT" = "done" ] || fail "stdout not forwarded. got: $OUT" || return 1
  expect_no_ci_line || return 1
  leftover="$(cat "$SCENE/descendants")"
  alive=1
  kill -0 "$leftover" 2> /dev/null || alive=0
  kill -KILL "$leftover" 2> /dev/null
  [ "$alive" -eq 1 ] || fail "the child's own process $leftover was stopped though the child finished in time"
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

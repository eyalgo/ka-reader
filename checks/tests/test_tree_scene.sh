#!/usr/bin/env bash
# Version: 1.0.0 — first version: the tests of checks/tree-scene.sh, the built-app helper for the
#   tree-follows-the-disk walk
#
# checks/tests/test_tree_scene.sh — the tests of checks/tree-scene.sh.
#
# WHY THIS EXISTS
#   checks/tree-scene.sh launches the built KA-Reader.app, stages a copy of checks/fixtures/tree-scene,
#   churns the copy for thirty seconds and prints what is on disk at quiescence, so a person can
#   compare the open tree with it (docs/nfdr.md QC-66, SDD § 6 S-5). No command can watch the app's
#   window, so what a command can hold is the helper's own contract: it refuses off a macOS virtual
#   machine, launches once, touches only its scratch copy, prints the fresh listings in the tree's
#   order, and stops only the pid it recorded. These cases run the REAL script, never a copy of its
#   logic, with `uname`, `sysctl`, `open`, `ps`, `kill` and `sleep` as stand-ins on PATH and a
#   temporary home and temporary directory. Nothing here launches a bundle or reads the machine's
#   home. The technique is the shell packet's, minus its runner: this product has no Python, so the
#   runner is this file.
#
# USAGE
#   checks/tests/test_tree_scene.sh
#   Runs on any host: every host reading is a stand-in, `open` only records, `ps` is a script, and
#   the clock returns at once. The script under test refuses off a macOS virtual machine; its
#   refusal case is test_off_a_vm_it_exits_non_zero_having_launched_nothing_and_copied_nothing.
#
# THE STAND-INS
#   open   records its arguments and marks the app as opened.
#   ps     lists a bystander, another instance of the same executable (pid 4243) and an unrelated
#          process; once `open` has run it lists the one the helper launched (pid 4242) as well.
#   kill   records its arguments; once told to stop a pid it reports that pid gone.
#   sleep  records its argument and returns at once. In the signal case its first start wait holds
#          for two real seconds, long enough to send the script a signal there.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TREE_SCENE_SH="$ROOT/checks/tree-scene.sh"
FIXTURE="$ROOT/checks/fixtures/tree-scene"
# shellcheck source=checks/tests/support/vm_refusal.sh
source "$ROOT/checks/tests/support/vm_refusal.sh"

LAUNCHED_PID=4242
BYSTANDER_PID=4243

WORK=""
SCENE=""
APP=""
SCENE_COUNT=0
STATUS=0

CASES="
test_off_a_vm_it_exits_non_zero_having_launched_nothing_and_copied_nothing
test_in_a_vm_it_launches_once_and_churns_only_the_scratch_copy
test_it_prints_the_fresh_listings_at_quiescence
test_it_stops_only_its_own_pid_on_a_normal_exit_and_on_a_signal
test_a_missing_argument_or_executable_launches_nothing
test_a_launch_that_starts_no_process_ends_the_run_and_stops_nothing
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# A fresh scene: a fake app with its one executable, a home, a temporary directory, a working
# directory, and a PATH of stand-ins ahead of ordinary tools. Sets SCENE and APP.
new_scene() {
  SCENE_COUNT=$((SCENE_COUNT + 1))
  SCENE="$WORK/scene$SCENE_COUNT"
  rm -rf "$SCENE"
  mkdir -p "$SCENE/cwd" "$SCENE/bin" "$SCENE/home" "$SCENE/tmp"
  APP="$SCENE/App.app"
  mkdir -p "$APP/Contents/MacOS"
  : > "$APP/Contents/MacOS/Fake-Exe"
  chmod +x "$APP/Contents/MacOS/Fake-Exe"
  : > "$SCENE/open_calls"
  : > "$SCENE/sleeps"
  : > "$SCENE/kill_log"
  vmr_install_ordinary "$SCENE/ordinary"
  vmr_install_admission "$SCENE/bin"
  write_open
  write_ps
  write_kill
  write_sleep
}

write_open() {
  cat > "$SCENE/bin/open" <<EOF
#!/bin/bash
printf '%s\n' "\$*" >> '$SCENE/open_calls'
: > '$SCENE/opened'
exit 0
EOF
  chmod +x "$SCENE/bin/open"
}

write_ps() {
  cat > "$SCENE/bin/ps" <<EOF
#!/bin/bash
printf '%s\n' '9999 /usr/bin/other'
printf '%s\n' '$BYSTANDER_PID $APP/Contents/MacOS/Fake-Exe'
if [ -f '$SCENE/opened' ] && [ ! -f '$SCENE/no_new_process' ]; then
  printf '%s\n' '$LAUNCHED_PID $APP/Contents/MacOS/Fake-Exe'
fi
exit 0
EOF
  chmod +x "$SCENE/bin/ps"
}

write_kill() {
  cat > "$SCENE/bin/kill" <<EOF
#!/bin/bash
printf '%s\n' "\$*" >> '$SCENE/kill_log'
for last in "\$@"; do :; done
if [ "\$1" = "-0" ]; then
  [ ! -f '$SCENE/gone_'"\$last" ]
  exit \$?
fi
: > '$SCENE/gone_'"\$last"
exit 0
EOF
  chmod +x "$SCENE/bin/kill"
}

write_sleep() {
  cat > "$SCENE/bin/sleep" <<EOF
#!/bin/bash
printf '%s\n' "\$*" >> '$SCENE/sleeps'
if [ -f '$SCENE/hold_start_wait' ] && [ "\$1" = "5" ]; then
  /bin/sleep 2
fi
exit 0
EOF
  chmod +x "$SCENE/bin/sleep"
}

# The helper's argument vector for the scene, then one run of it: stdout to $SCENE/out, stderr to
# $SCENE/err, the status in STATUS. The environment holds only the stand-ins' PATH, the scene's
# home and the scene's temporary directory.
run_helper() {
  (
    cd "$SCENE/cwd" || exit 99
    exec /usr/bin/env -i PATH="$SCENE/bin:$SCENE/ordinary" HOME="$SCENE/home" TMPDIR="$SCENE/tmp" \
      "$TREE_SCENE_SH" "$@"
  ) > "$SCENE/out" 2> "$SCENE/err"
  STATUS=$?
}

# How many times the clock stand-in was asked for exactly $1.
sleeps_of() {
  grep -c -x -F -e "$1" "$SCENE/sleeps" || true
}

# Fails unless every call the kill stand-in saw named the launched pid alone, and it was asked to
# stop it.
assert_only_the_launched_pid_was_stopped() {
  grep -q -x -F -e "-TERM $LAUNCHED_PID" "$SCENE/kill_log" \
    || fail "the launched pid $LAUNCHED_PID was never told to stop. kill saw: $(cat "$SCENE/kill_log")" || return 1
  others="$(grep -v -x -F -e "-0 $LAUNCHED_PID" -e "-TERM $LAUNCHED_PID" -e "-KILL $LAUNCHED_PID" "$SCENE/kill_log" || true)"
  [ -z "$others" ] || fail "kill was called for something other than the launched pid: $others"
}

# The listings the helper must print once the churn is done: the fixture, then the ten churn steps
# applied to it, each folder in the tree's order (folders first, then files, each by lowercase
# name) and a folder's entries right after it.
expected_listings() {
  cat <<'EOF'
.:
  docs/
  notes/
  reading/
  src/
  .scene-note
  README.txt
docs:
  draft.md
  guide.md
notes:
  n3.txt
reading:
  extra.md
  late.md
  long.md
src:
  extra/
  nested/
  newer/
  a.rs
src/extra:
  moved.rs
  x.txt
src/nested:
  deep/
src/nested/deep:
  d.rs
  e.rs
  stage1.txt
src/newer:
  n.rs
EOF
}

# --- cases ---

# QC-65, E19: off a macOS virtual machine the helper prints its one refusal line and does nothing
# else, on every refusing reading: nothing is launched, nothing is copied into the temporary
# directory, nothing is written to the home or the working directory, and the fixture is unchanged.
test_off_a_vm_it_exits_non_zero_having_launched_nothing_and_copied_nothing() {
  new_scene
  VMR_TMP="$WORK"
  VMR_SCENE="$SCENE/tmp"
  VMR_ENV=("TMPDIR=$SCENE/tmp")
  fixture_before="$(vmr_snapshot "$FIXTURE")"
  vmr_assert_refusal "$TREE_SCENE_SH" tree-scene.sh "$APP" || return 1
  [ "$(vmr_snapshot "$FIXTURE")" = "$fixture_before" ] || fail "the refused run changed the fixture"
}

# E19: on a virtual machine's reading the helper opens the bundle once, as `open -n -g`, finds the
# process that came with it, stages the fixture in the temporary directory, and runs the churn
# there. The fixture, the home and the working directory are left as they were.
test_in_a_vm_it_launches_once_and_churns_only_the_scratch_copy() {
  new_scene
  fixture_before="$(vmr_snapshot "$FIXTURE")"
  home_before="$(vmr_snapshot "$SCENE/home")"
  cwd_before="$(vmr_snapshot "$SCENE/cwd")"

  run_helper "$APP"

  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  [ "$(cat "$SCENE/open_calls")" = "-n -g $APP" ] \
    || fail "open was not called exactly once as 'open -n -g <app>': $(cat "$SCENE/open_calls")" || return 1
  scratch="$(sed -n 's/^tree-scene.sh: choose this folder in the app: //p' "$SCENE/err")"
  case "$scratch" in
    "$SCENE/tmp/"*) ;;
    *) fail "the folder to choose is not under the temporary directory: '$scratch'. stderr: $(cat "$SCENE/err")" || return 1 ;;
  esac
  grep -q -x 'tree-scene.sh: the churn starts in 60 seconds' "$SCENE/err" \
    || fail "stderr does not say when the churn starts. stderr: $(cat "$SCENE/err")" || return 1
  # Ten steps of three seconds make the thirty-second churn; twelve waits of five make the lead-in.
  [ "$(sleeps_of 3)" -eq 10 ] || fail "the churn is not ten steps of three seconds: $(sleeps_of 3) found" || return 1
  [ "$(sleeps_of 5)" -eq 12 ] || fail "the lead-in is not twelve waits of five seconds: $(sleeps_of 5) found" || return 1
  grep -q 'stage1.txt' "$SCENE/out" || fail "the churn left no trace in the printed listings, so it did not run" || return 1
  [ "$(vmr_snapshot "$FIXTURE")" = "$fixture_before" ] || fail "the churn changed the fixture itself" || return 1
  [ "$(vmr_snapshot "$SCENE/home")" = "$home_before" ] || fail "the run changed the home" || return 1
  [ "$(vmr_snapshot "$SCENE/cwd")" = "$cwd_before" ] || fail "the run changed the working directory"
}

# After the churn the helper waits out a quiet interval, then prints a fresh listing of every folder
# of the scratch copy, read from disk then, in the tree's order. The quiet interval is two waits of
# four seconds, after the ten of three.
test_it_prints_the_fresh_listings_at_quiescence() {
  new_scene

  run_helper "$APP"

  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  expected_listings > "$SCENE/expected"
  cmp -s "$SCENE/expected" "$SCENE/out" \
    || fail "the printed listings differ from the expected ones. got: $(cat "$SCENE/out")" || return 1
  [ "$(sleeps_of 4)" -eq 2 ] || fail "the quiet interval is not two waits of four seconds: $(sleeps_of 4) found"
}

# E19: the helper stops the pid it recorded and no other, when it ends normally and when it is sent
# SIGTERM during the lead-in. The bystander (another instance of the same executable) and the
# unrelated process are never named to `kill`, and the scratch copy is gone either way.
test_it_stops_only_its_own_pid_on_a_normal_exit_and_on_a_signal() {
  new_scene
  run_helper "$APP"
  [ "$STATUS" -eq 0 ] || fail "normal exit: expected 0, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  assert_only_the_launched_pid_was_stopped || return 1
  scratch="$(sed -n 's/^tree-scene.sh: choose this folder in the app: //p' "$SCENE/err")"
  [ -n "$scratch" ] && [ ! -e "$scratch" ] || fail "the scratch copy is still there after a normal exit: '$scratch'" || return 1

  new_scene
  : > "$SCENE/hold_start_wait"
  (
    cd "$SCENE/cwd" || exit 99
    exec /usr/bin/env -i PATH="$SCENE/bin:$SCENE/ordinary" HOME="$SCENE/home" TMPDIR="$SCENE/tmp" \
      "$TREE_SCENE_SH" "$APP"
  ) > "$SCENE/out" 2> "$SCENE/err" &
  helper=$!
  waited=0
  until grep -q -x -F -e 5 "$SCENE/sleeps" 2> /dev/null; do
    waited=$((waited + 1))
    [ "$waited" -lt 200 ] || { kill -KILL "$helper" 2> /dev/null; fail "the helper never reached its lead-in"; return 1; }
    /bin/sleep 0.05
  done
  kill -TERM "$helper"
  wait "$helper"
  STATUS=$?
  [ "$STATUS" -eq 143 ] || fail "signal: expected 143, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  assert_only_the_launched_pid_was_stopped || return 1
  scratch="$(sed -n 's/^tree-scene.sh: choose this folder in the app: //p' "$SCENE/err")"
  [ -n "$scratch" ] && [ ! -e "$scratch" ] || fail "the scratch copy is still there after a signal: '$scratch'"
}

# A run with no argument, or with an app that has no single executable, ends with one `tree-scene.sh:`
# line and exit 1 before it launches or copies anything, and stops nothing.
test_a_missing_argument_or_executable_launches_nothing() {
  new_scene
  run_helper
  [ "$STATUS" -eq 1 ] || fail "no argument: expected 1, got $STATUS" || return 1
  grep -q '^tree-scene.sh: ' "$SCENE/err" || fail "no argument: no tree-scene.sh: line. stderr: $(cat "$SCENE/err")" || return 1
  [ ! -s "$SCENE/open_calls" ] || fail "no argument: open was called" || return 1

  rm "$APP/Contents/MacOS/Fake-Exe"
  run_helper "$APP"
  [ "$STATUS" -eq 1 ] || fail "no executable: expected 1, got $STATUS" || return 1
  grep -q '^tree-scene.sh: ' "$SCENE/err" || fail "no executable: no tree-scene.sh: line. stderr: $(cat "$SCENE/err")" || return 1
  [ ! -s "$SCENE/open_calls" ] || fail "no executable: open was called" || return 1
  [ -z "$(ls -A "$SCENE/tmp")" ] || fail "something was copied before the run was refused: $(ls -A "$SCENE/tmp")" || return 1
  [ ! -s "$SCENE/kill_log" ] || fail "kill was called though no process was launched: $(cat "$SCENE/kill_log")"
}

# `open` that starts no new process of the app leaves the run nothing to stop and nothing to show:
# it ends with exit 1 and a line that says so, does not churn, and calls `kill` for nothing.
test_a_launch_that_starts_no_process_ends_the_run_and_stops_nothing() {
  new_scene
  : > "$SCENE/no_new_process"

  run_helper "$APP"

  [ "$STATUS" -eq 1 ] || fail "expected 1, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  grep -q '^tree-scene.sh: ' "$SCENE/err" || fail "no tree-scene.sh: line. stderr: $(cat "$SCENE/err")" || return 1
  [ "$(sleeps_of 3)" -eq 0 ] || fail "the churn ran though no process was launched" || return 1
  [ ! -s "$SCENE/kill_log" ] || fail "kill was called though no process was recorded: $(cat "$SCENE/kill_log")"
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

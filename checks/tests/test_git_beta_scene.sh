#!/usr/bin/env bash
# Version: 1.0.0 — first version: the skeleton's cases (admission, usage, entries, stops, signals,
#   the foreign folder and the leftover copy, nothing written outside the copies)
#
# checks/tests/test_git_beta_scene.sh — the tests of checks/git-beta-scene.sh.
#
# WHY THIS EXISTS
#   checks/git-beta-scene.sh sets up each state of the beta's read-at-open examples (E1 - E13) in a
#   folder on the Desktop, launches the built KA-Reader.app once per state, and prints each state's
#   record lines, so a person can look at the window and fill the record (docs/nfdr.md QC-44,
#   QC-66; change_spec CP-1302). No command can watch the app's window, so what a command can hold
#   is the helper's own contract: it refuses off a macOS virtual machine, stages the shape each id
#   states, launches once per state, writes only into the copies it made, prints one entry per id in
#   the fixed order, and stops only the pid it recorded. These cases run the REAL script, never a
#   copy of its logic, with `uname`, `sysctl`, `open`, `ps`, `kill`, `sleep` and `screencapture` as
#   stand-ins on PATH, the real `git` on temporary copies, and a temporary home and temporary
#   directory. Nothing here launches a bundle or reads the machine's home. The product has no
#   Python, so the runner is this file (docs/nfdr.md QC-70 sets the shell packet's pytest line
#   aside; deferred_decisions.md records the departure).
#
# USAGE
#   checks/tests/test_git_beta_scene.sh
#   Runs on any host: every host reading is a stand-in and `open` only records.
#
# THE STAND-INS
#   open           records its arguments and marks the app as opened.
#   ps             lists a bystander, another instance of the same executable (pid 4243) and an
#                  unrelated process; once `open` has run it lists the one launched (pid 4242).
#   kill           records its arguments; once told to stop a pid it reports that pid gone.
#   sleep          records its argument and returns at once.
#   screencapture  records its arguments and writes the file it was named.
#   Enter          is a newline on standard input; the signal case holds standard input open and
#                  empty, so the script waits there until it is sent the signal.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
GIT_BETA_SCENE_SH="$ROOT/checks/git-beta-scene.sh"
FIXTURES="$ROOT/checks/fixtures"
# shellcheck source=checks/tests/support/vm_refusal.sh
source "$ROOT/checks/tests/support/vm_refusal.sh"

LAUNCHED_PID=4242
BYSTANDER_PID=4243
BUILT_FROM="0123456789abcdef0123456789abcdef01234567, with no uncommitted changes"
USAGE_LINE='git-beta-scene.sh: usage: checks/git-beta-scene.sh <path-to-app> <built-from> [<state-id>…]'

WORK=""
SCENE=""
APP=""
SCENE_COUNT=0
STATUS=0

CASES="
test_off_a_vm_it_exits_one_having_launched_nothing_copied_nothing_and_read_no_home
test_a_wrong_invocation_exits_two_with_usage_and_launches_nothing
test_a_built_from_line_with_a_newline_exits_two
test_stdout_carries_one_entry_per_id_walked_in_the_fixed_order_with_built_from_verbatim
test_end_of_input_exits_one_stopping_only_the_recorded_pid_and_removing_the_copies
test_a_signal_ends_130_or_143_with_the_same_cleanup
test_a_desktop_folder_of_the_copys_name_without_the_note_stops_the_run_untouched
test_a_leftover_copy_that_carries_the_note_is_replaced_and_only_it
test_nothing_under_the_fixtures_changes_and_no_write_leaves_the_copies
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
  mkdir -p "$SCENE/cwd" "$SCENE/bin" "$SCENE/home/Desktop" "$SCENE/tmp"
  APP="$SCENE/App.app"
  mkdir -p "$APP/Contents/MacOS"
  : > "$APP/Contents/MacOS/Fake-Exe"
  chmod +x "$APP/Contents/MacOS/Fake-Exe"
  : > "$SCENE/open_calls"
  : > "$SCENE/sleeps"
  : > "$SCENE/kill_log"
  vmr_install_ordinary "$SCENE/ordinary"
  # The real git and tar are the scene's own tools, not stand-ins: the states are built with them.
  ln -sf "$(command -v git)" "$SCENE/ordinary/git"
  ln -sf "$(command -v tar)" "$SCENE/ordinary/tar"
  vmr_install_admission "$SCENE/bin"
  write_open
  write_ps
  write_kill
  write_sleep
  write_screencapture
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
exit 0
EOF
  chmod +x "$SCENE/bin/sleep"
}

# Records its arguments and writes the file it was named, so nothing captures the real screen.
write_screencapture() {
  cat > "$SCENE/bin/screencapture" <<EOF
#!/bin/bash
printf '%s\n' "\$*" >> '$SCENE/captures'
for last in "\$@"; do :; done
printf 'png' > "\$last"
exit 0
EOF
  chmod +x "$SCENE/bin/screencapture"
}

# One run of the helper with Enter already typed for every wait: stdout to $SCENE/out, stderr to
# $SCENE/err, the status in STATUS. The environment holds only the stand-ins' PATH, the scene's
# home and the scene's temporary directory.
run_helper() {
  run_helper_with_input $'\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n' "$@"
}

# As run_helper, with $1 as the whole of standard input.
run_helper_with_input() {
  input="$1"
  shift
  (
    cd "$SCENE/cwd" || exit 99
    exec /usr/bin/env -i PATH="$SCENE/bin:$SCENE/ordinary" HOME="$SCENE/home" TMPDIR="$SCENE/tmp" \
      "$GIT_BETA_SCENE_SH" "$@"
  ) > "$SCENE/out" 2> "$SCENE/err" < <(printf '%s' "$input")
  STATUS=$?
}

# Where the helper puts its copy of state $1 in the scene.
scene_copy() {
  echo "$SCENE/home/Desktop/git-beta-scene-$1"
}

# The ids the entries on stdout carry, in the order printed, space-separated.
entry_ids() {
  sed -n 's/^## //p' "$SCENE/out" | tr '\n' ' ' | sed 's/ $//'
}

# Fails unless every call the kill stand-in saw named the launched pid alone, and it was asked to
# stop it.
assert_only_the_launched_pid_was_stopped() {
  grep -q -x -F -e "-TERM $LAUNCHED_PID" "$SCENE/kill_log" \
    || fail "the launched pid $LAUNCHED_PID was never told to stop. kill saw: $(cat "$SCENE/kill_log")" || return 1
  others="$(grep -v -x -F -e "-0 $LAUNCHED_PID" -e "-TERM $LAUNCHED_PID" -e "-KILL $LAUNCHED_PID" "$SCENE/kill_log" || true)"
  [ -z "$others" ] || fail "kill was called for something other than the launched pid: $others"
}

# --- cases ---

# QC-65, CP-1314: off a macOS virtual machine the helper prints its one refusal line and does
# nothing else, on every refusing reading: nothing is launched, nothing is copied into the temporary
# directory, nothing is written to the home or the working directory, and the fixtures are unchanged.
test_off_a_vm_it_exits_one_having_launched_nothing_copied_nothing_and_read_no_home() {
  new_scene
  VMR_TMP="$WORK"
  VMR_SCENE="$SCENE/tmp"
  VMR_ENV=("TMPDIR=$SCENE/tmp")
  fixtures_before="$(vmr_snapshot "$FIXTURES")"
  vmr_assert_refusal "$GIT_BETA_SCENE_SH" git-beta-scene.sh "$APP" "$BUILT_FROM" || return 1
  [ "$(vmr_snapshot "$FIXTURES")" = "$fixtures_before" ] || fail "the refused run changed the fixtures"
}

# QC-70: too few arguments, an unknown id and a repeated id each end with exit 2 and the usage
# lines, before anything is read or launched.
test_a_wrong_invocation_exits_two_with_usage_and_launches_nothing() {
  new_scene
  assert_wrong_invocation "no argument"
  assert_wrong_invocation "one argument" "$APP" || return 1
  assert_wrong_invocation "unknown id" "$APP" "$BUILT_FROM" E99 || return 1
  assert_wrong_invocation "repeated id" "$APP" "$BUILT_FROM" E1 E1 || return 1
}

# $1 is the case label; the rest is the helper's argument vector.
assert_wrong_invocation() {
  case_label="$1"
  shift
  run_helper "$@"
  [ "$STATUS" -eq 2 ] || fail "$case_label: expected exit 2, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  grep -q -x -F -e "$USAGE_LINE" "$SCENE/err" \
    || fail "$case_label: stderr carries no usage line. stderr: $(cat "$SCENE/err")" || return 1
  [ ! -s "$SCENE/open_calls" ] || fail "$case_label: open was called: $(cat "$SCENE/open_calls")" || return 1
  [ -z "$(ls -A "$SCENE/home/Desktop")" ] \
    || fail "$case_label: something was set up on the Desktop: $(ls -A "$SCENE/home/Desktop")"
}

# Stdout carries exactly one entry per state, so a built-from line holding a line break would split
# one entry in two: it is a wrong invocation.
test_a_built_from_line_with_a_newline_exits_two() {
  new_scene
  assert_wrong_invocation "built-from with a newline" "$APP" $'first\nsecond' E1
}

# CP-1303: one entry per id walked, in the fixed order whatever order the ids were given in, with
# the built-from line copied verbatim into every entry, the person's fields left as the marker, and
# nothing else on standard output.
test_stdout_carries_one_entry_per_id_walked_in_the_fixed_order_with_built_from_verbatim() {
  new_scene
  run_helper "$APP" "$BUILT_FROM" E2-clean E1
  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  [ "$(entry_ids)" = "E1 E2-clean" ] \
    || fail "stdout does not carry exactly one entry per id walked, in the walk's order. The entries read: $(entry_ids)" || return 1
  [ "$(grep -c -x -F -e "- Built from: $BUILT_FROM" "$SCENE/out")" -eq 2 ] \
    || fail "the built-from line is not copied verbatim into every entry. got: $(grep 'Built from' "$SCENE/out")" || return 1
  stray="$(grep -v -E '^(## |- )' "$SCENE/out" || true)"
  [ -z "$stray" ] || fail "stdout carries a line that is not part of an entry: $stray" || return 1
  [ "$(grep -c -x -F -e '- The Git view showed: <to fill from the look>' "$SCENE/out")" -eq 2 ] \
    || fail "the person's fields are not printed as the marker. got: $(cat "$SCENE/out")" || return 1
  [ "$(grep -c -x -F -e '- Verdict against CP-1304: <to fill from the look>' "$SCENE/out")" -eq 2 ] \
    || fail "the verdict lines are not printed once per rule. got: $(cat "$SCENE/out")"
}

# Standard input that ends with no line: the helper says no Enter came, exits 1, stops the pid it
# launched and no other, removes its copy, and says what was walked and how to walk the rest.
test_end_of_input_exits_one_stopping_only_the_recorded_pid_and_removing_the_copies() {
  new_scene
  run_helper_with_input "" "$APP" "$BUILT_FROM"
  [ "$STATUS" -eq 1 ] || fail "no Enter: expected exit 1, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  grep -q -x -F -e 'git-beta-scene.sh: E1: no Enter came (standard input ended), so this state was not walked to its end and the walk ends here.' "$SCENE/err" \
    || fail "stderr does not say no Enter came. stderr: $(cat "$SCENE/err")" || return 1
  grep -q -x -F -e 'git-beta-scene.sh: no state was walked to its end.' "$SCENE/err" \
    || fail "stderr does not say nothing was walked. stderr: $(cat "$SCENE/err")" || return 1
  grep -q -x -F -e 'git-beta-scene.sh: to walk the rest, run the walk again with these ids: E1 E2-clean' "$SCENE/err" \
    || fail "stderr does not name the ids to run again. stderr: $(cat "$SCENE/err")" || return 1
  assert_only_the_launched_pid_was_stopped || return 1
  [ ! -e "$(scene_copy E1)" ] || fail "no Enter: a state's folder is still on the Desktop: $(ls -A "$SCENE/home/Desktop")"
}

# INT ends 130 and TERM ends 143, while the helper waits for Enter, with the same cleanup.
test_a_signal_ends_130_or_143_with_the_same_cleanup() {
  assert_signal INT 130 || return 1
  assert_signal TERM 143
}

# $1 is the signal name, $2 the status it must end with.
assert_signal() {
  signal="$1"
  expected="$2"
  new_scene
  mkfifo "$SCENE/enter"
  # Held open for writing and never written, so the helper's read waits. Job control is on while
  # the helper starts, so a background start leaves INT at its default and the helper can trap it.
  exec 7<> "$SCENE/enter"
  set -m
  (
    cd "$SCENE/cwd" || exit 99
    exec /usr/bin/env -i PATH="$SCENE/bin:$SCENE/ordinary" HOME="$SCENE/home" TMPDIR="$SCENE/tmp" \
      "$GIT_BETA_SCENE_SH" "$APP" "$BUILT_FROM"
  ) > "$SCENE/out" 2> "$SCENE/err" < "$SCENE/enter" &
  helper=$!
  set +m
  waited=0
  until grep -q 'press Enter here' "$SCENE/err" 2> /dev/null; do
    waited=$((waited + 1))
    [ "$waited" -lt 200 ] || { kill -KILL "$helper" 2> /dev/null; exec 7>&-; fail "the helper never reached its wait for Enter"; return 1; }
    /bin/sleep 0.05
  done
  /bin/sleep 0.2
  kill -"$signal" "$helper"
  wait "$helper"
  STATUS=$?
  exec 7>&-
  [ "$STATUS" -eq "$expected" ] || fail "signal $signal: expected $expected, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  assert_only_the_launched_pid_was_stopped || return 1
  [ ! -e "$(scene_copy E1)" ] || fail "signal $signal: a state's folder is still on the Desktop: $(ls -A "$SCENE/home/Desktop")"
}

# A Desktop folder of the copy's name that the helper did not make (it has no note) is never
# removed: the run stops with one line, before it launches anything, and the folder is as it was.
test_a_desktop_folder_of_the_copys_name_without_the_note_stops_the_run_untouched() {
  new_scene
  mkdir -p "$(scene_copy E1)"
  printf 'mine\n' > "$(scene_copy E1)/keep.txt"
  before="$(vmr_snapshot "$(scene_copy E1)")"
  run_helper "$APP" "$BUILT_FROM"
  [ "$STATUS" -eq 1 ] || fail "a foreign folder in the way did not stop the run: expected exit 1, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  [ "$(vmr_snapshot "$(scene_copy E1)")" = "$before" ] \
    || fail "the foreign folder in the way was changed: $(ls -A "$(scene_copy E1)")" || return 1
  [ ! -s "$SCENE/open_calls" ] || fail "open was called though a foreign folder was in the way: $(cat "$SCENE/open_calls")" || return 1
  grep -q 'is there and is not a scene copy, so it is left alone and the walk ends here' "$SCENE/err" \
    || fail "stderr does not say why. stderr: $(cat "$SCENE/err")"
}

# A copy a killed run left behind (the folder and its note) is replaced by a fresh one, and nothing
# else on the Desktop is touched.
test_a_leftover_copy_that_carries_the_note_is_replaced_and_only_it() {
  new_scene
  mkdir -p "$(scene_copy E1)"
  printf 'old\n' > "$(scene_copy E1)/stale.txt"
  : > "$SCENE/home/Desktop/.git-beta-scene-E1.note"
  printf 'mine\n' > "$SCENE/home/Desktop/other.txt"
  run_helper "$APP" "$BUILT_FROM" E1
  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  [ ! -e "$(scene_copy E1)" ] || fail "a leftover scene copy was not replaced: $(ls -A "$SCENE/home/Desktop")" || return 1
  [ "$(cat "$SCENE/home/Desktop/other.txt" 2> /dev/null)" = "mine" ] || fail "another file on the Desktop was touched"
  [ "$(cat "$SCENE/open_calls")" = "-n $APP" ] || fail "open was not called once for the replaced copy: $(cat "$SCENE/open_calls")"
}

# CP-1316: a walk leaves the fixtures as they were and writes nothing outside the copies, the
# captures folder and the temporary home.
test_nothing_under_the_fixtures_changes_and_no_write_leaves_the_copies() {
  new_scene
  fixtures_before="$(vmr_snapshot "$FIXTURES")"
  cwd_before="$(vmr_snapshot "$SCENE/cwd")"
  tmp_before="$(vmr_snapshot "$SCENE/tmp")"
  run_helper "$APP" "$BUILT_FROM"
  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  [ "$(vmr_snapshot "$FIXTURES")" = "$fixtures_before" ] \
    || fail "the walk changed checks/fixtures/: $(vmr_snapshot "$FIXTURES" | head -5)" || return 1
  [ "$(vmr_snapshot "$SCENE/cwd")" = "$cwd_before" ] || fail "the walk changed the working directory" || return 1
  [ "$(vmr_snapshot "$SCENE/tmp")" = "$tmp_before" ] || fail "the walk left something in the temporary directory: $(ls -A "$SCENE/tmp")" || return 1
  left="$(ls -A "$SCENE/home/Desktop")"
  [ "$left" = "git-beta-scene-captures" ] || fail "the walk left something on the Desktop besides the captures folder: $left"
}

# --- the runner ---

WORK="$(cd "$(mktemp -d)" && pwd -P)"
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

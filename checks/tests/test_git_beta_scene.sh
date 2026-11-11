#!/usr/bin/env bash
# Version: 1.4.0 — the entries' verdict lines: each state names the rules the spec's Examples table assigns it
# Version: 1.3.0 — the in-window disk changes' cases (E9 - E13): each change lands only after Enter and
#   only in its copy, the clearing, the commit order, the moved .git, the new repository, E13's
#   captures, the status-0 full walk, nothing written outside; the skeleton's fixtures case walks E1 and E2-clean
# Version: 1.2.0 — the failure states' cases (E5 - E8): the shape each id stages, one E8 id per
#   distinct observed sentence with the count read from GitSentences.swift, the fixed order, no guest config
# Version: 1.1.0 — the repository states' cases (E1 - E4): what each staged folder holds at the
#   moment of its launch, the order of the first four ids, E4 after a repository, no guest config
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
#   open           records its arguments and marks the app as opened, its pid running again. It also
#                  records what every state's folder on the Desktop holds at that moment, under
#                  seen/ in the scene: seen/order (id and whether it holds a repository, one line per
#                  launch), and per id its git status, its porcelain status, its file count outside
#                  .git and its listing. The copy is gone once the state is walked, so this is how a
#                  case reads the staged shape.
#   ps             lists a bystander, another instance of the same executable (pid 4243) and an
#                  unrelated process; once `open` has run it lists the one launched (pid 4242) until
#                  it has been told to stop.
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
test_a_launch_that_starts_no_process_ends_the_run_and_stops_nothing
test_nothing_under_the_fixtures_changes_and_no_write_leaves_the_copies
test_e1_stages_one_changed_file_and_one_staged_file
test_e2_clean_is_clean
test_each_e2_member_leaves_its_operation_in_progress_as_git_status_names_it
test_e3_working_tree_is_above_its_size_floor
test_e4_is_a_plain_folder_walked_right_after_a_repository_launch
test_e4_given_alone_walks_e2_clean_first_and_the_printed_lines_say_so
test_a_repository_state_uses_no_config_of_the_guest
test_e1_to_e4_are_walked_in_the_fixed_order_and_a_subset_in_that_order
test_e5_stages_an_unreadable_git_directory
test_e6_stages_a_repository_whose_config_is_invalid
test_e7_stages_the_chosen_status_only_shape
test_e8_ids_are_one_per_distinct_observed_sentence_and_the_count_is_read_from_the_catalogue
test_each_e8_shape_is_made_by_a_fixture_or_a_planned_disk_shape_and_none_is_empty
test_e5_to_e8_are_walked_after_e4_in_the_fixed_order
test_no_failure_shape_reads_the_guests_own_git_config
test_each_disk_change_lands_only_after_enter_and_only_in_its_copy
test_e9_clears_the_condition_on_enter
test_e10_edits_then_stages_then_commits_in_that_order
test_e11_moves_the_git_directory_out_of_the_root
test_e12_creates_a_repository_in_the_plain_root
test_e13_changes_a_tracked_file_between_switches_and_captures_each_look
test_a_full_walk_of_every_id_exits_zero
test_each_entry_prints_a_verdict_for_every_rule_the_specs_examples_assign_its_state
test_the_walk_writes_nothing_outside_its_copies_the_captures_and_the_temporary_home
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
  write_snapshot
  write_open
  write_ps
  write_kill
  write_sleep
  write_screencapture
}

# What every state's folder holds when the app is launched: the staged shape, read by the real git
# with no config of the machine, since the helper removes the copy once the state is walked.
write_snapshot() {
  cat > "$SCENE/snapshot.sh" <<'EOF'
#!/bin/bash
scene="$1"
mkdir -p "$scene/seen"
for folder in "$scene"/home/Desktop/git-beta-scene-*; do
  [ -d "$folder" ] || continue
  id="${folder##*/git-beta-scene-}"
  [ "$id" != captures ] || continue
  kind=plain
  if [ -e "$folder/.git" ] || [ -L "$folder/.git" ]; then kind=repo; fi
  printf '%s %s\n' "$id" "$kind" >> "$scene/seen/order"
  if [ "$kind" = repo ]; then
    env GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 git -C "$folder" status > "$scene/seen/$id.status" 2>&1
    env GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 git -C "$folder" status --porcelain > "$scene/seen/$id.porcelain" 2>&1
  fi
  find "$folder" -path "$folder/.git" -prune -o -type f -print | wc -l | tr -d ' ' > "$scene/seen/$id.files"
  ls -A "$folder" > "$scene/seen/$id.ls" 2> /dev/null
  # The modes of the entries a failure state takes away, and the few files that name the shape.
  mode_of() {
    mode="$(ls -ld "$1" 2> /dev/null | awk '{ print $1 }')"
    echo "${mode:-none}"
  }
  mode_of "$folder" > "$scene/seen/$id.mode_folder"
  mode_of "$folder/.git" > "$scene/seen/$id.mode_git"
  mode_of "$folder/.git/index" > "$scene/seen/$id.mode_index"
  mode_of "$folder/.gitmodules" > "$scene/seen/$id.mode_gitmodules"
  cat "$folder/.git/config" > "$scene/seen/$id.git_config" 2> /dev/null
  cat "$folder/.git/objects/info/alternates" > "$scene/seen/$id.alternates" 2> /dev/null
  cat "$folder/.gitmodules" > "$scene/seen/$id.gitmodules" 2> /dev/null
  if [ -f "$folder/.git" ] && [ ! -L "$folder/.git" ]; then cat "$folder/.git" > "$scene/seen/$id.git_entry" 2> /dev/null; fi
  # The shape as a whole: every path outside .git with its mode, and the files above. Two states
  # with the same fingerprint are the same shape. A folder of thousands of files (E3's) is not
  # listed entry by entry: that would spawn two processes for each and cost a minute.
  {
    printf '%s .\n' "$(mode_of "$folder")"
    if [ "$(cat "$scene/seen/$id.files")" -lt 1000 ]; then
      find "$folder" -mindepth 1 -path "$folder/.git/*" -prune -o -print 2> /dev/null | LC_ALL=C sort | while IFS= read -r entry; do
        printf '%s %s\n' "$(mode_of "$entry")" "${entry#"$folder"}"
      done
    fi
    for kept in .git/config .git/objects/info/alternates .gitmodules; do
      if [ -f "$folder/$kept" ]; then printf -- '-- %s\n' "$kept"; cat "$folder/$kept"; fi
    done
    if [ -f "$folder/.git" ]; then printf -- '-- .git\n'; cat "$folder/.git"; fi
  } > "$scene/seen/$id.fingerprint"
done
EOF
  chmod +x "$SCENE/snapshot.sh"
}

write_open() {
  cat > "$SCENE/bin/open" <<EOF
#!/bin/bash
printf '%s\n' "\$*" >> '$SCENE/open_calls'
'$SCENE/snapshot.sh' '$SCENE'
: > '$SCENE/opened'
rm -f '$SCENE/gone_$LAUNCHED_PID'
exit 0
EOF
  chmod +x "$SCENE/bin/open"
}

write_ps() {
  cat > "$SCENE/bin/ps" <<EOF
#!/bin/bash
printf '%s\n' '9999 /usr/bin/other'
printf '%s\n' '$BYSTANDER_PID $APP/Contents/MacOS/Fake-Exe'
if [ -f '$SCENE/opened' ] && [ ! -f '$SCENE/no_new_process' ] && [ ! -f '$SCENE/gone_$LAUNCHED_PID' ]; then
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
  # Eighty Enters, more than a full walk waits for; the trailing x keeps the substitution from
  # stripping the newlines.
  typed="$(printf '\n%.0s' $(seq 1 80); printf x)"
  run_helper_with_input "${typed%x}" "$@"
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

# Every id the helper lists, in its order: the script's own constant, so the list the cases expect
# grows with the script's and a case never repeats it.
state_ids() {
  sed -n 's/^STATE_IDS="\(.*\)"$/\1/p' "$GIT_BETA_SCENE_SH"
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
  grep -q -x -F -e "git-beta-scene.sh: to walk the rest, run the walk again with these ids: $(state_ids)" "$SCENE/err" \
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

# `open` that starts no new process of the app leaves the run nothing to stop and nothing to show:
# it ends with exit 1 and the stop lines, and calls `kill` for nothing (QC-70, status 1).
test_a_launch_that_starts_no_process_ends_the_run_and_stops_nothing() {
  new_scene
  : > "$SCENE/no_new_process"
  run_helper "$APP" "$BUILT_FROM"
  [ "$STATUS" -eq 1 ] || fail "no new process: expected exit 1, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  grep -q 'no new process of .* appeared within 20 seconds of open' "$SCENE/err" \
    || fail "stderr does not say no process appeared. stderr: $(cat "$SCENE/err")" || return 1
  [ ! -s "$SCENE/kill_log" ] || fail "kill was called though no process was recorded: $(cat "$SCENE/kill_log")" || return 1
  [ ! -e "$(scene_copy E1)" ] || fail "the state's folder is still on the Desktop: $(ls -A "$SCENE/home/Desktop")"
}

# CP-1316: a walk leaves the fixtures as they were and writes nothing outside the copies, the
# captures folder and the temporary home.
test_nothing_under_the_fixtures_changes_and_no_write_leaves_the_copies() {
  new_scene
  fixtures_before="$(vmr_snapshot "$FIXTURES")"
  cwd_before="$(vmr_snapshot "$SCENE/cwd")"
  tmp_before="$(vmr_snapshot "$SCENE/tmp")"
  run_helper "$APP" "$BUILT_FROM" E1 E2-clean
  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  [ "$(vmr_snapshot "$FIXTURES")" = "$fixtures_before" ] \
    || fail "the walk changed checks/fixtures/: $(vmr_snapshot "$FIXTURES" | head -5)" || return 1
  [ "$(vmr_snapshot "$SCENE/cwd")" = "$cwd_before" ] || fail "the walk changed the working directory" || return 1
  [ "$(vmr_snapshot "$SCENE/tmp")" = "$tmp_before" ] || fail "the walk left something in the temporary directory: $(ls -A "$SCENE/tmp")" || return 1
  left="$(ls -A "$SCENE/home/Desktop")"
  [ "$left" = "git-beta-scene-captures" ] || fail "the walk left something on the Desktop besides the captures folder: $left"
}

# --- the repository states, E1 - E4 ---

# The text the snapshot took of state $1's $2 (status, porcelain, files, ls) at its launch.
seen_of() {
  cat "$SCENE/seen/$1.$2" 2> /dev/null
}

# The ids the open stand-in saw launched, in order, each with whether its folder held a repository.
launch_order() {
  cat "$SCENE/seen/order" 2> /dev/null
}

# One run of ids "$@" that must end 0, for the cases that read the snapshot.
walk_ids() {
  run_helper "$APP" "$BUILT_FROM" "$@"
  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. stderr: $(cat "$SCENE/err")"
}

# CP-1304, CP-1305: E1 holds one changed file that is not staged and one staged file.
test_e1_stages_one_changed_file_and_one_staged_file() {
  new_scene
  walk_ids E1 || return 1
  porcelain="$(seen_of E1 porcelain)"
  [ "$(printf '%s\n' "$porcelain" | grep -c .)" -eq 2 ] \
    && [ "$(printf '%s\n' "$porcelain" | grep -c -E '^ M ')" -eq 1 ] \
    && [ "$(printf '%s\n' "$porcelain" | grep -c -E '^[MA]  ')" -eq 1 ] \
    || fail "E1: expected one changed file and one staged file. git status reads: $(seen_of E1 status)"
}

# CP-1304, CP-1305: E2-clean is a repository with nothing changed and nothing staged.
test_e2_clean_is_clean() {
  new_scene
  walk_ids E2-clean || return 1
  [ -f "$SCENE/seen/E2-clean.status" ] && [ -z "$(seen_of E2-clean porcelain)" ] \
    || fail "E2-clean: the repository is not clean. git status reads: $(seen_of E2-clean status)"
}

# One assertion per member: what `git status` says of each operation left in progress, and of a
# detached HEAD. The sentences are Git's own.
test_each_e2_member_leaves_its_operation_in_progress_as_git_status_names_it() {
  new_scene
  walk_ids E2-merge E2-rebase E2-cherry-pick E2-revert E2-bisect E2-am E2-detached || return 1
  assert_status_names E2-merge merge "You have unmerged paths" || return 1
  assert_status_names E2-rebase rebase "rebase in progress" || return 1
  assert_status_names E2-cherry-pick cherry-pick "You are currently cherry-picking" || return 1
  assert_status_names E2-revert revert "You are currently reverting" || return 1
  assert_status_names E2-bisect bisect "You are currently bisecting" || return 1
  assert_status_names E2-am am "You are in the middle of an am session" || return 1
  grep -q -F "HEAD detached at" "$SCENE/seen/E2-detached.status" 2> /dev/null \
    || fail "E2-detached: HEAD is not detached. git status reads: $(seen_of E2-detached status)"
}

# $1 is the state id, $2 Git's word for its operation, $3 the sentence git status prints for it.
assert_status_names() {
  grep -q -F "$3" "$SCENE/seen/$1.status" 2> /dev/null \
    || fail "$1: git status does not name a $2 in progress. git status reads: $(seen_of "$1" status)"
}

# CP-1306: E3 is a repository large enough that its status read is still under way when the person
# opens the Git view. The floor is the script's own constant, never a number written here.
test_e3_working_tree_is_above_its_size_floor() {
  new_scene
  floor="$(sed -n 's/^E3_FILE_COUNT=//p' "$GIT_BETA_SCENE_SH")"
  case "$floor" in
    '' | *[!0-9]*) fail "E3: the script states no numeric E3_FILE_COUNT (it reads: $floor)"; return 1 ;;
  esac
  walk_ids E3 || return 1
  file_count="$(seen_of E3 files)"
  [ "${file_count:-0}" -ge "$floor" ] \
    || fail "E3: the working tree's file count is ${file_count:-0}, below the floor of $floor" || return 1
  grep -q -x -F -e "git-beta-scene.sh: E3: writing $floor files into the working tree." "$SCENE/err" \
    || fail "E3: stderr does not say how many files were written. stderr: $(grep 'E3' "$SCENE/err")" || return 1
  grep -q -x -F -e '- Verdict against CP-1306: <to fill from the look>' "$SCENE/out" \
    || fail "E3: its entry has no verdict line for CP-1306. got: $(cat "$SCENE/out")"
}

# CP-1306: E4 is a folder with no repository, and the launch right before it is a repository's.
test_e4_is_a_plain_folder_walked_right_after_a_repository_launch() {
  new_scene
  walk_ids E1 E4 || return 1
  [ "$(launch_order)" = "$(printf 'E1 repo\nE4 plain')" ] \
    || fail "E4: the launch before E4 was not for a repository state. open saw: $(launch_order | tr '\n' ';')" || return 1
  [ ! -e "$SCENE/seen/E4.status" ] && [ -n "$(seen_of E4 ls)" ] \
    || fail "E4: the folder holds a repository or nothing. It holds: $(seen_of E4 ls)"
}

# E4 given alone has no repository launch before it: the helper walks E2-clean first and says why.
test_e4_given_alone_walks_e2_clean_first_and_the_printed_lines_say_so() {
  new_scene
  walk_ids E4 || return 1
  [ "$(entry_ids)" = "E2-clean E4" ] \
    || fail "E4 given alone: E2-clean was not walked before it. The entries read: $(entry_ids)" || return 1
  grep -q -x -F -e 'git-beta-scene.sh: E4 needs a launch on a repository right before it, so E2-clean is walked first.' "$SCENE/err" \
    || fail "E4 given alone: stderr does not say why E2-clean comes first. stderr: $(cat "$SCENE/err")" || return 1
  [ "$(launch_order)" = "$(printf 'E2-clean repo\nE4 plain')" ] \
    || fail "E4 given alone: the launches were not a repository's then E4's: $(launch_order | tr '\n' ';')"
}

# The guest's own git config must never shape a scene: a global config that signs every commit
# with a program that is not there, and a hook that refuses every commit, would stop a state built
# without the helper's overrides. The states and what git says of them are the same with and
# without it.
test_a_repository_state_uses_no_config_of_the_guest() {
  repository_ids="E1 E2-clean E2-merge E2-rebase E2-cherry-pick E2-revert E2-bisect E2-am E2-detached"
  new_scene
  walk_ids $repository_ids || return 1
  plain_reading="$(normalized_statuses)"
  new_scene
  plant_guest_git_config
  walk_ids $repository_ids || return 1
  planted_reading="$(normalized_statuses)"
  [ -n "$plain_reading" ] || fail "no state was read: $(launch_order | tr '\n' ';')" || return 1
  [ "$plain_reading" = "$planted_reading" ] \
    || fail "the guest's config changed the states. Without it: $plain_reading With it: $planted_reading"
}

# Every state's status as the snapshot took it, with commit ids made alike.
normalized_statuses() {
  for status_file in "$SCENE"/seen/*.status; do
    echo "== ${status_file##*/}"
    sed -E 's/[0-9a-f]{7,40}/<commit>/g' "$status_file"
  done
}

plant_guest_git_config() {
  mkdir -p "$SCENE/home/hooks"
  printf '#!/bin/sh\nexit 1\n' > "$SCENE/home/hooks/pre-commit"
  chmod +x "$SCENE/home/hooks/pre-commit"
  cat > "$SCENE/home/.gitconfig" <<EOF
[commit]
  gpgsign = true
[gpg]
  program = $SCENE/no-such-gpg-program
[core]
  hooksPath = $SCENE/home/hooks
[init]
  defaultBranch = guest-branch
EOF
}

# The fixed order of E1 - E4: a subset is walked in that order, whatever order it was given in.
test_e1_to_e4_are_walked_in_the_fixed_order_and_a_subset_in_that_order() {
  new_scene
  walk_ids E4 E1 || return 1
  [ "$(entry_ids)" = "E1 E4" ] \
    || fail "stdout does not carry exactly one entry per id walked, in the walk's order. The entries read: $(entry_ids)" || return 1
  new_scene
  walk_ids E4 E2-bisect E1 E2-clean || return 1
  [ "$(entry_ids)" = "E1 E2-clean E2-bisect E4" ] \
    || fail "stdout does not carry exactly one entry per id walked, in the walk's order. The entries read: $(entry_ids)"
}

# --- the failure states, E5 - E8 ---

# CP-1307: E5 is a repository whose .git the folder cannot read: mode 000, as the core's own tests
# set it (root_finding.rs test_unreadable_git_directory_reports_condition).
test_e5_stages_an_unreadable_git_directory() {
  new_scene
  walk_ids E5 || return 1
  [ "$(seen_of E5 mode_git)" = "d---------" ] \
    || fail "E5: .git can still be read: its mode is $(seen_of E5 mode_git)"
}

# CP-1308: E6 is a repository whose .git/config is not Git config syntax, which fails the probe.
test_e6_stages_a_repository_whose_config_is_invalid() {
  new_scene
  walk_ids E6 || return 1
  planted_config="$SCENE/planted.config"
  seen_of E6 git_config > "$planted_config"
  grep -q -F 'bare = = nonsense' "$planted_config" \
    || fail "E6: .git/config does not hold the line the state is staged with. It reads: $(seen_of E6 git_config)" || return 1
  env GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null git config --file "$planted_config" --list > /dev/null 2>&1 \
    && fail "E6: .git/config does not hold the line the state is staged with. git config --list reads it without a fault: $(seen_of E6 git_config)"
  return 0
}

# CP-1308: E7 is a probe that answers root and a status read that stops unexplained. The shape the
# script chose is the unreadable index, one of the status-only paths in git_reader/libgit2.rs
# verify_submodules; the header names the git_state.rs case it was confirmed against.
test_e7_stages_the_chosen_status_only_shape() {
  new_scene
  walk_ids E7 || return 1
  [ "$(seen_of E7 mode_index)" = "----------" ] && [ "$(seen_of E7 mode_git | cut -c1-4)" = "drwx" ] \
    || fail "E7: the folder does not hold the shape the state is staged with. It holds: .git $(seen_of E7 mode_git), index $(seen_of E7 mode_index)" || return 1
  grep -q -F 'test_state_ok_and_status_failing_is_a_failed_item' "$GIT_BETA_SCENE_SH" \
    || fail "E7: the script's header does not name the git_state.rs case the shape was confirmed against"
}

# The number of distinct sentences the Git view draws for a condition KA-Reader observed, read out
# of GitSentences.swift: the cases of `failure` that carry their own sentence, and the groups of
# `sentence(for:)` that return a sentence of their own rather than one of the two unexplained
# faults. Never a number written here (design section 5).
observed_sentence_count() {
  awk '
    /static func failure\(/ { in_failure = 1; in_sentence = 0; next }
    /static func sentence\(for/ { in_sentence = 1; in_failure = 0; next }
    /^    }$/ { in_failure = 0; in_sentence = 0 }
    in_failure && /^        case \.[a-zA-Z]+\(/ && $0 !~ /case \.condition\(/ { count++ }
    in_sentence && /^        case \./ { waiting = 1 }
    in_sentence && waiting && /return/ {
      if ($0 !~ /return (fault|faultBeforeRepository)$/) { count++ }
      waiting = 0
    }
    END { print count + 0 }
  ' "$ROOT/ka-reader-mac/Sources/Surfaces/GitSentences.swift"
}

e8_ids() {
  state_ids | tr ' ' '\n' | grep -E '^E8-[0-9]+$' | tr '\n' ' ' | sed 's/ $//'
}

# CP-1307, CP-1310: one E8 id per distinct observed sentence, numbered from 1.
test_e8_ids_are_one_per_distinct_observed_sentence_and_the_count_is_read_from_the_catalogue() {
  sentence_count="$(observed_sentence_count)"
  [ "$sentence_count" -gt 0 ] || fail "E8: no observed sentence was read from GitSentences.swift" || return 1
  walked_count="$(e8_ids | wc -w | tr -d ' ')"
  [ "$walked_count" -eq "$sentence_count" ] \
    || fail "E8: the number of E8 states walked is $walked_count, and the number of distinct observed sentences is $sentence_count" || return 1
  expected="$(i=1; while [ "$i" -le "$sentence_count" ]; do printf 'E8-%s ' "$i"; i=$((i + 1)); done | sed 's/ $//')"
  [ "$(e8_ids)" = "$expected" ] || fail "E8: the ids are not numbered from 1 in order. They read: $(e8_ids)"
}

# Each E8 member's shape: what it stages, by the id's place in the order the sentences first appear
# in GitSentences.failure, and that no two members are the same shape.
test_each_e8_shape_is_made_by_a_fixture_or_a_planned_disk_shape_and_none_is_empty() {
  new_scene
  walk_ids $(e8_ids) || return 1
  assert_e8 1 git_entry 'gitdir: ../' || return 1
  assert_e8 2 git_config 'path = ../../outside.config' || return 1
  assert_e8 3 git_config 'path = ~/' || return 1
  assert_e8 4 alternates '../../../elsewhere/objects' || return 1
  assert_e8 5 alternates '~/objects' || return 1
  assert_e8 6 gitmodules 'path = link/x' || return 1
  assert_e8 7 mode_folder 'd---------' || return 1
  assert_e8 8 mode_git 'd---------' || return 1
  assert_e8 9 mode_git 'l' || return 1
  assert_e8 10 git_entry 'gitdir: .nothere' || return 1
  assert_e8 11 git_entry 'gitdir: .realgit' || return 1
  assert_e8 12 mode_gitmodules '----------' || return 1
  for first in $(e8_ids); do
    [ -s "$SCENE/seen/$first.fingerprint" ] || fail "$first: the folder does not hold the shape for its sentence. It holds nothing" || return 1
    for second in $(e8_ids); do
      [ "$first" = "$second" ] && continue
      cmp -s "$SCENE/seen/$first.fingerprint" "$SCENE/seen/$second.fingerprint" \
        && fail "$first: the folder does not hold the shape for its sentence. It is the same shape as $second" && return 1
    done
  done
  return 0
}

# $1 is the member's number, $2 the thing the snapshot kept, $3 what it must begin with or hold.
assert_e8() {
  found="$(seen_of "E8-$1" "$2")"
  case "$found" in
    *"$3"*) return 0 ;;
  esac
  fail "E8-$1: the folder does not hold the shape for its sentence. It holds: $2 reads: $found"
}

# The fixed order across E1 - E8: ids given out of order are walked E1 ... E4, E5, E6, E7, E8-n.
test_e5_to_e8_are_walked_after_e4_in_the_fixed_order() {
  case "$(state_ids)" in
    "E1 E2-clean E2-merge E2-rebase E2-cherry-pick E2-revert E2-bisect E2-am E2-detached E3 E4 E5 E6 E7 E8-1 "*) ;;
    *) fail "the fixed list does not run E1 - E4, E5, E6, E7, then E8-1 on: $(state_ids)"; return 1 ;;
  esac
  new_scene
  walk_ids E8-12 E5 E4 E2-merge E7 E1 E8-1 E6 || return 1
  [ "$(entry_ids)" = "E1 E2-merge E4 E5 E6 E7 E8-1 E8-12" ] \
    || fail "stdout does not carry exactly one entry per id walked, in the walk's order. The entries read: $(entry_ids)"
}

# The guest's own config shapes none of the failure states: the same planted config as the
# repository states', and each state is the shape it is without it.
test_no_failure_shape_reads_the_guests_own_git_config() {
  failure_ids="E5 E6 E7 $(e8_ids)"
  new_scene
  walk_ids $failure_ids || return 1
  plain_reading="$(cat_fingerprints)"
  new_scene
  plant_guest_git_config
  walk_ids $failure_ids || return 1
  planted_reading="$(cat_fingerprints)"
  [ -n "$plain_reading" ] || fail "no state was read: $(launch_order | tr '\n' ';')" || return 1
  [ "$plain_reading" = "$planted_reading" ] \
    || fail "the guest's config changed the states. Without it: $plain_reading With it: $planted_reading"
}

cat_fingerprints() {
  for fingerprint in "$SCENE"/seen/*.fingerprint; do
    echo "== ${fingerprint##*/}"
    cat "$fingerprint"
  done
}

# --- the in-window disk changes, E9 - E13 ---

# Starts the helper on ids "$@" with standard input held by the case, which types each Enter
# itself, so the case can read the folder at every wait. Leaves HELPER_PID. Standard input is a
# fifo held open for writing on fd 7, so the helper's read waits until a case sends a line.
start_held_helper() {
  new_scene
  mkfifo "$SCENE/enter"
  exec 7<> "$SCENE/enter"
  (
    cd "$SCENE/cwd" || exit 99
    exec /usr/bin/env -i PATH="$SCENE/bin:$SCENE/ordinary" HOME="$SCENE/home" TMPDIR="$SCENE/tmp" \
      "$GIT_BETA_SCENE_SH" "$APP" "$BUILT_FROM" "$@"
  ) > "$SCENE/out" 2> "$SCENE/err" < "$SCENE/enter" &
  HELPER_PID=$!
}

# Waits until the helper has printed $1 lines asking for Enter, which is when it is waiting.
await_prompts() {
  waited=0
  until [ "$(grep -c 'press Enter here' "$SCENE/err" 2> /dev/null)" -ge "$1" ]; do
    waited=$((waited + 1))
    if [ "$waited" -ge 400 ]; then
      kill -KILL "$HELPER_PID" 2> /dev/null
      exec 7>&-
      fail "the helper never reached its wait number $1. stderr: $(cat "$SCENE/err")"
      return 1
    fi
    /bin/sleep 0.05
  done
}

send_enter() {
  printf '\n' >&7
}

# Ends the held helper: waits for it, leaves its status in STATUS and lets go of its input.
finish_held_helper() {
  wait "$HELPER_PID"
  STATUS=$?
  exec 7>&-
}

# The disk-change lines the helper has printed for state $1, in the order printed.
change_lines() {
  grep -E "^git-beta-scene.sh: $1: (gave|changed|staged|committed|moved|created) " "$SCENE/err" 2> /dev/null
}

# Everything the walk of state $1 may not change: the rest of the home, the working directory,
# the temporary directory, the fixtures, and what is on the Desktop besides the state's own copy,
# its note, what E11 moves out and the captures.
outside_listing() {
  ls -A "$SCENE/home"
  ls -A "$SCENE/cwd"
  ls -A "$SCENE/tmp"
  vmr_snapshot "$FIXTURES"
  ls -A "$SCENE/home/Desktop" | grep -v -e "^git-beta-scene-$1\$" -e "^\.git-beta-scene-$1\." -e '^git-beta-scene-captures$'
}

# CP-1309: each of E9 - E12 changes its folder from outside once Enter has come and not before, and
# changes nothing but that folder (and what E11 moves out of it).
test_each_disk_change_lands_only_after_enter_and_only_in_its_copy() {
  for changing_id in E9 E10 E11 E12; do
    start_held_helper "$changing_id"
    await_prompts 1 || return 1
    [ -z "$(change_lines "$changing_id")" ] \
      || fail "$changing_id: the folder changed on disk before Enter came: $(change_lines "$changing_id")" || return 1
    copy_before="$(vmr_snapshot "$(scene_copy "$changing_id")")"
    outside_before="$(outside_listing "$changing_id")"
    send_enter
    await_prompts 2 || return 1
    copy_after="$(vmr_snapshot "$(scene_copy "$changing_id")")"
    [ "$copy_before" != "$copy_after" ] \
      || fail "$changing_id: the folder did not change on disk after Enter: $copy_after" || return 1
    [ "$(outside_listing "$changing_id")" = "$outside_before" ] \
      || fail "$changing_id: something outside the state's folder changed: $(outside_listing "$changing_id")" || return 1
    send_enter
    finish_held_helper
    [ "$STATUS" -eq 0 ] || fail "$changing_id: expected exit 0, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  done
}

# CP-1309, CP-1310: E9 is E5's shape, and Enter gives .git its permissions back.
test_e9_clears_the_condition_on_enter() {
  start_held_helper E9
  await_prompts 1 || return 1
  [ "$(ls -ld "$(scene_copy E9)/.git" | cut -c1-10)" = "d---------" ] \
    || fail "E9: .git can be read before Enter: its mode is $(ls -ld "$(scene_copy E9)/.git" | cut -c1-10)" || return 1
  send_enter
  await_prompts 2 || return 1
  [ "$(ls -ld "$(scene_copy E9)/.git" | cut -c1-4)" = "drwx" ] \
    && env GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null git -C "$(scene_copy E9)" status --porcelain > /dev/null 2>&1 \
    || fail "E9: .git can still not be read after Enter: its mode is $(ls -ld "$(scene_copy E9)/.git" | cut -c1-10)" || return 1
  grep -q -x -F -e 'git-beta-scene.sh: E9: gave .git its permissions back.' "$SCENE/err" \
    || fail "E9: stderr does not say the permissions were given back. stderr: $(cat "$SCENE/err")" || return 1
  send_enter
  finish_held_helper
}

# CP-1309: E10 edits a file, then stages it, then commits it, from outside, in that order.
test_e10_edits_then_stages_then_commits_in_that_order() {
  start_held_helper E10
  await_prompts 1 || return 1
  commits_before="$(env GIT_CONFIG_GLOBAL=/dev/null git -C "$(scene_copy E10)" rev-list --count HEAD)"
  [ -z "$(env GIT_CONFIG_GLOBAL=/dev/null git -C "$(scene_copy E10)" status --porcelain)" ] \
    || fail "E10: the folder is not clean before Enter: $(env GIT_CONFIG_GLOBAL=/dev/null git -C "$(scene_copy E10)" status --short)" || return 1
  grep -q -x -F -e 'git-beta-scene.sh: E10: before you press Enter, open notes/today.md in the reading panel, so you can see it change.' "$SCENE/err" \
    || fail "E10: stderr does not name the file to open. stderr: $(cat "$SCENE/err")" || return 1
  send_enter
  await_prompts 2 || return 1
  commits_after="$(env GIT_CONFIG_GLOBAL=/dev/null git -C "$(scene_copy E10)" rev-list --count HEAD)"
  [ "$commits_after" -eq $((commits_before + 1)) ] \
    || fail "E10: the log gained $((commits_after - commits_before)) commits, not one" || return 1
  expected_lines="$(printf '%s\n' \
    'git-beta-scene.sh: E10: changed notes/today.md.' \
    'git-beta-scene.sh: E10: staged notes/today.md with git add.' \
    'git-beta-scene.sh: E10: committed notes/today.md with git commit.')"
  [ "$(change_lines E10)" = "$expected_lines" ] \
    || fail "E10: the steps did not appear in the order change, stage, commit: $(change_lines E10)" || return 1
  send_enter
  finish_held_helper
}

# CP-1309: E11 moves .git out of the root, to a place outside the copy that the helper made and
# removes.
test_e11_moves_the_git_directory_out_of_the_root() {
  start_held_helper E11
  await_prompts 1 || return 1
  [ -d "$(scene_copy E11)/.git" ] || fail "E11: the folder has no .git before Enter" || return 1
  send_enter
  await_prompts 2 || return 1
  [ ! -e "$(scene_copy E11)/.git" ] || fail "E11: .git is still in the folder after Enter: $(ls -A "$(scene_copy E11)")" || return 1
  moved="$SCENE/home/Desktop/.git-beta-scene-E11.git"
  [ -f "$moved/HEAD" ] || fail "E11: .git was not moved to a place the helper made: $(ls -A "$SCENE/home/Desktop")" || return 1
  grep -q -x -F -e 'git-beta-scene.sh: E11: moved .git out of the folder.' "$SCENE/err" \
    || fail "E11: stderr does not say .git was moved. stderr: $(cat "$SCENE/err")" || return 1
  send_enter
  finish_held_helper
  [ "$STATUS" -eq 0 ] || fail "E11: expected exit 0, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  [ ! -e "$moved" ] && [ ! -e "$(scene_copy E11)" ] \
    || fail "E11: the moved .git or the folder is still on the Desktop: $(ls -A "$SCENE/home/Desktop")"
}

# CP-1306, CP-1309: E12 is a plain folder, and Enter runs git init in it.
test_e12_creates_a_repository_in_the_plain_root() {
  start_held_helper E12
  await_prompts 1 || return 1
  [ ! -e "$(scene_copy E12)/.git" ] || fail "E12: the folder already holds a .git before Enter" || return 1
  send_enter
  await_prompts 2 || return 1
  env GIT_CONFIG_GLOBAL=/dev/null git -C "$(scene_copy E12)" rev-parse --git-dir > /dev/null 2>&1 \
    && [ -d "$(scene_copy E12)/.git" ] \
    || fail "E12: the folder holds no repository after Enter: $(ls -A "$(scene_copy E12)")" || return 1
  grep -q -x -F -e "git-beta-scene.sh: E12: created a repository at the folder's root with git init." "$SCENE/err" \
    || fail "E12: stderr does not say a repository was created. stderr: $(cat "$SCENE/err")" || return 1
  send_enter
  finish_held_helper
}

# The captures E13 has made so far: one for each of its three looks, each taken when Enter ends it.
e13_captures() {
  ls "$SCENE/home/Desktop/git-beta-scene-captures" 2> /dev/null | grep -c '^E13'
}

# CP-1309, CP-1310: E13 is the sidebar round trip with a tracked file changed in the middle, and
# one capture for each of its three looks.
test_e13_changes_a_tracked_file_between_switches_and_captures_each_look() {
  start_held_helper E13
  await_prompts 1 || return 1
  tracked_status() { env GIT_CONFIG_GLOBAL=/dev/null git -C "$(scene_copy E13)" status --porcelain; }
  [ -z "$(tracked_status)" ] && [ "$(e13_captures)" -eq 0 ] \
    || fail "E13: the folder changed or a capture was taken before the first Enter: $(tracked_status)" || return 1
  send_enter
  await_prompts 2 || return 1
  [ -z "$(tracked_status)" ] && [ "$(e13_captures)" -eq 1 ] \
    || fail "E13: the folder changed before the middle Enter, or the first look has no capture ($(e13_captures)): $(tracked_status)" || return 1
  send_enter
  await_prompts 3 || return 1
  [ "$(tracked_status)" = " M notes/today.md" ] \
    || fail "E13: the file did not differ after the middle Enter: $(tracked_status)" || return 1
  [ "$(e13_captures)" -eq 2 ] || fail "E13: the captures after the middle Enter number $(e13_captures), not two" || return 1
  grep -q -x -F -e 'git-beta-scene.sh: E13: changed notes/today.md.' "$SCENE/err" \
    || fail "E13: stderr does not say the file was changed. stderr: $(cat "$SCENE/err")" || return 1
  send_enter
  finish_held_helper
  [ "$STATUS" -eq 0 ] || fail "E13: expected exit 0, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  [ "$(e13_captures)" -eq 3 ] || fail "E13: the captures number $(e13_captures), not one for each of three looks"
}

# QC-70, status 0: every id walked to its end, one entry per id in the fixed order, and the states
# with two looks print their fields once per look.
test_a_full_walk_of_every_id_exits_zero() {
  new_scene
  run_helper "$APP" "$BUILT_FROM"
  [ "$STATUS" -eq 0 ] || fail "full walk: expected exit 0, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  [ "$(entry_ids)" = "$(state_ids)" ] \
    || fail "stdout does not carry exactly one entry per id walked, in the walk's order. The entries read: $(entry_ids)" || return 1
  [ "$(grep -c -x -F -e '- The Git view showed (second look): <to fill from the look>' "$SCENE/out")" -eq 5 ] \
    || fail "full walk: the five states with two looks do not each print a second look. got: $(grep -c 'second look' "$SCENE/out")" || return 1
  [ "$(grep -c -x -F -e '- The Git view showed: <to fill from the look>' "$SCENE/out")" -eq "$(( $(state_ids | wc -w) - 5 ))" ] \
    || fail "full walk: the states with one look do not each print one: $(grep -c 'The Git view showed:' "$SCENE/out")"
}

# The rules the spec's Examples table assigns to state $1 (change_spec, Examples: E1 and E2 CP-1304
# and CP-1305; E3, E4 and E12 CP-1306; E5 and E8 CP-1307 and CP-1310; E6 and E7 CP-1308; E9 - E13
# CP-1309; E9 and E13 also CP-1310; E12 also CP-1309). Written here from the table and not read from
# the script, so the script is held to it.
specs_rules_of() {
  case "$1" in
    E1|E2-*) echo "CP-1304 CP-1305" ;;
    E3|E4) echo "CP-1306" ;;
    E5|E8-*) echo "CP-1307 CP-1310" ;;
    E6|E7) echo "CP-1308" ;;
    E9|E13) echo "CP-1309 CP-1310" ;;
    E10|E11) echo "CP-1309" ;;
    E12) echo "CP-1306 CP-1309" ;;
  esac
}

test_each_entry_prints_a_verdict_for_every_rule_the_specs_examples_assign_its_state() {
  new_scene
  # E3 is left out only for its twenty thousand files; its rule is the same one E4's carries.
  walked="E1 E2-clean E2-merge E4 E5 E6 E7 E8-1 E8-12 E9 E10 E11 E12 E13"
  # shellcheck disable=SC2086
  run_helper "$APP" "$BUILT_FROM" $walked
  [ "$STATUS" -eq 0 ] || fail "verdicts: expected exit 0, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  for id in $walked; do
    got="$(awk -v heading="## $id" '
      $0 == heading { inside = 1; next }
      /^## / { inside = 0 }
      inside && /^- Verdict against / { sub(/^- Verdict against /, ""); sub(/:.*/, ""); printf "%s ", $0 }
    ' "$SCENE/out" | sed 's/ $//')"
    [ "$got" = "$(specs_rules_of "$id")" ] \
      || fail "$id: the verdict lines name '$got', and the spec's Examples assign '$(specs_rules_of "$id")'" || return 1
  done
}

# CP-1316: a full walk changes nothing but the copies it made, the captures folder and the
# temporary home: before and after, the tree under the scene is the same.
test_the_walk_writes_nothing_outside_its_copies_the_captures_and_the_temporary_home() {
  new_scene
  fixtures_before="$(vmr_snapshot "$FIXTURES")"
  cwd_before="$(vmr_snapshot "$SCENE/cwd")"
  tmp_before="$(vmr_snapshot "$SCENE/tmp")"
  run_helper "$APP" "$BUILT_FROM"
  [ "$STATUS" -eq 0 ] || fail "full walk: expected exit 0, got $STATUS. stderr: $(cat "$SCENE/err")" || return 1
  [ "$(vmr_snapshot "$FIXTURES")" = "$fixtures_before" ] || fail "the walk changed checks/fixtures/: $(vmr_snapshot "$FIXTURES" | head -5)" || return 1
  [ "$(vmr_snapshot "$SCENE/cwd")" = "$cwd_before" ] || fail "the walk changed the working directory" || return 1
  [ "$(vmr_snapshot "$SCENE/tmp")" = "$tmp_before" ] || fail "the walk left something in the temporary directory: $(ls -A "$SCENE/tmp")" || return 1
  [ "$(ls -A "$SCENE/home")" = "Desktop" ] || fail "the walk wrote into the home beside the Desktop: $(ls -A "$SCENE/home")" || return 1
  [ "$(ls -A "$SCENE/home/Desktop")" = "git-beta-scene-captures" ] \
    || fail "the walk left something on the Desktop besides the captures folder: $(ls -A "$SCENE/home/Desktop")"
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

#!/usr/bin/env bash
# Version: 1.1.0 — the submodule walk runs every build — restore cases, read_git case, CI step
# Version: 1.0.0 — first version: drives the real checks/own-state.sh against the committed fixtures
#
# checks/tests/test_own_state.sh — the tests of checks/own-state.sh.
#
# WHY THIS EXISTS
#   checks/own-state.sh is the proof that a launch left nothing behind but the log, so a bug in it is
#   a proof nobody is checking. These cases run the real script against the committed fixtures. The
#   log condition is exercised by pointing HOME at a temporary directory. The fixture conditions are
#   exercised by putting a stray file into a fixture, removed again by the trap, and by adding or
#   removing repo's restored `.git` (its prior state is put back), and by unpacking submodule's
#   archive in place the way checks/read-only.sh does (its three restored entries are put back too).
#
# USAGE
#   checks/tests/test_own_state.sh   (from anywhere; it finds the product root itself)
#   A missing prerequisite (git, tar) FAILS the suite with a stated message and runs no case.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OWN_STATE_SH="$ROOT/checks/own-state.sh"
FIXTURES="$ROOT/checks/fixtures"
LOG_SUFFIX="Library/Containers/com.kensaiapp.nozoki/Data/Library/Logs/nozoki.log"

OUT=""
STATUS=0
WORK=""
GIT_WAS_PRESENT=0
SUBMODULE_WAS_RESTORED=0

CASES="
test_all_conditions_hold
test_missing_log_names_the_path
test_a_log_at_any_other_path_does_not_count
test_ignored_stray_file_fails_condition_two_only
test_untracked_stray_file_fails_conditions_two_and_three
test_modified_tracked_file_fails_condition_three_only
test_restored_git_is_not_extra
test_unrestored_git_is_not_extra
test_runs_from_anywhere_in_the_repo
test_restored_submodule_is_not_extra
test_stray_in_restored_submodule_fails_condition_two
test_stray_under_restored_submodule_folder_fails_condition_two
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# A HOME holding the log file where the app writes it.
home_with_log() {
  mkdir -p "$WORK/$1/$(dirname "$LOG_SUFFIX")"
  : > "$WORK/$1/$LOG_SUFFIX"
  printf '%s' "$WORK/$1"
}

# Runs the script with HOME=$1, from directory $2 (default: the product root). OUT is both streams.
run_own_state() {
  OUT="$(cd "${2:-$ROOT}" && HOME="$1" "$OWN_STATE_SH" 2>&1)"
  STATUS=$?
}

restore_git() {
  rm -rf "$FIXTURES/repo/.git"
  tar -xf "$FIXTURES/repo.git.tar" -C "$FIXTURES/repo"
}

# Unpacks submodule's archive into the fixture in place — the restore checks/read-only.sh makes.
restore_submodule() {
  remove_submodule_restore
  tar -xf "$FIXTURES/submodule.git.tar" -C "$FIXTURES/submodule"
}

# The restore's three entries; the folder's committed README.md stays.
remove_submodule_restore() {
  rm -rf "$FIXTURES/submodule/.git" "$FIXTURES/submodule/.gitmodules" "$FIXTURES/submodule/submodule"
}

expect_status() {
  [ "$STATUS" -eq "$1" ] || fail "expected exit $1, got $STATUS. output: $OUT"
}

expect_nonzero_status() {
  [ "$STATUS" -ne 0 ] || fail "expected a non-zero exit, got 0. output: $OUT"
}

# A line of the output carrying both $1 and $2.
expect_line_with() {
  printf '%s\n' "$OUT" | grep -F -- "$1" | grep -F -q -- "$2" \
    || fail "expected one line carrying [$1] and [$2]. output: $OUT"
}

expect_output_has() {
  case "$OUT" in
    *"$1"*) return 0 ;;
  esac
  fail "the output lacks [$1]. output: $OUT"
}

expect_output_lacks() {
  case "$OUT" in
    *"$1"*) fail "the output mentions [$1]. output: $OUT" ;;
  esac
}

# --- cases ---

test_all_conditions_hold() {
  home="$(home_with_log holds)"

  run_own_state "$home"

  expect_status 0
}

test_missing_log_names_the_path() {
  mkdir -p "$WORK/nolog"

  run_own_state "$WORK/nolog"

  expect_nonzero_status || return 1
  expect_line_with "condition 1" "$WORK/nolog/$LOG_SUFFIX"
}

test_a_log_at_any_other_path_does_not_count() {
  mkdir -p "$WORK/elsewhere/Library/Logs"
  : > "$WORK/elsewhere/Library/Logs/nozoki.log"
  : > "$WORK/elsewhere/nozoki.log"

  run_own_state "$WORK/elsewhere"

  expect_nonzero_status || return 1
  expect_line_with "condition 1" "$WORK/elsewhere/$LOG_SUFFIX"
}

test_ignored_stray_file_fails_condition_two_only() {
  home="$(home_with_log ignored)"
  : > "$FIXTURES/plain/x.log"

  run_own_state "$home"

  expect_nonzero_status || return 1
  expect_line_with "condition 2" "plain/x.log" || return 1
  expect_output_lacks "condition 3"
}

test_untracked_stray_file_fails_conditions_two_and_three() {
  home="$(home_with_log untracked)"
  : > "$FIXTURES/plain/x.tmp"

  run_own_state "$home"

  expect_nonzero_status || return 1
  expect_line_with "condition 2" "plain/x.tmp" || return 1
  expect_output_contains_condition_three
}

expect_output_contains_condition_three() {
  case "$OUT" in
    *"condition 3"*) return 0 ;;
  esac
  fail "expected condition 3 to be reported. output: $OUT"
}

test_modified_tracked_file_fails_condition_three_only() {
  home="$(home_with_log modified)"
  cp "$FIXTURES/plain/readme.txt" "$WORK/readme.saved"
  printf 'appended\n' >> "$FIXTURES/plain/readme.txt"

  run_own_state "$home"
  cp "$WORK/readme.saved" "$FIXTURES/plain/readme.txt"

  expect_nonzero_status || return 1
  expect_output_contains_condition_three || return 1
  expect_output_lacks "condition 2"
}

test_restored_git_is_not_extra() {
  home="$(home_with_log restored)"
  restore_git

  run_own_state "$home"

  expect_status 0
}

test_unrestored_git_is_not_extra() {
  home="$(home_with_log unrestored)"
  rm -rf "$FIXTURES/repo/.git"

  run_own_state "$home"

  expect_status 0
}

test_runs_from_anywhere_in_the_repo() {
  home="$(home_with_log anywhere)"

  run_own_state "$home" "$ROOT/crates/nozoki-core"

  expect_status 0
}

test_restored_submodule_is_not_extra() {
  home="$(home_with_log submodule-restored)"
  restore_submodule

  run_own_state "$home"

  expect_status 0 || return 1
  expect_output_has "own state holds"
}

test_stray_in_restored_submodule_fails_condition_two() {
  home="$(home_with_log submodule-stray)"
  restore_submodule
  : > "$FIXTURES/submodule/x.log"

  run_own_state "$home"

  expect_nonzero_status || return 1
  expect_line_with "condition 2" "submodule/x.log"
}

test_stray_under_restored_submodule_folder_fails_condition_two() {
  home="$(home_with_log submodule-folder-stray)"
  restore_submodule
  : > "$FIXTURES/submodule/submodule/stray.txt"

  run_own_state "$home"

  expect_nonzero_status || return 1
  expect_line_with "condition 2" "submodule/submodule/stray.txt"
}

# --- the runner ---

for tool in git tar; do
  if ! command -v "$tool" > /dev/null 2>&1; then
    echo "test_own_state.sh: a prerequisite is absent: $tool — install it; the suite does not skip" >&2
    exit 1
  fi
done

WORK="$(mktemp -d)"
[ -e "$FIXTURES/repo/.git" ] && GIT_WAS_PRESENT=1
[ -e "$FIXTURES/submodule/.git" ] && SUBMODULE_WAS_RESTORED=1
cleanup() {
  rm -f "$FIXTURES/plain/x.log" "$FIXTURES/plain/x.tmp" "$FIXTURES/submodule/x.log"
  [ ! -f "$WORK/readme.saved" ] || cp "$WORK/readme.saved" "$FIXTURES/plain/readme.txt"
  rm -rf "$FIXTURES/repo/.git"
  if [ "$GIT_WAS_PRESENT" -eq 1 ]; then
    tar -xf "$FIXTURES/repo.git.tar" -C "$FIXTURES/repo"
  fi
  remove_submodule_restore
  if [ "$SUBMODULE_WAS_RESTORED" -eq 1 ]; then
    tar -xf "$FIXTURES/submodule.git.tar" -C "$FIXTURES/submodule"
  fi
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
  # A stray file belongs to its case alone.
  rm -f "$FIXTURES/plain/x.log" "$FIXTURES/plain/x.tmp" "$FIXTURES/submodule/x.log" "$FIXTURES/submodule/submodule/stray.txt"
done

echo "$((total - failed)) of $total passed"
[ "$failed" -eq 0 ]

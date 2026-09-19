#!/usr/bin/env bash
# Version: 1.0.0 — first version: drives the real checks/read-only.sh against the committed fixtures
#
# checks/tests/test_read_only.sh — the tests of checks/read-only.sh.
#
# WHY THIS EXISTS
#   checks/read-only.sh is the proof that reading a folder changes nothing, so a bug in it is a
#   proof nobody is checking. These cases run the real script — never a copy of its logic. Two run
#   it with the real `cargo` and the real driver on the committed fixtures. The rest put a stub
#   `cargo` on PATH that does one specific thing to a TEMPORARY COPY of a fixture (never a committed
#   one), so each kind of change the script must report has a case that makes exactly that change.
#
# USAGE
#   checks/tests/test_read_only.sh
#   A missing prerequisite (cargo, git, tar, shasum) FAILS the suite with a stated message and runs
#   no case: a skip would let CI conclude green having proved nothing.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
READ_ONLY_SH="$ROOT/checks/read-only.sh"
FIXTURES="checks/fixtures"

OUT=""
ERR=""
STATUS=0
WORK=""

CASES="
test_clean_plain_is_unchanged
test_clean_repo_is_unchanged
test_restore_extracts_git_before_baseline
test_created_file_is_reported
test_modified_file_is_reported
test_removed_file_is_reported
test_retargeted_link_is_reported
test_rekinded_entry_is_reported
test_touch_only_is_unchanged
test_failed_walk_is_not_unchanged
test_zero_call_walk_is_not_unchanged
test_missing_fixture_names_argument
test_file_as_fixture_names_argument
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# Runs the script from the product root with the arguments given. OUT is its stdout alone, ERR its
# stderr alone, so a case can say which stream a thing appeared on.
run_read_only() {
  OUT="$(cd "$ROOT" && "$READ_ONLY_SH" "$@" 2> "$WORK/stderr")"
  STATUS=$?
  ERR="$(cat "$WORK/stderr")"
}

# Same, with the stub directory $1 ahead of the real tools on PATH.
run_read_only_with_stubs() {
  stubs="$1"
  shift
  OUT="$(cd "$ROOT" && PATH="$stubs:$PATH" "$READ_ONLY_SH" "$@" 2> "$WORK/stderr")"
  STATUS=$?
  ERR="$(cat "$WORK/stderr")"
}

# A `cargo` stub whose body is $2. In the body, "$last" is the walk's final argument — the fixture's
# absolute path, which is what the real driver is handed.
make_cargo_stub() {
  mkdir -p "$1"
  printf '#!/bin/sh\nfor last; do :; done\n%s\n' "$2" > "$1/cargo"
  chmod +x "$1/cargo"
}

# A temporary copy of committed fixture $1 (plain or repo) at $WORK/<case>/<fixture>. cp -R keeps
# links as links. Prints the copy's path.
fixture_copy() {
  mkdir -p "$WORK/$2"
  cp -R "$ROOT/$FIXTURES/$1" "$WORK/$2/$1"
  rm -rf "$WORK/$2/$1/.git"
  printf '%s' "$WORK/$2/$1"
}

expect_status() {
  [ "$STATUS" -eq "$1" ] || fail "expected exit $1, got $STATUS. stdout: $OUT stderr: $ERR"
}

expect_nonzero_status() {
  [ "$STATUS" -ne 0 ] || fail "expected a non-zero exit, got 0. stdout: $OUT"
}

expect_stdout_is() {
  [ "$OUT" = "$1" ] || fail "expected stdout exactly [$1], got [$OUT]. stderr: $ERR"
}

expect_stdout_lacks_unchanged() {
  case "$OUT" in
    *unchanged*) fail "stdout says unchanged: $OUT" ;;
  esac
}

expect_stderr_contains() {
  case "$ERR" in
    *"$1"*) return 0 ;;
  esac
  fail "expected stderr to contain: $1. stderr: $ERR"
}

# --- cases ---

test_clean_plain_is_unchanged() {
  run_read_only "$FIXTURES/plain"

  expect_status 0 || return 1
  expect_stdout_is "unchanged"
}

test_clean_repo_is_unchanged() {
  run_read_only "$FIXTURES/repo"

  expect_status 0 || return 1
  expect_stdout_is "unchanged"
}

test_restore_extracts_git_before_baseline() {
  mkdir -p "$WORK/restore"
  cp -R "$ROOT/$FIXTURES/repo" "$WORK/restore/repo"
  rm -rf "$WORK/restore/repo/.git"
  cp "$ROOT/$FIXTURES/repo.git.tar" "$WORK/restore/repo.git.tar"
  make_cargo_stub "$WORK/stubs-restore" 'echo 1'

  run_read_only_with_stubs "$WORK/stubs-restore" "$WORK/restore/repo"

  expect_status 0 || return 1
  expect_stdout_is "unchanged" || return 1
  [ -f "$WORK/restore/repo/.git/HEAD" ] || fail "the archive was not extracted: no .git/HEAD"
}

test_created_file_is_reported() {
  copy="$(fixture_copy plain created)"
  make_cargo_stub "$WORK/stubs-created" 'touch "$last/.DS_Store"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-created" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is ".DS_Store"
}

test_modified_file_is_reported() {
  copy="$(fixture_copy plain modified)"
  make_cargo_stub "$WORK/stubs-modified" 'printf "rewritten\n" > "$last/readme.txt"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-modified" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is "readme.txt"
}

test_removed_file_is_reported() {
  copy="$(fixture_copy plain removed)"
  make_cargo_stub "$WORK/stubs-removed" 'rm "$last/readme.txt"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-removed" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is "readme.txt"
}

test_retargeted_link_is_reported() {
  copy="$(fixture_copy plain retargeted)"
  make_cargo_stub "$WORK/stubs-retargeted" 'rm "$last/outside-link"; ln -s /tmp "$last/outside-link"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-retargeted" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is "outside-link"
}

test_rekinded_entry_is_reported() {
  copy="$(fixture_copy plain rekinded)"
  make_cargo_stub "$WORK/stubs-rekinded" 'rm "$last/readme.txt"; mkdir "$last/readme.txt"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-rekinded" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is "readme.txt"
}

test_touch_only_is_unchanged() {
  copy="$(fixture_copy plain touched)"
  make_cargo_stub "$WORK/stubs-touched" 'touch "$last/readme.txt"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-touched" "$copy"

  expect_status 0 || return 1
  expect_stdout_is "unchanged"
}

test_failed_walk_is_not_unchanged() {
  copy="$(fixture_copy plain failedwalk)"
  make_cargo_stub "$WORK/stubs-failedwalk" 'exit 1'

  run_read_only_with_stubs "$WORK/stubs-failedwalk" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_lacks_unchanged || return 1
  expect_stderr_contains "walk did not complete"
}

test_zero_call_walk_is_not_unchanged() {
  copy="$(fixture_copy plain zerowalk)"
  make_cargo_stub "$WORK/stubs-zerowalk" 'echo 0'

  run_read_only_with_stubs "$WORK/stubs-zerowalk" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_lacks_unchanged || return 1
  expect_stderr_contains "walk did not complete"
}

test_missing_fixture_names_argument() {
  run_read_only "$FIXTURES/nope"

  expect_nonzero_status || return 1
  expect_stdout_lacks_unchanged || return 1
  expect_stderr_contains "$FIXTURES/nope"
}

test_file_as_fixture_names_argument() {
  run_read_only "$FIXTURES/repo.git.tar"

  expect_nonzero_status || return 1
  expect_stdout_lacks_unchanged || return 1
  expect_stderr_contains "$FIXTURES/repo.git.tar"
}

# --- the runner ---

for tool in cargo git tar shasum; do
  if ! command -v "$tool" > /dev/null 2>&1; then
    echo "test_read_only.sh: a prerequisite is absent: $tool — install it; the suite does not skip" >&2
    exit 1
  fi
done

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

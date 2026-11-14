#!/usr/bin/env bash
# Version: 1.0.0 — first version: drives the real checks/git-view-memory.sh with a stand-in `swift`
#
# checks/tests/test_git_view_memory.sh — the tests of checks/git-view-memory.sh.
#
# WHY THIS EXISTS
#   checks/git-view-memory.sh is the step that makes each Git view memory case run alone in its own
#   process, because a case reads the whole process's high-water mark and any other test beside it
#   would be measured too. A bug in it is a case that never ran, or ran beside another, and the
#   bound held by nothing. These cases run the real script, never a copy of its logic, by its
#   absolute path. The world is stood in on PATH (docs/nfdr.md QC-67): each case builds a folder of
#   its own that holds a stand-in `swift` and links to the few programs the script runs, and runs
#   the script under `env -i` with that folder as its whole PATH, so no program of the host is ever
#   found. The stand-in prints a chosen test list, exits with a chosen status for each case's run,
#   and records every call it gets in a file outside the tree the script runs in. The real
#   `swift test` runs of the real cases are held by the gate's own "Git view memory bound" step,
#   not here. The runner is this file: the product has no Python (docs/nfdr.md § 9).
#
# USAGE
#   checks/tests/test_git_view_memory.sh
#     KA_READER_TEST_ONLY=<case> runs one case.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPT="$ROOT/checks/git-view-memory.sh"

TWO_ID="ShellTests.GitViewMemoryBoundTests/twoThousandFilesStayWithinTheBound()"
TWENTY_ID="ShellTests.GitViewMemoryBoundTests/twentyThousandFilesStayWithinTheBound()"
TWO_FILTER='^ShellTests\.GitViewMemoryBoundTests/twoThousandFilesStayWithinTheBound\(\)/'
TWENTY_FILTER='^ShellTests\.GitViewMemoryBoundTests/twentyThousandFilesStayWithinTheBound\(\)/'
LIST_CALL="test --package-path ka-reader-mac list"
TWO_CALL="test --package-path ka-reader-mac --filter $TWO_FILTER"
TWENTY_CALL="test --package-path ka-reader-mac --filter $TWENTY_FILTER"

STATUS=0
WORK=""

CASES="
test_both_cases_listed_and_passing_exits_zero_with_one_filtered_run_each
test_a_case_missing_from_the_list_is_named_and_nothing_is_run
test_a_failing_case_exits_one_naming_it_and_the_second_case_is_not_run
test_an_argument_exits_two_with_the_usage_line
test_the_tree_is_left_unchanged
test_a_signal_never_ends_with_zero
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# Builds the world of the case $1: the tree the script runs in (CWD), the folder that is its whole
# PATH (BIN), the folder the stand-in keeps its answers and its record in (DATA), and the TMPDIR
# (TMP). The list holds both cases and a case of another suite. The stand-in's files in DATA are
# `list` (the lines `swift test list` prints), `list_status` (to make the list call end non-zero),
# `status_two` and `status_twenty` (the status of that case's run), `selects_nothing` (a case's run
# reports the warning `swift test` prints for a filter that matched no test, and ends 0) and
# `signal` (a signal name the stand-in sends its parent on a case's run). Its record is `args`, one
# line for each call.
make_world() {
  CWD="$WORK/$1/tree"
  BIN="$WORK/$1/bin"
  DATA="$WORK/$1/data"
  TMP="$WORK/$1/tmp"
  mkdir -p "$CWD/ka-reader-mac" "$BIN" "$DATA" "$TMP" "$WORK/home"
  : > "$CWD/ka-reader-mac/Package.swift"
  for program in bash mktemp grep rm tee; do
    ln -s "$(command -v "$program")" "$BIN/$program"
  done
  printf '%s\n' "ShellTests.OtherTests/aCase()" "$TWO_ID" "$TWENTY_ID" > "$DATA/list"
  cat > "$BIN/swift" <<SWIFT
#!/bin/sh
data="$DATA"
printf '%s\n' "\$*" >> "\$data/args"
case "\$*" in
  "$LIST_CALL")
    if [ -f "\$data/list_status" ]; then
      read -r status < "\$data/list_status"
      exit "\$status"
    fi
    while IFS= read -r line; do printf '%s\n' "\$line"; done < "\$data/list"
    exit 0 ;;
  "test --package-path ka-reader-mac --filter "*)
    if [ -f "\$data/signal" ]; then
      read -r signal < "\$data/signal"
      kill -"\$signal" "\$PPID"
    fi
    case "\$*" in *twentyThousand*) which=twenty ;; *) which=two ;; esac
    if [ -f "\$data/selects_nothing" ]; then
      echo "warning: No matching test cases were run"
      exit 0
    fi
    echo "Test run with 1 test in 1 suite passed after 0.100 seconds."
    status=0
    if [ -f "\$data/status_\$which" ]; then read -r status < "\$data/status_\$which"; fi
    exit "\$status" ;;
  *)
    echo "stand-in swift: unexpected call: \$*" >&2
    exit 99 ;;
esac
SWIFT
  chmod +x "$BIN/swift"
}

# Runs the real script in the case's tree under an environment of nothing but PATH, HOME and
# TMPDIR, with the arguments given. Sets STATUS; stdout and stderr go to files in WORK.
run_script() {
  ( cd "$CWD" && env -i PATH="$BIN" HOME="$WORK/home" TMPDIR="$TMP" "$SCRIPT" "$@" ) \
    > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?
}

expect_status() {
  [ "$STATUS" -eq "$1" ] || fail "expected status $1, got $STATUS. stderr: $(cat "$WORK/stderr")"
}

# The stand-in's record holds exactly the lines given, in order.
expect_calls() {
  [ "$(cat "$DATA/args" 2> /dev/null)" = "$1" ] \
    || fail "the stand-in's calls were not as expected. Got: $(cat "$DATA/args" 2> /dev/null)"
}

expect_stderr_names() {
  case "$(cat "$WORK/stderr")" in
    *"$1"*) return 0 ;;
  esac
  fail "stderr does not name $1. stderr: $(cat "$WORK/stderr")"
}

# The script left nothing in its TMPDIR: its own folder is removed on every way out.
expect_tmp_empty() {
  [ -z "$(ls -A "$TMP")" ] || fail "the script left $(ls -A "$TMP") in TMPDIR"
}

# Every path of the tree and its checksums, for a before-and-after comparison.
snapshot() {
  ( cd "$1" && find . | LC_ALL=C sort && find . -type f -exec cksum {} + | LC_ALL=C sort )
}

# --- cases ---

# Both cases listed and passing: exit 0, one list call, then exactly one filtered run for each case,
# in order, each filtered on that case's whole identifier alone.
test_both_cases_listed_and_passing_exits_zero_with_one_filtered_run_each() {
  make_world pass
  run_script
  expect_status 0 || return 1
  expect_calls "$LIST_CALL
$TWO_CALL
$TWENTY_CALL" || return 1
  [ "$(tail -n 1 "$WORK/stdout")" = "git-view-memory.sh: 2 cases, each passed in a process of its own" ] \
    || fail "the last line of stdout is not the pass line: $(cat "$WORK/stdout")" || return 1
  [ "$(grep -c '^Test run with 1 test ' "$WORK/stdout")" -eq 2 ] \
    || fail "stdout does not hold both runs' own output: $(cat "$WORK/stdout")" || return 1
  expect_tmp_empty
}

# A case missing from the list is named, and nothing is run: not the case that is listed either. A
# line that holds the identifier of another suite is not the case. Both missing are both named, and
# a list call that ends non-zero is a refusal of its own that runs nothing.
test_a_case_missing_from_the_list_is_named_and_nothing_is_run() {
  make_world missing
  printf '%s\n' "$TWO_ID" "OtherSuite.${TWENTY_ID#*.}" "${TWENTY_ID}Extra" > "$DATA/list"
  run_script
  expect_status 1 || return 1
  expect_stderr_names "$TWENTY_ID" || return 1
  expect_calls "$LIST_CALL" || return 1
  expect_tmp_empty || return 1

  make_world missing-first
  printf '%s\n' "ShellTests.OtherTests/aCase()" "$TWENTY_ID" > "$DATA/list"
  run_script
  expect_status 1 || return 1
  expect_stderr_names "$TWO_ID" || return 1
  expect_calls "$LIST_CALL" || return 1

  make_world missing-both
  printf '%s\n' "ShellTests.OtherTests/aCase()" > "$DATA/list"
  run_script
  expect_status 1 || return 1
  expect_stderr_names "$TWO_ID" || return 1
  expect_stderr_names "$TWENTY_ID" || return 1
  expect_calls "$LIST_CALL" || return 1

  make_world list-fails
  echo 3 > "$DATA/list_status"
  run_script
  expect_status 1 || return 1
  expect_stderr_names "swift test list" || return 1
  expect_calls "$LIST_CALL" || return 1
  expect_tmp_empty
}

# A case that fails is named and ends the run: when the first fails the second is not run, and when
# the second fails the first has run once and the second once. A run whose filter selected no test
# ends 0 in `swift test`, and is a failure of its case here.
test_a_failing_case_exits_one_naming_it_and_the_second_case_is_not_run() {
  make_world first-fails
  echo 1 > "$DATA/status_two"
  run_script
  expect_status 1 || return 1
  expect_stderr_names "$TWO_ID" || return 1
  expect_calls "$LIST_CALL
$TWO_CALL" || return 1
  expect_tmp_empty || return 1

  make_world second-fails
  echo 1 > "$DATA/status_twenty"
  run_script
  expect_status 1 || return 1
  expect_stderr_names "$TWENTY_ID" || return 1
  expect_calls "$LIST_CALL
$TWO_CALL
$TWENTY_CALL" || return 1
  expect_tmp_empty || return 1

  make_world selects-nothing
  : > "$DATA/selects_nothing"
  run_script
  expect_status 1 || return 1
  expect_stderr_names "$TWO_ID" || return 1
  expect_stderr_names "was not run" || return 1
  expect_calls "$LIST_CALL
$TWO_CALL"
}

# Any argument is a usage error: exit 2, the usage line on stderr, nothing on stdout, and the
# stand-in never called.
test_an_argument_exits_two_with_the_usage_line() {
  make_world arguments
  run_script extra
  expect_status 2 || return 1
  expect_stderr_names "Usage: run checks/git-view-memory.sh from the repository's root." || return 1
  [ ! -s "$WORK/stdout" ] || fail "stdout is not empty: $(cat "$WORK/stdout")" || return 1
  [ ! -e "$DATA/args" ] || fail "swift was called: $(cat "$DATA/args")" || return 1

  run_script a b
  expect_status 2 || return 1
  [ ! -s "$WORK/stdout" ] || fail "stdout is not empty: $(cat "$WORK/stdout")" || return 1
  [ ! -e "$DATA/args" ] || fail "swift was called: $(cat "$DATA/args")" || return 1
  expect_tmp_empty
}

# The tree the script ran in is byte for byte what it was, after a pass and after a failure. The
# stand-in's record is outside it.
test_the_tree_is_left_unchanged() {
  make_world unchanged
  before="$(snapshot "$CWD")"
  run_script
  expect_status 0 || return 1
  [ "$(snapshot "$CWD")" = "$before" ] || fail "a passing run changed the tree" || return 1

  echo 1 > "$DATA/status_twenty"
  run_script
  expect_status 1 || return 1
  [ "$(snapshot "$CWD")" = "$before" ] || fail "a failing run changed the tree" || return 1

  rm -f "$DATA/status_twenty"
  printf '%s\n' "$TWO_ID" > "$DATA/list"
  run_script
  expect_status 1 || return 1
  [ "$(snapshot "$CWD")" = "$before" ] || fail "a run that refused changed the tree"
}

# A signal that lands while a case runs ends the script with 130 for INT, 143 for TERM, or 1 when it
# lands inside a command substitution. Never 0, even though the stand-in that sent it then exits 0,
# and nothing is left in TMPDIR. The stand-in sends the signal to its parent, so the case is
# deterministic.
test_a_signal_never_ends_with_zero() {
  for signal in TERM INT; do
    make_world "signal-$signal"
    echo "$signal" > "$DATA/signal"
    run_script
    case "$STATUS" in
      130 | 143 | 1) ;;
      *) fail "$signal: expected 130, 143 or 1, got $STATUS. stderr: $(cat "$WORK/stderr")" || return 1 ;;
    esac
    expect_tmp_empty || return 1
  done
}

# --- the runner ---

WORK="$(mktemp -d)"
cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

failed=0
for case_name in $CASES; do
  if [ -n "${KA_READER_TEST_ONLY:-}" ] && [ "$case_name" != "$KA_READER_TEST_ONLY" ]; then
    continue
  fi
  if result="$("$case_name" 2>&1)"; then
    echo "ok   $case_name"
  else
    echo "FAIL $case_name"
    [ -z "$result" ] || echo "$result"
    failed=$((failed + 1))
  fi
done

if [ "$failed" -ne 0 ]; then
  echo "test_git_view_memory.sh: $failed case(s) failed" >&2
  exit 1
fi

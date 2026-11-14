#!/usr/bin/env bash
# Version: 1.0.0 — first version: each Git view memory case run alone, in a `swift test` of its own
#
# checks/git-view-memory.sh — proves the Git view's memory stays bounded on a large repository, by
# running each memory case of the suite alone in a process of its own.
#
# WHY THIS EXISTS
#   Each case of ShellTests.GitViewMemoryBoundTests reads the process's maximum resident size
#   before and after it drives the Git view, and asserts a rise of at most 154,000,000 bytes. That
#   figure is a high-water mark of the whole process, so any other test that ran in the same
#   process first, or beside it, would be counted in it: a case read in a shared, parallel
#   `swift test` run would measure the other tests' memory. The gate's "Test gate" step therefore
#   skips the suite, and this script runs the two cases one at a time, each in its own `swift test`.
#
# USAGE
#   checks/git-view-memory.sh
#   Run from the product root. It takes no argument and reads nothing from the environment but the
#   platform's PATH, HOME and TMPDIR (docs/nfdr.md QC-67). Exit 0 when both cases are in the test
#   list and each passed in its own run, printing each run's own output and then one line. Exit 1,
#   naming the case, when a case is not in the test list (every missing case is named, and neither
#   case is run), when the list could not be made, when a case fails, or when a case's run did not
#   report exactly one test run (the cases after it are not run). Exit 2 with the usage line on
#   stderr when given an argument. INT ends it with 130 and TERM with 143; a signal that lands
#   inside a command substitution may end it with 1. It never ends with 0 on a signal (QC-70).
#
# THE ORDER OF A RUN
#   The argument count; the test list; both cases found in it; and only then the first run. A case
#   missing from the list is a filter that would select nothing, which `swift test` passes with
#   zero tests, so both are checked before either is run: a missing case never leaves the other
#   half-run. The first case that fails ends the run. A failing 2,000-file case means the view's
#   memory is not bounded, and running the 20,000-file case after it would do to the machine what
#   the owner's walk of that repository did.
#
# WHAT IT WRITES
#   The test list goes into a folder this script makes with `mktemp -d` and removes on every way
#   out. Nothing is written into the tree beyond what `swift test` itself writes under
#   ka-reader-mac/.build.
#
# WHERE IT RUNS
#   After "Build KA-Reader.app" in the gate: the package links the bridge artifact that step writes.

set -euo pipefail

TEMP_DIR=""
cleanup() {
  [ -z "$TEMP_DIR" ] || rm -rf "$TEMP_DIR"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

PACKAGE_PATH="ka-reader-mac"
# A case is selected by its whole identifier, anchored at the start and closed by the `/` that
# follows its `()`, so no other test and no case whose name only starts the same is selected beside
# it. The filter ends in `\(\)/` and never in `\(\)$`: measured on 2026-11-14, SwiftPM reads a
# test's name with a `/` and more after its `()`, so a `$` there selects nothing, and `swift test`
# ends 0 on a filter that selected nothing. The two arrays hold the same cases in the same order:
# the identifier `swift test list` prints, and the filter that selects it alone.
CASE_IDS=(
  'ShellTests.GitViewMemoryBoundTests/twoThousandFilesStayWithinTheBound()'
  'ShellTests.GitViewMemoryBoundTests/twentyThousandFilesStayWithinTheBound()'
)
CASE_FILTERS=(
  '^ShellTests\.GitViewMemoryBoundTests/twoThousandFilesStayWithinTheBound\(\)/'
  '^ShellTests\.GitViewMemoryBoundTests/twentyThousandFilesStayWithinTheBound\(\)/'
)

die() {
  echo "git-view-memory.sh: $*" >&2
  exit 1
}

# --- args ---

if [ "$#" -ne 0 ]; then
  echo "git-view-memory.sh: takes no argument; arguments given: $#. Usage: run checks/git-view-memory.sh from the repository's root." >&2
  exit 2
fi

# --- the test list, and both cases in it ---

TEMP_DIR="$(mktemp -d)" || die "could not make a temporary folder, so nothing was run. Check that TMPDIR is a folder this user can write to."
LIST_FILE="$TEMP_DIR/test-list.txt"

# The list goes to a file and is searched there, never piped into `grep -q`: grep stops at its first
# match, `swift test list` then gets SIGPIPE, and pipefail reports the pipeline as failed.
if ! swift test --package-path "$PACKAGE_PATH" list > "$LIST_FILE"; then
  die "swift test list failed, so no case was run. Run swift test --package-path $PACKAGE_PATH list from the repository's root to see its own message."
fi

missing=0
for id in "${CASE_IDS[@]}"; do
  if ! grep -F -x -q -- "$id" "$LIST_FILE"; then
    echo "git-view-memory.sh: the test list does not hold $id, so no case was run." >&2
    missing=1
  fi
done
[ "$missing" -eq 0 ] || exit 1

# --- each case, alone, in a process of its own ---

# A run's output stays attached to this script's own while it is kept, so the run can be read: a
# filter that selects nothing ends 0, so a run that did not report one test run is not a pass.
RUN_FILE="$TEMP_DIR/run.txt"
index=0
while [ "$index" -lt "${#CASE_IDS[@]}" ]; do
  if ! swift test --package-path "$PACKAGE_PATH" --filter "${CASE_FILTERS[$index]}" 2>&1 | tee "$RUN_FILE"; then
    die "${CASE_IDS[$index]} failed in its own run. The cases after it were not run."
  fi
  if ! grep -F -q -- 'Test run with 1 test ' "$RUN_FILE"; then
    die "${CASE_IDS[$index]} was not run: its filter selected no test, or not one. The cases after it were not run."
  fi
  index=$((index + 1))
done

echo "git-view-memory.sh: ${#CASE_IDS[@]} cases, each passed in a process of its own"

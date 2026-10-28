#!/usr/bin/env bash
# Version: 1.0.0 — first version: holds the gate's "Strings check" step, by reading checks/gate.sh as
#   text and applying one test of the gate to the real file and to disposable edited copies
#
# checks/tests/test_strings_step.sh — the test of the gate's "Strings check" step.
#
# WHY THIS EXISTS
#   The gate's "Strings check" step runs the message catalogue lint (docs/nfdr.md QC-53), and its
#   suite's cases run the real lint over a copy of the catalogue, so they stay green when the step
#   is deleted or moved after its suite. This suite holds the step itself. One test of the gate,
#   `gate_verdict`, reads a gate file as text and passes only when the file holds exactly one line
#   that is the step, and that line comes before the first "Strings check suite" step. The real
#   checks/gate.sh goes through it in a case of its own, which does not depend on any control, so a
#   broken gate fails there even when every control correctly rejects its copy. The controls make
#   an edited copy of the gate in a temporary directory outside the product tree, prove the edit
#   took effect, and pass only when the same `gate_verdict` rejects the copy and says why: a
#   control that edits nothing would pass on the real tree and prove nothing (docs/adr/0012: "A
#   gate that cannot go red has not run").
#   The suite never sources or runs the gate, and a line is recognised by comparing text, so no
#   shell text in a gate file is executed.
#
# USAGE
#   checks/tests/test_strings_step.sh
#     KA_READER_TEST_ONLY=<case> runs one case.
#   Runs on any host: it launches nothing, reads nothing under the machine's home, reaches no
#   network and runs no git command, so it carries no virtual-machine refusal.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

SUITE="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
GATE="$ROOT/checks/gate.sh"

LINT_LINE="run_step 'Strings check' 'checks/strings.sh'"
SUITE_LINE="run_step 'Strings check suite' 'checks/tests/test_strings.sh'"
SUITE_PREFIX="run_step 'Strings check suite' '"
TAB=$'\t'

WORK=""
COPY=""
TREE=""
SCRATCH=""
VERDICT_OUT=""
VERDICT_STATUS=0
NESTED_OUT=""
NESTED_STATUS=0

MISSING_PHRASE='"Strings check" step is missing from checks/gate.sh'
ORDER_PHRASE='"Strings check" must come before "Strings check suite"'

CASES="
test_real_gate_runs_strings_check_before_its_suite
test_this_suite_is_executable_and_carries_a_version_line
test_deleted_strings_check_line_is_named_missing
test_strings_check_moved_after_its_suite_is_named_out_of_order
test_mutation_that_changed_nothing_is_a_failure
test_commented_strings_check_line_does_not_count
test_space_indented_strings_check_line_does_not_count
test_tab_indented_strings_check_line_does_not_count
test_strings_check_with_another_command_does_not_count
test_strings_check_with_a_command_suffix_does_not_count
test_longer_line_containing_the_strings_check_line_does_not_count
test_strings_check_line_twice_does_not_pass_even_with_one_before_its_suite
test_empty_gate_does_not_pass
test_gate_with_no_step_lines_does_not_pass
test_gate_with_only_the_strings_check_suite_step_does_not_pass
test_another_step_between_strings_check_and_its_suite_passes
test_missing_strings_check_suite_step_does_not_pass
test_commented_strings_check_suite_step_does_not_count
test_indented_strings_check_suite_step_does_not_count
test_strings_check_suite_step_earlier_than_strings_check_does_not_pass
test_strings_check_suite_step_with_another_command_still_counts
test_strings_check_before_the_first_of_two_suite_steps_passes
test_strings_check_between_two_suite_steps_does_not_pass
test_unrelated_text_does_not_change_a_pass
test_lookalike_beside_the_strings_check_line_still_counts_once
test_closing_line_counts_cases_actually_run
test_copies_live_outside_the_product_tree_and_are_removed
"

# --- the messages ---

MSG_MISSING="The \"Strings check\" step is missing from checks/gate.sh: no line in it is exactly $LINT_LINE, starting at the beginning of the line. Add that line, exactly as shown, before the \"Strings check suite\" step."
MSG_NO_SUITE="checks/gate.sh has no \"Strings check suite\" step, and \"Strings check\" must come before it. Add the \"Strings check suite\" step after \"Strings check\"."
MSG_MUST_NOT_PASS="This case's copy of checks/gate.sh passed the suite's test of the gate, and that copy must not pass it. The fix is in this suite, not in checks/gate.sh."
MSG_MUST_PASS="This case's copy of checks/gate.sh did not pass the suite's test of the gate, and that copy must pass it. The fix is in this suite, not in checks/gate.sh. The test's own output follows."
MSG_DELETE_NOT_MISSING="This case's copy of checks/gate.sh, with the \"Strings check\" line deleted, did not pass the suite's test of the gate, but the output does not say that \"Strings check\" is missing from checks/gate.sh. The fix is in this suite, not in checks/gate.sh. The test's own output follows."
MSG_MOVE_NOT_ORDER="This case's copy of checks/gate.sh, with the \"Strings check\" line moved after \"Strings check suite\", did not pass the suite's test of the gate, but the output does not say that \"Strings check\" must come before \"Strings check suite\". The fix is in this suite, not in checks/gate.sh. The test's own output follows."
MSG_MOVE_CALLED_MISSING="The suite's test of the gate says \"Strings check\" is missing from this case's copy of checks/gate.sh, but on this copy the line was moved, not deleted. The fix is in this suite, not in checks/gate.sh. The test's own output follows."
MSG_NO_LINE_TO_EDIT="This case's copy of checks/gate.sh holds no line $LINT_LINE to edit, so the case tested nothing. The copy was taken from checks/gate.sh, which lacks that line too; add it there before the \"Strings check suite\" step."
MSG_NO_SUITE_TO_MOVE_AFTER="This case's copy of checks/gate.sh holds no \"Strings check suite\" step to move the \"Strings check\" line after, so the case tested nothing. The copy was taken from checks/gate.sh, which lacks that step too; add it there after \"Strings check\"."
MSG_DELETION_LEFT_LINE="After the deletion, this case's copy of checks/gate.sh still holds the line $LINT_LINE, so the case tested nothing. The fix is in this suite, not in checks/gate.sh."
MSG_MOVE_NOT_PLACED="After the move, the line $LINT_LINE is not directly after the \"Strings check suite\" step in this case's copy of checks/gate.sh, so the case tested nothing. The fix is in this suite, not in checks/gate.sh."

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

indent() {
  sed 's/^/  /'
}

# The test of the gate. Reads the file at $1 as text, prints the reason for each condition that does
# not hold, and returns 0 only when the file passes.
gate_verdict() {
  local file="$1"
  local line
  local number=0
  local lint_count=0
  local lint_numbers=""
  local lint_line=0
  local suite_line=0
  while IFS= read -r line || [ -n "$line" ]; do
    number=$((number + 1))
    # The suite's step is recognised by its name alone, and the first one counts.
    if [ "$suite_line" -eq 0 ]; then
      case "$line" in
        "$SUITE_PREFIX"*"'") suite_line=$number ;;
      esac
    fi
    if [ "$line" = "$LINT_LINE" ]; then
      lint_count=$((lint_count + 1))
      if [ "$lint_count" -eq 1 ]; then
        lint_line=$number
        lint_numbers="$number"
      else
        lint_numbers="$lint_numbers, $number"
      fi
    fi
  done < "$file"
  if [ "$lint_count" -eq 0 ]; then
    echo "$MSG_MISSING"
    return 1
  fi
  if [ "$lint_count" -gt 1 ]; then
    echo "checks/gate.sh holds the line $LINT_LINE more than once, at lines $lint_numbers, and the \"Strings check\" step must be in it exactly once. Keep one of them, before the \"Strings check suite\" step, and delete the rest."
    return 1
  fi
  if [ "$suite_line" -eq 0 ]; then
    echo "$MSG_NO_SUITE"
    return 1
  fi
  if [ "$lint_line" -gt "$suite_line" ]; then
    echo "In checks/gate.sh, \"Strings check\" is at line $lint_line and \"Strings check suite\" is at line $suite_line, but \"Strings check\" must come before \"Strings check suite\". Move the \"Strings check\" line above line $suite_line."
    return 1
  fi
  return 0
}

# Runs the test of the gate over $1 and keeps its output and status.
run_verdict() {
  VERDICT_OUT="$(gate_verdict "$1")"
  VERDICT_STATUS=$?
}

output_has() {
  printf '%s\n' "$VERDICT_OUT" | grep -q -F "$1"
}

expect_passes() {
  run_verdict "$1"
  [ "$VERDICT_STATUS" -eq 0 ] && return 0
  echo "  $MSG_MUST_PASS"
  printf '%s\n' "$VERDICT_OUT" | indent
  return 1
}

expect_rejected() {
  run_verdict "$1"
  [ "$VERDICT_STATUS" -ne 0 ] && return 0
  fail "$MSG_MUST_NOT_PASS"
}

# A copy that must be rejected as having no exact "Strings check" line. No message exists for a
# rejection that names another condition, so the case prints the test's own lines.
expect_rejected_as_missing() {
  expect_rejected "$1" || return 1
  output_has "$MISSING_PHRASE" && return 0
  echo "  the test of the gate rejected this case's copy without saying the step is missing:"
  printf '%s\n' "$VERDICT_OUT" | indent
  return 1
}

# Writes the lines after the first argument to the file named by it, one per line.
write_gate() {
  local file="$1"
  local text
  shift
  : > "$file"
  for text in "$@"; do
    printf '%s\n' "$text" >> "$file"
  done
}

new_copy() {
  COPY="$WORK/$1.gate.sh"
  cp "$GATE" "$COPY"
}

# Edits of a copy, each done by comparing text.
delete_lint_line() {
  grep -q -x -F "$LINT_LINE" "$GATE" || fail "$MSG_NO_LINE_TO_EDIT" || return 1
  grep -v -x -F "$LINT_LINE" "$GATE" > "$COPY"
  return 0
}

move_lint_line_after_suite() {
  local line moved=0
  grep -q -x -F "$LINT_LINE" "$GATE" || fail "$MSG_NO_LINE_TO_EDIT" || return 1
  : > "$COPY"
  while IFS= read -r line || [ -n "$line" ]; do
    [ "$line" = "$LINT_LINE" ] && continue
    printf '%s\n' "$line" >> "$COPY"
    if [ "$moved" -eq 0 ]; then
      case "$line" in
        "$SUITE_PREFIX"*"'")
          printf '%s\n' "$LINT_LINE" >> "$COPY"
          moved=1
          ;;
      esac
    fi
  done < "$GATE"
  [ "$moved" -eq 1 ] || fail "$MSG_NO_SUITE_TO_MOVE_AFTER"
}

# A control proves its own edit before the test of the gate is applied to the copy.
deletion_took_effect() {
  ! grep -q -x -F "$LINT_LINE" "$1" || fail "$MSG_DELETION_LEFT_LINE"
}

move_took_effect() {
  local line previous_is_suite=0 first_suite_seen=0
  while IFS= read -r line || [ -n "$line" ]; do
    if [ "$previous_is_suite" -eq 1 ] && [ "$line" = "$LINT_LINE" ]; then
      return 0
    fi
    previous_is_suite=0
    if [ "$first_suite_seen" -eq 0 ]; then
      case "$line" in
        "$SUITE_PREFIX"*"'")
          previous_is_suite=1
          first_suite_seen=1
          ;;
      esac
    fi
  done < "$1"
  fail "$MSG_MOVE_NOT_PLACED"
}

# Builds a tree holding a copy of this suite and the gate file at $2, under $WORK, with a scratch
# directory of its own for the copy's temporary directory.
make_tree() {
  TREE="$WORK/tree-$1"
  SCRATCH="$WORK/scratch-$1"
  mkdir -p "$TREE/checks/tests" "$SCRATCH"
  cp "$SUITE" "$TREE/checks/tests/test_strings_step.sh"
  if [ -n "$2" ]; then
    cp "$2" "$TREE/checks/gate.sh"
  fi
}

# Runs the copy of this suite in $TREE with one case, its temporary directory under $SCRATCH.
run_nested() {
  NESTED_OUT="$(TMPDIR="$SCRATCH" KA_READER_TEST_ONLY="$1" "$TREE/checks/tests/test_strings_step.sh" 2>&1)"
  NESTED_STATUS=$?
}

# --- the cases ---

test_real_gate_runs_strings_check_before_its_suite() {
  expect_passes "$GATE"
}

test_this_suite_is_executable_and_carries_a_version_line() {
  [ -x "$SUITE" ] || fail "$SUITE is not executable" || return 1
  [ "$(head -20 "$SUITE" | grep -c '^# Version:')" -ge 1 ] \
    || fail "no line beginning '# Version:' in the first 20 lines of $SUITE"
}

test_deleted_strings_check_line_is_named_missing() {
  new_copy deleted || return 1
  delete_lint_line || return 1
  deletion_took_effect "$COPY" || return 1
  expect_rejected "$COPY" || return 1
  output_has "$MISSING_PHRASE" && return 0
  echo "  $MSG_DELETE_NOT_MISSING"
  printf '%s\n' "$VERDICT_OUT" | indent
  return 1
}

test_strings_check_moved_after_its_suite_is_named_out_of_order() {
  new_copy moved || return 1
  move_lint_line_after_suite || return 1
  move_took_effect "$COPY" || return 1
  expect_rejected "$COPY" || return 1
  if ! output_has "$ORDER_PHRASE"; then
    echo "  $MSG_MOVE_NOT_ORDER"
    printf '%s\n' "$VERDICT_OUT" | indent
    return 1
  fi
  if output_has "is missing from checks/gate.sh"; then
    echo "  $MSG_MOVE_CALLED_MISSING"
    printf '%s\n' "$VERDICT_OUT" | indent
    return 1
  fi
}

test_mutation_that_changed_nothing_is_a_failure() {
  new_copy unchanged || return 1
  cmp -s "$GATE" "$COPY" || fail "the unedited copy differs from the gate it was taken from" || return 1
  # An edit that took no effect must be reported by the same checks the controls rely on.
  [ -n "$(deletion_took_effect "$COPY")" ] \
    || fail "a deletion that left the copy identical to the gate was not reported" || return 1
  [ -n "$(move_took_effect "$COPY")" ] \
    || fail "a move that left the line where it was was not reported" || return 1
}

test_commented_strings_check_line_does_not_count() {
  write_gate "$WORK/commented.gate.sh" "# $LINT_LINE" "$SUITE_LINE"
  expect_rejected_as_missing "$WORK/commented.gate.sh"
}

test_space_indented_strings_check_line_does_not_count() {
  write_gate "$WORK/spaced.gate.sh" "  $LINT_LINE" "$SUITE_LINE"
  expect_rejected_as_missing "$WORK/spaced.gate.sh"
}

test_tab_indented_strings_check_line_does_not_count() {
  write_gate "$WORK/tabbed.gate.sh" "${TAB}$LINT_LINE" "$SUITE_LINE"
  expect_rejected_as_missing "$WORK/tabbed.gate.sh"
}

test_strings_check_with_another_command_does_not_count() {
  write_gate "$WORK/other.gate.sh" "run_step 'Strings check' 'checks/other.sh'" "$SUITE_LINE"
  expect_rejected_as_missing "$WORK/other.gate.sh"
}

test_strings_check_with_a_command_suffix_does_not_count() {
  write_gate "$WORK/suffix.gate.sh" "run_step 'Strings check' 'checks/strings.sh || true'" "$SUITE_LINE"
  expect_rejected_as_missing "$WORK/suffix.gate.sh" || return 1
  write_gate "$WORK/trailing.gate.sh" "$LINT_LINE # kept" "$SUITE_LINE"
  expect_rejected_as_missing "$WORK/trailing.gate.sh"
}

test_longer_line_containing_the_strings_check_line_does_not_count() {
  write_gate "$WORK/longer.gate.sh" "if true; then $LINT_LINE; fi" "$SUITE_LINE"
  expect_rejected_as_missing "$WORK/longer.gate.sh"
}

test_strings_check_line_twice_does_not_pass_even_with_one_before_its_suite() {
  write_gate "$WORK/twice.gate.sh" "$LINT_LINE" "$SUITE_LINE" "$LINT_LINE"
  expect_rejected "$WORK/twice.gate.sh" || return 1
  output_has "more than once, at lines 1, 3" && return 0
  echo "  the test of the gate rejected two exact lines without naming lines 1 and 3:"
  printf '%s\n' "$VERDICT_OUT" | indent
  return 1
}

test_empty_gate_does_not_pass() {
  : > "$WORK/empty.gate.sh"
  expect_rejected "$WORK/empty.gate.sh"
}

test_gate_with_no_step_lines_does_not_pass() {
  write_gate "$WORK/stepless.gate.sh" "#!/usr/bin/env bash" "set -euo pipefail" "echo nothing to run"
  expect_rejected "$WORK/stepless.gate.sh"
}

test_gate_with_only_the_strings_check_suite_step_does_not_pass() {
  write_gate "$WORK/suite-only.gate.sh" "$SUITE_LINE"
  expect_rejected_as_missing "$WORK/suite-only.gate.sh"
}

test_another_step_between_strings_check_and_its_suite_passes() {
  write_gate "$WORK/between.gate.sh" "$LINT_LINE" "run_step 'Another step' 'checks/another.sh'" "$SUITE_LINE"
  expect_passes "$WORK/between.gate.sh"
}

test_missing_strings_check_suite_step_does_not_pass() {
  write_gate "$WORK/no-suite.gate.sh" "$LINT_LINE" "run_step 'Another step' 'checks/another.sh'"
  expect_rejected "$WORK/no-suite.gate.sh" || return 1
  output_has "$MSG_NO_SUITE" && return 0
  echo "  the test of the gate rejected a gate with no suite step without saying so:"
  printf '%s\n' "$VERDICT_OUT" | indent
  return 1
}

test_commented_strings_check_suite_step_does_not_count() {
  write_gate "$WORK/suite-commented.gate.sh" "$LINT_LINE" "# $SUITE_LINE"
  expect_rejected "$WORK/suite-commented.gate.sh"
}

test_indented_strings_check_suite_step_does_not_count() {
  write_gate "$WORK/suite-spaced.gate.sh" "$LINT_LINE" "  $SUITE_LINE"
  expect_rejected "$WORK/suite-spaced.gate.sh" || return 1
  write_gate "$WORK/suite-tabbed.gate.sh" "$LINT_LINE" "${TAB}$SUITE_LINE"
  expect_rejected "$WORK/suite-tabbed.gate.sh"
}

test_strings_check_suite_step_earlier_than_strings_check_does_not_pass() {
  write_gate "$WORK/suite-first.gate.sh" "$SUITE_LINE" "run_step 'Another step' 'checks/another.sh'" "$LINT_LINE"
  expect_rejected "$WORK/suite-first.gate.sh" || return 1
  output_has "$ORDER_PHRASE" && return 0
  echo "  the test of the gate rejected the suite step coming first without naming the order:"
  printf '%s\n' "$VERDICT_OUT" | indent
  return 1
}

test_strings_check_suite_step_with_another_command_still_counts() {
  write_gate "$WORK/suite-other.gate.sh" "$LINT_LINE" "run_step 'Strings check suite' 'checks/tests/other.sh'"
  expect_passes "$WORK/suite-other.gate.sh"
}

test_strings_check_before_the_first_of_two_suite_steps_passes() {
  write_gate "$WORK/two-suites.gate.sh" "$LINT_LINE" "$SUITE_LINE" "$SUITE_LINE"
  expect_passes "$WORK/two-suites.gate.sh"
}

test_strings_check_between_two_suite_steps_does_not_pass() {
  write_gate "$WORK/straddle.gate.sh" "$SUITE_LINE" "$LINT_LINE" "$SUITE_LINE"
  expect_rejected "$WORK/straddle.gate.sh"
}

test_unrelated_text_does_not_change_a_pass() {
  write_gate "$WORK/unrelated.gate.sh" \
    "#!/usr/bin/env bash" \
    "set -euo pipefail" \
    "# nothing in this line names either step" \
    "$LINT_LINE" \
    "echo some text that is not a step" \
    "run_step 'Own state' 'checks/own-state-step.sh'" \
    "$SUITE_LINE" \
    "run_step 'Somewhere else' 'checks/else.sh'"
  expect_passes "$WORK/unrelated.gate.sh" || return 1
  # The test holds two conditions and no rule about the other steps: a gate with only the two passes.
  write_gate "$WORK/bare.gate.sh" "$LINT_LINE" "$SUITE_LINE"
  expect_passes "$WORK/bare.gate.sh"
}

test_lookalike_beside_the_strings_check_line_still_counts_once() {
  write_gate "$WORK/look-commented.gate.sh" "# $LINT_LINE" "$LINT_LINE" "$SUITE_LINE"
  expect_passes "$WORK/look-commented.gate.sh" || return 1
  write_gate "$WORK/look-indented.gate.sh" "$LINT_LINE" "  $LINT_LINE" "$SUITE_LINE"
  expect_passes "$WORK/look-indented.gate.sh" || return 1
  write_gate "$WORK/look-other.gate.sh" "$LINT_LINE" "run_step 'Strings check' 'checks/other.sh'" "$SUITE_LINE"
  expect_passes "$WORK/look-other.gate.sh"
}

test_closing_line_counts_cases_actually_run() {
  make_tree closing-pass "$GATE"
  run_nested test_real_gate_runs_strings_check_before_its_suite
  [ "$NESTED_STATUS" -eq 0 ] || fail "a run of one passing case exited $NESTED_STATUS: $NESTED_OUT" || return 1
  [ "$(printf '%s\n' "$NESTED_OUT" | tail -n 1)" = "1 of 1 passed" ] \
    || fail "the last line of a run of one passing case was not '1 of 1 passed': $NESTED_OUT" || return 1
  new_copy closing-deleted || return 1
  delete_lint_line || return 1
  make_tree closing-fail "$COPY"
  run_nested test_real_gate_runs_strings_check_before_its_suite
  [ "$NESTED_STATUS" -ne 0 ] || fail "a suite in which a case failed exited 0: $NESTED_OUT" || return 1
  [ "$(printf '%s\n' "$NESTED_OUT" | tail -n 1)" = "0 of 1 passed" ] \
    || fail "the last line of a run of one failing case was not '0 of 1 passed': $NESTED_OUT"
}

test_copies_live_outside_the_product_tree_and_are_removed() {
  case "$WORK" in
    "$ROOT" | "$ROOT"/*) fail "the temporary directory $WORK is inside the product tree $ROOT" || return 1 ;;
  esac
  new_copy outside || return 1
  case "$COPY" in
    "$WORK"/*) ;;
    *) fail "an edited copy, $COPY, is not under the temporary directory $WORK" || return 1 ;;
  esac
  # A run that passes, and a run in which a case fails, each leave nothing in the directory the
  # temporary directory is made in; the gate they read stays byte-identical.
  make_tree removal-pass "$GATE"
  run_nested test_real_gate_runs_strings_check_before_its_suite
  [ "$NESTED_STATUS" -eq 0 ] || fail "the passing run exited $NESTED_STATUS: $NESTED_OUT" || return 1
  [ -z "$(ls -A "$SCRATCH")" ] || fail "a passing run left $(ls -A "$SCRATCH") behind" || return 1
  new_copy removal-deleted || return 1
  delete_lint_line || return 1
  make_tree removal-fail "$COPY"
  run_nested test_real_gate_runs_strings_check_before_its_suite
  [ "$NESTED_STATUS" -ne 0 ] || fail "the run with a failing case exited 0: $NESTED_OUT" || return 1
  [ -z "$(ls -A "$SCRATCH")" ] || fail "a run with a failing case left $(ls -A "$SCRATCH") behind" || return 1
  cmp -s "$GATE" "$GATE_AT_START" || fail "checks/gate.sh changed while the suite ran" || return 1
  # The two states before any case runs leave nothing behind either.
  make_tree no-gate ""
  run_nested test_real_gate_runs_strings_check_before_its_suite
  [ "$NESTED_STATUS" -ne 0 ] || fail "a run with no gate to read exited 0" || return 1
  printf '%s\n' "$NESTED_OUT" | grep -q -F "The suite found no readable checks/gate.sh at $TREE/checks/gate.sh, so no case ran." \
    || fail "no message said the gate could not be read: $NESTED_OUT" || return 1
  make_tree no-temp "$GATE"
  SCRATCH="$WORK/absent"
  run_nested test_real_gate_runs_strings_check_before_its_suite
  [ "$NESTED_STATUS" -ne 0 ] || fail "a run with no temporary directory to make exited 0" || return 1
  printf '%s\n' "$NESTED_OUT" | grep -q -F "The suite could not create its temporary directory under $SCRATCH, so no case ran." \
    || fail "no message said the temporary directory could not be made: $NESTED_OUT"
}

# --- the runner ---

if [ ! -r "$GATE" ]; then
  echo "The suite found no readable checks/gate.sh at $GATE, so no case ran. Run the suite from inside a clone of KA-Reader: it reads the checks/gate.sh of the tree it sits in." >&2
  exit 1
fi

TEMP_PARENT="${TMPDIR:-/tmp}"
WORK="$(mktemp -d "${TEMP_PARENT%/}/strings-step.XXXXXX" 2>/dev/null)" || {
  echo "The suite could not create its temporary directory under $TEMP_PARENT, so no case ran. Make $TEMP_PARENT writable, then run the suite again." >&2
  exit 1
}
cleanup() {
  [ -z "$WORK" ] || rm -rf "$WORK"
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM

GATE_AT_START="$WORK/gate-at-start"
cp "$GATE" "$GATE_AT_START"

failed=0
total=0
for case_name in $CASES; do
  if [ -n "${KA_READER_TEST_ONLY:-}" ] && [ "$case_name" != "$KA_READER_TEST_ONLY" ]; then
    continue
  fi
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

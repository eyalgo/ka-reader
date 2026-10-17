#!/usr/bin/env bash
# Version: 1.1.0 — gate script holds every rule; workflow calls it; suite readers re-aimed
# Version: 1.0.0 — first version: the refusal of the guarded suites' entry points (NFDR QC-65)
#
# checks/tests/test_vm_refusal.sh — proves that the guarded suites refuse to run off a macOS virtual
# machine, and that the workflow runs the refusal and step suites.
#
# WHY THIS EXISTS
#   test_bundle.sh and test_renderer.sh launch KA-Reader.app, so each now refuses, on its first work,
#   to run on a host that does not read as a macOS virtual machine (docs/nfdr.md QC-65). A suite that
#   refuses cannot be required to run its own refusal case: there is no case to run once it has
#   refused, and a case inside it would only run where the refusal does not apply. So the cases that
#   run those two suites as subjects live here, in a suite that does not launch anything and so has no
#   reason to refuse. Its existing and mandatory cases (the sandbox negative control among them) stay
#   in the suites they belong to.
#   The assertion is checks/tests/support/vm_refusal.sh's: a matrix of host readings, each given to the
#   REAL suite entry point through stand-ins on PATH, and a traced run showing nothing precedes the
#   refusal. The suites are never told which reading they have.
#
# USAGE
#   checks/tests/test_vm_refusal.sh
#   Runs on any host: every reading is a stand-in, and nothing here launches a bundle or reads the
#   machine's home.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BUNDLE_SUITE="$ROOT/checks/tests/test_bundle.sh"
RENDERER_SUITE="$ROOT/checks/tests/test_renderer.sh"
WORKFLOWS="$ROOT/.github/workflows"
WORKFLOW="$WORKFLOWS/ci.yml"
GATE="$ROOT/checks/gate.sh"
TAB=$'\t'
# shellcheck source=checks/tests/support/vm_refusal.sh
source "$ROOT/checks/tests/support/vm_refusal.sh"

WORK=""

CASES="
test_bundle_suite_refuses_off_vm_before_work
test_bundle_suite_admits_on_a_vm_reading
test_renderer_suite_refuses_off_vm_before_work
test_renderer_suite_admits_on_a_vm_reading
test_moved_steps_hold_no_block_and_no_timer_setting
test_moved_steps_are_single_line_commands_in_order
test_every_toplevel_suite_is_an_entire_fatal_step
test_no_conditional_or_nonfatal_step
test_every_runner_names_macos_26
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# The steps of the gate, one per line: the name, a tab, the command. Only a top-level call in the
# gate's literal form is read, so a comment or an indented call is never a step. The gate is read,
# never run. From the first call to the end of the file, the list holds nothing but calls, comments
# and blank lines. Any other line there is read as no list at all: an `if` or a `fi`, a heredoc, a
# function, an `exit` or an `export` around or between the calls can leave a call that never runs,
# or one that runs with a variable set, and a reader that took each call on its own would still
# count it as a step.
gate_steps() {
  [ -f "$GATE" ] || return 0
  first="$(grep -n -m 1 "^run_step '" "$GATE" | cut -d: -f1 || true)"
  [ -n "$first" ] || return 0
  stray="$(tail -n +"$first" "$GATE" | grep -v -E "^run_step '[^']*' '.*'\$|^[[:space:]]*(#.*)?\$" || true)"
  [ -z "$stray" ] || return 0
  sed -n "s/^run_step '\([^']*\)' '\(.*\)'\$/\1${TAB}\2/p" "$GATE"
}

# Reads the gate's steps into $steps, or fails when none was read.
read_gate_steps() {
  steps="$(gate_steps)"
  [ -n "$steps" ] || fail "no step was read from checks/gate.sh, so nothing was checked"
}

# Puts the command of the gate's step named $1 in $gate_command; fails when the name is on no step
# or on more than one.
gate_command_of() {
  count="$(printf '%s\n' "$steps" | awk -F'\t' -v want="$1" '$1 == want' | wc -l | tr -d ' ')"
  [ "$count" -ge 1 ] || fail "checks/gate.sh has no step named \"$1\"" || return 1
  [ "$count" -le 1 ] || fail "checks/gate.sh has more than one step named \"$1\"" || return 1
  gate_command="$(printf '%s\n' "$steps" | awk -F'\t' -v want="$1" '$1 == want { print substr($0, length($1) + 2) }')"
}

# Fails unless the gate's step named $1 runs exactly $2.
assert_gate_step_runs_exactly() {
  gate_command_of "$1" || return 1
  [ "$gate_command" = "$2" ] \
    || fail "the step \"$1\" in checks/gate.sh does not run exactly $2, with no variable or timer set for it"
}

# --- cases ---

# QC-65 (CP-797, CP-798, CP-799, CP-801): off a macOS virtual machine the bundle suite prints its one
# refusal line and does nothing else, whatever it is given. Nothing precedes the line: no bundle lookup,
# no temporary directory, no case, no `ok` or `FAIL` line, no write of the work-directory log.
test_bundle_suite_refuses_off_vm_before_work() {
  VMR_TMP="$WORK"
  scene="$WORK/bundle-suite-scene"
  mkdir -p "$scene/Fake.app"
  # The scene holds the work-directory log's path, so a suite that wrote it would change the scene.
  workdir_log="$scene/workdir.log"
  VMR_SCENE="$scene"

  # Every run names an app that is absent or a bare directory, so a suite that did not refuse could
  # never reach the real bundle: it would stop at its own missing-bundle message, or fail a case at once.
  VMR_ENV=("KA_READER_APP=/nonexistent/KA-Reader.app")
  vmr_assert_refusal "$BUNDLE_SUITE" test_bundle.sh || return 1
  VMR_ENV=("KA_READER_APP=$scene/Fake.app" "KA_READER_TEST_ONLY=test_real_bundle_passes")
  vmr_assert_refusal "$BUNDLE_SUITE" test_bundle.sh || return 1
  VMR_ENV=("KA_READER_APP=$scene/Fake.app" "KA_READER_TEST_ONLY=test_no_such_case")
  vmr_assert_refusal "$BUNDLE_SUITE" test_bundle.sh || return 1
  VMR_ENV=("KA_READER_APP=$scene/Fake.app" "KA_READER_TEST_ONLY=test_real_bundle_passes" "KA_READER_TEST_WORKDIR_LOG=$workdir_log")
  vmr_assert_refusal "$BUNDLE_SUITE" test_bundle.sh || return 1
  [ ! -e "$workdir_log" ] || fail "the refused suite wrote the work-directory log: $workdir_log"
}

# CP-798/CP-800: on a virtual machine's reading the admission adds no line and the suite goes on to its
# first case. The selected case calls bundle.sh on a path that does not exist, so no real bundle is
# launched; the suite's own closing verdict (the negative control did not run) is not this case's.
test_bundle_suite_admits_on_a_vm_reading() {
  VMR_TMP="$WORK"
  scene="$WORK/bundle-suite-admit-scene"
  mkdir -p "$scene/Fake.app"
  VMR_SCENE=""
  VMR_ENV=("KA_READER_APP=$scene/Fake.app" "KA_READER_TEST_ONLY=test_nonexistent_path_fails")

  vmr_run_on admit "$BUNDLE_SUITE" || return 1

  grep -q '^ok   test_nonexistent_path_fails$' "$vmr_case/stdout" \
    || fail "the suite did not reach its first case. stdout: $(cat "$vmr_case/stdout"); stderr: $(cat "$vmr_case/stderr")" \
    || return 1
  if grep -q 'refused' "$vmr_case/stdout" "$vmr_case/stderr"; then
    fail "a refusal line appeared on a virtual machine's reading. stderr: $(cat "$vmr_case/stderr")"
  fi
}

# QC-65 (CP-797, CP-798, CP-799, CP-801): off a macOS virtual machine the renderer suite prints its one
# refusal line and does nothing else: no temporary work, fixture read, case, control compile, `ok` or
# `FAIL` line, and no `open`. The helper's stand-ins record `open` and every compile or fixture tool.
test_renderer_suite_refuses_off_vm_before_work() {
  VMR_TMP="$WORK"
  scene="$WORK/renderer-suite-scene"
  mkdir -p "$scene"
  VMR_SCENE="$scene"

  # Every run selects a case: a suite that did not refuse runs only the one named, and a nonexistent
  # name runs none. Both run on stand-ins that cannot launch anything.
  VMR_ENV=("KA_READER_TEST_ONLY=test_real_bundle_passes")
  vmr_assert_refusal "$RENDERER_SUITE" test_renderer.sh || return 1
  VMR_ENV=("KA_READER_TEST_ONLY=test_no_such_case")
  vmr_assert_refusal "$RENDERER_SUITE" test_renderer.sh || return 1
  VMR_ENV=("KA_READER_TEST_ONLY=test_real_bundle_passes" "TMPDIR=$scene")
  vmr_assert_refusal "$RENDERER_SUITE" test_renderer.sh || return 1
}

# CP-798/CP-800: on a virtual machine's reading the admission adds no line and the suite goes on to its
# first case. The selected case runs renderer.sh on a path that is not an app, which launches nothing.
test_renderer_suite_admits_on_a_vm_reading() {
  VMR_TMP="$WORK"
  VMR_SCENE=""
  VMR_ENV=("KA_READER_TEST_ONLY=test_not_an_app_launches_nothing")

  vmr_run_on admit "$RENDERER_SUITE" || return 1

  grep -q '^ok   test_not_an_app_launches_nothing$' "$vmr_case/stdout" \
    || fail "the suite did not reach its first case. stdout: $(cat "$vmr_case/stdout"); stderr: $(cat "$vmr_case/stderr")" \
    || return 1
  if grep -q 'refused' "$vmr_case/stdout" "$vmr_case/stderr"; then
    fail "a refusal line appeared on a virtual machine's reading. stderr: $(cat "$vmr_case/stderr")"
  fi
}

# CP-792, CP-795: the two moved steps are exactly their scripts, with no timer setting and no
# environment prefix; the rule they carried is in the scripts. Asserted over the gate's own calls.
test_moved_steps_hold_no_block_and_no_timer_setting() {
  read_gate_steps || return 1
  assert_gate_step_runs_exactly "Launch the built bundle" "checks/launch.sh" || return 1
  assert_gate_step_runs_exactly "Own state" "checks/own-state-step.sh"
}

# CP-792, CP-795: each moved step calls exactly its script, keeps its name, and sits where it sat in
# the gate: the renderer gate suite before the real launch, and Own state after it and last. In the
# workflow, the step that runs the gate is the step directly before packaging.
test_moved_steps_are_single_line_commands_in_order() {
  read_gate_steps || return 1
  assert_gate_step_runs_exactly "Launch the built bundle" "checks/launch.sh" || return 1
  assert_gate_step_runs_exactly "Own state" "checks/own-state-step.sh" || return 1
  gate_command_of "Renderer gate suite" || return 1

  names="$(printf '%s\n' "$steps" | awk -F'\t' '{ print $1 }')"
  position() { printf '%s\n' "$names" | grep -n -x -F "$1" | head -1 | cut -d: -f1; }
  renderer_suite="$(position "Renderer gate suite")"
  launch="$(position "Launch the built bundle")"
  own_state="$(position "Own state")"
  [ "$renderer_suite" -lt "$launch" ] \
    || fail "in checks/gate.sh, \"Renderer gate suite\" does not come before \"Launch the built bundle\"" || return 1
  [ "$launch" -lt "$own_state" ] \
    || fail "in checks/gate.sh, \"Own state\" does not come after \"Launch the built bundle\"" || return 1
  [ "$own_state" -eq "$(printf '%s\n' "$names" | wc -l | tr -d ' ')" ] \
    || fail "in checks/gate.sh, \"Own state\" is not the last step" || return 1

  # The workflow's gate steps and packaging steps counted, and where each sits among the steps.
  set -- $(awk '
    /^      - / { step_number++ }
    $0 == "        run: checks/gate.sh" { gates++; gate_at = step_number }
    $0 == "      - name: Package KA-Reader.app" { packages++; package_at = step_number }
    END { print gates + 0, gate_at + 0, packages + 0, package_at + 0 }
  ' "$WORKFLOW")
  gate_count="$1" gate_at="$2" package_count="$3" package_at="$4"
  [ "$gate_count" -ge 1 ] || fail "the workflow has no step whose entire run is checks/gate.sh" || return 1
  [ "$gate_count" -le 1 ] || fail "the workflow has more than one step whose entire run is checks/gate.sh" || return 1
  [ "$package_count" -ge 1 ] || fail "the workflow has no step named \"Package KA-Reader.app\"" || return 1
  [ "$((gate_at + 1))" -eq "$package_at" ] \
    || fail "in the workflow, the step that runs checks/gate.sh is not the step directly before \"Package KA-Reader.app\""
}

# CP-803: every top-level suite is the entire command of a step of the gate, so none is left off it.
test_every_toplevel_suite_is_an_entire_fatal_step() {
  read_gate_steps || return 1
  commands="$(printf '%s\n' "$steps" | awk -F'\t' '{ print substr($0, length($1) + 2) }')"
  checked=0
  for suite in "$ROOT"/checks/tests/*.sh; do
    checked=$((checked + 1))
    printf '%s\n' "$commands" | grep -q -x -F "checks/tests/$(basename "$suite")" \
      || fail "checks/tests/$(basename "$suite") is not the entire command of a step in checks/gate.sh" || return 1
  done
  [ "$checked" -gt 0 ] || fail "no top-level suite was found, so nothing was checked"
}

# CP-803: no step is conditional and none may fail without failing the run.
test_no_conditional_or_nonfatal_step() {
  found="$(grep -n -E 'continue-on-error|^[[:space:]]+if:' "$WORKFLOW" || true)"
  [ -z "$found" ] || fail "a conditional or non-fatal step: $found"
}

# CP-804: every runner the workflows name is macos-26, the image whose virtual machine the refusal needs.
test_every_runner_names_macos_26() {
  runners="$(grep -h -E '^[[:space:]]*runs-on:' "$WORKFLOWS"/*.yml || true)"
  [ -n "$runners" ] || fail "no workflow names a runner, so nothing was checked" || return 1
  other="$(printf '%s\n' "$runners" | grep -v -E 'runs-on:[[:space:]]*macos-26[[:space:]]*$' || true)"
  [ -z "$other" ] || fail "a runner other than macos-26: $other"
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

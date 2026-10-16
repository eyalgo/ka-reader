#!/usr/bin/env bash
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

# The text of the workflow step named $1: its name line down to the line before the next step's.
step_text() {
  awk -v want="      - name: $1" '
    /^      - name: / { printing = ($0 == want) }
    printing { print }
  ' "$WORKFLOW"
}

# The step names of the workflow, one per line, in order.
step_names() {
  sed -n 's/^      - name: //p' "$WORKFLOW"
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

# CP-792, CP-795 (workflow proof): the two moved steps hold no multi-line block and no timer setting; the
# rule they carried is in the scripts. Asserted over the real workflow, which acquires no rule of its own.
test_moved_steps_hold_no_block_and_no_timer_setting() {
  for step in "Launch the built bundle" "Own state"; do
    text="$(step_text "$step")"
    [ -n "$text" ] || fail "the workflow has no step named $step" || return 1
    case "$text" in
      *"run: |"* | *"run: >"*) fail "step $step still holds a multi-line run block" || return 1 ;;
    esac
    case "$text" in
      *CONTAINER_WAIT_TICKS* | *"env:"*) fail "step $step still sets a timer or any environment" || return 1 ;;
    esac
  done
}

# CP-792, CP-795: each moved step calls exactly its script as its whole run, keeps its name, and sits where
# it sat: the renderer gate suite before the real launch, and Own state last before packaging.
test_moved_steps_are_single_line_commands_in_order() {
  [ "$(step_text "Launch the built bundle" | grep -c '^        run:')" -eq 1 ] \
    && step_text "Launch the built bundle" | grep -q -x '        run: checks/launch.sh' \
    || fail "Launch the built bundle is not exactly run: checks/launch.sh" || return 1
  [ "$(step_text "Own state" | grep -c '^        run:')" -eq 1 ] \
    && step_text "Own state" | grep -q -x '        run: checks/own-state-step.sh' \
    || fail "Own state is not exactly run: checks/own-state-step.sh" || return 1

  names="$(step_names)"
  position() { printf '%s\n' "$names" | grep -n -x -F "$1" | head -1 | cut -d: -f1; }
  renderer_suite="$(position "Renderer gate suite")"
  launch="$(position "Launch the built bundle")"
  own_state="$(position "Own state")"
  packaging="$(position "Package KA-Reader.app")"
  for found in "$renderer_suite" "$launch" "$own_state" "$packaging"; do
    [ -n "$found" ] || fail "a step the order depends on is missing from the workflow" || return 1
  done
  [ "$renderer_suite" -lt "$launch" ] || fail "Renderer gate suite does not come before Launch the built bundle" || return 1
  [ "$launch" -lt "$own_state" ] || fail "Own state does not come after Launch the built bundle" || return 1
  [ "$((own_state + 1))" -eq "$packaging" ] || fail "Own state is not the step directly before Package KA-Reader.app"
}

# CP-803: every top-level suite is the entire run of a step, so none is left off the workflow.
test_every_toplevel_suite_is_an_entire_fatal_step() {
  checked=0
  for suite in "$ROOT"/checks/tests/*.sh; do
    checked=$((checked + 1))
    grep -q -x "        run: checks/tests/$(basename "$suite")" "$WORKFLOW" \
      || fail "checks/tests/$(basename "$suite") is not the entire run of a workflow step" || return 1
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

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
# shellcheck source=checks/tests/support/vm_refusal.sh
source "$ROOT/checks/tests/support/vm_refusal.sh"

WORK=""

CASES="
test_bundle_suite_refuses_off_vm_before_work
test_bundle_suite_admits_on_a_vm_reading
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
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

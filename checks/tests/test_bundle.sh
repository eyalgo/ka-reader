#!/usr/bin/env bash
# Version: 1.0.0 — first version: drives the real checks/bundle.sh against the built Nozoki.app
#
# checks/tests/test_bundle.sh — the tests of checks/bundle.sh.
#
# WHY THIS EXISTS
#   checks/bundle.sh is the wall's proof on a built bundle, so a bug in it is a wall nobody is
#   checking. These cases run the real script — never a copy of its logic — against the real built
#   bundle and against re-signed copies of it, with the outside world (`ps`, `open`) stubbed on PATH.
#   The technique is the shell packet's, minus its runner: this product has no Python, so the runner
#   is this file (`docs/nfdr.md` § 9 names the product's toolchains).
#
# USAGE
#   NOZOKI_APP=<path-to-Nozoki.app> checks/tests/test_bundle.sh
#     NOZOKI_APP defaults to target/release/bundle/macos/Nozoki.app under the product root.
#   A bundle that is absent FAILS the suite with a stated message and runs no case: a skip would
#   let CI conclude green having proved nothing.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BUNDLE_SH="$ROOT/checks/bundle.sh"
APP="${NOZOKI_APP:-$ROOT/target/release/bundle/macos/Nozoki.app}"

APP_SANDBOX_KEY="com.apple.security.app-sandbox"
USER_SELECTED_READ_ONLY_KEY="com.apple.security.files.user-selected.read-only"
EXTRA_KEY="com.apple.security.files.bookmarks.app-scope"
# The legacy marker's name, assembled from two halves so this file carries no literal of it: the case
# that proves the marker is gone from the tree greps for the literal (CP-41), and a literal here would
# make that grep find its own subject.
LEGACY_MARKER="APP_SANDBOX""_CONTAINER_ID"
PROBE_SOURCE="$ROOT/checks/sandbox_probe.rs"

OUT=""
STATUS=0
WORK=""

CASES="
test_real_bundle_passes
test_outbound_connection_allowed_fails
test_out_of_grant_read_allowed_fails
test_not_sandboxed_fails
test_marker_in_the_environment_does_not_pass
test_marker_is_absent_from_the_tree
test_existing_container_is_not_evidence
test_unresolvable_symbol_fails
test_probe_error_fails
test_probe_reports_an_unsandboxed_pid_as_unsandboxed
test_probe_fails_on_a_pid_that_does_not_exist
test_extra_key_fails_before_launch
test_false_value_fails
test_missing_key_fails
test_no_sandbox_observed_fails_and_cleans_up
test_nonexistent_path_fails
test_plain_directory_fails
test_directory_without_app_suffix_fails
test_unlaunchable_bundle_fails
test_absent_bundle_fails_the_suite
test_temporaries_removed
"

# --- helpers ---

regex_escape() {
  printf '%s' "$1" | sed 's/[][\.*^$(){}?+|/]/\\&/g'
}

# Every process whose executable sits inside the bundle at $1.
bundle_processes() {
  pgrep -f "^$(regex_escape "$1")/Contents/MacOS/" || true
}

run_bundle_sh() {
  OUT="$("$BUNDLE_SH" "$@" 2>&1)"
  STATUS=$?
}

# Same, with a stub directory ahead of the real tools on PATH.
run_bundle_sh_with_stubs() {
  stubs="$1"
  shift
  OUT="$(PATH="$stubs:$PATH" "$BUNDLE_SH" "$@" 2>&1)"
  STATUS=$?
}

make_stub() {
  printf '#!/bin/sh\n%s\n' "$3" > "$1/$2"
  chmod +x "$1/$2"
}

fail() {
  echo "  $*"
  return 1
}

expect_nonzero_status() {
  [ "$STATUS" -ne 0 ] || fail "expected a non-zero exit, got 0. output: $OUT"
}

expect_output_contains() {
  case "$OUT" in
    *"$1"*) return 0 ;;
  esac
  fail "expected the output to contain: $1. output: $OUT"
}

expect_output_lacks() {
  case "$OUT" in
    *"$1"*) fail "expected the output not to contain: $1. output: $OUT" ;;
  esac
}

expect_no_bundle_process() {
  left="$(bundle_processes "$1")"
  [ -z "$left" ] || fail "processes of $1 are still running: $left"
}

# A copy of the built bundle in $WORK, re-signed ad hoc with the entitlements in file $2.
resigned_copy() {
  copy="$WORK/$1/Nozoki.app"
  mkdir -p "$WORK/$1"
  cp -R "$APP" "$copy"
  codesign --force --sign - --entitlements "$2" "$copy" > /dev/null 2>&1 || return 1
  printf '%s' "$copy"
}

# A stand-in for `nozoki-sandbox-probe`, placed ahead of the real one on PATH. $2 is the sandboxed
# line, $3 the out-of-grant read line, $4 the outbound connection line — each the value the real probe
# would print, so one condition at a time can be made to fail without an unsandboxed bundle.
probe_stub() {
  make_stub "$1" nozoki-sandbox-probe "printf 'sandboxed: %s\nout-of-grant-read: %s\noutbound-connection: %s\n' $2 $3 $4"
}

write_entitlements() {
  path="$1"
  shift
  {
    echo '<?xml version="1.0" encoding="UTF-8"?>'
    echo '<plist version="1.0"><dict>'
    while [ $# -gt 1 ]; do
      echo "<key>$1</key><$2/>"
      shift 2
    done
    echo '</dict></plist>'
  } > "$path"
}

# The real probe, compiled once per case that needs it, into $WORK/probe-bin.
compile_probe() {
  mkdir -p "$WORK/probe-bin"
  rustc --edition 2021 -O -o "$WORK/probe-bin/nozoki-sandbox-probe" "$PROBE_SOURCE" > "$WORK/probe-build.log" 2>&1 \
    || fail "the probe source did not compile: $(cat "$WORK/probe-build.log" 2> /dev/null)"
}

# --- cases ---

test_real_bundle_passes() {
  run_bundle_sh "$APP"
  [ "$STATUS" -eq 0 ] || fail "expected exit 0 on the real bundle, got $STATUS. output: $OUT" || return 1
  expect_output_contains "$APP_SANDBOX_KEY" || return 1
  expect_output_contains "$USER_SELECTED_READ_ONLY_KEY" || return 1
  expect_output_contains "sandboxed: yes" || return 1
  expect_output_contains "out-of-grant-read: denied" || return 1
  expect_output_contains "outbound-connection: denied" || return 1
  expect_no_bundle_process "$APP"
}

# One condition at a time: the probe stub reports two of the three as held and one as not.
test_outbound_connection_allowed_fails() {
  mkdir -p "$WORK/stubs-outbound"
  probe_stub "$WORK/stubs-outbound" yes denied allowed

  run_bundle_sh_with_stubs "$WORK/stubs-outbound" "$APP"

  expect_nonzero_status || return 1
  expect_output_contains "an outbound network connection is not denied" || return 1
  expect_no_bundle_process "$APP"
}

test_out_of_grant_read_allowed_fails() {
  mkdir -p "$WORK/stubs-read"
  probe_stub "$WORK/stubs-read" yes allowed denied

  run_bundle_sh_with_stubs "$WORK/stubs-read" "$APP"

  expect_nonzero_status || return 1
  expect_output_contains "an out-of-grant file read is not denied" || return 1
  expect_no_bundle_process "$APP"
}

test_not_sandboxed_fails() {
  mkdir -p "$WORK/stubs-unsandboxed"
  probe_stub "$WORK/stubs-unsandboxed" no denied denied

  run_bundle_sh_with_stubs "$WORK/stubs-unsandboxed" "$APP"

  expect_nonzero_status || return 1
  expect_output_contains "the launched process is not sandboxed" || return 1
  expect_no_bundle_process "$APP"
}

# `sandbox_check` answers "sandboxed, everything denied" for a pid that names no process at all — a
# measured false positive (pid 99999999, this change). A wall check that reads it as a pass would pass
# on a process that is not there, so the probe must fail on a pid it cannot find.
test_probe_fails_on_a_pid_that_does_not_exist() {
  compile_probe || return 1

  OUT="$("$WORK/probe-bin/nozoki-sandbox-probe" 99999999 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_output_lacks "sandboxed: yes"
}

test_extra_key_fails_before_launch() {
  mkdir -p "$WORK/stubs-extra"
  make_stub "$WORK/stubs-extra" open "echo \"\$@\" >> \"$WORK/open-extra.log\""
  write_entitlements "$WORK/extra.plist" "$APP_SANDBOX_KEY" true "$USER_SELECTED_READ_ONLY_KEY" true "$EXTRA_KEY" true
  copy="$(resigned_copy extra "$WORK/extra.plist")" || fail "could not re-sign the copy" || return 1

  run_bundle_sh_with_stubs "$WORK/stubs-extra" "$copy"

  expect_nonzero_status || return 1
  expect_output_contains "extra entitlement: $EXTRA_KEY" || return 1
  [ ! -e "$WORK/open-extra.log" ] || fail "the copy was launched: $(cat "$WORK/open-extra.log")"
}

test_false_value_fails() {
  write_entitlements "$WORK/false.plist" "$APP_SANDBOX_KEY" false "$USER_SELECTED_READ_ONLY_KEY" true
  copy="$(resigned_copy false "$WORK/false.plist")" || fail "could not re-sign the copy" || return 1

  run_bundle_sh "$copy"

  expect_nonzero_status || return 1
  expect_output_contains "entitlement not true: $APP_SANDBOX_KEY" || return 1
  expect_no_bundle_process "$copy"
}

test_missing_key_fails() {
  write_entitlements "$WORK/missing.plist" "$USER_SELECTED_READ_ONLY_KEY" true
  copy="$(resigned_copy missing "$WORK/missing.plist")" || fail "could not re-sign the copy" || return 1

  run_bundle_sh "$copy"

  expect_nonzero_status || return 1
  expect_output_contains "missing entitlement: $APP_SANDBOX_KEY" || return 1
  expect_no_bundle_process "$copy"
}

test_no_sandbox_observed_fails_and_cleans_up() {
  mkdir -p "$WORK/stubs-nosandbox"
  probe_stub "$WORK/stubs-nosandbox" no allowed allowed

  run_bundle_sh_with_stubs "$WORK/stubs-nosandbox" "$APP"

  expect_nonzero_status || return 1
  expect_output_contains "the launched process is not sandboxed" || return 1
  expect_no_bundle_process "$APP"
}

# The inverse of the case the legacy marker used to have: the launched process carries the marker and
# the operating system says it is not sandboxed — the marker changes nothing (CP-41).
test_marker_in_the_environment_does_not_pass() {
  mkdir -p "$WORK/stubs-marker"
  probe_stub "$WORK/stubs-marker" no allowed allowed

  OUT="$(env "$LEGACY_MARKER=com.kensaiapp.nozoki" PATH="$WORK/stubs-marker:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_output_contains "the launched process is not sandboxed" || return 1
  expect_no_bundle_process "$APP"
}

test_marker_is_absent_from_the_tree() {
  hits="$(grep -n "$LEGACY_MARKER" "$BUNDLE_SH" "$ROOT/checks/tests/test_bundle.sh" || true)"
  [ -z "$hits" ] || fail "the legacy marker is still in the tree: $hits"
}

# A container directory the bundle's identifier names is not evidence of a sandbox (CP-41). HOME is
# redirected so the directory is created in the scratch area, never in the real ~/Library.
test_existing_container_is_not_evidence() {
  mkdir -p "$WORK/stubs-container" "$WORK/home/Library/Containers/com.kensaiapp.nozoki"
  probe_stub "$WORK/stubs-container" no allowed allowed

  OUT="$(HOME="$WORK/home" PATH="$WORK/stubs-container:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_output_contains "the launched process is not sandboxed" || return 1
  expect_no_bundle_process "$APP"
}

# `sandbox_check` cannot be resolved: the run fails naming the symbol, and says nothing that reads as a
# pass or as a denial (CP-43).
test_unresolvable_symbol_fails() {
  mkdir -p "$WORK/stubs-unresolvable"
  make_stub "$WORK/stubs-unresolvable" nozoki-sandbox-probe 'echo "nozoki-sandbox-probe: sandbox_check cannot be resolved" >&2; exit 2'

  run_bundle_sh_with_stubs "$WORK/stubs-unresolvable" "$APP"

  expect_nonzero_status || return 1
  expect_output_contains "sandbox_check" || return 1
  expect_output_lacks "sandboxed: yes" || return 1
  expect_output_lacks "denied" || return 1
  expect_no_bundle_process "$APP"
}

test_probe_error_fails() {
  mkdir -p "$WORK/stubs-error"
  make_stub "$WORK/stubs-error" nozoki-sandbox-probe 'echo "nozoki-sandbox-probe: sandbox_check returned an error" >&2; exit 1'

  run_bundle_sh_with_stubs "$WORK/stubs-error" "$APP"

  expect_nonzero_status || return 1
  expect_output_contains "sandbox_check" || return 1
  expect_output_lacks "sandboxed: yes" || return 1
  expect_output_lacks "denied" || return 1
  expect_no_bundle_process "$APP"
}

# Every other case stubs the probe, so this is the one that holds the real probe's output contract:
# the suite's own shell is unsandboxed, and the compiled probe must say so in the lines the script parses.
test_probe_reports_an_unsandboxed_pid_as_unsandboxed() {
  compile_probe || return 1

  OUT="$("$WORK/probe-bin/nozoki-sandbox-probe" "$$" 2>&1)"
  STATUS=$?

  [ "$STATUS" -eq 0 ] || fail "expected the probe to exit 0 on an unsandboxed pid, got $STATUS. output: $OUT" || return 1
  expect_output_contains "sandboxed: no"
}

test_nonexistent_path_fails() {
  run_bundle_sh /nonexistent/Nozoki.app

  expect_nonzero_status || return 1
  expect_output_contains "not found: /nonexistent/Nozoki.app"
}

test_plain_directory_fails() {
  mkdir -p "$WORK/plain-directory"

  run_bundle_sh "$WORK/plain-directory"

  expect_nonzero_status || return 1
  expect_output_contains "not an application bundle"
}

test_directory_without_app_suffix_fails() {
  # Everything a launchable bundle has except the .app suffix, so only the suffix rule can stop it.
  mkdir -p "$WORK/NotAnApp/Contents/MacOS"
  printf '#!/bin/sh\nexit 0\n' > "$WORK/NotAnApp/Contents/MacOS/notanapp"
  chmod +x "$WORK/NotAnApp/Contents/MacOS/notanapp"
  cat > "$WORK/NotAnApp/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>notanapp</string>
</dict></plist>
PLIST

  run_bundle_sh "$WORK/NotAnApp"

  expect_nonzero_status || return 1
  expect_output_contains "not an application bundle"
}

test_unlaunchable_bundle_fails() {
  mkdir -p "$WORK/Unlaunchable.app/Contents"
  cat > "$WORK/Unlaunchable.app/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>unlaunchable</string>
<key>CFBundleIdentifier</key><string>com.example.unlaunchable</string>
</dict></plist>
PLIST

  run_bundle_sh "$WORK/Unlaunchable.app"

  expect_nonzero_status || return 1
  expect_output_contains "cannot be launched"
}

test_absent_bundle_fails_the_suite() {
  # The suite is run as its own subject: with the bundle absent it must exit non-zero, say why, and
  # run no case (a case that ran would print an "ok" or "FAIL" line).
  nested="$(NOZOKI_APP=/nonexistent/Nozoki.app bash "$0" 2>&1)"
  nested_status=$?

  [ "$nested_status" -ne 0 ] || fail "the suite exited 0 with no bundle to test" || return 1
  case "$nested" in
    *"the bundle under test is absent: /nonexistent/Nozoki.app"*) ;;
    *) fail "no stated message. output: $nested" || return 1 ;;
  esac
  case "$nested" in
    *"ok   test_"* | *"FAIL test_"*) fail "the suite ran a case with no bundle. output: $nested" ;;
  esac
}

test_temporaries_removed() {
  # Run one re-signing case in a nested suite, learn where its temporary directory was, and look
  # for it after that suite has exited.
  log="$WORK/nested-workdir.log"
  NOZOKI_TEST_ONLY=test_missing_key_fails NOZOKI_TEST_WORKDIR_LOG="$log" bash "$0" > /dev/null 2>&1

  nested_work="$(cat "$log" 2> /dev/null || true)"
  [ -n "$nested_work" ] || fail "the nested suite recorded no temporary directory" || return 1
  [ ! -e "$nested_work" ] || fail "the temporary directory still exists: $nested_work"
}

# --- the runner ---

if [ ! -d "$APP" ]; then
  echo "test_bundle.sh: the bundle under test is absent: $APP — build it first (the bundle command), or set NOZOKI_APP" >&2
  exit 1
fi

WORK="$(mktemp -d)"
[ -z "${NOZOKI_TEST_WORKDIR_LOG:-}" ] || printf '%s' "$WORK" > "$NOZOKI_TEST_WORKDIR_LOG"
cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

failed=0
for case_name in $CASES; do
  if [ -n "${NOZOKI_TEST_ONLY:-}" ] && [ "$case_name" != "$NOZOKI_TEST_ONLY" ]; then
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
  echo "test_bundle.sh: $failed case(s) failed" >&2
  exit 1
fi

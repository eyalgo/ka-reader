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
SANDBOX_MARKER="APP_SANDBOX_CONTAINER_ID"

OUT=""
STATUS=0
WORK=""

CASES="
test_real_bundle_passes
test_extra_key_fails_before_launch
test_false_value_fails
test_missing_key_fails
test_no_sandbox_observed_fails_and_cleans_up
test_marker_in_the_environment_passes
test_nonexistent_path_fails
test_plain_directory_fails
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

# --- cases ---

test_real_bundle_passes() {
  run_bundle_sh "$APP"
  [ "$STATUS" -eq 0 ] || fail "expected exit 0 on the real bundle, got $STATUS. output: $OUT" || return 1
  expect_output_contains "$APP_SANDBOX_KEY" || return 1
  expect_output_contains "$USER_SELECTED_READ_ONLY_KEY" || return 1
  expect_no_bundle_process "$APP"
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
  make_stub "$WORK/stubs-nosandbox" ps 'echo "/some/executable HOME=/Users/someone PATH=/usr/bin"'

  run_bundle_sh_with_stubs "$WORK/stubs-nosandbox" "$APP"

  expect_nonzero_status || return 1
  expect_output_contains "sandbox not found in the launched process" || return 1
  expect_no_bundle_process "$APP"
}

# The positive twin of the case above. It separates "the script is right" from "the bundle is
# sandboxed": with the marker present in the observed environment the script must pass.
test_marker_in_the_environment_passes() {
  mkdir -p "$WORK/stubs-marker"
  make_stub "$WORK/stubs-marker" ps "echo \"/some/executable $SANDBOX_MARKER=com.kensaiapp.nozoki HOME=/Users/someone\""

  run_bundle_sh_with_stubs "$WORK/stubs-marker" "$APP"

  [ "$STATUS" -eq 0 ] || fail "expected exit 0 with the marker present, got $STATUS. output: $OUT" || return 1
  expect_no_bundle_process "$APP"
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

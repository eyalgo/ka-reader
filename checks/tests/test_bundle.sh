#!/usr/bin/env bash
# Version: 1.0.0 — first version: drives the real checks/bundle.sh against the built Nozoki.app
#
# checks/tests/test_bundle.sh — the tests of checks/bundle.sh.
#
# WHY THIS EXISTS
#   checks/bundle.sh is the wall's proof on a built bundle, so a bug in it is a wall nobody is
#   checking. These cases run the real script — never a copy of its logic — against the real built
#   bundle and against re-signed copies of it, with the outside world (`ps`, `open` and the sandbox
#   probe) stubbed on PATH.
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
# The case without which the probe has not run (NFDR QC-25): the same probe, on the same bundle
# re-signed with no entitlements, must report it NOT sandboxed. The runner, not a case, records that
# it ran — a case cannot detect its own absence.
CONTROL_CASE="test_negative_control_reports_unsandboxed"

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
test_instance_already_running_fails_before_launch
test_no_process_appears_fails
test_more_than_one_process_fails
test_more_than_one_process_signals_neither
test_already_running_copy_survives
test_only_the_launched_pid_is_signalled
test_negative_control_reports_unsandboxed
test_negative_control_reported_sandboxed_fails
test_negative_control_reported_sandboxed_fails_the_suite
test_absent_control_fails_the_suite
test_negative_control_refuses_the_c_r2_entitlement_set
test_second_executable_fails
test_renderer_file_outside_resources_fails
test_renderer_file_directly_under_contents_fails
test_renderer_file_under_resources_passes
test_absent_frontend_dist_states_an_empty_set
test_named_frontend_dist_that_does_not_exist_fails
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

# The executable path a bundle's main process has: <app>/Contents/MacOS/<CFBundleExecutable>, with the
# bundle path resolved the way checks/bundle.sh resolves it.
bundle_executable_of() {
  resolved="$(cd "$1" && pwd -P)"
  name="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' "$resolved/Contents/Info.plist")"
  printf '%s/Contents/MacOS/%s' "$resolved" "$name"
}

# Every process whose executable path is exactly $1 — the identification the script itself uses,
# never a command-line pattern.
pids_of_executable() {
  /bin/ps -axo pid=,comm= | while read -r candidate candidate_path; do
    if [ "$candidate_path" = "$1" ]; then
      echo "$candidate"
    fi
  done
}

# Starts a real instance of the bundle at $1 the way a user would, waits for its process, and prints
# its pid. The pid is recorded so the runner's cleanup stops it whatever the case's verdict.
start_instance() {
  open -n -g "$1" || return 1
  executable="$(bundle_executable_of "$1")"
  waited=0
  while [ "$waited" -lt 80 ]; do
    started="$(pids_of_executable "$executable" | head -1)"
    if [ -n "$started" ]; then
      echo "$started" >> "$WORK/started-pids"
      printf '%s' "$started"
      return 0
    fi
    sleep 0.25
    waited=$((waited + 1))
  done
  return 1
}

process_is_running() {
  kill -0 "$1" 2> /dev/null
}

# A copy of the built bundle carrying exactly the C-R2 entitlement set, so it passes the entitlement
# half of the script and reaches the launch.
valid_copy() {
  write_entitlements "$WORK/valid.plist" "$APP_SANDBOX_KEY" true "$USER_SELECTED_READ_ONLY_KEY" true
  resigned_copy "$1" "$WORK/valid.plist"
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

# CP-42: three counts, three named failures. `ps` is stubbed on PATH; `open` is stubbed too, so nothing
# is launched and the stubbed `ps` is the only thing that says what is running.
test_instance_already_running_fails_before_launch() {
  executable="$(bundle_executable_of "$APP")"
  mkdir -p "$WORK/stubs-running"
  make_stub "$WORK/stubs-running" open "echo \"\$@\" >> \"$WORK/open-running.log\""
  make_stub "$WORK/stubs-running" ps "echo \"424242 $executable\""

  run_bundle_sh_with_stubs "$WORK/stubs-running" "$APP"

  expect_nonzero_status || return 1
  expect_output_contains "an instance was already running" || return 1
  [ ! -e "$WORK/open-running.log" ] || fail "the bundle was launched: $(cat "$WORK/open-running.log")"
}

test_no_process_appears_fails() {
  mkdir -p "$WORK/stubs-none"
  make_stub "$WORK/stubs-none" open "exit 0"
  make_stub "$WORK/stubs-none" ps "exit 0"

  OUT="$(BUNDLE_SH_LAUNCH_TICKS=2 PATH="$WORK/stubs-none:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_output_contains "no process appeared"
}

test_more_than_one_process_fails() {
  executable="$(bundle_executable_of "$APP")"
  mkdir -p "$WORK/stubs-many"
  make_stub "$WORK/stubs-many" open "echo launched > \"$WORK/open-many.log\""
  # Nothing is running until the launch has happened; then two processes carry the path.
  make_stub "$WORK/stubs-many" ps "if [ -e \"$WORK/open-many.log\" ]; then echo \"424242 $executable\"; echo \"424243 $executable\"; fi"

  OUT="$(BUNDLE_SH_LAUNCH_TICKS=2 PATH="$WORK/stubs-many:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_output_contains "more than one process"
}

# CP-46 binds EVERY exit path: the script stops the process it launched and stops nothing else. On this
# path it recorded no pid — it cannot tell which of the two it launched — so it must signal neither.
# The two processes are real, so "still running afterwards" is a fact about the machine and not about
# what a stub reported; the case above uses invented pids and cannot assert survival at all. Without
# this, a stop that went back to signalling everything it found (the pkill-by-pattern defect CP-46
# exists to retire) would leave the whole suite green.
test_more_than_one_process_signals_neither() {
  executable="$(bundle_executable_of "$APP")"
  first="$(sleep 120 > /dev/null 2>&1 & echo $!)"
  second="$(sleep 120 > /dev/null 2>&1 & echo $!)"
  echo "$first" >> "$WORK/started-pids"
  echo "$second" >> "$WORK/started-pids"

  mkdir -p "$WORK/stubs-many-survive"
  make_stub "$WORK/stubs-many-survive" open "echo launched > \"$WORK/open-many-survive.log\""
  make_stub "$WORK/stubs-many-survive" ps "if [ -e \"$WORK/open-many-survive.log\" ]; then echo \"$first $executable\"; echo \"$second $executable\"; fi"

  OUT="$(BUNDLE_SH_LAUNCH_TICKS=2 PATH="$WORK/stubs-many-survive:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  process_is_running "$first" || fail "the first process (pid $first) was signalled" || return 1
  process_is_running "$second" || fail "the second process (pid $second) was signalled"
}

# A copy that was running before the script started is not the script's to stop (CP-46).
test_already_running_copy_survives() {
  copy="$(valid_copy survivor)" || fail "could not re-sign the copy" || return 1
  running="$(start_instance "$copy")" || fail "could not start an instance of the copy" || return 1

  run_bundle_sh "$copy"

  expect_nonzero_status || return 1
  expect_output_contains "an instance was already running" || return 1
  process_is_running "$running" || fail "the already-running copy (pid $running) was stopped"
}

# The probe stand-in starts a second process of the same executable path while the script is between
# recording its pid and stopping it. The script must stop its own pid and leave the second one.
test_only_the_launched_pid_is_signalled() {
  copy="$(valid_copy bystander)" || fail "could not re-sign the copy" || return 1
  executable="$(bundle_executable_of "$copy")"
  mkdir -p "$WORK/stubs-bystander"
  make_stub "$WORK/stubs-bystander" nozoki-sandbox-probe "\"$executable\" > /dev/null 2>&1 &
echo \$! > \"$WORK/bystander-pid\"
printf 'sandboxed: yes\nout-of-grant-read: denied\noutbound-connection: denied\n'"

  run_bundle_sh_with_stubs "$WORK/stubs-bystander" "$copy"

  bystander="$(cat "$WORK/bystander-pid" 2> /dev/null || true)"
  [ -n "$bystander" ] && echo "$bystander" >> "$WORK/started-pids"
  [ -n "$bystander" ] || fail "the stand-in probe started no second process" || return 1
  launched_pid="$(printf '%s' "$OUT" | sed -n 's/^launched: pid \([0-9]*\).*/\1/p')"
  [ -n "$launched_pid" ] || fail "the script did not name the pid it launched. output: $OUT" || return 1
  ! process_is_running "$launched_pid" || fail "the launched pid $launched_pid is still running"
  process_is_running "$bystander" || fail "the second process (pid $bystander) was stopped with it"
}

# CP-45: one executable under Contents/MacOS, and every file of the renderer build under
# Contents/Resources. Both are read before anything is launched.
# CP-44: the negative control. `checks/bundle.sh` refuses to launch a bundle whose entitlements are not
# exactly C-R2's, so the ordinary path cannot run the probe on a no-entitlement build; --negative-control
# is the mode that does, and it passes only on a NOT-sandboxed report.
test_negative_control_reports_unsandboxed() {
  write_entitlements "$WORK/empty.plist"
  copy="$(resigned_copy control "$WORK/empty.plist")" || fail "could not re-sign the copy" || return 1

  run_bundle_sh --negative-control "$copy"

  [ "$STATUS" -eq 0 ] || fail "expected exit 0 for the no-entitlement build, got $STATUS. output: $OUT" || return 1
  expect_output_contains "sandboxed: no" || return 1
  expect_no_bundle_process "$copy"
}

# The script's own judgement, on its own: an unentitled build the operating system reports sandboxed
# means the probe cannot tell the two builds apart, and the control fails. The suite-level case below
# would fail on the control case's own assertion whatever the script decided, so it cannot carry this.
test_negative_control_reported_sandboxed_fails() {
  write_entitlements "$WORK/empty-judged.plist"
  copy="$(resigned_copy control-judged "$WORK/empty-judged.plist")" || fail "could not re-sign the copy" || return 1
  mkdir -p "$WORK/stubs-control-judged"
  probe_stub "$WORK/stubs-control-judged" yes denied denied

  run_bundle_sh_with_stubs "$WORK/stubs-control-judged" --negative-control "$copy"

  expect_nonzero_status || return 1
  expect_output_contains "the negative control was reported sandboxed" || return 1
  expect_no_bundle_process "$copy"
}

# The suite run as its own subject: a probe that reports the no-entitlement build sandboxed cannot tell
# the two builds apart, so the suite must fail and say which case.
test_negative_control_reported_sandboxed_fails_the_suite() {
  mkdir -p "$WORK/stubs-control-sandboxed"
  probe_stub "$WORK/stubs-control-sandboxed" yes denied denied

  nested="$(PATH="$WORK/stubs-control-sandboxed:$PATH" NOZOKI_TEST_ONLY="$CONTROL_CASE" bash "$0" 2>&1)"
  nested_status=$?

  [ "$nested_status" -ne 0 ] || fail "the suite exited 0 with the control reported sandboxed. output: $nested" || return 1
  case "$nested" in
    *"FAIL $CONTROL_CASE"*) ;;
    *) fail "the failing control case is not named. output: $nested" ;;
  esac
}

# A run in which the control did not run is a failure, not a skip — recorded by the runner.
test_absent_control_fails_the_suite() {
  nested="$(NOZOKI_TEST_ONLY=test_missing_key_fails bash "$0" 2>&1)"
  nested_status=$?

  [ "$nested_status" -ne 0 ] || fail "the suite exited 0 although the negative control did not run. output: $nested" || return 1
  case "$nested" in
    *"the negative control did not run: $CONTROL_CASE"*) ;;
    *) fail "no stated message. output: $nested" ;;
  esac
}

# The mode is not a route past the gate: on a bundle carrying the C-R2 keys it refuses, unlaunched.
test_negative_control_refuses_the_c_r2_entitlement_set() {
  mkdir -p "$WORK/stubs-refuse"
  make_stub "$WORK/stubs-refuse" open "echo \"\$@\" >> \"$WORK/open-refuse.log\""

  run_bundle_sh_with_stubs "$WORK/stubs-refuse" --negative-control "$APP"

  expect_nonzero_status || return 1
  expect_output_contains "the entitlement set of" || return 1
  [ ! -e "$WORK/open-refuse.log" ] || fail "the bundle was launched: $(cat "$WORK/open-refuse.log")"
}

test_second_executable_fails() {
  copy="$(valid_copy second-executable)" || fail "could not re-sign the copy" || return 1
  printf '#!/bin/sh\nexit 0\n' > "$copy/Contents/MacOS/second-tool"
  chmod +x "$copy/Contents/MacOS/second-tool"
  mkdir -p "$WORK/stubs-second"
  make_stub "$WORK/stubs-second" open "echo \"\$@\" >> \"$WORK/open-second.log\""

  run_bundle_sh_with_stubs "$WORK/stubs-second" "$copy"

  expect_nonzero_status || return 1
  expect_output_contains "Contents/MacOS/second-tool" || return 1
  [ ! -e "$WORK/open-second.log" ] || fail "the copy was launched: $(cat "$WORK/open-second.log")"
}

# A tauri.conf.json stand-in whose build.frontendDist is $2, written to $1.
write_tauri_conf() {
  printf '{"build":{"frontendDist":"%s"}}\n' "$2" > "$1"
}

# The renderer build the stubbed configuration names: one stylesheet.
make_renderer_build() {
  mkdir -p "$WORK/renderer-build/assets"
  echo 'body {}' > "$WORK/renderer-build/assets/style.css"
}

# CP-45 names every renderer file found outside Contents/Resources, and Contents itself is outside it.
# The case above places the file one level down (Contents/MacOS/assets/style.css); this one places the
# same relative path at the root of Contents, which is just as much "not under Contents/Resources".
test_renderer_file_directly_under_contents_fails() {
  make_renderer_build
  write_tauri_conf "$WORK/conf-at-contents.json" "$WORK/renderer-build"
  copy="$(valid_copy renderer-at-contents)" || fail "could not re-sign the copy" || return 1
  mkdir -p "$copy/Contents/assets"
  echo 'body {}' > "$copy/Contents/assets/style.css"
  mkdir -p "$WORK/stubs-at-contents"
  make_stub "$WORK/stubs-at-contents" open "echo \"\$@\" >> \"$WORK/open-at-contents.log\""

  OUT="$(BUNDLE_SH_TAURI_CONF="$WORK/conf-at-contents.json" PATH="$WORK/stubs-at-contents:$PATH" "$BUNDLE_SH" "$copy" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_output_contains "Contents/assets/style.css" || return 1
  [ ! -e "$WORK/open-at-contents.log" ] || fail "the copy was launched: $(cat "$WORK/open-at-contents.log")"
}

test_renderer_file_outside_resources_fails() {
  make_renderer_build
  write_tauri_conf "$WORK/conf-renderer.json" "$WORK/renderer-build"
  copy="$(valid_copy renderer-outside)" || fail "could not re-sign the copy" || return 1
  mkdir -p "$copy/Contents/MacOS/assets"
  echo 'body {}' > "$copy/Contents/MacOS/assets/style.css"
  mkdir -p "$WORK/stubs-renderer"
  make_stub "$WORK/stubs-renderer" open "echo \"\$@\" >> \"$WORK/open-renderer.log\""

  OUT="$(BUNDLE_SH_TAURI_CONF="$WORK/conf-renderer.json" PATH="$WORK/stubs-renderer:$PATH" "$BUNDLE_SH" "$copy" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_output_contains "Contents/MacOS/assets/style.css" || return 1
  [ ! -e "$WORK/open-renderer.log" ] || fail "the copy was launched: $(cat "$WORK/open-renderer.log")"
}

# The counterpart: the same renderer file, where the rule wants it, does not stop the run.
test_renderer_file_under_resources_passes() {
  make_renderer_build
  write_tauri_conf "$WORK/conf-inside.json" "$WORK/renderer-build"
  copy="$(valid_copy renderer-inside)" || fail "could not re-sign the copy" || return 1
  mkdir -p "$copy/Contents/Resources/assets"
  echo 'body {}' > "$copy/Contents/Resources/assets/style.css"

  OUT="$(BUNDLE_SH_TAURI_CONF="$WORK/conf-inside.json" "$BUNDLE_SH" "$copy" 2>&1)"
  STATUS=$?

  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. output: $OUT" || return 1
  expect_no_bundle_process "$copy"
}

# The committed configuration carries no frontendDist (crates/nozoki-app/tests/config.rs holds that), so
# the renderer half compares against an empty set — and says so, rather than passing in silence.
test_absent_frontend_dist_states_an_empty_set() {
  run_bundle_sh "$APP"

  [ "$STATUS" -eq 0 ] || fail "expected exit 0 on the real bundle, got $STATUS. output: $OUT" || return 1
  expect_output_contains "the renderer set is empty"
}

test_named_frontend_dist_that_does_not_exist_fails() {
  write_tauri_conf "$WORK/conf-missing.json" "$WORK/no-such-renderer-build"
  mkdir -p "$WORK/stubs-missing"
  make_stub "$WORK/stubs-missing" open "echo \"\$@\" >> \"$WORK/open-missing.log\""

  OUT="$(BUNDLE_SH_TAURI_CONF="$WORK/conf-missing.json" PATH="$WORK/stubs-missing:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  # The script's own named failure, not merely a failing `cd` under `set -e` that happens to print the path.
  expect_output_contains "names a directory that does not exist: $WORK/no-such-renderer-build" || return 1
  [ ! -e "$WORK/open-missing.log" ] || fail "the bundle was launched: $(cat "$WORK/open-missing.log")"
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
  launched_pid="$(printf '%s' "$OUT" | sed -n 's/^launched: pid \([0-9]*\).*/\1/p')"
  [ -n "$launched_pid" ] || fail "the script did not name the pid it launched. output: $OUT" || return 1
  ! process_is_running "$launched_pid" || fail "the launched pid $launched_pid is still running" || return 1
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
  # Instances a case started on purpose are stopped by pid, never by pattern.
  if [ -f "$WORK/started-pids" ]; then
    while read -r started; do
      kill -TERM "$started" 2> /dev/null || true
    done < "$WORK/started-pids"
  fi
  rm -rf "$WORK"
}
trap cleanup EXIT

failed=0
ran=""
for case_name in $CASES; do
  if [ -n "${NOZOKI_TEST_ONLY:-}" ] && [ "$case_name" != "$NOZOKI_TEST_ONLY" ]; then
    continue
  fi
  ran="$ran $case_name"
  if result="$("$case_name" 2>&1)"; then
    echo "ok   $case_name"
  else
    echo "FAIL $case_name"
    [ -z "$result" ] || echo "$result"
    failed=$((failed + 1))
  fi
done

# The runner records which cases ran, and a run without the control is a failure: without it the probe
# has not run (NFDR QC-25).
case "$ran " in
  *" $CONTROL_CASE "*) ;;
  *)
    echo "test_bundle.sh: the negative control did not run: $CONTROL_CASE" >&2
    failed=$((failed + 1))
    ;;
esac

if [ "$failed" -ne 0 ]; then
  echo "test_bundle.sh: $failed case(s) failed" >&2
  exit 1
fi

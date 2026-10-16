#!/usr/bin/env bash
# Version: 1.3.0 — the suite prints the control line — test_bundle.sh publishes the control's one reading and refuses a report without it
# Version: 1.2.0 — the Tauri build leaves — native bundle assembled, bundle.sh and no-network.sh read it, CI builds it, boundaries and README pinned
# Version: 1.1.0 — the probe waits, bounded, for the sandbox report, and its control holds for the whole window; plutil read only on exit 0
# Version: 1.0.0 — first version: drives the real checks/bundle.sh against the built KA-Reader.app
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
#   KA_READER_APP=<path-to-KA-Reader.app> checks/tests/test_bundle.sh
#     KA_READER_APP defaults to target/release/bundle/macos/KA-Reader.app under the product root.
#   A bundle that is absent FAILS the suite with a stated message and runs no case: a skip would
#   let CI conclude green having proved nothing.
#   A clean run prints, after the negative control's `ok` line, that control's one reading — the
#   line `out-of-grant-read: denied` or `out-of-grant-read: allowed` — so a hosted build's log
#   carries it (NFDR QC-25). It is printed, never judged.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BUNDLE_SH="$ROOT/checks/bundle.sh"
# shellcheck source=checks/tests/support/vm_refusal.sh
source "$ROOT/checks/tests/support/vm_refusal.sh"
APP="${KA_READER_APP:-$ROOT/target/release/bundle/macos/KA-Reader.app}"

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
# What the drawn-from rule prints on a pass: how many members of the expected set it checked. On the
# real bundle the set is the fourteen files of third_party/lucide/icons.
DRAWN_FROM_PASS_LINE="glyph set: 14 members checked"
EXPECTED_SET_DIR="$ROOT/third_party/lucide/icons"

OUT=""
STATUS=0
WORK=""

CASES="
test_real_bundle_passes
test_probe_waits_past_an_early_unsandboxed_report
test_first_ask_holding_all_three_passes
test_pass_line_states_the_window_in_force
test_pass_line_is_on_stdout
test_red_verdict_lines_are_on_stderr
test_outbound_connection_allowed_fails
test_out_of_grant_read_allowed_fails
test_not_sandboxed_fails
test_marker_in_the_environment_does_not_pass
test_marker_is_absent_from_the_tree
test_existing_container_is_not_evidence
test_unresolvable_symbol_fails
test_probe_error_fails
test_probe_failure_mid_window_ends_the_run
test_unreadable_report_is_asked_past
test_probe_reports_an_unsandboxed_pid_as_unsandboxed
test_probe_fails_on_a_pid_that_does_not_exist
test_instance_already_running_fails_before_launch
test_no_process_appears_fails
test_more_than_one_process_fails
test_more_than_one_process_signals_neither
test_already_running_copy_survives
test_only_the_launched_pid_is_signalled
test_negative_control_reports_unsandboxed
test_negative_control_sandboxed_later_in_the_window_fails
test_negative_control_asks_the_whole_window
test_negative_control_probe_failure_fails
test_negative_control_unreadable_report_fails
test_negative_control_reported_sandboxed_fails
test_negative_control_reported_sandboxed_fails_the_suite
test_negative_control_missing_read_fails_the_suite
test_absent_control_fails_the_suite
test_negative_control_refuses_the_c_r2_entitlement_set
test_second_executable_fails
test_drawn_from_pass_line_is_on_stdout
test_expected_set_is_read_from_the_source_tree
test_glyph_under_macos_fails
test_glyph_directly_under_contents_fails
test_svg_nested_deep_outside_resources_fails
test_foreign_svg_outside_resources_fails
test_empty_expected_set_fails_saying_why
test_missing_expected_set_directory_fails_saying_why
test_glyphs_missing_from_resources_are_each_named
test_files_outside_the_set_under_resources_pass
test_executable_bit_file_under_resources_fails
test_mach_o_without_execute_bit_fails
test_font_by_extension_fails
test_font_by_signature_fails
test_copy_of_a_checks_file_fails
test_empty_file_is_not_a_checks_copy
test_checks_listing_that_fails_is_refused
test_empty_checks_listing_is_refused
test_pre_launch_refusals_are_on_stderr
test_every_font_extension_fails_in_any_case
test_every_font_signature_fails
test_every_mach_o_magic_is_an_executable
test_group_or_other_execute_bit_fails
test_member_name_without_svg_suffix_outside_resources_fails
test_dotfile_in_the_expected_set_is_a_member
test_extra_key_fails_before_launch
test_false_value_fails
test_missing_key_fails
test_invalid_probe_window_is_refused_before_launch
test_header_names_the_probe_window
test_empty_probe_window_reads_as_the_default
test_leading_zero_window_reads_in_base_ten
test_never_sandboxed_within_the_window_fails_naming_it
test_window_exhausted_after_a_short_yes_judges_the_last_report
test_probe_failure_after_a_short_yes_ends_the_run
test_window_exhausted_reads_the_last_report
test_no_sandbox_observed_fails_and_cleans_up
test_nonexistent_path_fails
test_plain_directory_fails
test_directory_without_app_suffix_fails
test_unlaunchable_bundle_fails
test_absent_bundle_fails_the_suite
test_temporaries_removed
test_refuses_off_vm_before_work
test_admits_on_a_vm_reading
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

# "One report" (CP-68, CP-77): the output holds exactly one `sandboxed:` line — the report the run
# judged. CP-68 is the negative control's half; CP-77 is the ordinary path's.
expect_one_report() {
  reports="$(printf '%s\n' "$OUT" | grep -c '^sandboxed: ')"
  [ "$reports" -eq 1 ] || fail "expected exactly one report, got $reports. output: $OUT"
}

# The run's closing failure line: the last `bundle.sh: ` line the script printed (its `die`).
closing_line() {
  printf '%s\n' "$OUT" | grep '^bundle.sh: ' | tail -1
}

# The closing failure line of a run whose window ran out (CP-75), matched exactly: "bundle.sh: the wall
# does not hold on the launched process (pid <digits>): no ask held all three within <N> asks, 0.25 s
# apart". $1 is N.
expect_closing_line_states_the_window() {
  closing="$(closing_line)"
  matched="$(printf '%s' "$closing" | sed -n "s/^bundle\.sh: the wall does not hold on the launched process (pid [0-9][0-9]*): no ask held all three within $1 asks, 0\.25 s apart\$/matched/p")"
  [ -n "$matched" ] \
    || fail "expected the closing failure line to state the window of $1 asks, 0.25 s apart exactly. closing line: $closing. output: $OUT"
}

# The not-sandboxed condition line exactly as it reads today: the condition blocks read the kept report
# unchanged (change_design.md § 4), and the window belongs to the closing line, not to this one.
expect_not_sandboxed_condition_line_unchanged() {
  printf '%s\n' "$OUT" | grep -qx 'condition not held: the launched process is not sandboxed' \
    || fail "expected the unchanged line 'condition not held: the launched process is not sandboxed'. output: $OUT"
}

# A copy of the built bundle in $WORK, re-signed ad hoc with the entitlements in file $2.
resigned_copy() {
  copy="$WORK/$1/KA-Reader.app"
  mkdir -p "$WORK/$1"
  cp -R "$APP" "$copy"
  codesign --force --sign - --entitlements "$2" "$copy" > /dev/null 2>&1 || return 1
  printf '%s' "$copy"
}

# A stand-in for `ka-reader-sandbox-probe`, placed ahead of the real one on PATH. $2 is the sandboxed
# line, $3 the out-of-grant read line, $4 the outbound connection line — each the value the real probe
# would print, so one condition at a time can be made to fail without an unsandboxed bundle.
probe_stub() {
  make_stub "$1" ka-reader-sandbox-probe "printf 'sandboxed: %s\nout-of-grant-read: %s\noutbound-connection: %s\n' $2 $3 $4"
}

# A stand-in for `ka-reader-sandbox-probe` whose answer depends on how many times it has been called —
# for proving the ordinary-path and negative-control loops, which ask more than once. $1 is a fresh
# directory the caller owns; the remaining arguments are the answers, one per ask, each either a
# three-value report (`sandboxed out-of-grant-read outbound-connection`, space-separated, one call's
# worth) or the literal FAIL for a probe failure (exits non-zero with a sandbox_check message on
# stderr, like the real probe's own failure shape). An ask past the last answer repeats the last one.
# Every call bumps the counter file at $1/count; `asked_count` below reads it as the ask count.
sequenced_probe_stub() {
  dir="$1"
  shift
  mkdir -p "$dir"
  printf '%s\n' "$@" > "$dir/answers"
  echo 0 > "$dir/count"
  cat > "$dir/ka-reader-sandbox-probe" << STUB
#!/bin/sh
n=\$(( \$(cat "$dir/count") + 1 ))
echo "\$n" > "$dir/count"
total=\$(wc -l < "$dir/answers" | tr -d ' ')
line_no=\$n
[ "\$line_no" -le "\$total" ] || line_no="\$total"
answer=\$(sed -n "\${line_no}p" "$dir/answers")
if [ "\$answer" = FAIL ]; then
  echo "ka-reader-sandbox-probe: sandbox_check returned an error" >&2
  exit 1
fi
set -- \$answer
printf 'sandboxed: %s\nout-of-grant-read: %s\noutbound-connection: %s\n' "\$1" "\$2" "\$3"
STUB
  chmod +x "$dir/ka-reader-sandbox-probe"
}

# The number of times a sequenced probe stub (above) was called.
asked_count() {
  cat "$1/count"
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
  rustc --edition 2021 -O -o "$WORK/probe-bin/ka-reader-sandbox-probe" "$PROBE_SOURCE" > "$WORK/probe-build.log" 2>&1 \
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
  expect_output_contains "$DRAWN_FROM_PASS_LINE" || return 1
  expect_output_lacks "extra executable" || return 1
  expect_output_lacks "font: " || return 1
  expect_output_lacks "copy of a checks/ file" || return 1
  expect_output_lacks "glyph missing from" || return 1
  expect_output_lacks "glyph outside" || return 1
  expect_no_bundle_process "$APP"
}

# CP-73: the loop asks past an early report that falls short and passes on the first ask holding all
# three, at the default window.
test_probe_waits_past_an_early_unsandboxed_report() {
  seq="$WORK/seq-waits-past"
  sequenced_probe_stub "$seq" "no allowed allowed" "no allowed allowed" "yes denied denied"

  run_bundle_sh_with_stubs "$seq" "$APP"

  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. output: $OUT" || return 1
  expect_output_contains "sandbox observed:" || return 1
  expect_one_report || return 1
  expect_output_contains "sandboxed: yes" || return 1
  [ "$(asked_count "$seq")" -eq 3 ] || fail "expected 3 asks, got $(asked_count "$seq")" || return 1
  expect_no_bundle_process "$APP"
}

# CP-73: the loop's stop and the verdict are the same judgment, computed once per ask — the first ask
# whose report holds all three lines ends the loop as a pass. A first `yes` carrying an `allowed` is
# asked past, not judged as it stands (the split CP-73 reverses).
test_first_ask_holding_all_three_passes() {
  seq="$WORK/seq-first-all-three"
  sequenced_probe_stub "$seq" "yes denied allowed" "yes denied denied"

  run_bundle_sh_with_stubs "$seq" "$APP"

  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. output: $OUT" || return 1
  [ "$(asked_count "$seq")" -eq 2 ] || fail "expected 2 asks, got $(asked_count "$seq")" || return 1
  expect_one_report || return 1
  expect_output_contains "outbound-connection: denied" || return 1
  expect_output_lacks "outbound-connection: allowed" || return 1
  last_line="$(printf '%s\n' "$OUT" | tail -1)"
  matched="$(printf '%s' "$last_line" | sed -n 's/^sandbox observed: sandboxed, out-of-grant read denied, outbound connection denied (pid [0-9][0-9]*), the first ask to hold all three within 40 asks, 0\.25 s apart$/matched/p')"
  [ -n "$matched" ] \
    || fail "expected the last line to be exactly the CP-76 pass line with 40 asks. last line: $last_line" || return 1
  expect_no_bundle_process "$APP"
}

# CP-76: the pass line states the window in force ($PROBE_TICKS), never the ask that passed. The pass
# comes on ask 1 while the line says 5, which is what tells the two apart.
test_pass_line_states_the_window_in_force() {
  seq="$WORK/seq-pass-line-window"
  sequenced_probe_stub "$seq" "yes denied denied"

  OUT="$(BUNDLE_SH_PROBE_TICKS=5 PATH="$seq:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
  STATUS=$?

  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. output: $OUT" || return 1
  [ "$(asked_count "$seq")" -eq 1 ] || fail "expected 1 ask, got $(asked_count "$seq")" || return 1
  last_line="$(printf '%s\n' "$OUT" | tail -1)"
  matched="$(printf '%s' "$last_line" | sed -n 's/^sandbox observed: sandboxed, out-of-grant read denied, outbound connection denied (pid [0-9][0-9]*), the first ask to hold all three within 5 asks, 0\.25 s apart$/matched/p')"
  [ -n "$matched" ] \
    || fail "expected the last line to be exactly the CP-76 pass line stating the window of 5 asks with a digit pid. last line: $last_line"
}

# CP-76: the pass line is printed on stdout — it is the run's last stdout line, and stderr never
# carries it. Every other case merges the two streams, so none of them could tell.
test_pass_line_is_on_stdout() {
  seq="$WORK/seq-pass-stdout"
  sequenced_probe_stub "$seq" "yes denied denied"

  BUNDLE_SH_PROBE_TICKS=2 PATH="$seq:$PATH" "$BUNDLE_SH" "$APP" > "$WORK/pass.out" 2> "$WORK/pass.err"
  STATUS=$?
  OUT="stdout: $(cat "$WORK/pass.out") stderr: $(cat "$WORK/pass.err")"

  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. output: $OUT" || return 1
  last_line="$(tail -1 "$WORK/pass.out")"
  case "$last_line" in
    "sandbox observed: sandboxed, out-of-grant read denied, outbound connection denied (pid "*"), the first ask to hold all three within 2 asks, 0.25 s apart") ;;
    *) fail "expected stdout's last line to be the CP-76 pass line. stdout's last line: $last_line. output: $OUT" || return 1 ;;
  esac
  ! grep -q 'sandbox observed:' "$WORK/pass.err" \
    || fail "the pass line was printed on stderr. output: $OUT" || return 1
  expect_no_bundle_process "$APP"
}

# CP-74, CP-75: a red run's condition lines and its closing line are printed on stderr, and stdout
# carries neither — the closing line is stderr's last line.
test_red_verdict_lines_are_on_stderr() {
  seq="$WORK/seq-red-stderr"
  sequenced_probe_stub "$seq" "yes denied allowed"

  BUNDLE_SH_PROBE_TICKS=2 PATH="$seq:$PATH" "$BUNDLE_SH" "$APP" > "$WORK/red.out" 2> "$WORK/red.err"
  STATUS=$?
  OUT="stdout: $(cat "$WORK/red.out") stderr: $(cat "$WORK/red.err")"

  expect_nonzero_status || return 1
  grep -qx 'condition not held: an outbound network connection is not denied' "$WORK/red.err" \
    || fail "expected the condition line on stderr. output: $OUT" || return 1
  last_err="$(tail -1 "$WORK/red.err")"
  case "$last_err" in
    "bundle.sh: the wall does not hold on the launched process (pid "*"): no ask held all three within 2 asks, 0.25 s apart") ;;
    *) fail "expected stderr's last line to be the CP-75 closing line. stderr's last line: $last_err. output: $OUT" || return 1 ;;
  esac
  ! grep -q 'condition not held:' "$WORK/red.out" \
    || fail "a condition line was printed on stdout. output: $OUT" || return 1
  ! grep -q 'the wall does not hold' "$WORK/red.out" \
    || fail "the closing line was printed on stdout. output: $OUT" || return 1
  expect_no_bundle_process "$APP"
}

# CP-74, CP-75: a `yes` report is not exempt when the window runs out — one condition short still
# fails after every ask, and the closing line states the window. Bounded at 3 asks: at the default the
# static stub would be asked 40 times, about 10 s.
test_outbound_connection_allowed_fails() {
  seq="$WORK/seq-outbound-allowed"
  sequenced_probe_stub "$seq" "yes denied allowed"

  OUT="$(BUNDLE_SH_PROBE_TICKS=3 PATH="$seq:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_one_report || return 1
  expect_output_contains "an outbound network connection is not denied" || return 1
  expect_output_lacks "the launched process is not sandboxed" || return 1
  expect_output_lacks "an out-of-grant file read is not denied" || return 1
  expect_closing_line_states_the_window 3 || return 1
  [ "$(asked_count "$seq")" -eq 3 ] || fail "expected 3 asks, got $(asked_count "$seq")" || return 1
  expect_no_bundle_process "$APP"
}

test_out_of_grant_read_allowed_fails() {
  seq="$WORK/seq-read-allowed"
  sequenced_probe_stub "$seq" "yes allowed denied"

  OUT="$(BUNDLE_SH_PROBE_TICKS=3 PATH="$seq:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_one_report || return 1
  expect_output_contains "an out-of-grant file read is not denied" || return 1
  expect_output_lacks "the launched process is not sandboxed" || return 1
  expect_output_lacks "an outbound network connection is not denied" || return 1
  expect_closing_line_states_the_window 3 || return 1
  [ "$(asked_count "$seq")" -eq 3 ] || fail "expected 3 asks, got $(asked_count "$seq")" || return 1
  expect_no_bundle_process "$APP"
}

test_not_sandboxed_fails() {
  mkdir -p "$WORK/stubs-unsandboxed"
  probe_stub "$WORK/stubs-unsandboxed" no denied denied

  # A bound on the window: with the default, a static stub's answer never changes, so the run would
  # otherwise ask the whole 40-ask window before failing.
  OUT="$(BUNDLE_SH_PROBE_TICKS=2 PATH="$WORK/stubs-unsandboxed:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_output_contains "the launched process is not sandboxed" || return 1
  expect_no_bundle_process "$APP"
}

# `sandbox_check` answers "sandboxed, everything denied" for a pid that names no process at all — a
# measured false positive (pid 99999999, this change). A wall check that reads it as a pass would pass
# on a process that is not there, so the probe must fail on a pid it cannot find.
test_probe_fails_on_a_pid_that_does_not_exist() {
  compile_probe || return 1

  OUT="$("$WORK/probe-bin/ka-reader-sandbox-probe" 99999999 2>&1)"
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
  make_stub "$WORK/stubs-bystander" ka-reader-sandbox-probe "\"$executable\" > /dev/null 2>&1 &
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

# CP-768, CP-771: the control's report must hold the reading, and the reading is this case's whole
# output — the runner prints it once, after the case's `ok` line. Printing it is all that is done
# with it: `denied` and `allowed` are both a pass (CP-769).
publish_control_reading() {
  # `|| true`: pipefail would otherwise end the run on a report with no line, before the guard
  # reports.
  marker_lines="$(printf '%s\n' "$OUT" | grep -c 'out-of-grant-read:' || true)"
  [ "$marker_lines" -ne 0 ] \
    || fail "The negative control's report has no out-of-grant-read line. This run has no reading to print. To read the whole report, run checks/bundle.sh --negative-control on a copy of the bundle under test re-signed with an empty entitlement set." \
    || return 1
  [ "$marker_lines" -eq 1 ] \
    || fail "The negative control's report has more than one out-of-grant-read line. This run has no reading to print. To read the whole report, run checks/bundle.sh --negative-control on a copy of the bundle under test re-signed with an empty entitlement set." \
    || return 1
  reading="$(printf '%s\n' "$OUT" | grep -E '^out-of-grant-read: (denied|allowed)$' || true)"
  [ -n "$reading" ] \
    || fail "The negative control's report has one out-of-grant-read line, and it isn't exactly out-of-grant-read, a colon, a space, and then denied or allowed. This run has no reading to print. To read the whole report, run checks/bundle.sh --negative-control on a copy of the bundle under test re-signed with an empty entitlement set." \
    || return 1
  printf '%s\n' "$reading"
}

# CP-44: the negative control. `checks/bundle.sh` refuses to launch a bundle whose entitlements are not
# exactly C-R2's, so the ordinary path cannot run the probe on a no-entitlement build; --negative-control
# is the mode that does, and it passes only on a NOT-sandboxed report.
test_negative_control_reports_unsandboxed() {
  write_entitlements "$WORK/empty.plist"
  copy="$(resigned_copy control "$WORK/empty.plist")" || fail "could not re-sign the copy" || return 1

  run_bundle_sh --negative-control "$copy"

  [ "$STATUS" -eq 0 ] || fail "expected exit 0 for the no-entitlement build, got $STATUS. output: $OUT" || return 1
  expect_output_contains "sandboxed: no" || return 1
  expect_output_contains "40 asks" || return 1
  expect_output_contains "0.25 s" || return 1
  expect_one_report || return 1
  expect_no_bundle_process "$copy" || return 1
  publish_control_reading
}

# CP-69, CP-68: a report that turns sandboxed later in the window still fails the control — waiting
# for more reports never turns a positive one into a pass.
test_negative_control_sandboxed_later_in_the_window_fails() {
  seq="$WORK/seq-control-later"
  write_entitlements "$WORK/empty-later.plist"
  copy="$(resigned_copy control-later "$WORK/empty-later.plist")" || fail "could not re-sign the copy" || return 1
  sequenced_probe_stub "$seq" "no denied denied" "yes denied denied"

  run_bundle_sh_with_stubs "$seq" --negative-control "$copy"

  expect_nonzero_status || return 1
  expect_output_contains "the negative control was reported sandboxed" || return 1
  expect_one_report || return 1
  expect_output_contains "sandboxed: yes" || return 1
  [ "$(asked_count "$seq")" -eq 2 ] || fail "expected 2 asks, got $(asked_count "$seq")" || return 1
  expect_no_bundle_process "$copy"
}

# CP-69: the control asks the whole window before it can pass, and the passing line states it.
test_negative_control_asks_the_whole_window() {
  seq="$WORK/seq-control-whole-window"
  write_entitlements "$WORK/empty-whole.plist"
  copy="$(resigned_copy control-whole "$WORK/empty-whole.plist")" || fail "could not re-sign the copy" || return 1
  sequenced_probe_stub "$seq" "no denied denied"

  OUT="$(BUNDLE_SH_PROBE_TICKS=3 PATH="$seq:$PATH" "$BUNDLE_SH" --negative-control "$copy" 2>&1)"
  STATUS=$?

  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. output: $OUT" || return 1
  expect_output_contains "3 asks" || return 1
  expect_output_contains "0.25 s" || return 1
  expect_one_report || return 1
  [ "$(asked_count "$seq")" -eq 3 ] || fail "expected 3 asks, got $(asked_count "$seq")" || return 1
  expect_no_bundle_process "$copy"
}

# CP-67 (control half): the probe's own failure on any ask ends the run at once, and the run never
# reaches its passing line.
test_negative_control_probe_failure_fails() {
  write_entitlements "$WORK/empty-failure.plist"
  copy="$(resigned_copy control-failure "$WORK/empty-failure.plist")" || fail "could not re-sign the copy" || return 1
  mkdir -p "$WORK/stubs-control-failure"
  make_stub "$WORK/stubs-control-failure" ka-reader-sandbox-probe 'echo "ka-reader-sandbox-probe: sandbox_check returned an error" >&2; exit 1'

  run_bundle_sh_with_stubs "$WORK/stubs-control-failure" --negative-control "$copy"

  expect_nonzero_status || return 1
  expect_output_contains "sandbox_check" || return 1
  expect_output_lacks "negative control: the operating system reports" || return 1
  expect_no_bundle_process "$copy"
}

# CP-67's last sentence (control half): a report that exits 0 but carries no sandboxed: line is not a
# NOT-sandboxed report, so it fails the control exactly as a sandboxed: yes report would.
test_negative_control_unreadable_report_fails() {
  write_entitlements "$WORK/empty-unreadable.plist"
  copy="$(resigned_copy control-unreadable "$WORK/empty-unreadable.plist")" || fail "could not re-sign the copy" || return 1
  mkdir -p "$WORK/stubs-control-unreadable"
  make_stub "$WORK/stubs-control-unreadable" ka-reader-sandbox-probe "printf 'garbled\n'"

  run_bundle_sh_with_stubs "$WORK/stubs-control-unreadable" --negative-control "$copy"

  expect_nonzero_status || return 1
  expect_output_contains "the negative control was reported sandboxed" || return 1
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

  nested="$(PATH="$WORK/stubs-control-sandboxed:$PATH" KA_READER_TEST_ONLY="$CONTROL_CASE" bash "$0" 2>&1)"
  nested_status=$?

  [ "$nested_status" -ne 0 ] || fail "the suite exited 0 with the control reported sandboxed. output: $nested" || return 1
  case "$nested" in
    *"FAIL $CONTROL_CASE"*) ;;
    *) fail "the failing control case is not named. output: $nested" ;;
  esac
}

# A stand-in for `ka-reader-sandbox-probe` whose whole report is the lines given, one per argument,
# each printed exactly as written — so a report with no reading, an empty, indented or doubled one
# can be made. `probe_stub` always prints all three lines, so it cannot.
report_stub() {
  dir="$1"
  shift
  body="printf '%s\\n'"
  for report_line in "$@"; do
    body="$body '$report_line'"
  done
  make_stub "$dir" ka-reader-sandbox-probe "$body"
}

# The suite's own control, run nested against the stand-in probe in $1. The two streams are kept
# apart: nested_status, nested_stdout and nested_stderr hold what the nested run exited with and
# wrote.
run_nested_control() {
  nested_stdout="$(PATH="$1:$PATH" KA_READER_TEST_ONLY="$CONTROL_CASE" bash "$0" 2> "$WORK/nested-stderr")"
  nested_status=$?
  nested_stderr="$(cat "$WORK/nested-stderr")"
}

nested_output_names_a_reading() {
  case "$nested_stdout$nested_stderr" in
    *"out-of-grant-read:"*) return 0 ;;
  esac
  return 1
}

# A control report the suite must refuse: the nested run exits non-zero and writes the marker text
# on neither stream, so a hosted log holds no line a reader could take for a reading. $1 names the
# kind of report — `missing` (no reading line), `odd` (one reading line not in the exact form) or
# `several` — and the remaining arguments are the lines of the report.
expect_report_refused() {
  kind="$1"
  shift
  stubs="$(mktemp -d "$WORK/stubs-refused.XXXXXX")"
  report_stub "$stubs" "$@"

  run_nested_control "$stubs"

  case "$kind" in
    missing) exited_zero="With a negative control report that has no out-of-grant-read line, the suite exited 0." ;;
    odd) exited_zero="With a negative control report whose one out-of-grant-read line isn't exactly out-of-grant-read, a colon, a space, and then denied or allowed, the suite exited 0." ;;
    several) exited_zero="With a negative control report that has more than one out-of-grant-read line, the suite exited 0." ;;
  esac
  [ "$nested_status" -ne 0 ] || fail "$exited_zero" || return 1

  if [ "$kind" = missing ]; then
    case "$nested_stdout$nested_stderr" in
      *"no out-of-grant-read line"*) ;;
      *) fail "With a negative control report that has no out-of-grant-read line, the suite's output doesn't name the missing line." || return 1 ;;
    esac
    if nested_output_names_a_reading; then
      fail "With a negative control report that has no out-of-grant-read line, the suite still printed an out-of-grant-read line." || return 1
    fi
  elif nested_output_names_a_reading; then
    case "$kind" in
      odd) fail "With a negative control report whose one out-of-grant-read line isn't exactly out-of-grant-read, a colon, a space, and then denied or allowed, the suite printed a denied or allowed reading on stdout." || return 1 ;;
      several) fail "With a negative control report that has more than one out-of-grant-read line, the suite printed a denied or allowed reading on stdout." || return 1 ;;
    esac
  fi
}

# CP-771, CP-772 and CP-773: the suite goes red when the control's report carries no reading it can
# publish — and goes red on every run, which is what proves the check can. The real probe always
# prints the line, so the real control passes; stand-ins make each report the check must refuse, and
# two make the one it must publish. Every report keeps the control's other assertions green
# (`sandboxed: no`, one such line, the whole window), so a refusal here comes from the reading
# check alone.
test_negative_control_missing_read_fails_the_suite() {
  expect_report_refused missing 'sandboxed: no' 'outbound-connection: denied' || return 1

  for reading in denied allowed; do
    stubs="$WORK/stubs-reading-$reading"
    mkdir -p "$stubs"
    report_stub "$stubs" 'sandboxed: no' "out-of-grant-read: $reading" 'outbound-connection: denied'

    run_nested_control "$stubs"

    [ "$nested_status" -eq 0 ] \
      || fail "With a negative control report that reads $reading, the suite exited $nested_status instead of 0." || return 1
    expected_stdout="$(printf 'ok   %s\nout-of-grant-read: %s' "$CONTROL_CASE" "$reading")"
    [ "$nested_stdout" = "$expected_stdout" ] \
      || fail "With a negative control report that reads $reading, the suite's stdout isn't exactly the negative control's ok line followed by its reading." || return 1
    case "$nested_stderr" in
      *"out-of-grant-read:"*) fail "With a negative control report that reads $reading, the suite printed an out-of-grant-read line on stderr." || return 1 ;;
    esac
    # Both streams, with the reading itself masked: what is left must not depend on the value.
    masked="$(printf '%s\n%s' "$nested_stdout" "$nested_stderr" | sed 's/^out-of-grant-read: .*$/out-of-grant-read: READING/')"
    if [ "$reading" = denied ]; then denied_output="$masked"; else allowed_output="$masked"; fi
  done
  [ "$denied_output" = "$allowed_output" ] \
    || fail "The suite's output with a negative control report that reads denied differs from its output with one that reads allowed in more than the reading." || return 1

  expect_report_refused odd 'sandboxed: no' 'out-of-grant-read: unknown' 'outbound-connection: denied' || return 1
  expect_report_refused odd 'sandboxed: no' 'out-of-grant-read:' 'outbound-connection: denied' || return 1
  expect_report_refused odd 'sandboxed: no' '  out-of-grant-read: denied' 'outbound-connection: denied' || return 1
  expect_report_refused odd 'sandboxed: no' 'out-of-grant-read: denied (cached)' 'outbound-connection: denied' || return 1
  expect_report_refused odd 'sandboxed: no' 'out-of-grant-read: denied ' 'outbound-connection: denied' || return 1

  expect_report_refused several 'sandboxed: no' 'out-of-grant-read: denied' 'out-of-grant-read: allowed' 'outbound-connection: denied' || return 1
  expect_report_refused several 'sandboxed: no' 'out-of-grant-read: denied' 'out-of-grant-read: denied' 'outbound-connection: denied' || return 1
  expect_report_refused several 'sandboxed: no' 'out-of-grant-read: denied' 'out-of-grant-read: unknown' 'outbound-connection: denied' || return 1
}

# A run in which the control did not run is a failure, not a skip — recorded by the runner.
test_absent_control_fails_the_suite() {
  nested="$(KA_READER_TEST_ONLY=test_missing_key_fails bash "$0" 2>&1)"
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

# --- the drawn-from rule and the contents block (CP-116 – CP-118) ---
#
# Every refusal case asserts two things: the run exits non-zero and names the offending path, and
# nothing was launched — the `open` stub's log does not exist. A copy that gains or loses a file needs
# no re-signing for a refusal, because the refusal comes before the launch; a case that expects the run
# to go past both blocks and launch re-signs it first.

# Runs the script on $1 with an `open` stub that records a launch in $WORK/open-$2.log. Any further
# argument is a NAME=value pair put into the run's environment. A stub the caller already placed in
# $WORK/stubs-$2 is kept.
run_unlaunched() {
  target="$1"
  tag="$2"
  shift 2
  mkdir -p "$WORK/stubs-$tag"
  make_stub "$WORK/stubs-$tag" open "echo \"\$@\" >> \"$WORK/open-$tag.log\""
  OUT="$(env "$@" PATH="$WORK/stubs-$tag:$PATH" "$BUNDLE_SH" "$target" 2>&1)"
  STATUS=$?
}

expect_not_launched() {
  [ ! -e "$WORK/open-$1.log" ] || fail "the bundle was launched: $(cat "$WORK/open-$1.log")"
}

# The shape every refusal shares: non-zero, every path in "$@" named, nothing launched. $1 is the tag.
expect_refused_naming() {
  tag="$1"
  shift
  expect_nonzero_status || return 1
  for named in "$@"; do
    expect_output_contains "$named" || return 1
  done
  expect_not_launched "$tag"
}

# A re-signed copy of the bundle with a file of $3 placed at $2, relative to the bundle. $1 names the copy.
copy_with_file() {
  placed="$(valid_copy "$1")" || return 1
  mkdir -p "$(dirname "$placed/$2")"
  printf '%s' "$3" > "$placed/$2"
  printf '%s' "$placed"
}

# CP-117: on the real bundle the rule prints one line saying how many members it checked, and the
# contents block refuses nothing.
test_drawn_from_pass_line_is_on_stdout() {
  mkdir -p "$WORK/stubs-pass-line"
  make_stub "$WORK/stubs-pass-line" open "exit 0"
  make_stub "$WORK/stubs-pass-line" ps "exit 0"

  stdout_only="$(BUNDLE_SH_LAUNCH_TICKS=2 PATH="$WORK/stubs-pass-line:$PATH" "$BUNDLE_SH" "$APP" 2> /dev/null)"

  case "$stdout_only" in
    *"$DRAWN_FROM_PASS_LINE"*) ;;
    *) fail "expected stdout alone to carry: $DRAWN_FROM_PASS_LINE. stdout: $stdout_only" ;;
  esac
}

# D1-2: the expected set is the source tree's, read when the script runs — a set with one more member
# than the bundle holds is refused, naming it.
test_expected_set_is_read_from_the_source_tree() {
  mkdir -p "$WORK/set-plus-extra"
  cp "$EXPECTED_SET_DIR"/* "$WORK/set-plus-extra/"
  echo '<svg/>' > "$WORK/set-plus-extra/extra.svg"

  run_unlaunched "$APP" set-plus-extra BUNDLE_SH_GLYPH_DIR="$WORK/set-plus-extra"

  expect_refused_naming set-plus-extra "extra.svg"
}

# D1-3: a member's name under Contents/MacOS is outside Contents/Resources.
test_glyph_under_macos_fails() {
  copy="$(copy_with_file glyph-macos Contents/MacOS/folder.svg '<svg/>')" || fail "could not re-sign the copy" || return 1

  run_unlaunched "$copy" glyph-macos

  expect_refused_naming glyph-macos "Contents/MacOS/folder.svg"
}

# D1-4: Contents itself is outside Contents/Resources.
test_glyph_directly_under_contents_fails() {
  copy="$(copy_with_file glyph-contents Contents/folder.svg '<svg/>')" || fail "could not re-sign the copy" || return 1

  run_unlaunched "$copy" glyph-contents

  expect_refused_naming glyph-contents "Contents/folder.svg"
}

# D1-5: at any depth.
test_svg_nested_deep_outside_resources_fails() {
  copy="$(copy_with_file svg-deep Contents/MacOS/a/b/file.svg '<svg/>')" || fail "could not re-sign the copy" || return 1

  run_unlaunched "$copy" svg-deep

  expect_refused_naming svg-deep "Contents/MacOS/a/b/file.svg"
}

# D1-6: a name that is not in the set, ending in .svg. Only the suffix half of the rule can refuse it.
test_foreign_svg_outside_resources_fails() {
  copy="$(copy_with_file svg-foreign Contents/MacOS/stray.svg '<svg/>')" || fail "could not re-sign the copy" || return 1

  run_unlaunched "$copy" svg-foreign

  expect_refused_naming svg-foreign "Contents/MacOS/stray.svg"
}

# D1-7 (CP-117 a): an empty set is red, and the output says it was empty and why.
test_empty_expected_set_fails_saying_why() {
  mkdir -p "$WORK/set-empty"

  run_unlaunched "$APP" set-empty BUNDLE_SH_GLYPH_DIR="$WORK/set-empty"

  expect_refused_naming set-empty "the expected glyph set is empty" "holds no regular file"
}

# D1-8 (CP-117 a): a directory that does not exist is the same verdict.
test_missing_expected_set_directory_fails_saying_why() {
  run_unlaunched "$APP" set-missing BUNDLE_SH_GLYPH_DIR="$WORK/no-such-set"

  expect_refused_naming set-missing "the expected glyph set is empty" "does not exist"
}

# D1-9 (CP-117 b): every missing member is named, not only the first.
test_glyphs_missing_from_resources_are_each_named() {
  copy="$(valid_copy glyphs-missing)" || fail "could not re-sign the copy" || return 1
  rm "$copy/Contents/Resources/folder.svg" "$copy/Contents/Resources/file.svg"
  codesign --force --sign - --entitlements "$WORK/valid.plist" "$copy" > /dev/null 2>&1 \
    || fail "could not re-sign the copy after removing the glyphs" || return 1

  run_unlaunched "$copy" glyphs-missing

  expect_refused_naming glyphs-missing "folder.svg" "file.svg"
}

# D1-10: files of any other name, at any depth under Contents/Resources, are outside the rule and do not
# stop the run. The rule's output never names the three entries outside its domain.
test_files_outside_the_set_under_resources_pass() {
  copy="$(copy_with_file resources-extra Contents/Resources/sub/x.txt 'x')" || fail "could not place the file" || return 1
  codesign --force --sign - --entitlements "$WORK/valid.plist" "$copy" > /dev/null 2>&1 \
    || fail "could not re-sign the copy after adding the file" || return 1

  run_bundle_sh "$copy"

  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. output: $OUT" || return 1
  expect_output_contains "$DRAWN_FROM_PASS_LINE" || return 1
  expect_output_lacks "Info.plist" || return 1
  expect_output_lacks "_CodeSignature" || return 1
  expect_output_lacks "icon.icns" || return 1
  expect_no_bundle_process "$copy"
}

# D1-11 (CP-118 a): the execute bit alone, on a file that is no binary, under Resources.
test_executable_bit_file_under_resources_fails() {
  copy="$(copy_with_file exec-bit Contents/Resources/helper '#!/bin/sh
exit 0
')" || fail "could not place the file" || return 1
  chmod 755 "$copy/Contents/Resources/helper"

  run_unlaunched "$copy" exec-bit

  expect_refused_naming exec-bit "Contents/Resources/helper"
}

# D1-12 (CP-118 a): a Mach-O binary is an executable whatever its mode. Only the magic can refuse it.
test_mach_o_without_execute_bit_fails() {
  copy="$(valid_copy mach-o)" || fail "could not re-sign the copy" || return 1
  cp "$copy/Contents/MacOS/KAReader" "$copy/Contents/Resources/bin"
  chmod 644 "$copy/Contents/Resources/bin"

  run_unlaunched "$copy" mach-o

  expect_refused_naming mach-o "Contents/Resources/bin"
}

# D1-13 (CP-118 b): a font by its extension, with contents that are no font. Only the extension can
# refuse it.
test_font_by_extension_fails() {
  copy="$(copy_with_file font-ext Contents/Resources/Inter.ttf 'not a font')" || fail "could not place the file" || return 1

  run_unlaunched "$copy" font-ext

  expect_refused_naming font-ext "Contents/Resources/Inter.ttf"
}

# D1-13 (CP-118 b): a font by its first four bytes, under a name no extension list holds. Only the
# signature can refuse it.
test_font_by_signature_fails() {
  copy="$(copy_with_file font-sig Contents/Resources/glyphs.dat 'OTTO and then some bytes')" || fail "could not place the file" || return 1

  run_unlaunched "$copy" font-sig

  expect_refused_naming font-sig "Contents/Resources/glyphs.dat"
}

# D1-14 (CP-118 c): a byte copy of a tracked checks/ file, whatever its name. Its mode is set to 644 so
# the execute bit does not refuse it first: only the copy rule can.
test_copy_of_a_checks_file_fails() {
  copy="$(valid_copy checks-copy)" || fail "could not re-sign the copy" || return 1
  cp "$ROOT/checks/bundle.sh" "$copy/Contents/Resources/x"
  chmod 644 "$copy/Contents/Resources/x"

  run_unlaunched "$copy" checks-copy

  expect_refused_naming checks-copy "Contents/Resources/x"
}

# D1-14 (CP-118 c): an empty file matches nothing — checks/.gitkeep is tracked and empty — so the run
# goes past the blocks and reaches the launch, which the `open` stub records.
test_empty_file_is_not_a_checks_copy() {
  copy="$(copy_with_file empty-file Contents/Resources/empty '')" || fail "could not place the file" || return 1

  run_unlaunched "$copy" empty-file BUNDLE_SH_LAUNCH_TICKS=2

  expect_output_lacks "copy of a checks/ file" || return 1
  expect_output_lacks "the bundle holds files it must not ship" || return 1
  [ -e "$WORK/open-empty-file.log" ] || fail "the run stopped before the launch. output: $OUT"
}

# D1-15 (CP-118 c): a listing of checks/ that fails is a refusal naming the cause, never a pass.
test_checks_listing_that_fails_is_refused() {
  mkdir -p "$WORK/stubs-git-fails"
  make_stub "$WORK/stubs-git-fails" git 'echo "git: stubbed failure" >&2; exit 3'

  run_unlaunched "$APP" git-fails

  expect_refused_naming git-fails "cannot list the files tracked under checks/"
}

# The listing that comes back empty: a set of candidates with no member would let every copy through.
test_empty_checks_listing_is_refused() {
  mkdir -p "$WORK/stubs-git-empty"
  make_stub "$WORK/stubs-git-empty" git 'exit 0'

  run_unlaunched "$APP" git-empty

  expect_refused_naming git-empty "the list of files tracked under checks/ is empty"
}

# CP-117 and CP-118 name the cause on stderr. The suite's helper folds the streams together, so this is
# the one case that reads stderr alone: with stdout discarded, a drawn-from refusal and a contents
# refusal each still name their path.
test_pre_launch_refusals_are_on_stderr() {
  mkdir -p "$WORK/stubs-stderr"
  make_stub "$WORK/stubs-stderr" open "exit 0"
  drawn="$(copy_with_file stderr-drawn Contents/MacOS/folder.svg '<svg/>')" || fail "could not place the file" || return 1
  contents="$(copy_with_file stderr-contents Contents/Resources/helper '#!/bin/sh
exit 0
')" || fail "could not place the file" || return 1
  chmod 755 "$contents/Contents/Resources/helper"

  stderr_drawn="$(PATH="$WORK/stubs-stderr:$PATH" "$BUNDLE_SH" "$drawn" 2>&1 > /dev/null)"
  stderr_contents="$(PATH="$WORK/stubs-stderr:$PATH" "$BUNDLE_SH" "$contents" 2>&1 > /dev/null)"

  case "$stderr_drawn" in
    *"Contents/MacOS/folder.svg"*) ;;
    *) fail "the drawn-from refusal did not name its path on stderr. stderr: $stderr_drawn" || return 1 ;;
  esac
  case "$stderr_contents" in
    *"Contents/Resources/helper"*) ;;
    *) fail "the contents refusal did not name its path on stderr. stderr: $stderr_contents" ;;
  esac
}

# --- added by the code-integrity review: each member of a closed list, and each half of a rule ---
#
# The cases above test one member of each list the plan fixed (tl_instruction.md, Task 2, 2b). A script
# that dropped any other member would still pass them, so each case below places every member at once
# and asserts each is named. Every file is mode 644 unless the case is about the mode.

# CP-118 (b): every extension of the plan's set, compared case-insensitively. The contents are no font,
# so only the extension can refuse them.
test_every_font_extension_fails_in_any_case() {
  copy="$(valid_copy font-exts)" || fail "could not re-sign the copy" || return 1
  for name in a.OTF b.ttc c.Otc d.woff e.WOFF2 f.dfont g.TTF; do
    printf 'not a font' > "$copy/Contents/Resources/$name"
  done

  run_unlaunched "$copy" font-exts

  expect_refused_naming font-exts \
    "font: Contents/Resources/a.OTF" "font: Contents/Resources/b.ttc" "font: Contents/Resources/c.Otc" \
    "font: Contents/Resources/d.woff" "font: Contents/Resources/e.WOFF2" "font: Contents/Resources/f.dfont" \
    "font: Contents/Resources/g.TTF"
}

# CP-118 (b): every signature of the plan's set, under names no extension list holds.
test_every_font_signature_fails() {
  copy="$(valid_copy font-sigs)" || fail "could not re-sign the copy" || return 1
  printf '\000\001\000\000rest' > "$copy/Contents/Resources/truetype.dat"
  printf 'OTTOrest' > "$copy/Contents/Resources/otto.dat"
  printf 'truerest' > "$copy/Contents/Resources/true.dat"
  printf 'typ1rest' > "$copy/Contents/Resources/typ1.dat"
  printf 'ttcfrest' > "$copy/Contents/Resources/ttcf.dat"
  printf 'wOFFrest' > "$copy/Contents/Resources/woff.dat"
  printf 'wOF2rest' > "$copy/Contents/Resources/woff2.dat"

  run_unlaunched "$copy" font-sigs

  expect_refused_naming font-sigs \
    "font: Contents/Resources/truetype.dat" "font: Contents/Resources/otto.dat" \
    "font: Contents/Resources/true.dat" "font: Contents/Resources/typ1.dat" \
    "font: Contents/Resources/ttcf.dat" "font: Contents/Resources/woff.dat" \
    "font: Contents/Resources/woff2.dat"
}

# CP-118 (a): a Mach-O is an executable whatever its mode — thin or fat, in either byte order. Each file is
# the four magic bytes and nothing else, at mode 644, so only the magic can refuse it.
test_every_mach_o_magic_is_an_executable() {
  copy="$(valid_copy mach-o-magics)" || fail "could not re-sign the copy" || return 1
  printf '\376\355\372\316' > "$copy/Contents/Resources/m-feedface"
  printf '\376\355\372\317' > "$copy/Contents/Resources/m-feedfacf"
  printf '\316\372\355\376' > "$copy/Contents/Resources/m-cefaedfe"
  printf '\317\372\355\376' > "$copy/Contents/Resources/m-cffaedfe"
  printf '\312\376\272\276' > "$copy/Contents/Resources/m-cafebabe"
  printf '\312\376\272\277' > "$copy/Contents/Resources/m-cafebabf"
  printf '\276\272\376\312' > "$copy/Contents/Resources/m-bebafeca"
  printf '\277\272\376\312' > "$copy/Contents/Resources/m-bfbafeca"
  chmod 644 "$copy"/Contents/Resources/m-*

  run_unlaunched "$copy" mach-o-magics

  expect_refused_naming mach-o-magics \
    "extra executable: Contents/Resources/m-feedface" "extra executable: Contents/Resources/m-feedfacf" \
    "extra executable: Contents/Resources/m-cefaedfe" "extra executable: Contents/Resources/m-cffaedfe" \
    "extra executable: Contents/Resources/m-cafebabe" "extra executable: Contents/Resources/m-cafebabf" \
    "extra executable: Contents/Resources/m-bebafeca" "extra executable: Contents/Resources/m-bfbafeca"
}

# CP-118 (a): "any execute permission bit" — the group's alone, and the others' alone, each make an
# executable. The user bit is the case test_executable_bit_file_under_resources_fails already holds.
test_group_or_other_execute_bit_fails() {
  copy="$(valid_copy group-other-exec)" || fail "could not re-sign the copy" || return 1
  printf 'x' > "$copy/Contents/Resources/group-exec"
  printf 'x' > "$copy/Contents/Resources/other-exec"
  chmod 654 "$copy/Contents/Resources/group-exec"
  chmod 645 "$copy/Contents/Resources/other-exec"

  run_unlaunched "$copy" group-other-exec

  expect_refused_naming group-other-exec \
    "extra executable: Contents/Resources/group-exec" "extra executable: Contents/Resources/other-exec"
}

# CP-117 (c): a path outside Contents/Resources is refused when its name is a member's, as well as when it
# ends in .svg. Every real member ends in .svg, so the name half is proved with a set that holds one member
# that does not; the copy carries it under Resources too, so only (c) can refuse.
test_member_name_without_svg_suffix_outside_resources_fails() {
  mkdir -p "$WORK/set-plain-member"
  cp "$EXPECTED_SET_DIR"/* "$WORK/set-plain-member/"
  printf 'x' > "$WORK/set-plain-member/plain-member"
  copy="$(valid_copy plain-member)" || fail "could not re-sign the copy" || return 1
  printf 'x' > "$copy/Contents/Resources/plain-member"
  printf 'x' > "$copy/Contents/MacOS/plain-member"
  chmod 644 "$copy/Contents/MacOS/plain-member"

  run_unlaunched "$copy" plain-member BUNDLE_SH_GLYPH_DIR="$WORK/set-plain-member"

  expect_refused_naming plain-member "glyph outside Contents/Resources: Contents/MacOS/plain-member" || return 1
  expect_output_lacks "glyph missing from Contents/Resources"
}

# CP-117: the expected set is every file in the glyph directory, dotfiles included (tl_instruction.md,
# Task 2, 2b). A dotfile member the bundle lacks is a missing member, named.
test_dotfile_in_the_expected_set_is_a_member() {
  mkdir -p "$WORK/set-dotfile"
  cp "$EXPECTED_SET_DIR"/* "$WORK/set-dotfile/"
  printf 'x' > "$WORK/set-dotfile/.hidden-member"

  run_unlaunched "$APP" set-dotfile BUNDLE_SH_GLYPH_DIR="$WORK/set-dotfile"

  expect_refused_naming set-dotfile "glyph missing from Contents/Resources: .hidden-member"
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

# CP-66: a window that is not a positive whole number is refused before anything is launched.
test_invalid_probe_window_is_refused_before_launch() {
  mkdir -p "$WORK/stubs-invalid-window"
  make_stub "$WORK/stubs-invalid-window" open "echo \"\$@\" >> \"$WORK/open-invalid-window.log\""

  for value in 0 -1 abc; do
    rm -f "$WORK/open-invalid-window.log"

    OUT="$(BUNDLE_SH_PROBE_TICKS="$value" BUNDLE_SH_LAUNCH_TICKS=2 PATH="$WORK/stubs-invalid-window:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
    STATUS=$?

    expect_nonzero_status || return 1
    expect_output_contains "BUNDLE_SH_PROBE_TICKS" || return 1
    [ ! -e "$WORK/open-invalid-window.log" ] || fail "open was called for BUNDLE_SH_PROBE_TICKS=$value: $(cat "$WORK/open-invalid-window.log")" || return 1
  done
}

# CP-66, CP-78: the header names the variable and its unit, and states the ordinary path as CP-73's
# one judgment — never the retired first-yes rule. The lines before `set -euo pipefail`.
test_header_names_the_probe_window() {
  header="$(awk '/^set -euo pipefail$/{exit} {print}' "$BUNDLE_SH")"
  case "$header" in
    *BUNDLE_SH_PROBE_TICKS*) ;;
    *) fail "the header does not name BUNDLE_SH_PROBE_TICKS. header: $header" || return 1 ;;
  esac
  case "$header" in
    *"0.25 s"*) ;;
    *) fail "the header does not name the 0.25 s unit. header: $header" || return 1 ;;
  esac
  case "$header" in
    *"the first ask on which all three hold"*) ;;
    *) fail "the header does not state that the pass is the first ask on which all three hold. header: $header" || return 1 ;;
  esac
  case "$header" in
    *"the first report that says sandboxed: yes"*) fail "the header still states the retired rule: the first report that says sandboxed: yes. header: $header" ;;
  esac
}

# CP-66: an empty value (set, but empty) reads as unset, so the window is still the default of 40.
# Also proves the default is exactly 40: the run only reaches sandboxed: yes on the 40th ask.
test_empty_probe_window_reads_as_the_default() {
  seq="$WORK/seq-empty-window"
  set --
  i=1
  while [ "$i" -le 39 ]; do
    set -- "$@" "no denied denied"
    i=$((i + 1))
  done
  set -- "$@" "yes denied denied"
  sequenced_probe_stub "$seq" "$@"

  OUT="$(BUNDLE_SH_PROBE_TICKS= PATH="$seq:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
  STATUS=$?

  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. output: $OUT" || return 1
  expect_output_contains "sandbox observed:" || return 1
  [ "$(asked_count "$seq")" -eq 40 ] || fail "expected 40 asks, got $(asked_count "$seq")" || return 1
}

# CP-66: a leading-zero window is a positive whole number, read in base 10 rather than refused as
# invalid octal.
test_leading_zero_window_reads_in_base_ten() {
  seq="$WORK/seq-leading-zero"
  sequenced_probe_stub "$seq" "no denied denied"

  OUT="$(BUNDLE_SH_PROBE_TICKS=08 PATH="$seq:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_output_contains "8 asks" || return 1
  # CP-75: <N> is the window in force, read in base 10 — 8, never the override's spelling 08.
  expect_closing_line_states_the_window 8 || return 1
  expect_output_lacks "BUNDLE_SH_PROBE_TICKS" || return 1
  expect_output_lacks "octal" || return 1
  [ "$(asked_count "$seq")" -eq 8 ] || fail "expected 8 asks, got $(asked_count "$seq")" || return 1
}

# CP-74, CP-75, CP-77: never sandboxed within the window — the run fails naming the window it waited.
test_never_sandboxed_within_the_window_fails_naming_it() {
  seq="$WORK/seq-never-sandboxed"
  sequenced_probe_stub "$seq" "no denied denied"

  OUT="$(BUNDLE_SH_PROBE_TICKS=3 PATH="$seq:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_output_contains "the launched process is not sandboxed" || return 1
  expect_output_contains "3 asks" || return 1
  expect_output_contains "0.25 s" || return 1
  expect_not_sandboxed_condition_line_unchanged || return 1
  # CP-74: only the condition the last report fails is named (spec § Examples, `no denied denied`).
  expect_output_lacks "an out-of-grant file read is not denied" || return 1
  expect_output_lacks "an outbound network connection is not denied" || return 1
  expect_closing_line_states_the_window 3 || return 1
  expect_one_report || return 1
  [ "$(asked_count "$seq")" -eq 3 ] || fail "expected 3 asks, got $(asked_count "$seq")" || return 1
}

# CP-74: a short `yes` (missing a condition) does not survive to the end of the window — asked past
# like any other report short of all three, and when the window runs out the last report asked is
# judged, even though an earlier report said sandboxed: yes.
test_window_exhausted_after_a_short_yes_judges_the_last_report() {
  seq="$WORK/seq-short-yes-exhausted"
  sequenced_probe_stub "$seq" "yes denied allowed" "no allowed allowed"

  OUT="$(BUNDLE_SH_PROBE_TICKS=2 PATH="$seq:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  [ "$(asked_count "$seq")" -eq 2 ] || fail "expected 2 asks, got $(asked_count "$seq")" || return 1
  expect_one_report || return 1
  expect_output_lacks "sandboxed: yes" || return 1
  expect_output_contains "the launched process is not sandboxed" || return 1
  expect_output_contains "an out-of-grant file read is not denied" || return 1
  expect_output_contains "an outbound network connection is not denied" || return 1
  expect_closing_line_states_the_window 2 || return 1
}

# CP-80.2: a probe failure on any ask ends the run at once — a short `yes` on an earlier ask changes
# nothing, and the report that would have followed (a full sandboxed: yes) never gets the chance to be
# judged.
test_probe_failure_after_a_short_yes_ends_the_run() {
  seq="$WORK/seq-short-yes-then-fail"
  sequenced_probe_stub "$seq" "yes denied allowed" FAIL "yes denied denied"

  run_bundle_sh_with_stubs "$seq" "$APP"

  expect_nonzero_status || return 1
  [ "$(asked_count "$seq")" -eq 2 ] || fail "expected 2 asks, got $(asked_count "$seq")" || return 1
  case "$(closing_line)" in
    "bundle.sh: the operating system's sandbox report for pid "*) ;;
    *) fail "expected the closing line to open with the probe-failure message. closing line: $(closing_line)" || return 1 ;;
  esac
  expect_output_contains "sandbox_check" || return 1
  expect_output_lacks "asks" || return 1
  expect_output_lacks "sandbox observed:" || return 1
  expect_output_lacks "condition not held:" || return 1
  expect_no_bundle_process "$APP"
}

# CP-74: when the window runs out, the last report is the one judged — not the first.
test_window_exhausted_reads_the_last_report() {
  seq="$WORK/seq-window-exhausted"
  sequenced_probe_stub "$seq" "no allowed allowed" "no denied denied"

  OUT="$(BUNDLE_SH_PROBE_TICKS=2 PATH="$seq:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_output_contains "not sandboxed" || return 1
  expect_output_lacks "an out-of-grant file read is not denied" || return 1
  expect_output_lacks "an outbound network connection is not denied" || return 1
  # The second report's own conditions, proving it is the one printed and judged, not the first.
  expect_output_contains "out-of-grant-read: denied" || return 1
  expect_one_report || return 1
  [ "$(asked_count "$seq")" -eq 2 ] || fail "expected 2 asks, got $(asked_count "$seq")" || return 1
}

test_no_sandbox_observed_fails_and_cleans_up() {
  mkdir -p "$WORK/stubs-nosandbox"
  probe_stub "$WORK/stubs-nosandbox" no allowed allowed

  OUT="$(BUNDLE_SH_PROBE_TICKS=2 PATH="$WORK/stubs-nosandbox:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_output_contains "the launched process is not sandboxed" || return 1
  expect_output_contains "2 asks" || return 1
  expect_output_contains "0.25 s" || return 1
  expect_not_sandboxed_condition_line_unchanged || return 1
  expect_closing_line_states_the_window 2 || return 1
  expect_output_contains "an out-of-grant file read is not denied" || return 1
  expect_output_contains "an outbound network connection is not denied" || return 1
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

  OUT="$(env "$LEGACY_MARKER=com.kensaiapp.ka-reader" BUNDLE_SH_PROBE_TICKS=2 PATH="$WORK/stubs-marker:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
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
  mkdir -p "$WORK/stubs-container" "$WORK/home/Library/Containers/com.kensaiapp.ka-reader"
  probe_stub "$WORK/stubs-container" no allowed allowed

  OUT="$(HOME="$WORK/home" BUNDLE_SH_PROBE_TICKS=2 PATH="$WORK/stubs-container:$PATH" "$BUNDLE_SH" "$APP" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_output_contains "the launched process is not sandboxed" || return 1
  expect_no_bundle_process "$APP"
}

# `sandbox_check` cannot be resolved: the run fails naming the symbol, and says nothing that reads as a
# pass or as a denial (CP-43).
test_unresolvable_symbol_fails() {
  mkdir -p "$WORK/stubs-unresolvable"
  make_stub "$WORK/stubs-unresolvable" ka-reader-sandbox-probe 'echo "ka-reader-sandbox-probe: sandbox_check cannot be resolved" >&2; exit 2'

  run_bundle_sh_with_stubs "$WORK/stubs-unresolvable" "$APP"

  expect_nonzero_status || return 1
  expect_output_contains "sandbox_check" || return 1
  expect_output_lacks "sandboxed: yes" || return 1
  expect_output_lacks "denied" || return 1
  expect_no_bundle_process "$APP"
}

test_probe_error_fails() {
  mkdir -p "$WORK/stubs-error"
  make_stub "$WORK/stubs-error" ka-reader-sandbox-probe 'echo "ka-reader-sandbox-probe: sandbox_check returned an error" >&2; exit 1'

  run_bundle_sh_with_stubs "$WORK/stubs-error" "$APP"

  expect_nonzero_status || return 1
  expect_output_contains "sandbox_check" || return 1
  expect_output_lacks "sandboxed: yes" || return 1
  expect_output_lacks "denied" || return 1
  expect_no_bundle_process "$APP"
}

# CP-73: a report that exits 0 but is missing a line — a report the judgment cannot read as holding
# that condition — is asked past like any report short of all three; it is neither a failure that ends
# the run nor a pass.
test_unreadable_report_is_asked_past() {
  dir="$WORK/stubs-unreadable-then-yes"
  mkdir -p "$dir"
  echo 0 > "$dir/count"
  make_stub "$dir" ka-reader-sandbox-probe "n=\$(( \$(cat \"$dir/count\") + 1 )); echo \"\$n\" > \"$dir/count\"
if [ \"\$n\" -eq 1 ]; then printf 'garbled\\n'; else printf 'sandboxed: yes\\nout-of-grant-read: denied\\noutbound-connection: denied\\n'; fi"

  run_bundle_sh_with_stubs "$dir" "$APP"

  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. output: $OUT" || return 1
  expect_output_contains "sandbox observed:" || return 1
  expect_output_lacks "garbled" || return 1
  [ "$(cat "$dir/count")" -eq 2 ] || fail "expected 2 asks, got $(cat "$dir/count")" || return 1
  expect_no_bundle_process "$APP"
}

# CP-67: a probe failure on any ask ends the run at once — no later ask is made, and the failure that
# never happens (ask 3's sandboxed: yes) never gets the chance to be judged.
test_probe_failure_mid_window_ends_the_run() {
  seq="$WORK/seq-mid-window"
  sequenced_probe_stub "$seq" "no denied denied" FAIL "yes denied denied"

  run_bundle_sh_with_stubs "$seq" "$APP"

  expect_nonzero_status || return 1
  expect_output_contains "sandbox_check" || return 1
  expect_output_lacks "sandboxed: yes" || return 1
  [ "$(asked_count "$seq")" -eq 2 ] || fail "expected 2 asks, got $(asked_count "$seq")" || return 1
  expect_no_bundle_process "$APP"
}

# Every other case stubs the probe, so this is the one that holds the real probe's output contract:
# the suite's own shell is unsandboxed, and the compiled probe must say so in the lines the script parses.
test_probe_reports_an_unsandboxed_pid_as_unsandboxed() {
  compile_probe || return 1

  OUT="$("$WORK/probe-bin/ka-reader-sandbox-probe" "$$" 2>&1)"
  STATUS=$?

  [ "$STATUS" -eq 0 ] || fail "expected the probe to exit 0 on an unsandboxed pid, got $STATUS. output: $OUT" || return 1
  expect_output_contains "sandboxed: no"
}

test_nonexistent_path_fails() {
  run_bundle_sh /nonexistent/KA-Reader.app

  expect_nonzero_status || return 1
  expect_output_contains "not found: /nonexistent/KA-Reader.app"
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
  nested="$(KA_READER_APP=/nonexistent/KA-Reader.app bash "$0" 2>&1)"
  nested_status=$?

  [ "$nested_status" -ne 0 ] || fail "the suite exited 0 with no bundle to test" || return 1
  case "$nested" in
    *"the bundle under test is absent: /nonexistent/KA-Reader.app"*) ;;
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
  KA_READER_TEST_ONLY=test_missing_key_fails KA_READER_TEST_WORKDIR_LOG="$log" bash "$0" > /dev/null 2>&1

  nested_work="$(cat "$log" 2> /dev/null || true)"
  [ -n "$nested_work" ] || fail "the nested suite recorded no temporary directory" || return 1
  [ ! -e "$nested_work" ] || fail "the temporary directory still exists: $nested_work"
}

# QC-65 (CP-797, CP-798, CP-799): off a macOS virtual machine bundle.sh prints its one refusal line and
# does nothing else, whatever it is given. The matrix (every host reading that must refuse) and the
# traced run are the shared helper's; the arguments and inputs below are the ones bundle.sh reads.
test_refuses_off_vm_before_work() {
  VMR_TMP="$WORK"
  scene="$WORK/refusal-scene"
  mkdir -p "$scene/plain" "$scene/Fake.app/Contents"
  : > "$scene/Fake.app/Contents/Info.plist"
  VMR_SCENE="$scene"
  VMR_ENV=()

  vmr_assert_refusal "$BUNDLE_SH" bundle.sh || return 1
  vmr_assert_refusal "$BUNDLE_SH" bundle.sh /nonexistent || return 1
  vmr_assert_refusal "$BUNDLE_SH" bundle.sh "$scene/plain" || return 1
  vmr_assert_refusal "$BUNDLE_SH" bundle.sh "$scene/Fake.app" || return 1
  vmr_assert_refusal "$BUNDLE_SH" bundle.sh --negative-control || return 1
  vmr_assert_refusal "$BUNDLE_SH" bundle.sh --negative-control "$scene/Fake.app" || return 1
  for ticks in 1 0 abc ""; do
    VMR_ENV=("BUNDLE_SH_PROBE_TICKS=$ticks" "BUNDLE_SH_LAUNCH_TICKS=$ticks")
    vmr_assert_refusal "$BUNDLE_SH" bundle.sh "$scene/Fake.app" || return 1
  done
}

# CP-798/CP-800: on a virtual machine's reading the admission adds no line and changes no verdict.
test_admits_on_a_vm_reading() {
  VMR_TMP="$WORK"
  VMR_SCENE=""
  VMR_ENV=()

  vmr_run_on admit "$BUNDLE_SH" /nonexistent || return 1

  [ "$vmr_status" -eq 1 ] || fail "expected exit 1, got $vmr_status" || return 1
  [ ! -s "$vmr_case/stdout" ] || fail "stdout is not empty: $(cat "$vmr_case/stdout")" || return 1
  [ "$(cat "$vmr_case/stderr")" = "bundle.sh: not found: /nonexistent" ] \
    || fail "expected only the existing verdict. stderr: $(cat "$vmr_case/stderr")"
}

# --- the runner ---

if [ ! -d "$APP" ]; then
  echo "test_bundle.sh: the bundle under test is absent: $APP — build it first (the bundle command), or set KA_READER_APP" >&2
  exit 1
fi

WORK="$(mktemp -d)"
[ -z "${KA_READER_TEST_WORKDIR_LOG:-}" ] || printf '%s' "$WORK" > "$KA_READER_TEST_WORKDIR_LOG"
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
  if [ -n "${KA_READER_TEST_ONLY:-}" ] && [ "$case_name" != "$KA_READER_TEST_ONLY" ]; then
    continue
  fi
  ran="$ran $case_name"
  if result="$("$case_name" 2>&1)"; then
    echo "ok   $case_name"
    # The control's whole output on success is its one reading (CP-768). It is forwarded because the
    # case runs in this command substitution, where an assignment would not reach the runner; every
    # other case's output stays suppressed, so no other probe report is published.
    [ "$case_name" != "$CONTROL_CASE" ] || printf '%s\n' "$result"
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

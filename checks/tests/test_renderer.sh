#!/usr/bin/env bash
# Version: 1.0.0 — first version: drives the real checks/renderer.sh, both halves, over stand-in
#   ps, open, sample, codesign and swiftc, and over the real bundle
#
# checks/tests/test_renderer.sh — the tests of checks/renderer.sh.
#
# WHY THIS EXISTS
#   checks/renderer.sh is the proof that the shipped shell reaches the Open panel, so a bug in it
#   is a wall nobody is watching. These cases run the real script — never a copy of its logic.
#   `ps`, `open`, `sample`, `codesign` and `swiftc` are stood in on PATH, the seams the script has.
#   The pids are real processes (`sleep`), started and stopped by pid, because the script asks the
#   operating system whether a pid still names a process and signals it.
#   The technique is the shell packet's, minus its runner: this product has no Python, so the runner
#   is this file, as in checks/tests/test_bundle.sh.
#
# USAGE
#   checks/tests/test_renderer.sh
#   The real-bundle cases launch target/release/bundle/macos/KA-Reader.app and sample it, so run
#   ka-reader-mac/assemble.sh first and run this in a logged-in GUI session; they also build and
#   sign the real control with the real swiftc and codesign. A bundle that is absent FAILS those
#   cases with a stated message and never skips it: a skip would let CI conclude green having
#   proved nothing.
#   KA_READER_TEST_ONLY=<case> runs one case.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.
#
# ADMISSION
#   The first thing the suite does is ask the host whether it is a macOS virtual machine (`uname -s`
#   Darwin and `sysctl -n kern.hv_vmm_present` 1, both succeeding), because its cases launch the built
#   bundle. On any other reading it prints one line on stderr, nothing on stdout, and exits 1, before it
#   finds the product root, makes a temporary directory or runs a case (docs/nfdr.md QC-65). Nothing it
#   is given turns this off, KA_READER_TEST_ONLY included. The case that proves it is
#   checks/tests/test_vm_refusal.sh's: a suite that refused has no case left to run.

set -uo pipefail

# --- admission: this suite runs only in a macOS virtual machine (docs/nfdr.md QC-65) ---
# First work of the run, inline so nothing is opened, found or read before it. Both host readings must
# succeed and read exactly Darwin and 1; a reader that fails, is missing or prints anything else
# refuses, and a failing reader that prints 1 does not admit (the status is kept, not only the text).
# Nothing the suite reads — argument, flag or variable — changes this.
host_os="$(uname -s 2> /dev/null)" && host_vmm="$(sysctl -n kern.hv_vmm_present 2> /dev/null)" \
  && [ "$host_os" = "Darwin" ] && [ "$host_vmm" = "1" ] \
  || { echo "test_renderer.sh: refused: this host does not read as a macOS virtual machine. This step launches KA-Reader.app or reads this machine's home, and runs only in a macOS virtual machine (docs/nfdr.md QC-65)." >&2; exit 1; }

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
RENDERER_SH="$ROOT/checks/renderer.sh"
# shellcheck source=checks/tests/support/vm_refusal.sh
source "$ROOT/checks/tests/support/vm_refusal.sh"
REAL_APP="$ROOT/target/release/bundle/macos/KA-Reader.app"

STDOUT=""
STDERR=""
STATUS=0
WORK="$(mktemp -d)"
CASE_COUNTER=0

CASES="
test_real_bundle_passes
test_real_bundle_passes_with_its_control
test_not_an_app_launches_nothing
test_launch_goes_through_open
test_running_instance_refused
test_two_pids_after_launch
test_no_pid_appears
test_pid_found_by_path_not_pattern
test_stops_only_its_own_pid
test_sample_writes_only_into_the_run_directory
test_first_matching_observation_passes
test_frames_on_another_thread_do_not_count
test_main_thread_under_its_early_label_counts
test_frames_out_of_order_do_not_count
test_generic_modal_alone_does_not_count
test_panel_without_shell_frames_does_not_count
test_near_frame_names_do_not_count
test_tree_characters_carry_no_meaning
test_pid_gone_fails_at_once
test_sample_error_fails_at_once
test_sample_writing_no_report_fails_at_once
test_window_runs_out
test_pass_line_on_stdout_failures_on_stderr
test_header_names_frames_and_the_mac_reading
test_header_names_the_runner_reading
test_bound_override_validated
test_control_set_must_equal_product_set
test_control_signed_ad_hoc_with_the_hardened_runtime
test_product_signature_unreadable_fails_before_any_launch
test_swiftc_absent_fails_before_any_launch
test_product_half_alone_is_not_a_pass
test_product_stopped_before_the_control_launches
test_control_pid_not_found_once_fails
test_control_crash_is_not_a_red
test_control_at_the_panel_fails
test_control_line_states_the_bound
test_nothing_written_under_fixtures
test_no_checks_file_matches_a_bundle_file
test_no_input_sent
test_refuses_off_vm_before_work
test_admits_on_a_vm_reading
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# Every pid a stand-in started, for the cleanup at exit.
stop_all_spawned() {
  for spawned_file in "$WORK"/*/stubs/spawned; do
    [ -f "$spawned_file" ] || continue
    while read -r spawned_pid; do
      [ -n "$spawned_pid" ] && kill -KILL "$spawned_pid" 2> /dev/null
    done < "$spawned_file"
  done
  return 0
}

# A synthetic application bundle: an Info.plist naming the executable, and an executable that records
# any direct run, so a launch that bypasses `open` is seen.
new_app() {
  app_dir="$WORK/$1/app/KA-Reader.app"
  mkdir -p "$app_dir/Contents/MacOS"
  cat > "$app_dir/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict><key>CFBundleExecutable</key><string>KAReader</string></dict></plist>
PLIST
  printf '#!/bin/sh\necho direct > "%s/direct_exec"\n' "$WORK/$1" > "$app_dir/Contents/MacOS/KAReader"
  chmod +x "$app_dir/Contents/MacOS/KAReader"
  printf '%s' "$app_dir"
}

# An entitlement property list at $1 holding the entries $2, in the form codesign prints.
set_entitlements() {
  printf '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "https://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><dict>%s</dict></plist>\n' "$2" > "$1"
}

PRODUCT_ENTITLEMENTS='<key>com.apple.security.app-sandbox</key><true/><key>com.apple.security.files.user-selected.read-only</key><true/>'

# The stand-ins for one case, in $WORK/<case>/stubs. Their behaviour is set by small files beside them.
make_stubs() {
  stubs="$WORK/$1/stubs"
  mkdir -p "$stubs"

  cat > "$stubs/ps" << 'STUB'
#!/bin/bash
# Lists the live processes of $STUB/ps_table: "<pid> <comm> [<args>]" per line.
[ -f "$STUB/ps_table" ] || exit 0
while read -r listed_pid listed_comm listed_args; do
  [ -n "$listed_pid" ] || continue
  kill -0 "$listed_pid" 2> /dev/null || continue
  case "$*" in
    *command=* | *args=*) echo "$listed_pid $listed_comm $listed_args" ;;
    *) echo "$listed_pid $listed_comm" ;;
  esac
done < "$STUB/ps_table"
exit 0
STUB

  cat > "$stubs/open" << 'STUB'
#!/bin/bash
# Records its call, then starts the launched process: one, two, or none, by $STUB/open_mode.
echo "$*" >> "$STUB/open_calls"
for last_argument in "$@"; do :; done
executable="$last_argument/Contents/MacOS/$(ls "$last_argument/Contents/MacOS" | head -1)"
echo "$executable" > "$STUB/exe_path"
open_number="$(wc -l < "$STUB/open_calls" | tr -d ' ')"
# What the first launch's process is doing when a later launch is made: the run must have stopped it.
if [ "$open_number" -ge 2 ]; then
  first_pid="$(head -1 "$STUB/spawned")"
  if kill -0 "$first_pid" 2> /dev/null; then
    echo "open $open_number: first pid $first_pid alive" >> "$STUB/events"
  else
    echo "open $open_number: first pid $first_pid stopped" >> "$STUB/events"
  fi
fi
spawn() {
  spawned_pid="$( (sleep 300 > /dev/null 2>&1 & echo $!) )"
  echo "$spawned_pid $executable" >> "$STUB/ps_table"
  echo "$spawned_pid" >> "$STUB/spawned"
}
open_mode="$(cat "$STUB/open_mode.$open_number" 2> /dev/null || cat "$STUB/open_mode" 2> /dev/null || echo one)"
case "$open_mode" in
  none) ;;
  two) spawn; spawn ;;
  *) spawn ;;
esac
exit 0
STUB

  cat > "$stubs/sample" << 'STUB'
#!/bin/bash
# sample <pid> <seconds> -file <path>: writes the report the case prepared for this call's number.
call_arguments="$*"
target_pid="$1"
report_path=""
while [ $# -gt 0 ]; do
  [ "$1" = "-file" ] && report_path="$2"
  shift
done
call_number=$(( $(cat "$STUB/sample_count" 2> /dev/null || echo 0) + 1 ))
echo "$call_number" > "$STUB/sample_count"
echo "$call_arguments" >> "$STUB/sample_calls"
if [ "$call_number" -eq 1 ] && [ -f "$STUB/decoy_on_first" ]; then
  decoy_pid="$( (sleep 300 > /dev/null 2>&1 & echo $!) )"
  echo "$decoy_pid $(cat "$STUB/exe_path")" >> "$STUB/ps_table"
  echo "$decoy_pid" >> "$STUB/spawned"
  echo "$decoy_pid" > "$STUB/decoy_pid"
fi
if [ "$(cat "$STUB/sample_fail_at" 2> /dev/null)" = "$call_number" ]; then
  echo "sample: cannot examine process $target_pid" >&2
  exit 1
fi
report_source="$STUB/report.$call_number"
[ -f "$report_source" ] || report_source="$STUB/report.default"
[ -f "$report_source" ] && [ -n "$report_path" ] && cp "$report_source" "$report_path"
if [ "$(cat "$STUB/kill_after" 2> /dev/null)" = "$call_number" ]; then
  kill -KILL "$target_pid" 2> /dev/null
  waited=0
  while kill -0 "$target_pid" 2> /dev/null && [ "$waited" -lt 40 ]; do
    sleep 0.05
    waited=$((waited + 1))
  done
fi
exit 0
STUB

  cat > "$stubs/codesign" << 'STUB'
#!/bin/bash
# -d ... <app>: prints the entitlement plist of the product, or of the control (what it was last signed
# with, unless a case overrides it). --sign ...: records the call and keeps the entitlements it was given.
echo "$*" >> "$STUB/codesign_calls"
for target_path in "$@"; do :; done
case " $* " in
  *" -d "*)
    case "$target_path" in
      *idle-shell.app*) plist_source="$STUB/control_entitlements.xml" ;;
      *)
        [ ! -e "$STUB/product_unreadable" ] || exit 1
        plist_source="$STUB/product_entitlements.xml"
        ;;
    esac
    [ -f "$plist_source" ] && cat "$plist_source"
    exit 0
    ;;
  *" --sign "*)
    previous=""
    entitlements_path=""
    for argument in "$@"; do
      [ "$previous" = "--entitlements" ] && entitlements_path="$argument"
      previous="$argument"
    done
    echo "$*" > "$STUB/signing_call"
    # What is being signed: its layout, and the Info.plist it carries.
    (cd "$target_path" && find . -type f | LC_ALL=C sort) > "$STUB/signed_layout"
    cp "$target_path/Contents/Info.plist" "$STUB/signed_info_plist" 2> /dev/null
    if [ -n "$entitlements_path" ]; then
      cp "$entitlements_path" "$STUB/signed_with.xml"
      if [ -f "$STUB/control_override.xml" ]; then
        cp "$STUB/control_override.xml" "$STUB/control_entitlements.xml"
      else
        cp "$entitlements_path" "$STUB/control_entitlements.xml"
      fi
    fi
    exit 0
    ;;
esac
exit 0
STUB

  cat > "$stubs/swiftc" << 'STUB'
#!/bin/bash
# Records its call and writes an executable at the -o path, unless a case makes it fail.
echo "$*" >> "$STUB/swiftc_calls"
output_path=""
previous=""
for argument in "$@"; do
  [ "$previous" = "-o" ] && output_path="$argument"
  previous="$argument"
done
if [ -e "$STUB/swiftc_fails" ]; then
  echo "swiftc: error: stand-in build failure" >&2
  exit 1
fi
printf '#!/bin/sh\nexit 0\n' > "$output_path"
chmod +x "$output_path"
exit 0
STUB

  set_entitlements "$stubs/product_entitlements.xml" "$PRODUCT_ENTITLEMENTS"

  for tool in osascript cliclick; do
    printf '#!/bin/sh\necho "$0 $*" >> "$STUB/input_calls"\nexit 0\n' > "$stubs/$tool"
  done
  chmod +x "$stubs"/*
  printf '%s' "$stubs"
}

# A new case directory with its stand-ins and its synthetic app. Sets CASE_DIR, STUBS, APP, APP_EXE.
new_case() {
  CASE_COUNTER=$((CASE_COUNTER + 1))
  CASE_DIR="$WORK/c$CASE_COUNTER-$1"
  mkdir -p "$CASE_DIR"
  STUBS="$(make_stubs "c$CASE_COUNTER-$1")"
  APP="$(new_app "c$CASE_COUNTER-$1")"
  APP="$(cd "$APP" && pwd -P)"
  APP_EXE="$APP/Contents/MacOS/KAReader"
}

# A process that outlives the script under test, listed by the ps stand-in under path $1 with the
# arguments $2. Started in a subshell so it is not this shell's child: a child that is killed stays a
# zombie until it is waited for, and a zombie still answers `kill -0`.
spawn_listed() {
  spawned="$( (sleep 300 > /dev/null 2>&1 & echo $!) )"
  echo "$spawned $1 ${2:-}" >> "$STUBS/ps_table"
  echo "$spawned" >> "$STUBS/spawned"
  printf '%s' "$spawned"
}

alive() {
  kill -0 "$1" 2> /dev/null
}

# The ordinary run: the stand-ins ahead of the real tools.
run_renderer() {
  STUB="$STUBS" PATH="$STUBS:$PATH" "$RENDERER_SH" "$@" > "$CASE_DIR/stdout" 2> "$CASE_DIR/stderr"
  STATUS=$?
  STDOUT="$(cat "$CASE_DIR/stdout")"
  STDERR="$(cat "$CASE_DIR/stderr")"
}

expect_status() {
  [ "$STATUS" -eq "$1" ] || fail "expected exit $1, got $STATUS. stdout: $STDOUT stderr: $STDERR"
}

expect_stderr_contains() {
  case "$STDERR" in
    *"$1"*) return 0 ;;
  esac
  fail "expected stderr to contain: $1. stderr: $STDERR stdout: $STDOUT"
}

expect_stderr_lacks() {
  case "$STDERR" in
    *"$1"*) fail "expected stderr not to contain: $1. stderr: $STDERR" ;;
  esac
}

expect_stdout_contains() {
  case "$STDOUT" in
    *"$1"*) return 0 ;;
  esac
  fail "expected stdout to contain: $1. stdout: $STDOUT stderr: $STDERR"
}

expect_no_open_call() {
  [ ! -s "$STUBS/open_calls" ] || fail "expected no open call, got: $(cat "$STUBS/open_calls")"
}

sample_call_count() {
  if [ -f "$STUBS/sample_calls" ]; then
    wc -l < "$STUBS/sample_calls" | tr -d ' '
  else
    echo 0
  fi
}

expect_sample_calls() {
  observed="$(sample_call_count)"
  [ "$observed" -eq "$1" ] || fail "expected $1 sample call(s), got $observed"
}

# --- reports: what `sample` writes, in its own shape ---
#
# A frame line is the tree marks, then the digits of its count. The count's column is the frame's
# depth: the thread header sits at column 4 and each level is two columns deeper.

# One frame line at level $1 with symbol $2, drawn with tree mark $3 (default +).
frame_line() {
  printf '    %s%*s867 %s  (in KAReader) + 100  [0x100c05644]\n' "${3:-+}" $((2 * $1 - 1)) '' "$2"
}

# Frames from stdin, one "<level> <symbol>" per line.
frames_from_stdin() {
  while read -r frame_level frame_symbol; do
    [ -n "$frame_level" ] && frame_line "$frame_level" "$frame_symbol" "${1:-+}"
  done
}

# The report file $1. $2 is the main thread's frames (stdin form). $3, when given, is a second
# thread's header, and $4 its frames.
write_report() {
  {
    echo "Analysis of sampling KAReader (pid 4242) every 1 millisecond"
    echo "Process:         KAReader [4242]"
    echo ""
    echo "Call graph:"
    echo "    867 Thread_1${MAIN_HEADER:-   DispatchQueue_1: com.apple.main-thread  (serial)}"
    printf '%s\n' "$2" | frames_from_stdin "${TREE_MARK:-+}"
    echo ""
    if [ -n "${3:-}" ]; then
      echo "    867 Thread_2: $3"
      printf '%s\n' "${4:-}" | frames_from_stdin "${TREE_MARK:-+}"
      echo ""
    fi
    echo "Total number in stack (recursive counted multiple, when >=5):"
  } > "$1"
}

LAUNCH_FRAMES="1 start
2 main
3 -[NSApplication run]
4 @objc AppDelegate.applicationDidFinishLaunching(_:)
5 AppDelegate.applicationDidFinishLaunching(_:)"

FULL_FRAMES="$LAUNCH_FRAMES
6 OpenFolderPanel.chooseFolder()
7 -[NSSavePanel runModal]
8 -[NSApplication runModalForWindow:]
9 _NSTryRunModal"

IDLE_FRAMES="1 start
2 main
3 -[NSApplication run]
4 _DPSNextEvent"

# Reports for a run that should exit 0: the product is observed at the panel on the first sample, and
# the control never is.
pass_reports() {
  write_report "$STUBS/report.1" "$FULL_FRAMES"
  write_report "$STUBS/report.default" "$IDLE_FRAMES"
}

# The ordinary run with PATH exactly $1 (the stand-ins first, then a directory of ordinary tools): for
# the case where one tool must be absent.
run_renderer_with_path() {
  restricted_path="$1"
  shift
  STUB="$STUBS" PATH="$restricted_path" "$RENDERER_SH" "$@" > "$CASE_DIR/stdout" 2> "$CASE_DIR/stderr"
  STATUS=$?
  STDOUT="$(cat "$CASE_DIR/stdout")"
  STDERR="$(cat "$CASE_DIR/stderr")"
}

# A directory of links to the ordinary tools and to no `swiftc`, so a run on it finds everything but
# the seam. `uname` and `sysctl` are linked too: the script reads the host first (docs/nfdr.md QC-65),
# and without them this run would be refused for its host reading before it reached the missing
# compiler. They are the real tools, so the case still has its real guest observation.
tools_without_swiftc() {
  mkdir -p "$1"
  for tool in bash env awk grep sed find sort tr cat cut head tail wc basename dirname mktemp rm mkdir \
    ls uniq expr od date cp mv tee xargs sh test kill sleep printf chmod cmp git uname sysctl; do
    resolved="$(command -v "$tool" 2> /dev/null || true)"
    case "$resolved" in
      /*) ln -sf "$resolved" "$1/$tool" ;;
    esac
  done
}

# --- cases ---

test_real_bundle_passes() {
  [ -d "$REAL_APP" ] || fail "no bundle at $REAL_APP — run ka-reader-mac/assemble.sh first (a missing bundle fails, never skips)" || return 1
  real_dir="$WORK/real"
  mkdir -p "$real_dir"
  "$RENDERER_SH" "$REAL_APP" > "$real_dir/stdout" 2> "$real_dir/stderr"
  STATUS=$?
  STDOUT="$(cat "$real_dir/stdout")"
  STDERR="$(cat "$real_dir/stderr")"
  expect_status 0 || return 1
  expect_stdout_contains "pid " || return 1
  expect_stdout_contains "bound" || return 1
  launched_pid="$(printf '%s' "$STDOUT" | sed -n 's/.*pid \([0-9][0-9]*\).*/\1/p' | head -1)"
  [ -n "$launched_pid" ] || fail "no pid on the pass line: $STDOUT" || return 1
  if alive "$launched_pid"; then
    fail "pid $launched_pid still names a process after the run"
    return 1
  fi
}

test_not_an_app_launches_nothing() {
  new_case not-an-app
  run_renderer /tmp/not-an-app
  expect_status 1 || return 1
  expect_stderr_contains "not-an-app" || return 1
  expect_no_open_call || return 1
  # An application bundle whose executable is missing.
  rm -f "$APP_EXE"
  run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "Contents/MacOS/KAReader" || return 1
  expect_no_open_call || return 1
  # A path that is not a .app at all.
  mkdir -p "$CASE_DIR/plain-folder"
  run_renderer "$CASE_DIR/plain-folder"
  expect_status 1 || return 1
  expect_stderr_contains "not an application bundle" || return 1
  expect_no_open_call || return 1
}

test_launch_goes_through_open() {
  new_case through-open
  pass_reports
  run_renderer "$APP"
  expect_status 0 || return 1
  # The product is the first launch. The control's is the second, and it too goes through open.
  first_call="$(head -1 "$STUBS/open_calls")"
  [ "$first_call" = "-n -g $APP" ] || fail "expected the product's launch to be 'open -n -g $APP', got: $first_call" || return 1
  calls="$(wc -l < "$STUBS/open_calls" | tr -d ' ')"
  [ "$calls" -eq 2 ] || fail "expected two open calls (the product, then the control), got $calls" || return 1
  [ ! -e "$CASE_DIR/direct_exec" ] || fail "the bundle's executable was run directly"
}

test_running_instance_refused() {
  new_case running
  running_pid="$(spawn_listed "$APP_EXE")"
  run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "$running_pid" || return 1
  # A failed observation: the run did not wait out the window, so no bound is printed (CP-144).
  expect_stderr_lacks "bound" || return 1
  expect_no_open_call || return 1
  # Refused before the control is built, not only before anything is launched.
  [ ! -e "$STUBS/swiftc_calls" ] || fail "the control was built although an instance was already running" || return 1
  alive "$running_pid" || fail "the running instance (pid $running_pid) was signalled" || return 1
}

test_two_pids_after_launch() {
  new_case two-pids
  echo two > "$STUBS/open_mode"
  run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "more than one" || return 1
  expect_stderr_lacks "bound" || return 1
  expect_sample_calls 0 || return 1
  while read -r each_pid; do
    alive "$each_pid" || fail "pid $each_pid was signalled although the run could not tell which was its own" || return 1
  done < "$STUBS/spawned"
}

test_no_pid_appears() {
  new_case no-pid
  echo none > "$STUBS/open_mode"
  RENDERER_SH_LAUNCH_TICKS=2 run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "no process appeared" || return 1
  expect_stderr_lacks "bound" || return 1
  expect_sample_calls 0 || return 1
}

test_pid_found_by_path_not_pattern() {
  new_case by-path
  pass_reports
  # Not the product: another executable whose command line names the product's path.
  namesake="$(spawn_listed "/usr/bin/other-tool" "$APP_EXE --serve")"
  run_renderer "$APP"
  expect_status 0 || return 1
  launched_pid="$(printf '%s' "$STDOUT" | sed -n 's/.*pid \([0-9][0-9]*\).*/\1/p' | head -1)"
  [ "$launched_pid" != "$namesake" ] || fail "the process that merely mentioned the bundle path was taken as the pid" || return 1
  alive "$namesake" || fail "the process that merely mentioned the bundle path was signalled" || return 1
}

test_stops_only_its_own_pid() {
  # Three endings: a pass, a window that runs out, and a failed observation. In each, another process
  # with the product's path that appears after the launch survives, and the launched one is gone.
  for ending in pass runs-out failed-observation; do
    new_case "own-pid-$ending"
    touch "$STUBS/decoy_on_first"
    case "$ending" in
      pass) pass_reports ;;
      runs-out) write_report "$STUBS/report.default" "$IDLE_FRAMES" ;;
      failed-observation)
        write_report "$STUBS/report.default" "$IDLE_FRAMES"
        echo 2 > "$STUBS/sample_fail_at"
        ;;
    esac
    RENDERER_SH_OBSERVATIONS=3 run_renderer "$APP"
    case "$ending" in
      pass) expect_status 0 || return 1 ;;
      *) expect_status 1 || return 1 ;;
    esac
    decoy_pid="$(cat "$STUBS/decoy_pid")"
    alive "$decoy_pid" || fail "$ending: the other process (pid $decoy_pid) was signalled" || return 1
    launched_pid="$(head -1 "$STUBS/spawned")"
    ! alive "$launched_pid" || fail "$ending: the launched pid $launched_pid was left running" || return 1
  done
}

# Listed last in CASES, so the stand-ins of every case the run has already made are on disk to read.
test_no_input_sent() {
  new_case no-input
  pass_reports
  run_renderer "$APP"
  expect_status 0 || return 1
  [ ! -e "$STUBS/input_calls" ] || fail "an input tool was called: $(cat "$STUBS/input_calls")" || return 1
  # Across every stand-in case of this run, not only this one: no input tool recorded a call.
  for input_log in "$WORK"/*/stubs/input_calls; do
    [ -e "$input_log" ] || continue
    fail "an input tool was called in $(basename "$(dirname "$(dirname "$input_log")")"): $(cat "$input_log")" || return 1
  done
  # The script reads nothing the product wrote: no path under its container, in any line of code.
  code_lines="$(grep -v '^[[:space:]]*#' "$RENDERER_SH" || true)"
  case "$code_lines" in
    *Containers* | *osascript* | *cliclick*) fail "the script names a container path or an input tool in code" ;;
  esac
}

test_sample_writes_only_into_the_run_directory() {
  new_case run-directory
  write_report "$STUBS/report.default" "$IDLE_FRAMES"
  write_report "$STUBS/report.3" "$FULL_FRAMES"
  # Three observations of the product, which passes on the third, then three of the control.
  export RENDERER_SH_OBSERVATIONS=3
  run_dir_parent="$CASE_DIR/tmp"
  mkdir -p "$run_dir_parent"
  run_dir_parent="$(cd "$run_dir_parent" && pwd -P)"
  TMPDIR="$run_dir_parent" run_renderer "$APP"
  expect_status 0 || return 1
  expect_sample_calls 6 || return 1
  while read -r call; do
    case "$call" in
      *" -file $run_dir_parent/"*) ;;
      *) fail "a sample call has no -file under the run's temporary directory: $call" || return 1 ;;
    esac
  done < "$STUBS/sample_calls"
  leftover="$(ls -A "$run_dir_parent")"
  [ -z "$leftover" ] || fail "the run's temporary directory was not removed: $leftover"
}

test_first_matching_observation_passes() {
  new_case first-match
  write_report "$STUBS/report.1" "$IDLE_FRAMES"
  write_report "$STUBS/report.2" "$LAUNCH_FRAMES"
  write_report "$STUBS/report.3" "$FULL_FRAMES"
  write_report "$STUBS/report.default" "$IDLE_FRAMES"
  RENDERER_SH_OBSERVATIONS=10 run_renderer "$APP"
  expect_status 0 || return 1
  # The product's own line names the observation it passed on; the control then takes ten more samples.
  product_line="$(printf '%s\n' "$STDOUT" | head -1)"
  case "$product_line" in
    *"observation 3 "*) ;;
    *) fail "expected the product to pass on observation 3, got: $product_line" || return 1 ;;
  esac
  expect_sample_calls 13 || return 1
  expect_stdout_contains "10" || return 1
}

test_frames_on_another_thread_do_not_count() {
  new_case other-thread
  write_report "$STUBS/report.default" "$IDLE_FRAMES" "com.apple.NSEventThread  (serial)" "$FULL_FRAMES"
  RENDERER_SH_OBSERVATIONS=3 run_renderer "$APP"
  expect_status 1 || return 1
  expect_sample_calls 3 || return 1
  expect_stderr_contains "never observed" || return 1
}

test_main_thread_under_its_early_label_counts() {
  new_case early-label
  # Until the main queue is up, sample labels the main thread "Main Thread" and not
  # com.apple.main-thread. A launch observed that early is not a failed observation, and its frames
  # are the main thread's.
  MAIN_HEADER=": Main Thread   DispatchQueue_<multiple>" write_report "$STUBS/report.1" "$IDLE_FRAMES"
  MAIN_HEADER=": Main Thread   DispatchQueue_<multiple>" write_report "$STUBS/report.2" "$FULL_FRAMES"
  write_report "$STUBS/report.default" "$IDLE_FRAMES"
  RENDERER_SH_OBSERVATIONS=5 run_renderer "$APP"
  expect_status 0 || return 1
  # The product passes on the second observation, after the first was read under the early label; the
  # control then takes its five.
  product_line="$(printf '%s\n' "$STDOUT" | head -1)"
  case "$product_line" in
    *"observation 2 "*) ;;
    *) fail "expected the product to pass on observation 2, got: $product_line" || return 1 ;;
  esac
  expect_sample_calls 7 || return 1
}

test_frames_out_of_order_do_not_count() {
  new_case out-of-order
  # The panel's frames hang off a sibling of AppDelegate.applicationDidFinishLaunching(_:), not off it.
  write_report "$STUBS/report.default" "$LAUNCH_FRAMES
5 OpenFolderPanel.chooseFolder()
6 -[NSSavePanel runModal]
7 -[NSApplication runModalForWindow:]"
  RENDERER_SH_OBSERVATIONS=3 run_renderer "$APP"
  expect_status 1 || return 1
  expect_sample_calls 3 || return 1
  expect_stderr_contains "never observed" || return 1
}

test_generic_modal_alone_does_not_count() {
  new_case generic-modal
  write_report "$STUBS/report.default" "$LAUNCH_FRAMES
6 -[NSApplication runModalForWindow:]
7 _NSTryRunModal"
  RENDERER_SH_OBSERVATIONS=3 run_renderer "$APP"
  expect_status 1 || return 1
  expect_sample_calls 3 || return 1
  expect_stderr_contains "never observed" || return 1
}

test_panel_without_shell_frames_does_not_count() {
  new_case panel-alone
  write_report "$STUBS/report.default" "1 start
2 main
3 -[NSApplication run]
4 -[NSSavePanel runModal]
5 -[NSApplication runModalForWindow:]"
  RENDERER_SH_OBSERVATIONS=3 run_renderer "$APP"
  expect_status 1 || return 1
  expect_sample_calls 3 || return 1
  expect_stderr_contains "never observed" || return 1
}

test_near_frame_names_do_not_count() {
  new_case near-names
  # "specialized OpenFolderPanel.chooseFolder()" is not OpenFolderPanel.chooseFolder(): a frame is its
  # whole symbol, not a part of one, so a containing symbol does not advance the match.
  write_report "$STUBS/report.default" "1 start
2 main
3 -[NSApplication run]
4 AppDelegate.applicationDidFinishLaunching(_:)
5 specialized OpenFolderPanel.chooseFolder()
6 -[NSSavePanel runModal]
7 -[NSApplication runModalForWindow:]"
  RENDERER_SH_OBSERVATIONS=3 run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "never observed" || return 1
}

test_tree_characters_carry_no_meaning() {
  new_case tree-characters
  for mark in '|' ':' '!'; do
    rm -f "$STUBS/sample_count" "$STUBS/sample_calls"
    TREE_MARK="$mark" write_report "$STUBS/report.1" "$FULL_FRAMES"
    write_report "$STUBS/report.default" "$IDLE_FRAMES"
    RENDERER_SH_OBSERVATIONS=2 run_renderer "$APP"
    expect_status 0 || return 1
    # Each run starts its own process; stop it so the next run's "already running" check is clean.
    rm -f "$STUBS/ps_table" "$STUBS/spawned"
  done
}

test_pid_gone_fails_at_once() {
  new_case pid-gone
  write_report "$STUBS/report.default" "$IDLE_FRAMES"
  echo 1 > "$STUBS/kill_after"
  RENDERER_SH_OBSERVATIONS=5 run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "no longer names a process" || return 1
  expect_stderr_lacks "bound" || return 1
  expect_sample_calls 1 || return 1
}

test_sample_error_fails_at_once() {
  new_case sample-error
  write_report "$STUBS/report.default" "$IDLE_FRAMES"
  echo 1 > "$STUBS/sample_fail_at"
  RENDERER_SH_OBSERVATIONS=5 run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "cannot examine process" || return 1
  expect_stderr_lacks "bound" || return 1
  expect_sample_calls 1 || return 1
  # A report with no main-thread block is a failed observation too.
  new_case no-main-thread
  {
    echo "Call graph:"
    echo "    867 Thread_2: com.apple.NSEventThread  (serial)"
    frame_line 1 "start"
    echo ""
    echo "Total number in stack (recursive counted multiple, when >=5):"
  } > "$STUBS/report.default"
  RENDERER_SH_OBSERVATIONS=5 run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "main-thread" || return 1
  expect_stderr_lacks "bound" || return 1
  expect_sample_calls 1 || return 1
}

test_sample_writing_no_report_fails_at_once() {
  new_case no-report
  # The product passes on the first sample. The control's first sample writes no file at all, and the
  # product's report must not be taken for it.
  write_report "$STUBS/report.1" "$FULL_FRAMES"
  RENDERER_SH_OBSERVATIONS=5 run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "wrote no report" || return 1
  expect_stderr_lacks "bound" || return 1
  expect_sample_calls 2 || return 1
}

test_window_runs_out() {
  new_case window-runs-out
  write_report "$STUBS/report.default" "$IDLE_FRAMES
5 LastFrameMarker"
  RENDERER_SH_OBSERVATIONS=4 run_renderer "$APP"
  expect_status 1 || return 1
  expect_sample_calls 4 || return 1
  launched_pid="$(head -1 "$STUBS/spawned")"
  expect_stderr_contains "$launched_pid" || return 1
  expect_stderr_contains "never observed" || return 1
  expect_stderr_contains "bound" || return 1
  expect_stderr_contains "4" || return 1
  expect_stderr_contains "LastFrameMarker" || return 1
}

test_pass_line_on_stdout_failures_on_stderr() {
  new_case streams-pass
  pass_reports
  run_renderer "$APP"
  expect_status 0 || return 1
  [ -z "$STDERR" ] || fail "expected empty stderr on a pass, got: $STDERR" || return 1
  lines="$(printf '%s\n' "$STDOUT" | wc -l | tr -d ' ')"
  [ "$lines" -eq 2 ] || fail "expected two stdout lines on a pass (the product's, then the control's), got $lines: $STDOUT" || return 1
  new_case streams-runs-out
  write_report "$STUBS/report.default" "$IDLE_FRAMES"
  RENDERER_SH_OBSERVATIONS=2 run_renderer "$APP"
  expect_status 1 || return 1
  [ -z "$STDOUT" ] || fail "expected no stdout when the window runs out, got: $STDOUT" || return 1
  [ -n "$STDERR" ] || fail "expected the verdict on stderr" || return 1
  new_case streams-failed-observation
  write_report "$STUBS/report.default" "$IDLE_FRAMES"
  echo 1 > "$STUBS/sample_fail_at"
  run_renderer "$APP"
  expect_status 1 || return 1
  [ -z "$STDOUT" ] || fail "expected no stdout on a failed observation, got: $STDOUT" || return 1
  [ -n "$STDERR" ] || fail "expected the verdict on stderr" || return 1
}

test_header_names_frames_and_the_mac_reading() {
  # The list is read from the script's own definition of it, never from a copy here.
  frame_list="$(awk '/^FRAME_LIST="/ { listing = 1; sub(/^FRAME_LIST="/, "") }
    listing { line = $0; closing = (line ~ /"$/); sub(/"$/, "", line); if (line != "") print line; if (closing) exit }' "$RENDERER_SH")"
  [ -n "$frame_list" ] || fail "no FRAME_LIST found in the script" || return 1
  header="$(awk '/^set -/ { exit } { print }' "$RENDERER_SH")"
  count=0
  while IFS= read -r frame; do
    [ -n "$frame" ] || continue
    count=$((count + 1))
    case "$header" in
      *"$frame"*) ;;
      *) fail "the header does not name the frame: $frame" || return 1 ;;
    esac
  done <<< "$frame_list"
  [ "$count" -ge 2 ] || fail "the frame list holds $count frame(s); it must hold the shell's launch frames and the panel's" || return 1
  case "$frame_list" in
    *ka_reader_open_folder*) fail "ka_reader_open_folder is in the frame list" || return 1 ;;
  esac
  printf '%s\n' "$header" | grep -Eq 'macOS [0-9]+\.[0-9]+' \
    || fail "the header names no macOS version for the Mac reading" || return 1
}

test_header_names_the_runner_reading() {
  # The hosted runner's reading is recorded in the header: a GitHub Actions run id (all digits) beside
  # the words that label it, and the runner image that run names. Read from the script, not a copy.
  header="$(awk '/^set -/ { exit } { print }' "$RENDERER_SH")"
  printf '%s\n' "$header" | grep -Eqi 'hosted runner.*run [0-9]+|run [0-9]+.*hosted runner' \
    || fail "the header carries no GitHub Actions run id labelled as the hosted runner's reading" || return 1
  printf '%s\n' "$header" | grep -Eq 'macos-[0-9]+' \
    || fail "the header names no runner image for the hosted runner's reading" || return 1
  printf '%s\n' "$header" | grep -Eq 'macOS [0-9]+\.[0-9]+' \
    || fail "the header names no macOS version for the Mac reading beside it" || return 1
}

test_bound_override_validated() {
  new_case bound-override
  write_report "$STUBS/report.default" "$FULL_FRAMES"
  for bad in 0 x -1 1.5; do
    RENDERER_SH_OBSERVATIONS="$bad" run_renderer "$APP"
    expect_status 1 || return 1
    expect_stderr_contains "RENDERER_SH_OBSERVATIONS" || return 1
    RENDERER_SH_LAUNCH_TICKS="$bad" run_renderer "$APP"
    expect_status 1 || return 1
    expect_stderr_contains "RENDERER_SH_LAUNCH_TICKS" || return 1
  done
  expect_no_open_call || return 1
  # A leading zero is read as base 10: 08 is eight, and the run says so.
  write_report "$STUBS/report.default" "$IDLE_FRAMES"
  RENDERER_SH_OBSERVATIONS=08 run_renderer "$APP"
  expect_status 1 || return 1
  expect_sample_calls 8 || return 1
  # An empty value reads as unset.
  new_case bound-empty
  pass_reports
  RENDERER_SH_OBSERVATIONS="" RENDERER_SH_LAUNCH_TICKS="" run_renderer "$APP"
  expect_status 0 || return 1
}

# The number after "bound: " on a line of output.
bound_of() {
  printf '%s\n' "$1" | sed -n 's/.*bound: \([0-9][0-9]*\) observations.*/\1/p' | head -1
}

test_real_bundle_passes_with_its_control() {
  [ -d "$REAL_APP" ] || fail "no bundle at $REAL_APP — run ka-reader-mac/assemble.sh first (a missing bundle fails, never skips)" || return 1
  real_dir="$WORK/real-control"
  mkdir -p "$real_dir"
  "$RENDERER_SH" "$REAL_APP" > "$real_dir/stdout" 2> "$real_dir/stderr"
  STATUS=$?
  STDOUT="$(cat "$real_dir/stdout")"
  STDERR="$(cat "$real_dir/stderr")"
  expect_status 0 || return 1
  lines="$(printf '%s\n' "$STDOUT" | wc -l | tr -d ' ')"
  [ "$lines" -eq 2 ] || fail "expected two stdout lines, got $lines: $STDOUT" || return 1
  product_line="$(printf '%s\n' "$STDOUT" | sed -n 1p)"
  control_line="$(printf '%s\n' "$STDOUT" | sed -n 2p)"
  case "$control_line" in
    *control*) ;;
    *) fail "the second line is not the control's: $control_line" || return 1 ;;
  esac
  [ -n "$(bound_of "$product_line")" ] && [ "$(bound_of "$product_line")" = "$(bound_of "$control_line")" ] \
    || fail "the two lines do not carry the same bound: $STDOUT" || return 1
  for line in "$product_line" "$control_line"; do
    each_pid="$(printf '%s' "$line" | sed -n 's/.*pid \([0-9][0-9]*\).*/\1/p' | head -1)"
    [ -n "$each_pid" ] || fail "no pid on the line: $line" || return 1
    if alive "$each_pid"; then
      fail "pid $each_pid still names a process after the run"
      return 1
    fi
  done
  [ -z "$(git -C "$ROOT" status --porcelain -- checks/fixtures)" ] \
    || fail "the run left something under checks/fixtures: $(git -C "$ROOT" status --porcelain -- checks/fixtures)"
}

test_control_set_must_equal_product_set() {
  new_case set-differs
  pass_reports
  set_entitlements "$STUBS/control_override.xml" '<key>com.apple.security.app-sandbox</key><true/>'
  run_renderer "$APP"
  expect_status 1 || return 1
  expect_no_open_call || return 1
  expect_stderr_contains "control" || return 1
  expect_stderr_contains "product" || return 1
  # Both sets are printed: the read-only entitlement is in the product's alone, the sandbox in both.
  read_only_lines="$(printf '%s\n' "$STDERR" | grep -c 'com.apple.security.files.user-selected.read-only')"
  sandbox_lines="$(printf '%s\n' "$STDERR" | grep -c 'com.apple.security.app-sandbox')"
  [ "$read_only_lines" -eq 1 ] && [ "$sandbox_lines" -eq 2 ] \
    || fail "expected both sets printed (read-only once, sandbox twice), got $read_only_lines and $sandbox_lines. stderr: $STDERR" || return 1
}

test_control_signed_ad_hoc_with_the_hardened_runtime() {
  new_case signing
  pass_reports
  run_renderer "$APP"
  expect_status 0 || return 1
  [ -s "$STUBS/signing_call" ] || fail "no signing call was made" || return 1
  signing_call=" $(cat "$STUBS/signing_call") "
  for wanted in " --sign - " " --options runtime " " --entitlements "; do
    case "$signing_call" in
      *"$wanted"*) ;;
      *) fail "the signing call lacks '$wanted': $signing_call" || return 1 ;;
    esac
  done
  case "$signing_call" in
    *"idle-shell.app "*) ;;
    *) fail "the signing call is not on the control: $signing_call" || return 1 ;;
  esac
  cmp -s "$STUBS/signed_with.xml" "$STUBS/product_entitlements.xml" \
    || fail "the entitlements file the control was signed with is not the set read from the product's signature" || return 1
  # The control that was signed is the layout the gate launches: the compiled executable and the
  # fixture's own Info.plist, and nothing else.
  layout="$(tr '\n' ' ' < "$STUBS/signed_layout")"
  [ "$layout" = "./Contents/Info.plist ./Contents/MacOS/idle-shell " ] \
    || fail "the signed control's layout is: $layout" || return 1
  cmp -s "$STUBS/signed_info_plist" "$ROOT/checks/fixtures/idle-shell/Info.plist" \
    || fail "the signed control's Info.plist is not the fixture's" || return 1
}

test_product_signature_unreadable_fails_before_any_launch() {
  new_case product-unreadable
  pass_reports
  touch "$STUBS/product_unreadable"
  run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "entitlements" || return 1
  expect_no_open_call || return 1
  # A signature that carries no entitlements at all leaves nothing to sign the control with.
  rm -f "$STUBS/product_unreadable"
  : > "$STUBS/product_entitlements.xml"
  run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "empty" || return 1
  expect_no_open_call || return 1
}

test_swiftc_absent_fails_before_any_launch() {
  new_case no-swiftc
  pass_reports
  rm -f "$STUBS/swiftc"
  tools_without_swiftc "$CASE_DIR/tools"
  run_renderer_with_path "$STUBS:$CASE_DIR/tools" "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "swiftc not found on PATH" || return 1
  expect_no_open_call || return 1
}

test_product_half_alone_is_not_a_pass() {
  new_case product-alone
  pass_reports
  touch "$STUBS/swiftc_fails"
  run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "control" || return 1
  expect_no_open_call || return 1
  expect_sample_calls 0 || return 1
  [ -z "$STDOUT" ] || fail "expected no stdout when the control cannot be built, got: $STDOUT"
}

test_product_stopped_before_the_control_launches() {
  new_case product-first
  pass_reports
  run_renderer "$APP"
  expect_status 0 || return 1
  grep -q '^open 2: first pid [0-9]* stopped$' "$STUBS/events" \
    || fail "the product's pid was not stopped before the control's open call. events: $(cat "$STUBS/events" 2> /dev/null)"
}

test_control_pid_not_found_once_fails() {
  new_case control-no-pid
  pass_reports
  echo none > "$STUBS/open_mode.2"
  RENDERER_SH_LAUNCH_TICKS=2 run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "no process appeared" || return 1
  new_case control-two-pids
  pass_reports
  echo two > "$STUBS/open_mode.2"
  run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "more than one" || return 1
  # The first spawned pid is the product's, stopped by its own half; the other two are the control's.
  sed -n '2,$p' "$STUBS/spawned" | while read -r control_pid; do
    alive "$control_pid" || exit 1
  done || fail "a control pid was signalled although the run could not tell which was its own" || return 1
}

test_control_crash_is_not_a_red() {
  new_case control-crash
  pass_reports
  echo 3 > "$STUBS/kill_after"
  RENDERER_SH_OBSERVATIONS=4 run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "no longer names a process" || return 1
  [ -z "$STDOUT" ] || fail "expected no stdout when the control dies, got: $STDOUT"
}

test_control_at_the_panel_fails() {
  new_case control-at-panel
  write_report "$STUBS/report.1" "$FULL_FRAMES"
  write_report "$STUBS/report.2" "$FULL_FRAMES"
  write_report "$STUBS/report.default" "$IDLE_FRAMES"
  RENDERER_SH_OBSERVATIONS=5 run_renderer "$APP"
  expect_status 1 || return 1
  expect_sample_calls 2 || return 1
  expect_stderr_contains "control" || return 1
  expect_stderr_contains "Open panel" || return 1
  [ -z "$STDOUT" ] || fail "expected no stdout when the control matches, got: $STDOUT"
}

test_control_line_states_the_bound() {
  new_case control-bound-default
  pass_reports
  run_renderer "$APP"
  expect_status 0 || return 1
  product_line="$(printf '%s\n' "$STDOUT" | sed -n 1p)"
  control_line="$(printf '%s\n' "$STDOUT" | sed -n 2p)"
  [ "$(bound_of "$control_line")" = "30" ] && [ "$(bound_of "$product_line")" = "30" ] \
    || fail "expected both lines to state a bound of 30, got: $STDOUT" || return 1
  new_case control-bound-override
  pass_reports
  RENDERER_SH_OBSERVATIONS=7 run_renderer "$APP"
  expect_status 0 || return 1
  product_line="$(printf '%s\n' "$STDOUT" | sed -n 1p)"
  control_line="$(printf '%s\n' "$STDOUT" | sed -n 2p)"
  [ "$(bound_of "$control_line")" = "7" ] && [ "$(bound_of "$product_line")" = "7" ] \
    || fail "expected both lines to state a bound of 7, got: $STDOUT" || return 1
}

test_nothing_written_under_fixtures() {
  new_case fixtures-clean
  pass_reports
  run_renderer "$APP"
  expect_status 0 || return 1
  dirty="$(git -C "$ROOT" status --porcelain -- checks/fixtures)"
  [ -z "$dirty" ] || fail "the run left something under checks/fixtures: $dirty" || return 1
  held="$(ls -A "$ROOT/checks/fixtures/idle-shell" | tr '\n' ' ')"
  [ "$held" = "Info.plist main.swift " ] || fail "checks/fixtures/idle-shell holds: $held" || return 1
}

test_no_checks_file_matches_a_bundle_file() {
  [ -d "$REAL_APP" ] || fail "no bundle at $REAL_APP — run ka-reader-mac/assemble.sh first (a missing bundle fails, never skips)" || return 1
  bundle_hashes="$(find "$REAL_APP/Contents" -type f -exec shasum -a 256 {} + | awk '{ print $1 }' | LC_ALL=C sort -u)"
  [ -n "$bundle_hashes" ] || fail "the bundle holds no file" || return 1
  tracked="$(git -C "$ROOT" ls-files checks)"
  [ -n "$tracked" ] || fail "no file is tracked under checks/" || return 1
  while IFS= read -r tracked_file; do
    candidate="$ROOT/$tracked_file"
    [ -f "$candidate" ] && [ ! -L "$candidate" ] && [ -s "$candidate" ] || continue
    candidate_hash="$(shasum -a 256 "$candidate" | awk '{ print $1 }')"
    case "
$bundle_hashes
" in
      *"
$candidate_hash
"*) fail "$tracked_file has the same bytes as a file in the bundle" || return 1 ;;
    esac
  done <<< "$tracked"
}

# QC-65 (CP-797, CP-798, CP-799): off a macOS virtual machine renderer.sh prints its one refusal line and
# does nothing else — no launch, no fixture read, no control compiled — whatever it is given. The matrix
# and the traced run are the shared helper's; the apps and inputs below are the ones renderer.sh reads.
test_refuses_off_vm_before_work() {
  new_case refusal
  VMR_TMP="$WORK"
  scene="$WORK/refusal-scene"
  mkdir -p "$scene/plain" "$scene/wrong.app/Contents"
  VMR_SCENE="$scene"
  VMR_ENV=()

  vmr_assert_refusal "$RENDERER_SH" renderer.sh || return 1
  vmr_assert_refusal "$RENDERER_SH" renderer.sh /nonexistent || return 1
  vmr_assert_refusal "$RENDERER_SH" renderer.sh "$scene/plain" || return 1
  vmr_assert_refusal "$RENDERER_SH" renderer.sh "$scene/wrong.app" || return 1
  vmr_assert_refusal "$RENDERER_SH" renderer.sh "$APP" || return 1
  for value in 1 0 abc ""; do
    VMR_ENV=("RENDERER_SH_OBSERVATIONS=$value" "RENDERER_SH_LAUNCH_TICKS=$value")
    vmr_assert_refusal "$RENDERER_SH" renderer.sh "$APP" || return 1
    vmr_assert_refusal "$RENDERER_SH" renderer.sh "$scene/wrong.app" || return 1
  done
}

# CP-798/CP-800: on a virtual machine's reading the admission adds no line and changes no verdict — an
# ordinary pass run passes and prints no refusal.
test_admits_on_a_vm_reading() {
  new_case admits
  pass_reports
  vmr_install_admission "$STUBS"
  run_renderer "$APP"
  expect_status 0 || return 1
  expect_stderr_lacks "refused" || return 1
  expect_stdout_contains "observation 1 " || return 1
}

# --- runner ---

cleanup() {
  stop_all_spawned
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
  echo "test_renderer.sh: $failed case(s) failed" >&2
  exit 1
fi

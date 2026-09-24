#!/usr/bin/env bash
# Version: 1.0.0 — first version: drives the real checks/renderer.sh over stand-in ps, open and sample, and over the real bundle
#
# checks/tests/test_renderer.sh — the tests of checks/renderer.sh.
#
# WHY THIS EXISTS
#   checks/renderer.sh is the proof that the shipped shell reaches the Open panel, so a bug in it is a
#   wall nobody is watching. These cases run the real script — never a copy of its logic. `ps`, `open`
#   and `sample` are stood in on PATH, the seams the script has. The pids are real processes (`sleep`),
#   started and stopped by pid, because the script asks the operating system whether a pid still names
#   a process and signals it.
#   The technique is the shell packet's, minus its runner: this product has no Python, so the runner
#   is this file, as in checks/tests/test_bundle.sh.
#
# USAGE
#   checks/tests/test_renderer.sh
#   The real-bundle case launches target/release/bundle/macos/Nozoki.app and samples it, so run
#   nozoki-mac/assemble.sh first and run this in a logged-in GUI session. A bundle that is absent FAILS
#   that case with a stated message and never skips it: a skip would let CI conclude green having
#   proved nothing.
#   NOZOKI_TEST_ONLY=<case> runs one case.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
RENDERER_SH="$ROOT/checks/renderer.sh"
REAL_APP="$ROOT/target/release/bundle/macos/Nozoki.app"

STDOUT=""
STDERR=""
STATUS=0
WORK="$(mktemp -d)"
CASE_COUNTER=0

CASES="
test_real_bundle_passes
test_not_an_app_launches_nothing
test_launch_goes_through_open
test_running_instance_refused
test_two_pids_after_launch
test_no_pid_appears
test_pid_found_by_path_not_pattern
test_stops_only_its_own_pid
test_no_input_sent
test_sample_writes_only_into_the_run_directory
test_first_matching_observation_passes
test_frames_on_another_thread_do_not_count
test_frames_out_of_order_do_not_count
test_generic_modal_alone_does_not_count
test_panel_without_shell_frames_does_not_count
test_near_frame_names_do_not_count
test_tree_characters_carry_no_meaning
test_pid_gone_fails_at_once
test_sample_error_fails_at_once
test_window_runs_out
test_pass_line_on_stdout_failures_on_stderr
test_header_names_frames_and_the_mac_reading
test_bound_override_validated
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
  app_dir="$WORK/$1/app/Nozoki.app"
  mkdir -p "$app_dir/Contents/MacOS"
  cat > "$app_dir/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict><key>CFBundleExecutable</key><string>Nozoki</string></dict></plist>
PLIST
  printf '#!/bin/sh\necho direct > "%s/direct_exec"\n' "$WORK/$1" > "$app_dir/Contents/MacOS/Nozoki"
  chmod +x "$app_dir/Contents/MacOS/Nozoki"
  printf '%s' "$app_dir"
}

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
executable="$last_argument/Contents/MacOS/Nozoki"
echo "$executable" > "$STUB/exe_path"
spawn() {
  spawned_pid="$( (sleep 300 > /dev/null 2>&1 & echo $!) )"
  echo "$spawned_pid $executable" >> "$STUB/ps_table"
  echo "$spawned_pid" >> "$STUB/spawned"
}
case "$(cat "$STUB/open_mode" 2> /dev/null || echo one)" in
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
  APP_EXE="$APP/Contents/MacOS/Nozoki"
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
  printf '    %s%*s867 %s  (in Nozoki) + 100  [0x100c05644]\n' "${3:-+}" $((2 * $1 - 1)) '' "$2"
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
    echo "Analysis of sampling Nozoki (pid 4242) every 1 millisecond"
    echo "Process:         Nozoki [4242]"
    echo ""
    echo "Call graph:"
    echo "    867 Thread_1   DispatchQueue_1: com.apple.main-thread  (serial)"
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
5 AppDelegate.applicationDidFinishLaunching(_:)
6 LaunchFlow.run()"

FULL_FRAMES="$LAUNCH_FRAMES
7 OpenFolderPanel.chooseFolder()
8 -[NSSavePanel runModal]
9 -[NSApplication runModalForWindow:]
10 _NSTryRunModal"

IDLE_FRAMES="1 start
2 main
3 -[NSApplication run]
4 _DPSNextEvent"

# --- cases ---

test_real_bundle_passes() {
  [ -d "$REAL_APP" ] || fail "no bundle at $REAL_APP — run nozoki-mac/assemble.sh first (a missing bundle fails, never skips)" || return 1
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
  expect_stderr_contains "Contents/MacOS/Nozoki" || return 1
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
  write_report "$STUBS/report.default" "$FULL_FRAMES"
  run_renderer "$APP"
  expect_status 0 || return 1
  calls="$(cat "$STUBS/open_calls")"
  [ "$calls" = "-n -g $APP" ] || fail "expected exactly one open call '-n -g $APP', got: $calls" || return 1
  [ ! -e "$CASE_DIR/direct_exec" ] || fail "the bundle's executable was run directly"
}

test_running_instance_refused() {
  new_case running
  running_pid="$(spawn_listed "$APP_EXE")"
  run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "$running_pid" || return 1
  expect_no_open_call || return 1
  alive "$running_pid" || fail "the running instance (pid $running_pid) was signalled" || return 1
}

test_two_pids_after_launch() {
  new_case two-pids
  echo two > "$STUBS/open_mode"
  run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "more than one" || return 1
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
  write_report "$STUBS/report.default" "$FULL_FRAMES"
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
      pass) write_report "$STUBS/report.default" "$FULL_FRAMES" ;;
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

test_no_input_sent() {
  new_case no-input
  write_report "$STUBS/report.default" "$FULL_FRAMES"
  run_renderer "$APP"
  expect_status 0 || return 1
  [ ! -e "$STUBS/input_calls" ] || fail "an input tool was called: $(cat "$STUBS/input_calls")" || return 1
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
  run_dir_parent="$CASE_DIR/tmp"
  mkdir -p "$run_dir_parent"
  run_dir_parent="$(cd "$run_dir_parent" && pwd -P)"
  TMPDIR="$run_dir_parent" run_renderer "$APP"
  expect_status 0 || return 1
  expect_sample_calls 3 || return 1
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
  RENDERER_SH_OBSERVATIONS=10 run_renderer "$APP"
  expect_status 0 || return 1
  expect_sample_calls 3 || return 1
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

test_frames_out_of_order_do_not_count() {
  new_case out-of-order
  # The panel's frames hang off a sibling of LaunchFlow.run(), not off it.
  write_report "$STUBS/report.default" "$LAUNCH_FRAMES
6 OpenFolderPanel.chooseFolder()
7 -[NSSavePanel runModal]
8 -[NSApplication runModalForWindow:]"
  RENDERER_SH_OBSERVATIONS=3 run_renderer "$APP"
  expect_status 1 || return 1
  expect_sample_calls 3 || return 1
  expect_stderr_contains "never observed" || return 1
}

test_generic_modal_alone_does_not_count() {
  new_case generic-modal
  write_report "$STUBS/report.default" "$LAUNCH_FRAMES
7 -[NSApplication runModalForWindow:]
8 _NSTryRunModal"
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
  # LaunchFlow.runAgain() is not LaunchFlow.run(): a frame is its whole symbol, not a substring.
  write_report "$STUBS/report.default" "1 start
2 main
3 -[NSApplication run]
4 AppDelegate.applicationDidFinishLaunching(_:)
5 LaunchFlow.runAgain()
6 OpenFolderPanel.chooseFolder()
7 -[NSSavePanel runModal]
8 -[NSApplication runModalForWindow:]"
  RENDERER_SH_OBSERVATIONS=3 run_renderer "$APP"
  expect_status 1 || return 1
  expect_stderr_contains "never observed" || return 1
}

test_tree_characters_carry_no_meaning() {
  new_case tree-characters
  for mark in '|' ':' '!'; do
    rm -f "$STUBS/sample_count" "$STUBS/sample_calls"
    TREE_MARK="$mark" write_report "$STUBS/report.default" "$FULL_FRAMES"
    run_renderer "$APP"
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
  write_report "$STUBS/report.default" "$FULL_FRAMES"
  run_renderer "$APP"
  expect_status 0 || return 1
  [ -z "$STDERR" ] || fail "expected empty stderr on a pass, got: $STDERR" || return 1
  lines="$(printf '%s\n' "$STDOUT" | wc -l | tr -d ' ')"
  [ "$lines" -eq 1 ] || fail "expected one stdout line on a pass, got $lines: $STDOUT" || return 1
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
    *nozoki_open_folder*) fail "nozoki_open_folder is in the frame list" || return 1 ;;
  esac
  printf '%s\n' "$header" | grep -Eq 'macOS [0-9]+\.[0-9]+' \
    || fail "the header names no macOS version for the Mac reading" || return 1
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
  write_report "$STUBS/report.default" "$FULL_FRAMES"
  RENDERER_SH_OBSERVATIONS="" RENDERER_SH_LAUNCH_TICKS="" run_renderer "$APP"
  expect_status 0 || return 1
}

# --- runner ---

cleanup() {
  stop_all_spawned
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
  echo "test_renderer.sh: $failed case(s) failed" >&2
  exit 1
fi

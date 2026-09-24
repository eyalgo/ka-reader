#!/usr/bin/env bash
# Version: 1.0.0 — first version: the renderer gate's product half — the bundle is launched and its main thread observed at the Open panel, inside the shell's launch frames
#
# checks/renderer.sh <path-to-app> — proves the shipped Nozoki.app reaches the Open panel.
#
# WHY THIS EXISTS
#   The wall proof (checks/bundle.sh) shows the launched process is sandboxed. It cannot show that the
#   shell then reaches the folder-choosing panel, which is the shell's first and only unconditional
#   act (nozoki-mac/Sources/Shell/LaunchFlow.swift). A shell that never reaches the panel is an empty
#   window, and every other check still passes on it. This launches the built bundle the way a user
#   does and reads the operating system's own view of the process: a thread sample of the main thread.
#   It sends no input. It reads nothing the product writes, and nothing in the product exists for
#   this gate: the panel's modal run is what the shell does anyway.
#
# USAGE
#   checks/renderer.sh target/release/bundle/macos/Nozoki.app
#   Run it in a logged-in GUI session: LaunchServices must be able to start the application.
#   RENDERER_SH_OBSERVATIONS   the bound: how many observations, of about 1 s each (default 30)
#   RENDERER_SH_LAUNCH_TICKS   how long to wait for the launched process, in 0.25 s ticks (default 80)
#   Each is a positive whole number, read in base 10, and is refused before anything is launched. They
#   set this harness's timing; they are not what is observed, and CI sets neither.
#   Exit 0 only when an observation shows the frames below. Every other ending is exit 1:
#     - the window of observations runs out: stderr names the pid, says it was never observed at the
#       panel, states the bound, and prints the last observation's main-thread frames;
#     - an observation fails (the pid is gone, sample errors, the report has no main-thread block): it
#       ends the run at once, names what failed, and prints no bound, since none was reached.
#   On every exit path the one process this run launched, and recorded, is stopped — and only that one.
#
# THE FRAMES
#   One ordered list, outermost first. A match needs every frame of it in the main-thread block of the
#   report — the block sample labels com.apple.main-thread, or Main Thread while the main queue is
#   not yet up (a sample taken at the launch's first moments, measured on this Mac) — each nested strictly deeper than the one
#   before and inside its subtree, read from sample's own indentation; its tree characters + | : ! mean
#   nothing. A frame is its whole symbol, not a part of one. The list holds the shell's own launch
#   frames and the Open panel's own modal run, and a generic -[NSApplication runModalForWindow:] alone
#   is not a match, since any alert shows it. nozoki_open_folder is not in the list: the native shell
#   calls it only after the panel returns.
#     AppDelegate.applicationDidFinishLaunching(_:)
#     LaunchFlow.run()
#     OpenFolderPanel.chooseFolder()
#     -[NSSavePanel runModal]
#     -[NSApplication runModalForWindow:]
#   Mac reading (CP-145): macOS 26.6.2 (sw_vers -productVersion), a release bundle from
#   nozoki-mac/assemble.sh launched by open -n -g and sampled while the panel was up. The main thread
#   showed start, main, -[NSApplication run], the launch-notification frames, then the five frames
#   above nested in that order, then _NSTryRunModal.
#
# HOW THE OPERATING SYSTEM IS ASKED
#   `ps`, `open` and `sample` are found through PATH — the seams a test stands its own in for. The
#   process is launched through LaunchServices (open -n -g), the route a user takes; a direct exec would
#   test a path no user takes. It is found by its absolute executable path, never by a pattern over
#   command lines, which would also match every process that merely mentions the bundle. sample runs as
#   the invoking user, with -file into this run's temporary directory: without -file it also writes each
#   report to /tmp.

set -euo pipefail

die() { echo "renderer.sh: $*" >&2; exit 1; }

FRAME_LIST="AppDelegate.applicationDidFinishLaunching(_:)
LaunchFlow.run()
OpenFolderPanel.chooseFolder()
-[NSSavePanel runModal]
-[NSApplication runModalForWindow:]
"

STOP_POLL_TICKS=20     # of 0.25 s: 5 s for the launched process to exit after SIGTERM

# --- args ---

app="${1:-}"
[ -n "$app" ] || die "usage: checks/renderer.sh <path-to-app>"

[ -e "$app" ] || die "not found: $app"
case "$app" in
  *.app | *.app/) ;;
  *) die "not an application bundle: $app (no .app suffix)" ;;
esac
[ -d "$app" ] && [ -f "$app/Contents/Info.plist" ] || die "not an application bundle: $app (no Contents/Info.plist)"

app="$(cd "$app" && pwd -P)"
executable_name="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' "$app/Contents/Info.plist" 2> /dev/null || true)"
[ -n "$executable_name" ] && [ -x "$app/Contents/MacOS/$executable_name" ] \
  || die "cannot be launched: $app has no executable at Contents/MacOS/${executable_name:-<CFBundleExecutable unreadable>}"
bundle_executable="$app/Contents/MacOS/$executable_name"

# --- the two overrides, refused before anything is launched ---

# An empty value reads as unset. A leading zero is read in base 10 (10#…), never as invalid octal.
positive_whole_number() {
  case "$2" in
    *[!0-9]*) die "$1 must be a positive whole number (got: $2)" ;;
  esac
  [ "$((10#$2))" -gt 0 ] || die "$1 must be a positive whole number (got: $2)"
  echo "$((10#$2))"
}
OBSERVATIONS="$(positive_whole_number RENDERER_SH_OBSERVATIONS "${RENDERER_SH_OBSERVATIONS:-30}")"   # about 1 s each
LAUNCH_POLL_TICKS="$(positive_whole_number RENDERER_SH_LAUNCH_TICKS "${RENDERER_SH_LAUNCH_TICKS:-80}")"  # of 0.25 s

# Required for the run, so refused here and not met after a launch.
for required in ps open sample; do
  command -v "$required" > /dev/null 2>&1 || die "$required not found on PATH — this gate launches and samples the bundle with it"
done

# --- the pid: found by the executable path, recorded, stopped alone ---

# An unreadable listing reads as "none found", never as a crash.
executable_pids() {
  { ps -axo pid=,comm= 2> /dev/null || true; } | while read -r candidate_pid candidate_path; do
    if [ "$candidate_path" = "$1" ]; then
      echo "$candidate_pid"
    fi
  done
}

# The one pid this run launched. Empty until it has been found and recorded, so a run that never
# recorded one has nothing of its own to stop.
launched_pid=""

# On every exit path, stop the pid this run recorded and no other. Whatever else carries the same
# executable path is not this run's.
stop_launched_process() {
  [ -n "$launched_pid" ] || return 0
  kill -TERM "$launched_pid" 2> /dev/null || true
  ticks=0
  while kill -0 "$launched_pid" 2> /dev/null && [ "$ticks" -lt "$STOP_POLL_TICKS" ]; do
    sleep 0.25
    ticks=$((ticks + 1))
  done
  if kill -0 "$launched_pid" 2> /dev/null; then
    kill -KILL "$launched_pid" 2> /dev/null || true
  fi
}

# Under $TMPDIR by name: a template-less BSD mktemp -d does not read it, and a caller that points
# TMPDIR somewhere is owed the run's files there.
work="$(mktemp -d "${TMPDIR:-/tmp}/renderer.XXXXXX")" || die "cannot create a temporary directory under ${TMPDIR:-/tmp}"
trap 'stop_launched_process; rm -rf "$work"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

# Launches $1 (an application bundle) and records its one pid in launched_pid. $2 is its executable.
launch_and_record() {
  local app_path="$1" executable_path="$2" already_running
  # An instance already running would make "the process this run launched" unknowable, and stopping
  # it afterwards would stop someone else's.
  already_running="$(executable_pids "$executable_path" | tr '\n' ' ')"
  [ -z "$already_running" ] \
    || die "an instance was already running (pid ${already_running% }) with the executable path $executable_path; nothing was launched"

  # Through LaunchServices, the route a user takes.
  open -n -g "$app_path" || die "cannot be launched: open refused $app_path"

  local found_pids="" ticks=0
  while [ -z "$found_pids" ] && [ "$ticks" -lt "$LAUNCH_POLL_TICKS" ]; do
    found_pids="$(executable_pids "$executable_path" | tr '\n' ' ')"
    [ -n "$found_pids" ] || sleep 0.25
    ticks=$((ticks + 1))
  done
  [ -n "$found_pids" ] \
    || die "cannot be launched: no process appeared — none has the executable path $executable_path within $((LAUNCH_POLL_TICKS / 4)) seconds"
  set -- $found_pids
  # Nothing is recorded, so nothing is signalled: which of them this run launched cannot be told.
  [ "$#" -eq 1 ] \
    || die "more than one process has the executable path $executable_path after the launch (pids $found_pids); none was stopped, since this run cannot tell which one it launched"
  launched_pid="$1"
}

# --- the frames: one report in, the verdict on the main-thread block out ---

printf '%s' "$FRAME_LIST" > "$work/frames"

# Reads the frame list, then the report $1. Line one is `main=<0|1> match=<0|1>`; the lines after it are
# the main-thread block's frames as sample wrote them. A frame's depth is the column of its count, the
# tree characters before it being drawing only. Along the path from the thread header down, each frame
# equal to the next listed name advances the match, so a match is every listed frame nested in order.
main_thread_verdict() {
  awk '
    NR == FNR { if ($0 != "") { wanted_count++; wanted[wanted_count] = $0 } next }
    function column_of_count(line) { match(line, /[0-9]/); return RSTART }
    function symbol_of(line,   text, gap) {
      text = line
      sub(/^[ +|:!]*[0-9]+ /, "", text)
      gap = index(text, "  ")
      if (gap > 0) text = substr(text, 1, gap - 1)
      return text
    }
    /^ *[0-9]+ +Thread_/ {
      in_main = (index($0, "com.apple.main-thread") > 0 || index($0, ": Main Thread") > 0)
      if (in_main) {
        has_main = 1
        top = 1; path_depth[1] = column_of_count($0); path_matched[1] = 0
      }
      next
    }
    in_main && /^[ +|:!]*[0-9]+ / {
      depth = column_of_count($0)
      while (top > 0 && path_depth[top] >= depth) top--
      matched = (top > 0) ? path_matched[top] : 0
      if (matched < wanted_count && symbol_of($0) == wanted[matched + 1]) matched++
      top++; path_depth[top] = depth; path_matched[top] = matched
      if (matched == wanted_count) found = 1
      block = block $0 "\n"
      next
    }
    in_main { in_main = 0 }
    END { printf "main=%d match=%d\n%s", has_main + 0, found + 0, block }
  ' "$work/frames" "$1"
}

# --- observing: up to OBSERVATIONS of about 1 s each ---

last_frames=""

# Observes launched_pid up to OBSERVATIONS times. Returns 0 on the first observation that matches the
# frames, with matched_at set to its number, and 1 when the window runs out with none, with last_frames
# holding the last observation's main-thread frames. A failed observation ends the run at once through
# die, and names no bound.
observe_window() {
  local observation=1 report verdict status_line
  while [ "$observation" -le "$OBSERVATIONS" ]; do
    kill -0 "$launched_pid" 2> /dev/null \
      || die "pid $launched_pid no longer names a process: it exited before observation $observation"
    report="$work/$observation.txt"
    sample "$launched_pid" 1 -file "$report" > /dev/null 2> "$work/sample.err" \
      || die "sample failed on pid $launched_pid at observation $observation: $(cat "$work/sample.err")"
    [ -s "$report" ] || die "sample wrote no report for pid $launched_pid at observation $observation"
    verdict="$(main_thread_verdict "$report")" || die "the report of observation $observation could not be read"
    status_line="${verdict%%$'\n'*}"
    case "$status_line" in
      "main=1 "*) ;;
      *) die "the report of observation $observation for pid $launched_pid has no com.apple.main-thread block" ;;
    esac
    last_frames="${verdict#*$'\n'}"
    case "$status_line" in
      *"match=1") matched_at="$observation"; return 0 ;;
    esac
    observation=$((observation + 1))
  done
  return 1
}

# --- the run ---

launch_and_record "$app" "$bundle_executable"
matched_at=0
if observe_window; then
  echo "renderer.sh: pid $launched_pid — the main process was observed at the Open panel, inside the shell's launch, on observation $matched_at (bound: $OBSERVATIONS observations, about 1 s each)"
  exit 0
fi
{
  echo "renderer.sh: pid $launched_pid was never observed at the Open panel inside the shell's launch: none of $OBSERVATIONS observations (the bound, about 1 s each) showed the frames in checks/renderer.sh's header"
  echo "the last observation's main-thread frames:"
  printf '%s' "$last_frames"
} >&2
exit 1

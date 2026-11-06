#!/usr/bin/env bash
# Version: 2.1.0 — after the listing the script captures the screen to
#   ~/Desktop/tree-scene-end.png, and the app stays open until a second Enter, so the end state can
#   be compared with the window without a person timing a screenshot (2.0.0 closed it at once: the scene goes on the Desktop, the churn
#   waits for Enter, each step is announced; 1.0.0 copied under the temporary directory and gave a fixed sixty-second lead-in)
#
# checks/tree-scene.sh — launches the built KA-Reader.app, stages a copy of checks/fixtures/tree-scene
# on the Desktop, waits for Enter, churns that copy for thirty seconds, and prints what is on disk
# once the churn has settled. A person on the host runs it through checks/tree-walk.sh, which builds
# the app in the guest and runs this there. Run by hand in the guest, from the product root:
#   checks/tree-scene.sh target/release/bundle/macos/KA-Reader.app
#
# WHY THIS EXISTS
#   The tree an open folder shows follows the disk (docs/SDD.md § 6 S-5). No command can watch the
#   app's window, and docs/SDD.md § 4 C-I3 builds no UI driver, so the built-app proof is a walk a
#   person performs (docs/nfdr.md QC-66). This script is the person's helper: it sets the scene,
#   changes the disk on a fixed schedule, and prints the listings the tree must agree with. It sends
#   the app no input. The person chooses the folder it names, sets the place, opens a long file and
#   scrolls, watches the tree follow, and compares it with the printed listings. Its cases are
#   checks/tests/test_tree_scene.sh, and its refusal is also held in checks/tests/test_vm_refusal.sh.
#
# USAGE
#   checks/tree-scene.sh <path-to-app>
#   stderr says which folder to choose in the app and what to set before pressing Enter, then the
#   churn runs and each step is named on stderr as it lands.
#   stdout is the listings, and only the listings: each folder as `<path>:` with its entries
#   beneath it, folders first and then files, each by lowercase name, and a folder's entries right
#   after it. A folder entry ends in `/`.
#
# WHAT IT DOES
#   1. Admission: it asks the host whether it is a macOS virtual machine. See ADMISSION below.
#   2. It copies the fixture to ~/Desktop/tree-scene, a folder the open panel shows in its sidebar,
#      and launches the bundle once, in front, as `open -n`. The process that came with the launch is the
#      one pid it records. A folder already there is replaced only if it holds the fixture's
#      .scene-note (a copy a killed run left behind); any other folder of that name stops the run.
#   3. It waits for a line on standard input: the person chooses the folder, expands the nested
#      folders, opens reading/long.md and scrolls, then presses Enter. End of input stops the run.
#      Then it churns the copy: ten steps of creates, changes, deletes and a rename in nested
#      folders, three seconds apart, each named on stderr. The churn is a fixed list, so a rerun
#      does the same work. reading/long.md is never touched, and the churn never goes outside the
#      copy.
#   4. It waits a quiet interval, then prints a fresh listing of every folder of the copy.
#   5. On every exit it stops the pid it recorded, and no other, and removes the copy.
#
# ADMISSION
#   The first thing the script does is ask the host whether it is a macOS virtual machine
#   (`uname -s` Darwin and `sysctl -n kern.hv_vmm_present` 1, both succeeding). On any other reading
#   it prints one line on stderr, nothing on stdout, and exits 1, before it launches anything,
#   copies anything or looks at the home (docs/nfdr.md QC-65). Nothing it is given turns this off.
#
# THE PID
#   The recorded pid is the first process whose executable path is the bundle's one executable and
#   that was not running before `open`. A process of the same executable that was already running
#   is not this run's and is never named to `kill`. If two new processes of that path appear in the
#   same look, the first listed is taken; the walk is run on a machine with no other instance.

set -euo pipefail

# --- admission: this step runs only in a macOS virtual machine (docs/nfdr.md QC-65) ---
# First work of the run, inline so nothing is opened, found or read before it. Both host readings
# must succeed and read exactly Darwin and 1; a reader that fails, is missing or prints anything
# else refuses, and a failing reader that prints 1 does not admit (the status is kept, not only the
# text). Nothing the script reads — argument, flag or variable — changes this.
host_os="$(uname -s 2> /dev/null)" && host_vmm="$(sysctl -n kern.hv_vmm_present 2> /dev/null)" \
  && [ "$host_os" = "Darwin" ] && [ "$host_vmm" = "1" ] \
  || { echo "tree-scene.sh: refused: this host does not read as a macOS virtual machine. This step launches KA-Reader.app or reads this machine's home, and runs only in a macOS virtual machine (docs/nfdr.md QC-65)." >&2; exit 1; }

die() { echo "tree-scene.sh: $*" >&2; exit 1; }

# The churn and the quiet interval, in ticks of a whole number of seconds. The step
# lengths are distinct so a case can count each from the waits it saw.
CHURN_STEPS=10
CHURN_STEP_SECONDS=3
QUIET_TICKS=2
QUIET_TICK_SECONDS=4
LAUNCH_POLL_TICKS=80   # of 0.25 s: 20 s for the launched process to appear
STOP_POLL_TICKS=20     # of 0.25 s: 5 s for it to exit after SIGTERM
TAB="$(printf '\t')"

# --- the app ---

[ $# -eq 1 ] || die "usage: checks/tree-scene.sh <path-to-app>"
app="$1"
[ -d "$app/Contents/MacOS" ] || die "$app has no Contents/MacOS, so it is not a built app"
# Absolute and with links resolved, because `ps` names a process by its physical executable path
# (/tmp reads as /private/tmp). A relative argument, the usage line's own form, never matched
# the process the launch started.
app="$(cd "$app" && pwd -P)"
executables="$(find "$app/Contents/MacOS" -mindepth 1 -maxdepth 1 | LC_ALL=C sort)"
[ -n "$executables" ] && [ "$(printf '%s\n' "$executables" | wc -l | tr -d ' ')" -eq 1 ] \
  || die "$app does not hold exactly one executable under Contents/MacOS"
bundle_executable="$app/Contents/MacOS/$(basename "$executables")"

fixture="$(cd "$(dirname "$0")" && pwd)/fixtures/tree-scene"
[ -d "$fixture" ] || die "the fixture is not at $fixture"

# `open`, `ps` and `kill` are found through PATH, so a case can put its own in front. `kill` is also
# a builtin that never looks at PATH, so the program is named once here and every call goes to it.
command -v open > /dev/null 2>&1 || die "open not found on PATH"
command -v ps > /dev/null 2>&1 || die "ps not found on PATH"
kill_tool="$(type -P kill)" || die "kill not found on PATH"

# --- the processes ---

# The main process is identified by its absolute executable path, never by a pattern over command
# lines. An unreadable listing reads as none found.
executable_pids() {
  { ps -axo pid=,comm= 2> /dev/null || true; } | while read -r candidate_pid candidate_path; do
    if [ "$candidate_path" = "$bundle_executable" ]; then
      echo "$candidate_pid"
    fi
  done
}

# The one pid this run launched. Empty until it has been found and recorded, so a run that never
# recorded one has nothing of its own to stop.
launched_pid=""

# On every exit path, stop the pid this run recorded and no other.
stop_launched_process() {
  [ -n "$launched_pid" ] || return 0
  "$kill_tool" -TERM "$launched_pid" 2> /dev/null || true
  stop_ticks=0
  while "$kill_tool" -0 "$launched_pid" 2> /dev/null && [ "$stop_ticks" -lt "$STOP_POLL_TICKS" ]; do
    sleep 0.25
    stop_ticks=$((stop_ticks + 1))
  done
  if "$kill_tool" -0 "$launched_pid" 2> /dev/null; then
    "$kill_tool" -KILL "$launched_pid" 2> /dev/null || true
  fi
}

# --- the scratch copy ---

# On the Desktop, so the open panel's sidebar reaches it in one click and nobody types a path.
[ -n "${HOME:-}" ] && [ -d "$HOME/Desktop" ] || die "there is no Desktop folder under the home to put the scene in"
scratch="$HOME/Desktop/tree-scene"
capture="$HOME/Desktop/tree-scene-end.png"
rm -f "$capture"
if [ -e "$scratch" ]; then
  [ -f "$scratch/.scene-note" ] || die "$scratch is there and is not a scene copy, so it is left alone; move it and run again"
  rm -rf "$scratch"
fi
trap 'stop_launched_process; rm -rf "$scratch"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
cp -R "$fixture" "$scratch"

# --- launch ---

before="$(executable_pids)"
open -n "$app" || die "cannot be launched: open refused $app"

poll_ticks=0
while [ -z "$launched_pid" ] && [ "$poll_ticks" -lt "$LAUNCH_POLL_TICKS" ]; do
  for candidate in $(executable_pids); do
    case "
$before
" in
      *"
$candidate
"*) ;;
      *) launched_pid="$candidate"; break ;;
    esac
  done
  if [ -z "$launched_pid" ]; then
    sleep 0.25
    poll_ticks=$((poll_ticks + 1))
  fi
done
[ -n "$launched_pid" ] || die "no new process of $bundle_executable appeared within $LAUNCH_POLL_TICKS ticks of 0.25s of open"

# --- the lead-in: the person sets the place, then presses Enter ---

echo "tree-scene.sh: choose this folder in the app: $scratch" >&2
echo "tree-scene.sh: in the app's window, before you press Enter:" >&2
echo "tree-scene.sh:   1. click KA-Reader in the Dock if its window is not in front; in its panel choose Desktop, then tree-scene, then Open" >&2
echo "tree-scene.sh:   2. expand src, src/nested, src/nested/deep, docs, notes and reading" >&2
echo "tree-scene.sh:   3. open reading/long.md and scroll to a section in the middle" >&2
echo "tree-scene.sh: press Enter here when that is set, then watch the app's window" >&2
IFS= read -r _ || die "no Enter came (standard input ended), so the churn did not start"

# --- the churn: a fixed list, one step at a time ---

# Step $1 of the churn, in the copy and nowhere else. Created and changed files hold a line naming
# the step.
churn_step() {
  case "$1" in
    1) printf 'step 1\n' > "$scratch/src/nested/deep/stage1.txt"; said='created src/nested/deep/stage1.txt' ;;
    2) printf 'step 2\n' >> "$scratch/src/a.rs"; said='changed src/a.rs' ;;
    3) mkdir -p "$scratch/src/extra" && printf 'step 3\n' > "$scratch/src/extra/x.txt"; said='created the folder src/extra with x.txt in it' ;;
    4) rm "$scratch/docs/changelog.md"; said='deleted docs/changelog.md' ;;
    5) printf 'step 5\n' > "$scratch/docs/draft.md"; said='created docs/draft.md' ;;
    6) rm "$scratch/src/nested/fresh.txt"; said='deleted src/nested/fresh.txt' ;;
    7) mv "$scratch/src/nested/deep/moved.rs" "$scratch/src/extra/moved.rs"; said='moved src/nested/deep/moved.rs to src/extra/moved.rs' ;;
    8) printf 'step 8\n' > "$scratch/notes/n3.txt"; said='created notes/n3.txt' ;;
    9) rm "$scratch/notes/n2.txt"; said='deleted notes/n2.txt' ;;
    10) printf 'step 10\n' > "$scratch/reading/late.md"; said='created reading/late.md' ;;
    *) die "no churn step $1" ;;
  esac
}

step=1
while [ "$step" -le "$CHURN_STEPS" ]; do
  said=""
  churn_step "$step"
  echo "tree-scene.sh: step $step of $CHURN_STEPS: $said" >&2
  sleep "$CHURN_STEP_SECONDS"
  step=$((step + 1))
done

# --- quiescence, then the fresh listings ---

quiet=0
while [ "$quiet" -lt "$QUIET_TICKS" ]; do
  sleep "$QUIET_TICK_SECONDS"
  quiet=$((quiet + 1))
done

# The entries of folder $1 in the tree's order, one per line as `<group><TAB><name>`: group 0 for
# an entry that is a folder and 1 for the rest, then the lowercase name, as the model orders them.
ordered_entries() {
  ls -A "$1" | while IFS= read -r entry_name; do
    if [ -d "$1/$entry_name" ]; then
      entry_group=0
    else
      entry_group=1
    fi
    printf '%s\t%s\t%s\n' "$entry_group" "$(printf '%s' "$entry_name" | tr 'A-Z' 'a-z')" "$entry_name"
  done | LC_ALL=C sort | cut -f 1,3
}

# Prints the listing of folder $1, headed by its path $2 below the copy, then the listing of each
# folder in it, depth first.
print_tree() {
  local entries
  echo "$2:"
  entries="$(ordered_entries "$1")"
  [ -z "$entries" ] && return 0
  printf '%s\n' "$entries" | while IFS="$TAB" read -r entry_group entry_name; do
    if [ "$entry_group" = "0" ]; then
      echo "  $entry_name/"
    else
      echo "  $entry_name"
    fi
  done
  printf '%s\n' "$entries" | while IFS="$TAB" read -r entry_group entry_name; do
    [ "$entry_group" = "0" ] || continue
    if [ "$2" = "." ]; then
      print_tree "$1/$entry_name" "$entry_name"
    else
      print_tree "$1/$entry_name" "$2/$entry_name"
    fi
  done
}

echo "tree-scene.sh: the churn is over. The app's tree should now match the listing below, with the" >&2
echo "tree-scene.sh: folders you expanded still expanded, long.md still open at the same section, and" >&2
echo "tree-scene.sh: nothing that flashed, popped up or asked for attention along the way." >&2
print_tree "$scratch" "."

# The window at quiescence, captured by the script itself: no person can time a screenshot between
# the listing and the exit trap. It goes beside the Desktop copy, never in it, so the trap keeps it.
if screencapture -x "$capture"; then
  echo "tree-scene.sh: the screen at quiescence is captured at $capture" >&2
else
  echo "tree-scene.sh: the screen could not be captured; compare the window by eye" >&2
fi

# The app stays open until a second Enter, so the person can compare the window with the listing
# before the exit trap closes it. End of input closes it at once.
echo "tree-scene.sh: the app stays open for comparing; press Enter here to close it" >&2
IFS= read -r _ || true

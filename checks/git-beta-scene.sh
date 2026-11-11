#!/usr/bin/env bash
# Version: 1.0.0 — first version: the skeleton (admission, usage, the ids, the walk of one state, the
#   entries, the stops and the cleanup); the states come in later versions
#
# checks/git-beta-scene.sh — sets up each state of the beta's read-at-open examples (E1 - E13) in a
# folder on the Desktop, launches the built KA-Reader.app once per state, tells the person which
# folder to choose and what to look at, and prints the state's record lines. A person on the host
# runs it through checks/git-beta-walk.sh, which builds the app in the guest and runs this there.
# Run by hand in the guest, from the product root:
#   checks/git-beta-scene.sh target/release/bundle/macos/KA-Reader.app "<built-from>" [<state-id>…]
#
# WHY THIS EXISTS
#   The beta's two lines, on the Git view and at the head of the tree, are proved in process by view
#   tests and wording checks, and nobody has looked at them in the built app's window in every
#   state (change_spec CP-1302). The look is a person's: docs/SDD.md § 4 C-I3 builds no UI driver
#   and docs/nfdr.md § 9 gives the rendered UI to a walk "deliberately not automated". What a
#   command can do is make the look one sitting: about thirty disk states, most of them Git states in
#   progress, made unreadable or changed under an open window, set up the same way every time. This
#   script is that tool. It sends the app no input. Its cases are checks/tests/test_git_beta_scene.sh,
#   and its refusal is also held in checks/tests/test_vm_refusal.sh.
#
# USAGE
#   checks/git-beta-scene.sh <path-to-app> <built-from> [<state-id>…]
#   <built-from> is one line the caller gives: the commit and whether the tree had uncommitted
#   changes. It is copied verbatim into every entry. With no state id every state is walked; a subset
#   is walked in the fixed order, whatever order it was given in.
#   stderr is the instructions to the person and the progress of each disk change. stdout is one
#   entry per state walked to its end, and nothing else; the fields only the person can fill are
#   printed as `<to fill from the look>`.
#
# WHAT IT DOES
#   1. Admission: it asks the host whether it is a macOS virtual machine. See ADMISSION below.
#   2. For each state, in the fixed order: it stages the state in a folder on the Desktop (a
#      folder the open panel shows in its sidebar), launches the bundle once, in front, as
#      `open -n`, tells the person which folder to choose and what to read, waits for Enter, and
#      captures the screen into ~/Desktop/git-beta-scene-captures/, outside every copy.
#   3. On the way out of each state, and on every exit, it stops the one pid it recorded and no other
#      and removes the copy it made.
#   A folder of a state's copy name that this script did not make (it has no note beside it) is never
#   touched: the run stops there. A copy a killed run left behind has its note, and is replaced.
#
# STATUSES (docs/nfdr.md QC-70)
#   0 once every requested state was walked to its end. 1 on a refusal: off a macOS virtual machine;
#   a Desktop folder of a copy's name that has no note; a state whose setup failed; no new process after
#   `open`; end of input. 2 on a wrong invocation, with usage on stderr, before anything is read or
#   launched. 130 on INT and 143 on TERM.
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
#   is not this run's and is never named to `kill`.

set -euo pipefail

# --- admission: this step runs only in a macOS virtual machine (docs/nfdr.md QC-65) ---
# First work of the run, inline so nothing is opened, found or read before it. Both host readings
# must succeed and read exactly Darwin and 1; a reader that fails, is missing or prints anything
# else refuses, and a failing reader that prints 1 does not admit (the status is kept, not only the
# text). Nothing the script reads — argument, flag or variable — changes this.
host_os="$(uname -s 2> /dev/null)" && host_vmm="$(sysctl -n kern.hv_vmm_present 2> /dev/null)" \
  && [ "$host_os" = "Darwin" ] && [ "$host_vmm" = "1" ] \
  || { echo "git-beta-scene.sh: refused: this host does not read as a macOS virtual machine. This step launches KA-Reader.app or reads this machine's home, and runs only in a macOS virtual machine (docs/nfdr.md QC-65)." >&2; exit 1; }

say() { echo "git-beta-scene.sh: $*" >&2; }
die() { say "$*"; exit 1; }

# The ids in the order they are walked: a plain word list, because bash 3.2 has no associative array.
# Each state's task adds its ids here, so a helper at any version walks every id it lists.
STATE_IDS="E1 E2-clean"

# The bounds, in ticks of 0.25 s, are constants (docs/nfdr.md QC-67).
LAUNCH_WAIT_SECONDS=20
LAUNCH_POLL_TICKS=80
STOP_POLL_TICKS=20
FILL='<to fill from the look>'
NL=$'\n'

# --- the arguments ---

usage_lines() {
  say "usage: checks/git-beta-scene.sh <path-to-app> <built-from> [<state-id>…]"
  say "the state ids, in the order they are walked: $STATE_IDS"
}

# A wrong invocation: the line, then the usage lines, exit 2, before anything is read or launched.
usage_die() {
  say "$*"
  usage_lines
  exit 2
}

[ $# -ge 2 ] || usage_die "it needs the app's path and a built-from line before any state id, so nothing was set up or launched."
app="$1"
built_from="$2"
shift 2
case "$built_from" in
  *"$NL"*) usage_die "the built-from line holds a line break, so nothing was set up or launched. Give it as one line." ;;
esac

requested=""
for requested_id in "$@"; do
  case " $STATE_IDS " in
    *" $requested_id "*) ;;
    *) usage_die "$requested_id is not one of the state ids, so nothing was set up or launched. Run it again with ids from the list below, or with none to walk every state." ;;
  esac
  case " $requested " in
    *" $requested_id "*) usage_die "$requested_id is given more than once, so nothing was set up or launched. Give each id once." ;;
  esac
  requested="$requested $requested_id"
done

# The ids this run walks, in the fixed order.
run_ids=""
for known_id in $STATE_IDS; do
  if [ -z "$requested" ]; then
    run_ids="$run_ids $known_id"
  else
    case " $requested " in
      *" $known_id "*) run_ids="$run_ids $known_id" ;;
    esac
  fi
done
run_ids="${run_ids# }"

# --- the app, the fixture, the tools, the Desktop ---

[ -d "$app/Contents/MacOS" ] || die "$app has no Contents/MacOS, so it is not a built app and nothing was launched. Give the path of the KA-Reader.app that ka-reader-mac/assemble.sh built."
# Absolute and with links resolved, because `ps` names a process by its physical executable path.
app="$(cd "$app" && pwd -P)"
executables="$(find "$app/Contents/MacOS" -mindepth 1 -maxdepth 1 | LC_ALL=C sort)"
[ -n "$executables" ] && [ "$(printf '%s\n' "$executables" | wc -l | tr -d ' ')" -eq 1 ] \
  || die "$app does not hold exactly one executable under Contents/MacOS, so nothing was launched. Give the path of the KA-Reader.app that ka-reader-mac/assemble.sh built."
bundle_executable="$app/Contents/MacOS/$(basename "$executables")"

fixture="$(cd "$(dirname "$0")" && pwd)/fixtures/git-beta-scene"
[ -d "$fixture" ] || die "the fixture is not at $fixture, so nothing was set up or launched. Run the helper from a full checkout of the product."

# `open`, `ps`, `kill`, `screencapture` and `git` are found through PATH, so a case can put its own
# in front. `kill` is also a builtin that never looks at PATH, so the program is named once here and
# every call goes to it.
for tool in open ps screencapture git; do
  command -v "$tool" > /dev/null 2>&1 || die "$tool was not found on PATH, so nothing was set up or launched. Put it on PATH and run this again."
done
kill_tool="$(type -P kill)" || die "kill was not found on PATH, so nothing was set up or launched. Put it on PATH and run this again."

[ -n "${HOME:-}" ] && [ -d "$HOME/Desktop" ] \
  || die "there is no Desktop folder under the home to put the states in, so nothing was set up or launched. Run it as an account that has a Desktop folder."
desktop="$HOME/Desktop"
captures="$desktop/git-beta-scene-captures"

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

# The one pid this run launched for the state in hand. Empty until it has been found and recorded,
# so a run that never recorded one has nothing of its own to stop.
launched_pid=""

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
  launched_pid=""
}

# --- the copies ---

# The copy of the state in hand and the note beside it that says this script made it. The note
# sits beside the copy and not in it, so the folder the app opens holds nothing but the state.
copy=""
note=""

# Removes the copy and its note. A state may have taken a folder's permissions away, so they are
# given back first, inside the copy only.
remove_copy() {
  if [ -n "$copy" ] && { [ -e "$copy" ] || [ -L "$copy" ]; }; then
    chmod -R u+rwx "$copy" 2> /dev/null || true
    rm -rf "$copy"
  fi
  if [ -n "$note" ]; then
    rm -f "$note"
  fi
  copy=""
  note=""
}

# On every exit path, stop the pid this run recorded and no other, and remove what it made.
cleanup() {
  stop_launched_process
  remove_copy
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

# --- the stops ---

walked_count=0

# The ids from the stopped state $1 to the end of the ids this run was given, in walk order.
remaining_ids() {
  remaining=""
  reached=0
  for listed_id in $run_ids; do
    if [ "$listed_id" = "$1" ]; then
      reached=1
    fi
    if [ "$reached" -eq 1 ]; then
      remaining="$remaining $listed_id"
    fi
  done
  echo "${remaining# }"
}

# The end of a walk that cannot go on: the stop line $2, what was walked, and the ids that finish it.
stop_walk() {
  say "$2"
  if [ "$walked_count" -eq 0 ]; then
    say "no state was walked to its end."
  else
    say "the states before $1 were walked to their end."
  fi
  say "to walk the rest, run the walk again with these ids: $(remaining_ids "$1")"
  exit 1
}

# --- what each state says about itself ---

# The state's one-sentence description of what is on disk.
on_disk_of() {
  case "$1" in
    E1) echo "A repository with one changed file and one staged file." ;;
    E2-clean) echo "A clean repository: nothing changed and nothing staged." ;;
    *) die "no description of state $1" ;;
  esac
}

# The state's account of what the scene did, never of what the person did.
done_of() {
  case "$1" in
    *) echo "The scene launched KA-Reader and asked for the folder above to be chosen in the Open panel." ;;
  esac
}

# The rules of the spec's Examples that the state is judged against.
rules_of() {
  case "$1" in
    E1|E2-*) echo "CP-1304 CP-1305" ;;
    *) die "no rules for state $1" ;;
  esac
}

# The entry for state $1, whole, on standard output.
print_entry() {
  printf '%s\n' "## $1"
  printf '%s\n' "- Built from: $built_from"
  printf '%s\n' "- On disk: $(on_disk_of "$1")"
  printf '%s\n' "- Done: $(done_of "$1")"
  printf '%s\n' "- The Git view showed: $FILL"
  printf '%s\n' "- The head of the file tree showed: $FILL"
  printf '%s\n' "- Letters beside the file tree's entries: $FILL"
  for rule in $(rules_of "$1"); do
    printf '%s\n' "- Verdict against $rule: $FILL"
  done
}

# --- the staging of a state ---

# Stages state $1 in the copy. A state's task fills its case; until then a state is the fixture alone.
stage_state() {
  case "$1" in
    *) ;;
  esac
}

# --- the walk of one state ---

# Prepares the copy for state $1: replaces a leftover of this script's own (its note is beside it),
# stops at a folder it did not make, copies the fixture and writes the note.
prepare_copy() {
  copy="$desktop/git-beta-scene-$1"
  note="$desktop/.git-beta-scene-$1.note"
  if [ -e "$copy" ] || [ -L "$copy" ]; then
    if [ ! -f "$note" ]; then
      folder="$copy"
      copy=""
      stop_walk "$1" "$folder is there and is not a scene copy, so it is left alone and the walk ends here. Move it somewhere else and run the walk again."
    fi
    remove_copy
    copy="$desktop/git-beta-scene-$1"
    note="$desktop/.git-beta-scene-$1.note"
  fi
  : > "$note"
  cp -R "$fixture" "$copy"
}

# Launches the bundle once and records the one new pid, or stops the walk for state $1.
launch_app() {
  before="$(executable_pids)"
  open_status=0
  open -n "$app" || open_status=$?
  if [ "$open_status" -ne 0 ]; then
    stop_walk "$1" "$1: open exited with status $open_status for $app, so this state was not shown and the walk ends here."
  fi
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
  [ -n "$launched_pid" ] \
    || stop_walk "$1" "$1: no new process of $bundle_executable appeared within $LAUNCH_WAIT_SECONDS seconds of open, so this state was not shown and the walk ends here. Check that the app starts when opened from Finder."
}

# Waits for a line on standard input for state $1, or stops the walk.
wait_for_enter() {
  IFS= read -r _ || stop_walk "$1" "$1: no Enter came (standard input ended), so this state was not walked to its end and the walk ends here."
}

# Captures the screen for state $1 into the captures folder, under the name $2.
capture_screen() {
  capture_path="$captures/$2.png"
  if screencapture -x "$capture_path"; then
    say "$1: the screen is captured at $capture_path"
  else
    say "$1: the screen could not be captured; write the entry from what you saw"
  fi
}

# Walks state $1, which is state $2 of $3: stage, launch, instruct, wait, capture, clean up, print.
walk_state() {
  state_id="$1"
  prepare_copy "$state_id"
  stage_state "$state_id"
  launch_app "$state_id"
  say "$state_id, state $2 of $3: $(on_disk_of "$state_id")"
  say "$state_id: choose this folder in the app: $copy"
  say "$state_id: click KA-Reader in the Dock if its window is not in front; in its Open panel choose Desktop, go to the folder named above, then choose Open."
  say "$state_id: choose Git in the sidebar and read every sentence the Git view shows, word for word. Then choose Files and read what the head of the file tree shows, and whether letters stand beside its entries."
  say "$state_id: press Enter here when you have looked."
  wait_for_enter "$state_id"
  capture_screen "$state_id" "$state_id"
  say "$state_id is walked to its end."
  stop_launched_process
  remove_copy
  walked_count=$((walked_count + 1))
  print_entry "$state_id"
}

# --- the walk ---

total=0
for counted_id in $run_ids; do
  total=$((total + 1))
done

mkdir -p "$captures"
say "for each state, the scene sets up a folder on the Desktop, launches KA-Reader, and tells you here what to choose and when to press Enter."
say "a state you could not bring about in the window is not seen: write not seen in its verdicts, with what you tried."
say "the screen captures go to $captures. Keep them out of the record: a capture can show this machine's login name and paths."

position=0
for walk_id in $run_ids; do
  position=$((position + 1))
  walk_state "$walk_id" "$position" "$total"
done

say "the walk is over, and every state it was given was walked to its end."
say "fill each entry's $FILL fields from what you saw in the window, word for word."

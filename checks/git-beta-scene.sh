#!/usr/bin/env bash
# Version: 1.4.0 — E3 holds the product's own Git read open for a time the scene sets, and lets it go on
#   by itself on every way out
# Version: 1.3.2 — an argument holding two ids with a space between them is no state id (exit 2)
# Version: 1.3.1 — E12's entry names both rules the spec assigns it, CP-1306 and CP-1309
# Version: 1.3.0 — the in-window disk changes E9 - E13: each waits for Enter, then changes its copy from outside
# Version: 1.2.0 — the failure states E5 - E8: E5, E6, E7 and one E8 id per distinct observed sentence
# Version: 1.1.0 — the repository states E1 - E4: E1, the E2 members, E3, E4; E4 after a repository
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
#   4. E3 also holds the product's own Git read open (see E3'S HOLD below), and ends that hold itself
#      on every way out, before the copy is removed.
#
# E3'S HOLD
#   The product reads E3's twenty thousand files in about 70 ms, so its Git view's pending line is
#   gone before anyone can choose Git. So E3's copy holds two named pipes, and one background holder
#   makes the read wait on them for E3_HOLD_SECONDS, counted from the read's own start. The status
#   read opens the root's .gitignore first and .git/info/exclude next, and a named pipe's open
#   returns only when a writer opens it, so: the first pipe (the start pipe, at .gitignore) tells the
#   holder the read has started, and the second (the hold pipe, at .git/info/exclude) keeps the read
#   waiting until the holder opens it, E3_HOLD_SECONDS later. The read's status walk skips a pipe, so
#   neither reaches the Git view, and once the hold ends the read finds no ignore rule, which is what
#   the copy without the hold gives it. The holder needs no Enter and no signal. On every way out the
#   hold is ended before the copy is removed, also without a signal: the hold pipe is opened for
#   reading and writing, which lets go a holder blocked there; its path is removed, so a holder not
#   yet past the start pipe skips its wait; the start pipe is opened for reading and writing, which
#   lets go a holder blocked there; and the holder is waited for. A holder already in its wait is
#   waited for, at most E3_HOLD_SECONDS. The holder is never named to kill.
#
# STATUSES (docs/nfdr.md QC-70)
#   0 once every requested state was walked to its end. 1 on a refusal: off a macOS virtual machine;
#   a Desktop folder of a copy's name that has no note; a state whose setup failed; no new process after
#   `open`; end of input. 2 on a wrong invocation, with usage on stderr, before anything is read or
#   launched. 130 on INT and 143 on TERM.
#
# THE IN-WINDOW DISK CHANGES (E9 - E13)
#   Each is walked as a first look, then a change made from outside while KA-Reader stays open,
#   then a second look: E9 gives .git back the permissions E5 removed; E10 edits a file, stages it
#   with git add and commits it with git commit; E11 moves .git out of the root, into a sibling
#   folder this script makes and removes; E12 runs git init in the plain root; E13 changes a tracked
#   file between the person's sidebar switches (Git, Files, Git). The change lands only after the
#   person's Enter, one step at a time, each said on stderr, and only in the copy. One screen capture
#   is taken when each look ends (E13: three).
#
# THE FAILURE STATES (E5 - E8)
#   Each is a disk shape the core's own tests already pin for its condition, never a guess:
#   E5  .git of a repository with mode 000 (crates/ka-reader-core/tests/root_finding.rs
#       test_unreadable_git_directory_reports_condition).
#   E6  a .git/config that is not Git config syntax; the probe's repository-read-failed condition
#       (root_finding.rs test_invalid_git_config_reports_observed_failure).
#   E7  a probe that answers root and a status read that stops unexplained: the shape chosen is the
#       UNREADABLE INDEX (.git/index with mode 000), one of the status-only RepositoryReadFailed
#       paths of git_reader/libgit2.rs verify_submodules (`repository.index()` failing). Confirmed
#       against crates/ka-reader-core/tests/git_state.rs
#       test_state_ok_and_status_failing_is_a_failed_item, which pins that a root whose status read
#       fails folds to a failed item. No git_state.rs case pins this disk shape itself, so the look
#       confirms which sentence the app shows; if it shows another, E7 is recorded as not seen with
#       what was tried (change_spec CP-1303).
#   E8-<n>  one shape per distinct sentence ka-reader-mac/Sources/Surfaces/GitSentences.swift
#       draws for a condition KA-Reader observed, numbered from 1 in the order the sentences first
#       appear in GitSentences.failure: 1 the Git directory outside, 2 the config names a path
#       outside, 3 the config names a path not located, 4 the object store names another outside,
#       5 the object store names another not located, 6 a .gitmodules path leading elsewhere, 7 the
#       folder cannot be looked in, 8 the Git directory cannot be read, 9 .git is a link, 10 nothing
#       where the Git directory pointed, 11 no repository in the Git directory, 12 .gitmodules
#       cannot be read. The suite reads the count from that file, so a sentence added there fails
#       the suite until an id is added here.
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
STATE_IDS="E1 E2-clean E2-merge E2-rebase E2-cherry-pick E2-revert E2-bisect E2-am E2-detached E3 E4 E5 E6 E7 E8-1 E8-2 E8-3 E8-4 E8-5 E8-6 E8-7 E8-8 E8-9 E8-10 E8-11 E8-12 E9 E10 E11 E12 E13"

# The bounds, in ticks of 0.25 s, are constants (docs/nfdr.md QC-67).
LAUNCH_WAIT_SECONDS=20
LAUNCH_POLL_TICKS=80
STOP_POLL_TICKS=20
# E3 is a repository with E3_FILE_COUNT empty files in its working tree, written in folders of
# E3_FILES_PER_FOLDER. The count does not give the Git view's pending line its time: a faster guest
# reads the files faster. What gives it the time is the hold (see E3'S HOLD in the header): the
# scene keeps the product's Git read waiting for E3_HOLD_SECONDS, counted from the read's own start.
# E3_HOLD_FLOOR_SECONDS is the time E3's instructions and entry promise, counted from the file tree's
# appearance. The hold is longer than the floor, because the app asks for its Git read a moment
# before the tree is drawn.
E3_FILE_COUNT=20000
E3_FILES_PER_FOLDER=100
E3_HOLD_FLOOR_SECONDS=10
E3_HOLD_SECONDS=12
# The identity every commit the states make carries, so the guest's own never shapes a scene.
SCENE_AUTHOR_NAME="Scene Author"
SCENE_AUTHOR_EMAIL="scene-author@example.invalid"
# The tracked file E10 and E13 change.
CHANGED_FILE="notes/today.md"
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
  # Compared with each listed id whole, never found inside the list: an argument holding two ids
  # with a space between them would otherwise be found there and pass as one id.
  is_listed=0
  for listed_id in $STATE_IDS; do
    if [ "$requested_id" = "$listed_id" ]; then
      is_listed=1
    fi
  done
  [ "$is_listed" -eq 1 ] \
    || usage_die "$requested_id is not one of the state ids, so nothing was set up or launched. Run it again with ids from the list below, or with none to walk every state."
  # Each id has passed the check above, so it holds no space and is found in the list only whole.
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
# E4 is a plain folder walked right after a repository launch. Every id before it in the fixed order
# is a repository state, so only an E4 that comes first has no such launch before it.
e2_clean_added=0
case "$run_ids" in
  E4 | "E4 "*) run_ids="E2-clean $run_ids"; e2_clean_added=1 ;;
esac

# --- the app, the fixture, the tools, the Desktop ---

[ -d "$app/Contents/MacOS" ] || die "$app has no Contents/MacOS, so it is not a built app and nothing was launched. Give the path of the KA-Reader.app that ka-reader-mac/assemble.sh built."
# Absolute and with links resolved, because `ps` names a process by its physical executable path.
app="$(cd "$app" && pwd -P)"
executables="$(find "$app/Contents/MacOS" -mindepth 1 -maxdepth 1 | LC_ALL=C sort)"
[ -n "$executables" ] && [ "$(printf '%s\n' "$executables" | wc -l | tr -d ' ')" -eq 1 ] \
  || die "$app does not hold exactly one executable under Contents/MacOS, so nothing was launched. Give the path of the KA-Reader.app that ka-reader-mac/assemble.sh built."
bundle_executable="$app/Contents/MacOS/$(basename "$executables")"

fixtures_root="$(cd "$(dirname "$0")" && pwd)/fixtures"
fixture="$fixtures_root/git-beta-scene"
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
# Where E11 moves .git to, once it has: a sibling of the copy that this script made.
moved_git=""

# E3's hold: the pid of the one background holder, and the two named pipes it works with. Both pipes
# are in the copy, and the holder's pid is empty until the hold is started, so a run that never
# started one has nothing to end.
holder_pid=""
start_pipe=""
hold_pipe=""

# Ends E3's hold, if one is up, without a signal, so the holder is never named to kill. Opening a
# named pipe for reading and writing never blocks, and lets go a holder blocked at it. Descriptors 8
# and 9 are used nowhere else in this script. A pipe is opened only where it is found, so a path that
# is gone never ends the cleanup.
end_the_hold() {
  [ -n "$holder_pid" ] || return 0
  if [ -p "$hold_pipe" ]; then
    exec 8<> "$hold_pipe"
  fi
  # With the hold pipe's path gone, a holder not yet past the start pipe skips its wait.
  rm -f "$hold_pipe"
  if [ -p "$start_pipe" ]; then
    exec 9<> "$start_pipe"
  fi
  wait "$holder_pid" || true
  exec 8>&- 9>&-
  holder_pid=""
}

# Removes the copy and its note. A state may have taken a folder's permissions away, so they are
# given back first, inside the copy only.
remove_copy() {
  end_the_hold
  if [ -n "$copy" ] && { [ -e "$copy" ] || [ -L "$copy" ]; }; then
    chmod -R u+rwx "$copy" 2> /dev/null || true
    rm -rf "$copy"
  fi
  if [ -n "$moved_git" ]; then
    chmod -R u+rwx "$moved_git" 2> /dev/null || true
    rm -rf "$moved_git"
  fi
  if [ -n "$note" ]; then
    rm -f "$note"
  fi
  copy=""
  note=""
  moved_git=""
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
# The state walked just before the one in hand; E4's entry names it.
previous_walked_id=""

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
    E2-merge) echo "A repository with a merge left in progress by a conflict." ;;
    E2-rebase) echo "A repository with a rebase left in progress by a conflict." ;;
    E2-cherry-pick) echo "A repository with a cherry-pick left in progress by a conflict." ;;
    E2-revert) echo "A repository with a revert left in progress by a conflict." ;;
    E2-bisect) echo "A repository with a bisect in progress, started between a good commit and a bad one." ;;
    E2-am) echo "A repository with an am session left in progress by a patch that does not apply." ;;
    E2-detached) echo "A repository with HEAD detached at a commit." ;;
    E3) echo "A repository with $E3_FILE_COUNT files in its working tree." ;;
    E4) echo "A plain folder, with no repository at its root." ;;
    E5) echo "A repository whose .git has had every permission removed." ;;
    E6) echo "A folder whose .git/config holds a line that is not Git config syntax." ;;
    E7) echo "A repository whose index file has had every permission removed." ;;
    E8-1) echo "A folder whose .git file names a Git directory outside the folder." ;;
    E8-2) echo "A repository whose .git/config sets a path outside the folder." ;;
    E8-3) echo "A repository whose .git/config sets a path whose destination cannot be worked out." ;;
    E8-4) echo "A repository whose object store names another store outside the folder." ;;
    E8-5) echo "A repository whose object store names another store whose destination cannot be worked out." ;;
    E8-6) echo "A repository whose .gitmodules gives a submodule a path that leads somewhere else." ;;
    E8-7) echo "A folder that has had every permission removed." ;;
    E8-8) echo "A repository whose .git has had every permission removed." ;;
    E8-9) echo "A folder whose .git is a link." ;;
    E8-10) echo "A folder whose .git file names a Git directory that is not there." ;;
    E8-11) echo "A folder whose .git folder holds no repository." ;;
    E8-12) echo "A repository whose .gitmodules has had every permission removed." ;;
    E9) echo "A repository whose .git has had every permission removed. After the first look, its permissions are given back while KA-Reader stays open." ;;
    E10) echo "A repository with nothing changed. After the first look, a file is edited, then staged, then committed, from outside KA-Reader while it stays open." ;;
    E11) echo "A repository. After the first look, its .git is moved out of the folder while KA-Reader stays open." ;;
    E12) echo "A plain folder, with no repository at its root. After the first look, a repository is created at its root with git init while KA-Reader stays open." ;;
    E13) echo "A repository. Between the sidebar's switches, a tracked file is changed from outside KA-Reader while it stays open." ;;
    *) die "no description of state $1" ;;
  esac
}

# The state's account of what the scene did, never of what the person did.
done_of() {
  case "$1" in
    E3) echo "The scene launched KA-Reader and asked for the folder above to be chosen in the Open panel, and for Git to be chosen as soon as the file tree appeared." ;;
    E4) echo "The scene launched KA-Reader right after the launch for $previous_walked_id, and asked for the folder above to be chosen in the Open panel." ;;
    E9|E10|E11|E12) echo "The scene launched KA-Reader and asked for the folder above to be chosen in the Open panel. After the first look, it made the change above from outside KA-Reader and asked for a second look." ;;
    E13) echo "The scene launched KA-Reader and asked for the folder above to be chosen in the Open panel, then for Git, Files and Git to be chosen in turn. Between Files and the second Git, it changed a tracked file from outside KA-Reader." ;;
    *) echo "The scene launched KA-Reader and asked for the folder above to be chosen in the Open panel." ;;
  esac
}

# The rules of the spec's Examples that the state is judged against.
rules_of() {
  case "$1" in
    E1|E2-*) echo "CP-1304 CP-1305" ;;
    E3|E4) echo "CP-1306" ;;
    E5|E8-*) echo "CP-1307 CP-1310" ;;
    E6|E7) echo "CP-1308" ;;
    E9|E13) echo "CP-1309 CP-1310" ;;
    E10|E11) echo "CP-1309" ;;
    E12) echo "CP-1306 CP-1309" ;;
    *) die "no rules for state $1" ;;
  esac
}

# The entry for state $1, whole, on standard output.
print_entry() {
  printf '%s\n' "## $1"
  printf '%s\n' "- Built from: $built_from"
  printf '%s\n' "- On disk: $(on_disk_of "$1")"
  printf '%s\n' "- Done: $(done_of "$1")"
  case "$1" in
    E9|E10|E11|E12|E13)
      for look in "first look" "second look"; do
        printf '%s\n' "- The Git view showed ($look): $FILL"
        printf '%s\n' "- The head of the file tree showed ($look): $FILL"
        printf '%s\n' "- Letters beside the file tree's entries ($look): $FILL"
      done
      ;;
    *)
      printf '%s\n' "- The Git view showed: $FILL"
      printf '%s\n' "- The head of the file tree showed: $FILL"
      printf '%s\n' "- Letters beside the file tree's entries: $FILL"
      ;;
  esac
  for rule in $(rules_of "$1"); do
    printf '%s\n' "- Verdict against $rule: $FILL"
  done
}

# --- the staging of a state ---

# A setup step that could not be taken ends the walk: $1 is the step as it was run, $2 its status.
setup_stopped() {
  stop_walk "$state_id" "$state_id: setting up this state's folder stopped when $1 exited with status $2, so KA-Reader was not launched for it and the walk ends here."
}

# Runs git on the copy alone. The guest's own config is out of the way (no system config, no global
# one), the commit identity is the scene's, and nothing is signed or opens an editor, so no machine
# shapes a state. Output goes to standard output.
git_raw() {
  env GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null GIT_EDITOR=true GIT_TERMINAL_PROMPT=0 \
    git -C "$copy" -c user.name="$SCENE_AUTHOR_NAME" -c user.email="$SCENE_AUTHOR_EMAIL" -c commit.gpgsign=false "$@"
}

# As git_raw, with git's output on standard error: standard output holds the entries and nothing else.
git_in_copy() {
  git_raw "$@" 1>&2
}

# One step that must succeed: $@ are git's arguments.
step() {
  step_status=0
  git_in_copy "$@" || step_status=$?
  [ "$step_status" -eq 0 ] || setup_stopped "git $*" "$step_status"
}

# One step that leaves an operation in progress: $1 is the files under .git, any one of which shows
# the operation is there; the rest are git's arguments. Git ends such a step with a failure status,
# so the status is not read; the operation being there is.
step_leaving() {
  markers="$1"
  shift
  step_status=0
  git_in_copy "$@" || step_status=$?
  for marker in $markers; do
    if [ -e "$copy/.git/$marker" ]; then
      return 0
    fi
  done
  setup_stopped "git $*" "$step_status"
}

# Sets the last line of the day's notes: the one line every conflict in these states is about.
set_plan() {
  printf '# Today\n\n%s\n' "$1" > "$copy/notes/today.md" || setup_stopped "writing notes/today.md" "$?"
}

# A repository with the fixture's files in one commit, on a branch named main.
init_repository() {
  step init -q
  step symbolic-ref HEAD refs/heads/main
  step add -A
  step commit -q -m "Start the scene folder"
}

# Two branches that changed the same line of the notes: main, and topic from the first commit. The
# copy is left on main.
init_conflicting_pair() {
  init_repository
  step checkout -q -b topic
  set_plan "The topic branch plans a walk."
  step commit -q -a -m "Plan a walk on the topic branch"
  step checkout -q main
  set_plan "Main plans a reading."
  step commit -q -a -m "Plan a reading on main"
}

# The files of E3: E3_FILE_COUNT empty files in folders of E3_FILES_PER_FOLDER, written into the
# copy at run time and committed nowhere. The names are relative and hold no space.
write_bulk_files() {
  say "E3: writing $E3_FILE_COUNT files into the working tree."
  (
    cd "$copy" || exit 1
    awk -v total="$E3_FILE_COUNT" -v per="$E3_FILES_PER_FOLDER" \
      'BEGIN { for (n = 0; n < total; n += per) printf "bulk/d%05d\n", n / per }' | xargs mkdir -p
    awk -v total="$E3_FILE_COUNT" -v per="$E3_FILES_PER_FOLDER" \
      'BEGIN { for (n = 0; n < total; n++) printf "bulk/d%05d/f%05d.txt\n", int(n / per), n }' | xargs touch
  ) || setup_stopped "writing the files of the working tree" "$?"
}

# E3's hold (see E3'S HOLD in the header). Makes the start pipe at the copy's .gitignore, which the
# fixture does not hold, and puts the hold pipe in the place of .git/info/exclude. Both come after
# init_repository and write_bulk_files, so git add -A never meets one. Then starts the one holder in
# the background and records its pid. The holder opens the start pipe for writing, which returns once
# the product's read opens it, and so is its wait for that read. It then checks that the hold pipe is
# still there: if it is not, the scene is ending, and it goes without waiting. Otherwise it waits
# E3_HOLD_SECONDS and opens the hold pipe for writing, which lets the read go on. It writes nothing
# and reads nothing, and its errors go nowhere. It keeps this script's standard output as it was
# given, on purpose: a holder that outlived the script would then keep the caller's pipe open, which
# is how a caller sees that something the script started is still running. It does not run this
# script's cleanup on its way out. Started in the background, it ignores INT, so only the release
# ends it.
start_the_hold() {
  start_pipe="$copy/.gitignore"
  hold_pipe="$copy/.git/info/exclude"
  mkdir -p "$copy/.git/info" || setup_stopped "mkdir -p .git/info" "$?"
  mkfifo "$start_pipe" || setup_stopped "mkfifo .gitignore" "$?"
  rm -f "$hold_pipe" || setup_stopped "rm -f .git/info/exclude" "$?"
  mkfifo "$hold_pipe" || setup_stopped "mkfifo .git/info/exclude" "$?"
  (
    trap - EXIT
    : > "$start_pipe"
    [ -p "$hold_pipe" ] || exit 0
    sleep "$E3_HOLD_SECONDS"
    : > "$hold_pipe"
  ) 2> /dev/null < /dev/null &
  holder_pid=$!
}

# Writes the text $2 (with a final newline) to the path $1 below the copy, replacing what is there.
plant_file() {
  printf '%s\n' "$2" > "$copy/$1" || setup_stopped "writing $1" "$?"
}

# Takes every permission away from the path $1 below the copy ("." for the copy itself).
remove_permissions() {
  chmod 000 "$copy/$1" || setup_stopped "chmod 000 $1" "$?"
}

# Replaces the copy with the existing fixture $1 and the .git its archive holds, as the read-only
# steps consume them: checks/fixtures/$1 beside checks/fixtures/$1.git.tar.
use_archived_fixture() {
  rm -rf "$copy" || setup_stopped "rm -rf the copy" "$?"
  cp -R "$fixtures_root/$1" "$copy" || setup_stopped "cp -R $1" "$?"
  tar -xf "$fixtures_root/$1.git.tar" -C "$copy" || setup_stopped "tar -xf $1.git.tar" "$?"
}

# Stages state $1 in the copy, which holds the fixture and no .git. E4 is the fixture alone.
stage_state() {
  case "$1" in
    E1)
      init_repository
      printf 'A staged line.\n' >> "$copy/docs/guide.md" || setup_stopped "writing docs/guide.md" "$?"
      step add docs/guide.md
      printf 'A changed line.\n' >> "$copy/notes/today.md" || setup_stopped "writing notes/today.md" "$?"
      ;;
    E2-clean) init_repository ;;
    E2-merge)
      init_conflicting_pair
      step_leaving MERGE_HEAD merge topic
      ;;
    E2-rebase)
      init_conflicting_pair
      step checkout -q topic
      step_leaving "rebase-merge rebase-apply" rebase main
      ;;
    E2-cherry-pick)
      init_conflicting_pair
      step_leaving CHERRY_PICK_HEAD cherry-pick topic
      ;;
    E2-revert)
      init_repository
      set_plan "The first plan."
      step commit -q -a -m "Write the first plan"
      set_plan "The second plan."
      step commit -q -a -m "Write the second plan"
      step_leaving REVERT_HEAD revert --no-edit HEAD~1
      ;;
    E2-bisect)
      init_repository
      step commit -q --allow-empty -m "Second commit"
      step commit -q --allow-empty -m "Third commit"
      step commit -q --allow-empty -m "Fourth commit"
      step_leaving BISECT_LOG bisect start HEAD HEAD~3
      ;;
    E2-am)
      init_conflicting_pair
      patch_text="$(git_raw format-patch -1 --stdout topic)" || setup_stopped "git format-patch -1 --stdout topic" "$?"
      step_leaving "rebase-apply/applying" am <<< "$patch_text"
      ;;
    E2-detached)
      init_repository
      step checkout -q --detach
      ;;
    E3)
      init_repository
      write_bulk_files
      start_the_hold
      ;;
    E4) ;;
    E9)
      init_repository
      remove_permissions .git
      ;;
    E10 | E11 | E13) init_repository ;;
    E12) ;;
    E5)
      init_repository
      remove_permissions .git
      ;;
    E6)
      init_repository
      printf '[core\n\tbare = = nonsense\n' > "$copy/.git/config" || setup_stopped "writing .git/config" "$?"
      ;;
    E7)
      init_repository
      remove_permissions .git/index
      ;;
    E8-1) plant_file .git "gitdir: ../git-beta-scene-nowhere/.git" ;;
    E8-2) use_archived_fixture config-names-outside ;;
    E8-3)
      init_repository
      printf '[include]\n\tpath = ~/ka-reader-never-read.config\n' >> "$copy/.git/config" || setup_stopped "writing .git/config" "$?"
      ;;
    E8-4) use_archived_fixture alternates-names-outside ;;
    E8-5)
      init_repository
      mkdir -p "$copy/.git/objects/info" || setup_stopped "mkdir -p .git/objects/info" "$?"
      plant_file .git/objects/info/alternates "~/objects"
      ;;
    E8-6) use_archived_fixture gitmodules-names-outside ;;
    E8-7)
      init_repository
      remove_permissions .
      ;;
    E8-8)
      init_repository
      remove_permissions .git
      ;;
    E8-9) ln -s nowhere "$copy/.git" || setup_stopped "ln -s nowhere .git" "$?" ;;
    E8-10) plant_file .git "gitdir: .nothere" ;;
    E8-11)
      plant_file .git "gitdir: .realgit"
      mkdir "$copy/.realgit" || setup_stopped "mkdir .realgit" "$?"
      ;;
    E8-12)
      init_repository
      plant_file .gitmodules "# nothing"
      remove_permissions .gitmodules
      ;;
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
    # What a killed E11 moved out of its copy is this script's too: the note was there.
    rm -rf "$desktop/.git-beta-scene-$1.git"
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

# What the person is asked to look at in state $1.
say_the_look() {
  case "$1" in
    E3)
      say "E3: as soon as the file tree appears, choose Git in the sidebar and read what the Git view shows first, before it changes. Then choose Files and read what the head of the file tree shows, and whether letters stand beside its entries."
      say "E3: if the Git view already showed the repository's state when you first saw it, this state was not seen: write not seen in its verdicts, with what you did."
      ;;
    *)
      say "$1: choose Git in the sidebar and read every sentence the Git view shows, word for word. Then choose Files and read what the head of the file tree shows, and whether letters stand beside its entries."
      ;;
  esac
}

# Appends a line to the tracked file that E10 and E13 change.
change_the_tracked_file() {
  printf 'Changed from outside KA-Reader.\n' >> "$copy/$CHANGED_FILE" || setup_stopped "writing $CHANGED_FILE" "$?"
}

# The change state $1 makes from outside, once the person's Enter has come, each step said as it lands.
change_disk() {
  case "$1" in
    E9)
      chmod 755 "$copy/.git" || setup_stopped "chmod 755 .git" "$?"
      say "E9: gave .git its permissions back."
      ;;
    E10)
      change_the_tracked_file
      say "E10: changed $CHANGED_FILE."
      step add "$CHANGED_FILE"
      say "E10: staged $CHANGED_FILE with git add."
      step commit -q -m "Change the notes from outside KA-Reader"
      say "E10: committed $CHANGED_FILE with git commit."
      ;;
    E11)
      moved_git="$desktop/.git-beta-scene-E11.git"
      if [ -e "$moved_git" ] || [ -L "$moved_git" ]; then
        folder="$moved_git"
        moved_git=""
        stop_walk "$1" "$folder is there and is not a scene copy, so it is left alone and the walk ends here. Move it somewhere else and run the walk again."
      fi
      mv "$copy/.git" "$moved_git" || setup_stopped "mv .git out of the folder" "$?"
      say "E11: moved .git out of the folder."
      ;;
    E12)
      step init -q
      say "E12: created a repository at the folder's root with git init."
      ;;
    E13)
      change_the_tracked_file
      say "E13: changed $CHANGED_FILE."
      ;;
  esac
}

# The looks of state $1, each ended by the person's Enter and a capture.
look_at_state() {
  case "$1" in
    E9|E10|E11|E12)
      say_the_look "$1"
      if [ "$1" = "E10" ]; then
        say "E10: before you press Enter, open $CHANGED_FILE in the reading panel, so you can see it change."
      fi
      say "$1: press Enter here when you have looked, and the folder changes on disk while KA-Reader stays open."
      wait_for_enter "$1"
      capture_screen "$1" "$1-before"
      change_disk "$1"
      say "$1: the change is made. Without closing KA-Reader or choosing another folder, look at both surfaces again as before, then press Enter here."
      wait_for_enter "$1"
      capture_screen "$1" "$1-after"
      ;;
    E13)
      say "E13: choose Git in the sidebar, wait until the Git view shows the repository's state, read it, then press Enter here."
      wait_for_enter "$1"
      capture_screen "$1" "E13-first-look"
      say "E13: choose Files in the sidebar and read what the head of the file tree shows, then press Enter here, and a tracked file changes on disk."
      wait_for_enter "$1"
      capture_screen "$1" "E13-files"
      change_disk "$1"
      say "E13: choose Git in the sidebar again and read the Git view, word for word, then press Enter here."
      wait_for_enter "$1"
      capture_screen "$1" "E13-second-look"
      ;;
    *)
      say_the_look "$1"
      say "$1: press Enter here when you have looked."
      wait_for_enter "$1"
      capture_screen "$1" "$1"
      ;;
  esac
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
  look_at_state "$state_id"
  say "$state_id is walked to its end."
  stop_launched_process
  remove_copy
  walked_count=$((walked_count + 1))
  print_entry "$state_id"
  previous_walked_id="$state_id"
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

if [ "$e2_clean_added" -eq 1 ]; then
  say "E4 needs a launch on a repository right before it, so E2-clean is walked first."
fi

position=0
for walk_id in $run_ids; do
  position=$((position + 1))
  walk_state "$walk_id" "$position" "$total"
done

say "the walk is over, and every state it was given was walked to its end."
say "fill each entry's $FILL fields from what you saw in the window, word for word."

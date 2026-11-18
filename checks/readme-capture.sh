#!/usr/bin/env bash
# Version: 1.0.0 — first version: one run builds the bundle at HEAD, captures its window on a fixture
#   repository, and writes the README's picture and its record
#
# checks/readme-capture.sh — takes the README's picture of KA-Reader's window and writes its record.
# A person runs it in the macOS guest, from the product root. The gate does not run it.
#
# WHY THIS EXISTS
#   The README's opening shows a picture of KA-Reader's window, and checks/readme-picture.sh holds
#   that picture to a record of the version and the commit it was captured from. KA-Reader takes a
#   folder only from its Open panel, and no command drives its views (docs/SDD.md § 4 C-I3), so a
#   person chooses the folder and the file. This script does everything else the same way every run:
#   it builds the bundle from the commit it records, opens it on a fixture made from that commit's
#   own files, captures that one window, and writes the picture and the record together. Its cases
#   are checks/tests/test_readme_capture.sh.
#
# USAGE
#   checks/readme-capture.sh, from the product root, in the macOS guest. It takes no argument and
#   reads no variable of its own. stderr is the instructions to the person and the progress of the
#   run. stdout is one line, printed once the picture and the record are written.
#
# WHAT IT DOES
#   1. Admission: see ADMISSION below.
#   2. It looks up every program it runs on PATH, and stops, naming the program, when one is missing.
#   3. It makes one work folder under /tmp, and stops when that folder lies under the home folder.
#   4. It reads the full hash of HEAD, clones the product root into the work folder and checks that
#      hash out. It reads the version from that commit's Cargo.toml and ka-reader-mac/Info.plist, and
#      stops when the two differ. It runs the clone's own ka-reader-mac/assemble.sh with Cargo held
#      offline, so the build writes nothing into the repository and makes no network call.
#   5. It clones the product root again at the same hash, removes that clone's .git, and makes a new
#      repository there. Every file is committed except CHANGELOG.md, which stays untracked, so the
#      file tree shows a letter beside it. Git runs with a fixed identity and none of the machine's
#      own Git configuration.
#   6. It compiles checks/window_probe/main.swift into the work folder.
#   7. It launches the bundle with open -n, records the one new process, tells the person which
#      folder to choose and what to select, and waits for Enter.
#   8. On Enter, the window probe finds that process's one window on screen, and screencapture takes
#      that window alone, without its shadow, into the work folder.
#   9. It reads the picture's metadata through the window probe, and stops when the metadata holds
#      this account's login name, full name or home folder, or this machine's host name, computer
#      name or local host name. A name it cannot read stops the run too, except an empty full name.
#   10. Only then does it write docs/readme/shell.png and, last, docs/readme/shell.record.
#   On every way out it stops the one process it launched and removes the work folder.
#
# ADMISSION
#   The first thing the script does is ask the host whether it is a macOS virtual machine
#   (uname -s Darwin and sysctl -n kern.hv_vmm_present 1, both succeeding). On any other reading it
#   prints one line on stderr and exits 1, before it clones, builds, launches or reads anything else
#   (docs/nfdr.md QC-65). Nothing it is given turns this off.
#
# STATUSES (docs/nfdr.md QC-70)
#   0 once the picture and the record are written. 1 on a refusal, each one stderr line. A refusal
#   before step 10 has written nothing into the repository. 2 on a wrong invocation, with the usage
#   line on stderr, after admission and before anything else is read or launched. 130 on INT and 143
#   on TERM.
#
# THE PID
#   The recorded pid is the first process whose executable path is the bundle's one executable and
#   that was not running before open. A process of the same executable that was already running is
#   not this run's and is never named to kill.

set -euo pipefail

# --- admission: this step runs only in a macOS virtual machine (docs/nfdr.md QC-65) ---
# First work of the run, inline so nothing is opened, found or read before it. Both host readings
# must succeed and read exactly Darwin and 1; a reader that fails, is missing or prints anything
# else refuses, and a failing reader that prints 1 does not admit (the status is kept, not only the
# text). Nothing the script reads — argument, flag or variable — changes this.
host_os="$(uname -s 2> /dev/null)" && host_vmm="$(sysctl -n kern.hv_vmm_present 2> /dev/null)" \
  && [ "$host_os" = "Darwin" ] && [ "$host_vmm" = "1" ] \
  || { echo "readme-capture.sh: refused: this host does not read as a macOS virtual machine. This script launches KA-Reader.app, so it runs only in a macOS virtual machine (docs/nfdr.md QC-65): run it there, from the product root." >&2; exit 1; }

say() { echo "readme-capture.sh: $*" >&2; }
die() { say "$*"; exit 1; }

# The programs the script runs, each looked up on PATH by its own name. The bounds the later stages
# use are constants in this file and never variables (docs/nfdr.md QC-67).
REQUIRED_TOOLS="git open ps kill screencapture swiftc shasum mktemp id hostname scutil"
WORK_FOLDER_TEMPLATE="/tmp/ka-reader-picture.XXXXXX"
# The identity every fixture commit carries, so no machine's own shapes the picture.
FIXTURE_IDENTITY_NAME="KA-Reader Capture"
FIXTURE_IDENTITY_EMAIL="capture@example.invalid"
FIXTURE_COMMIT_MESSAGE="KA-Reader fixture"
# The one file the fixture leaves untracked, so its tree marks it with a changed-file letter.
FIXTURE_UNTRACKED_FILE="CHANGELOG.md"
# Where the clone's own assembly puts the bundle, relative to the clone.
BUNDLE_IN_CLONE="target/release/bundle/macos/KA-Reader.app"
# The window probe the capture compiles, and where it writes what it makes in the repository.
PROBE_SOURCE="checks/window_probe/main.swift"
PICTURE_PATH="docs/readme/shell.png"
RECORD_PATH="docs/readme/shell.record"
# The bounds, in ticks of 0.25 s, are constants (docs/nfdr.md QC-67): the wait for the new process
# is LAUNCH_POLL_TICKS of them, which is LAUNCH_WAIT_SECONDS, and the wait for a process to end
# after TERM is STOP_POLL_TICKS.
LAUNCH_WAIT_SECONDS=20
LAUNCH_POLL_TICKS=80
STOP_POLL_TICKS=20
# How long one read of the person's Enter lasts before the script looks for a signal.
ENTER_POLL_SECONDS=1

# The version, read as text as checks/readme-picture.sh reads it: Cargo.toml's one version line in
# its [workspace.package] table, and Info.plist's one <string> after its one
# CFBundleShortVersionString key. awk ends with 3 when the text holds none or more than one.
CARGO_VERSION_PROGRAM='
/^\[/ { in_table = ($0 ~ /^\[workspace\.package\][ \t]*$/); next }
in_table && /^version[ \t]*=[ \t]*"[^"]+"[ \t]*(#.*)?$/ {
  value = $0
  sub(/^version[ \t]*=[ \t]*"/, "", value)
  sub(/".*$/, "", value)
  count++
  found = value
}
END { if (count != 1) exit 3; print found }
'
PLIST_VERSION_PROGRAM='
{
  text = $0
  if (index(text, "<key>CFBundleShortVersionString</key>")) {
    keys++
    want = 1
    sub(/.*<key>CFBundleShortVersionString<\/key>/, "", text)
  }
  if (want) {
    if (text ~ /^[ \t\r]*$/) next
    if (match(text, /<string>[^<]+<\/string>/)) {
      strings++
      found = substr(text, RSTART + 8, RLENGTH - 17)
    }
    want = 0
  }
}
END { if (keys != 1 || strings != 1) exit 3; print found }
'

# --- the arguments ---

[ $# -eq 0 ] || { echo "Usage: checks/readme-capture.sh, run from the product root with no argument." >&2; exit 2; }

# --- the work folder and the way out ---

# Empty until the folder is made, so a run that stops before then has nothing to remove.
work=""

# The one pid this run launched. Empty until it has been found and recorded, so a run that never
# recorded one has nothing of its own to stop. kill_tool is the program, since `kill` alone is the
# shell's builtin.
launched_pid=""
kill_tool=""
# 1 from the moment the first file is written into docs/readme/, so an interruption says which.
writing=0

# Stops the process this run launched, with TERM and then KILL, and says so when it cannot.
stop_launched_process() {
  [ -n "$launched_pid" ] || return 0
  stopping_pid="$launched_pid"
  launched_pid=""
  "$kill_tool" -TERM "$stopping_pid" 2> /dev/null || true
  stop_ticks=0
  while "$kill_tool" -0 "$stopping_pid" 2> /dev/null && [ "$stop_ticks" -lt "$STOP_POLL_TICKS" ]; do
    sleep 0.25
    stop_ticks=$((stop_ticks + 1))
  done
  if "$kill_tool" -0 "$stopping_pid" 2> /dev/null; then
    "$kill_tool" -KILL "$stopping_pid" 2> /dev/null || true
    sleep 0.25
  fi
  if "$kill_tool" -0 "$stopping_pid" 2> /dev/null; then
    say "could not stop KA-Reader (pid $stopping_pid). Quit KA-Reader with Command-Q in its window."
  fi
}

# Removes the work folder, and says so when it cannot.
remove_work_folder() {
  [ -n "$work" ] && [ "$work" != "/" ] || return 0
  if [ -e "$work" ] || [ -L "$work" ]; then
    rm -rf "$work" 2> /dev/null || true
  fi
  if [ -e "$work" ] || [ -L "$work" ]; then
    say "could not remove the work folder $work. Remove it with rm -rf $work."
  fi
}

# Runs on every way out: the process first, so nothing is left running over a removed folder. The
# status stands: a cleanup that ends the run on its own would hide the status that did.
cleanup() {
  stop_launched_process
  remove_work_folder
}
trap cleanup EXIT

interrupted() {
  if [ "$writing" -eq 1 ]; then
    say "interrupted by $1 after it began writing into docs/readme/, so $PICTURE_PATH and $RECORD_PATH may not agree. Run checks/readme-capture.sh from the product root to write both again."
  else
    say "interrupted by $1 before anything was written into the repository. Run checks/readme-capture.sh from the product root to capture again."
  fi
  exit "$2"
}
trap 'interrupted INT 130' INT
trap 'interrupted TERM 143' TERM

# --- the tools ---

# `type -P` finds a program only as a file on PATH, so a builtin of the same name (`kill`) is not
# taken for the program, and a case that leaves one off PATH is refused.
for tool in $REQUIRED_TOOLS; do
  type -P "$tool" > /dev/null 2>&1 \
    || die "$tool was not found on PATH, so nothing was cloned, built or launched. Put $tool on PATH, then run checks/readme-capture.sh from the product root."
done

kill_tool="$(type -P kill)"

[ -n "${HOME:-}" ] \
  || die "HOME is not set, so nothing was cloned, built or launched. Run checks/readme-capture.sh from a login shell, where HOME is set."

# --- the work folder ---

work="$(mktemp -d "$WORK_FOLDER_TEMPLATE" 2> /dev/null)" \
  || die "could not make a work folder under /tmp, so nothing was cloned, built or launched. Check that /tmp can be written, then run checks/readme-capture.sh from the product root."
case "$work" in
  "$HOME" | "$HOME"/*)
    die "the work folder $work lies under the home folder $HOME, so nothing was cloned, built or launched. The fixture is kept outside every folder of yours: run checks/readme-capture.sh on a guest where /tmp lies outside the home folder."
    ;;
esac

# --- the commit, and the clones that are built and shown ---

# Git runs with none of the machine's own configuration, the one fixed identity, no signing and no
# hook, so no machine shapes a build clone or the fixture.
git_isolated() {
  GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null GIT_EDITOR=true GIT_TERMINAL_PROMPT=0 \
    git -c user.name="$FIXTURE_IDENTITY_NAME" -c user.email="$FIXTURE_IDENTITY_EMAIL" -c commit.gpgsign=false -c core.hooksPath=/dev/null "$@"
}

root="$(pwd)"
commit="$(git_isolated -C "$root" rev-parse HEAD 2> /dev/null)" || commit=""
case "$commit" in
  *[!0-9a-f]* | "") commit="" ;;
esac
[ "${#commit}" -eq 40 ] \
  || die "could not read the commit at HEAD in $root, so nothing was cloned, built or launched. Run checks/readme-capture.sh from the root of a product checkout that has a commit."

# --- the build ---

build="$work/build"
say "building KA-Reader.app from commit $commit in $build, with Cargo held offline."
git_isolated clone --quiet --no-hardlinks "$root" "$build" > /dev/null 2>&1 \
  || die "could not clone $root into $build, so nothing was built or launched. Check that /tmp has room and can be written, then run checks/readme-capture.sh from the product root."
git_isolated -C "$build" checkout --quiet --detach "$commit" > /dev/null 2>&1 \
  || die "could not check out commit $commit in $build, so nothing was built or launched. Run checks/readme-capture.sh again from the product root."

cargo_version="$(LC_ALL=C awk "$CARGO_VERSION_PROGRAM" "$build/Cargo.toml" 2> /dev/null)" \
  || die "Cargo.toml at commit $commit holds no single version line in its [workspace.package] table, so nothing was built or launched. Commit Cargo.toml with exactly one version line there, then run checks/readme-capture.sh from the product root."
plist_version="$(LC_ALL=C awk "$PLIST_VERSION_PROGRAM" "$build/ka-reader-mac/Info.plist" 2> /dev/null)" \
  || die "ka-reader-mac/Info.plist at commit $commit holds no single <string> after <key>CFBundleShortVersionString</key>, so nothing was built or launched. Commit Info.plist with exactly one such key and its <string>, then run checks/readme-capture.sh from the product root."
[ "$cargo_version" = "$plist_version" ] \
  || die "at commit $commit, Cargo.toml carries version $cargo_version and ka-reader-mac/Info.plist carries $plist_version, so nothing was built or launched. Commit the same version in both, then run checks/readme-capture.sh from the product root."
version="$cargo_version"

# Cargo held offline: a crate missing from the guest's cache stops the build rather than being
# fetched. The build's own output goes to stderr, where the person reads it, and it reads no input.
assemble_status=0
CARGO_NET_OFFLINE=true "$build/ka-reader-mac/assemble.sh" 1>&2 < /dev/null || assemble_status=$?
[ "$assemble_status" -eq 0 ] \
  || die "ka-reader-mac/assemble.sh exited with status $assemble_status in $build, so nothing was launched or written. The build runs with Cargo held offline, and a crate missing from this guest's Cargo cache stops it. If Cargo's output names a crate it could not get, run checks/gate.sh once in this guest to fill the cache, then run checks/readme-capture.sh from the product root."
bundle="$build/$BUNDLE_IN_CLONE"
[ -d "$bundle" ] \
  || die "ka-reader-mac/assemble.sh finished, and $bundle is not there, so nothing was launched or written. Check where ka-reader-mac/assemble.sh puts KA-Reader.app at commit $commit, then run checks/readme-capture.sh from the product root."
# Absolute and with links resolved, because `ps` names a process by its physical executable path.
bundle="$(cd "$bundle" && pwd -P)"
# The bundle's one executable, found by its absolute path and never by a pattern over command lines.
bundle_executable=""
executable_count=0
for candidate in "$bundle"/Contents/MacOS/*; do
  [ -e "$candidate" ] || continue
  bundle_executable="$candidate"
  executable_count=$((executable_count + 1))
done
[ "$executable_count" -eq 1 ] \
  || die "$bundle does not hold exactly one executable under Contents/MacOS, so nothing was launched or written. Check what ka-reader-mac/assemble.sh built at commit $commit, then run checks/readme-capture.sh from the product root."
say "built $bundle, version $version."

# --- the fixture ---

# One step of making the fixture: $1 is the step as a person would type it, the rest is the command.
fixture="$work/ka-reader"
fixture_step() {
  step_name="$1"
  shift
  "$@" > /dev/null 2>&1 \
    || die "$step_name did not complete while making the fixture at $fixture, so nothing was launched or written. Check that /tmp has room and can be written, then run checks/readme-capture.sh from the product root."
}

say "making the fixture repository at $fixture from the files of commit $commit."
fixture_step "git clone" git_isolated clone --quiet --no-hardlinks "$root" "$fixture"
fixture_step "git clone" git_isolated -C "$fixture" checkout --quiet --detach "$commit"
# The clone's own .git goes, so no path of the person's repository survives in the fixture.
fixture_step "rm -rf .git" rm -rf "$fixture/.git"
fixture_step "git init" git_isolated -C "$fixture" init --quiet
fixture_step "git symbolic-ref HEAD refs/heads/main" git_isolated -C "$fixture" symbolic-ref HEAD refs/heads/main
fixture_step "git add" git_isolated -C "$fixture" add -- . ":(exclude)$FIXTURE_UNTRACKED_FILE"
fixture_step "git commit" git_isolated -C "$fixture" commit --quiet -m "$FIXTURE_COMMIT_MESSAGE"
say "the fixture repository is ready at $fixture, with $FIXTURE_UNTRACKED_FILE left untracked."

# --- the window probe ---

# Compiled into the work folder with the flags checks/app-icon.sh uses for checks/icon_probe/main.swift.
# The compiler's output is kept for the refusal line, and the compile reads no input.
probe="$work/window-probe"
say "compiling $PROBE_SOURCE into $work."
compile_status=0
compile_output="$(swiftc -swift-version 6 -warnings-as-errors -strict-memory-safety "$root/$PROBE_SOURCE" -o "$probe" 2>&1 < /dev/null)" || compile_status=$?
[ "$compile_status" -eq 0 ] \
  || die "swiftc could not compile checks/window_probe/main.swift, so nothing was launched or written. Check the Swift toolchain with swift --version, then run checks/readme-capture.sh from the product root. swiftc printed: $compile_output"

# --- the launch ---

# The pids of the bundle's executable now running, by its absolute path. An unreadable listing reads
# as none found.
executable_pids() {
  { ps -axo pid=,comm= 2> /dev/null || true; } | while read -r candidate_pid candidate_path; do
    if [ "$candidate_path" = "$bundle_executable" ]; then
      echo "$candidate_pid"
    fi
  done
}

say "launching $bundle with open -n."
before="$(executable_pids)"
open_status=0
open -n "$bundle" < /dev/null > /dev/null 2>&1 || open_status=$?
[ "$open_status" -eq 0 ] \
  || die "open -n $bundle exited with status $open_status, so nothing was captured or written. Run checks/readme-capture.sh again from a terminal in the guest's own window, where KA-Reader's Open panel can be seen."

# The one new pid: a process of the same executable that was running before open is not this run's.
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
  || die "no new KA-Reader process appeared within $LAUNCH_WAIT_SECONDS seconds of open -n, so nothing was captured or written. Run checks/readme-capture.sh again from a terminal in the guest's own window, where KA-Reader's Open panel can be seen."

say "KA-Reader is running (pid $launched_pid). If its window is not in front, click KA-Reader in the Dock."
say "in its Open panel, press Shift-Command-G, type $fixture, press Return, then click Open."
say "keep Files chosen in the sidebar, and select a file in the file tree so its content is in the reading panel. The file, the theme and the window's size are yours to choose: once the picture is committed, the README's opening shows it."
say "when the window shows what the picture should show, press Enter here. Only KA-Reader's window is captured, without its shadow."
# The wait is a read of one second at a time: a signal that has a trap is not acted on while a read
# blocks (the shell's own rule), so the trap runs between the slices and the run ends at once. A read
# that times out ends with a status above 128, and a line or the end of the input ends the loop.
while :; do
  enter_status=0
  IFS= read -r -t "$ENTER_POLL_SECONDS" _ || enter_status=$?
  [ "$enter_status" -gt 128 ] || break
done
[ "$enter_status" -eq 0 ] \
  || die "the input ended before Enter, so nothing was captured or written. Run checks/readme-capture.sh again from a terminal where you can press Enter."

# --- the capture ---

# The probe prints the window number, or on stderr how many windows the process owns, and exits 1.
window_status=0
window="$("$probe" window "$launched_pid" 2> "$work/window-probe.err" < /dev/null)" || window_status=$?
if [ "$window_status" -ne 0 ]; then
  window_count="$(sed -n 's/.* owns \([0-9][0-9]*\) on-screen windows.*/\1/p' "$work/window-probe.err")"
  case "$window_count" in
    0) die "KA-Reader (pid $launched_pid) has no window on screen, so nothing was captured or written. Run checks/readme-capture.sh again, and keep KA-Reader's window on screen, not minimized, when you press Enter." ;;
    "") die "the window probe could not read the list of windows on screen, so nothing was captured or written. Run checks/readme-capture.sh again from a terminal in the guest's own window." ;;
    *) die "KA-Reader (pid $launched_pid) has $window_count windows on screen, and the capture takes one, so nothing was captured or written. Run checks/readme-capture.sh again, and keep one KA-Reader window open when you press Enter." ;;
  esac
fi
case "$window" in
  "" | *[!0-9]*)
    die "the window probe could not read the list of windows on screen, so nothing was captured or written. Run checks/readme-capture.sh again from a terminal in the guest's own window."
    ;;
esac

say "capturing window $window of KA-Reader (pid $launched_pid)."
picture="$work/shell.png"
capture_status=0
screencapture -x -o -l"$window" "$picture" < /dev/null > /dev/null 2>&1 || capture_status=$?
[ "$capture_status" -eq 0 ] \
  || die "screencapture exited with status $capture_status, so nothing was written into the repository. Check that this terminal may record the screen in System Settings › Privacy & Security › Screen & System Audio Recording, then run checks/readme-capture.sh from the product root."
[ -s "$picture" ] \
  || die "screencapture wrote an empty file, so nothing was written into the repository. Check that this terminal may record the screen in System Settings › Privacy & Security › Screen & System Audio Recording, then run checks/readme-capture.sh from the product root."
printf '\211PNG\r\n\032\n' > "$work/png-signature"
head -c 8 "$picture" | cmp -s - "$work/png-signature" \
  || die "the file screencapture wrote is not a PNG, so nothing was written into the repository. Run checks/readme-capture.sh again from the product root."

# --- the metadata ---

# The decoded properties only, never the raw file: compressed pixel data can hold any short byte
# string by chance. Every name is read before any is compared, so an unreadable one refuses the run.
say "checking the picture's metadata for this machine's names."
metadata_status=0
"$probe" metadata "$picture" > "$work/metadata.txt" 2> /dev/null < /dev/null || metadata_status=$?
[ "$metadata_status" -eq 0 ] \
  || die "the window probe could not read the picture's metadata, so nothing was written into the repository. Run checks/readme-capture.sh again from the product root."

login_name="$(id -un 2> /dev/null)" && [ -n "$login_name" ] \
  || die "could not read this account's login name, so the picture's metadata cannot be checked for it and nothing was written into the repository. Run checks/readme-capture.sh from a login shell of this guest's account."
# An empty full name is no refusal: there is nothing to look for.
full_name="$(id -F 2> /dev/null)" \
  || die "could not read this account's full name, so the picture's metadata cannot be checked for it and nothing was written into the repository. Run checks/readme-capture.sh from a login shell of this guest's account."
host_name="$(hostname 2> /dev/null)" && [ -n "$host_name" ] \
  || die "could not read this machine's host name, so the picture's metadata cannot be checked for it and nothing was written into the repository. Give this guest a host name with sudo scutil --set HostName <name>, then run checks/readme-capture.sh from the product root."
computer_name="$(scutil --get ComputerName 2> /dev/null)" && [ -n "$computer_name" ] \
  || die "could not read this machine's computer name, so the picture's metadata cannot be checked for it and nothing was written into the repository. Give this guest a computer name with sudo scutil --set ComputerName <name>, then run checks/readme-capture.sh from the product root."
local_host_name="$(scutil --get LocalHostName 2> /dev/null)" && [ -n "$local_host_name" ] \
  || die "could not read this machine's local host name, so the picture's metadata cannot be checked for it and nothing was written into the repository. Give this guest a local host name with sudo scutil --set LocalHostName <name>, then run checks/readme-capture.sh from the product root."

# True when the decoded properties hold $1 as a fixed string. An empty name holds nothing to look for.
metadata_holds() {
  [ -n "$1" ] && grep -F -q -e "$1" "$work/metadata.txt"
}

if metadata_holds "$login_name"; then
  die "the picture's metadata holds this account's login name, $login_name, so nothing was written into the repository. Run checks/readme-capture.sh again from an account whose login name is not in it."
fi
if metadata_holds "$full_name"; then
  die "the picture's metadata holds this account's full name, $full_name, so nothing was written into the repository. Run checks/readme-capture.sh again from an account whose full name is not in it."
fi
if metadata_holds "$HOME"; then
  die "the picture's metadata holds this account's home folder, $HOME, so nothing was written into the repository. Run checks/readme-capture.sh again from an account whose home folder is not in it."
fi
if metadata_holds "$host_name"; then
  die "the picture's metadata holds this machine's host name, $host_name, so nothing was written into the repository. Give this guest another host name with sudo scutil --set HostName <name>, then run checks/readme-capture.sh from the product root."
fi
if metadata_holds "$computer_name"; then
  die "the picture's metadata holds this machine's computer name, $computer_name, so nothing was written into the repository. Give this guest another computer name with sudo scutil --set ComputerName <name>, then run checks/readme-capture.sh from the product root."
fi
if metadata_holds "$local_host_name"; then
  die "the picture's metadata holds this machine's local host name, $local_host_name, so nothing was written into the repository. Give this guest another local host name with sudo scutil --set LocalHostName <name>, then run checks/readme-capture.sh from the product root."
fi
say "the picture's metadata holds none of this machine's names."

# --- the write ---

# The record is made in the work folder first, so the two writes into the repository are each a
# copy: the picture, then the record. A run interrupted between them leaves a picture with no
# matching record, which checks/readme-picture.sh names.
picture_digest="$(shasum -a 256 "$picture" 2> /dev/null)" || picture_digest=""
picture_digest="${picture_digest%% *}"
[ "${#picture_digest}" -eq 64 ] \
  || die "shasum could not read the picture $picture, so neither the picture nor the record was written. Run checks/readme-capture.sh again from the product root."
printf 'picture: %s\nversion: %s\ncommit: %s\nsha256: %s\n' "$PICTURE_PATH" "$version" "$commit" "$picture_digest" > "$work/shell.record"

writing=1
{ mkdir -p "$root/docs/readme" && cp "$picture" "$root/$PICTURE_PATH"; } 2> /dev/null \
  || die "could not write $PICTURE_PATH, so neither the picture nor the record was written. Check that docs/readme/ in $root can be written, then run checks/readme-capture.sh from the product root."
cp "$work/shell.record" "$root/$RECORD_PATH" 2> /dev/null \
  || die "wrote $PICTURE_PATH, and could not write $RECORD_PATH, so the picture has no record written with it. Check that docs/readme/ in $root can be written, then run checks/readme-capture.sh from the product root to write both again."
writing=0

# --- the close ---

# The script stages nothing: staging writes the index, and inside the repository it writes the
# picture and the record only.
echo "readme-capture.sh: wrote $PICTURE_PATH and $RECORD_PATH, captured from KA-Reader $version built at commit $commit."
say "look at $PICTURE_PATH before you commit it: once it is committed, the README's opening shows it. If the README's opening has no image line naming $PICTURE_PATH, add one after the description sentence. Then commit $PICTURE_PATH, $RECORD_PATH and the README's image line together: checks/readme-picture.sh exits 1 on a tree that holds only some of them."

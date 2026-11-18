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

# Removes the work folder, and says so when it cannot. Runs on every way out.
remove_work_folder() {
  [ -n "$work" ] && [ "$work" != "/" ] || return 0
  if [ -e "$work" ] || [ -L "$work" ]; then
    rm -rf "$work" 2> /dev/null || true
  fi
  if [ -e "$work" ] || [ -L "$work" ]; then
    say "could not remove the work folder $work. Remove it with rm -rf $work."
  fi
}

# The status stands: a cleanup that ends the run on its own would hide the status that did.
trap remove_work_folder EXIT

interrupted() {
  say "interrupted by $1 before anything was written into the repository. Run checks/readme-capture.sh from the product root to capture again."
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

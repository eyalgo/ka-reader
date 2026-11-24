#!/usr/bin/env bash
# Version: 1.0.0 — first version: the capture's admission, usage, tool lookup, work folder, build,
#   fixture, launch, capture, metadata check, write and close, and the scan that holds it to no
#   variable of its own and no network tool
#
# checks/tests/test_readme_capture.sh — the cases of checks/readme-capture.sh.
#
# WHY THIS EXISTS
#   The capture builds the bundle, launches it and writes the README's picture (docs/nfdr.md QC-65,
#   QC-67, QC-70). Each case builds a scratch product root and runs the real script there under
#   `/usr/bin/env -i`, with a PATH made only of directories this suite built: the host's shell, its
#   ordinary text and file tools and shasum, each linked in by name, and a stand-in for every other
#   program the script runs. Each stand-in logs its calls to a file the case reads. `uname` and
#   `sysctl` answer as the case sets, `mktemp` makes its folder inside the case's scratch so nothing
#   lands in the real /tmp, and HOME points into the scratch. `sleep` is a stand-in too, one that
#   returns at once, so the script's launch bound of eighty ticks takes no real time. `open` records
#   a process in the list `ps` prints, `kill` stops it, `screencapture` writes the PNG the case
#   supplies and `swiftc` writes a probe whose two modes reply as the case sets. No case runs the
#   host's git, tar or cargo.
#
# THE RECORDED GIT REPLIES
#   The stand-in `git` replays replies recorded once from the real `git` and committed as data under
#   checks/tests/support/readme_capture_git_replies/. A call with no recorded reply is answered with
#   status 99, and the call is in the log.
#
# USAGE
#   checks/tests/test_readme_capture.sh
#   It runs every case, always: it reads no case selector and no variable of its own.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
GATE="$ROOT/checks/gate.sh"
TAB=$'\t'
SCRIPT="$ROOT/checks/readme-capture.sh"
REPLIES="$ROOT/checks/tests/support/readme_capture_git_replies"
# Recorded once for the picture check's suite; the capture's pass case replays its `ls-files` hit.
PICTURE_REPLIES="$ROOT/checks/tests/support/readme_picture_git_replies"
# The hash the git stand-in prints for `rev-parse HEAD`, and so the one the build must be held to.
COMMIT_HASH="3f2a9c1d5e7b40816a2c9d4e1f0b7a5c3d8e6f19"
TOOLS="bash awk sed grep cat tr head wc cmp cp mkdir rm shasum"
# The eleven programs the script looks up, each of which a case may leave off PATH.
LOOKED_UP="git open ps kill screencapture swiftc shasum mktemp id hostname scutil"
# Every stand-in the harness builds; a program the suite links in as an ordinary tool is not one.
STAND_INS="uname sysctl git open ps kill screencapture swiftc mktemp id hostname scutil sleep"

WORK=""
SUB=""

CASES="
test_off_a_vm_it_exits_non_zero_having_launched_nothing_and_read_nothing
test_any_argument_is_a_usage_error_before_anything_is_launched
test_a_missing_tool_is_refused_before_anything_is_made
test_a_work_folder_under_the_home_is_refused
test_the_work_folder_is_removed_on_every_way_out
test_the_bundle_is_built_from_the_recorded_commit_offline
test_versions_that_disagree_are_refused_before_the_build
test_the_fixture_is_a_fresh_repository_outside_the_home
test_a_failed_clone_checkout_build_or_fixture_step_is_refused_and_cleaned_up
test_the_capture_reads_the_versions_by_the_checks_own_rules
test_one_run_writes_the_picture_and_the_record_and_the_check_then_passes
test_the_run_waits_for_enter_until_the_person_presses_it
test_an_interrupted_run_removes_everything_it_made
test_each_refusal_writes_nothing_in_the_repository
test_a_picture_whose_metadata_names_the_machine_is_refused
test_the_capture_reads_no_variable_of_its_own_and_names_no_network_tool
test_the_suite_is_one_fatal_step_before_the_real_launch
"

# --- messages: the plain form, or the form that opens with the sub-case's label ---

fail() {
  if [ -n "$SUB" ]; then
    echo "  $SUB: $*"
  else
    echo "  $*"
  fi
  return 1
}

# --- the fixture ---

# Writes one stand-in: it logs its arguments, then runs the body the harness gives it.
stand_in() {
  name="$1"
  body="$2"
  {
    echo '#!/usr/bin/env bash'
    echo "printf '%s\\n' \"\$*\" >> \"$logs/$name.log\""
    printf '%s\n' "$body"
  } > "$bin/$name"
  chmod +x "$bin/$name"
}

# Fills the placeholders of a stand-in's text with this scene's folders.
render() {
  sed -e "s|@SCENE@|$scene|g" -e "s|@REPLIES@|$REPLIES|g" -e "s|@PICTURE_REPLIES@|$PICTURE_REPLIES|g"
}

# The `git` stand-in: it logs the isolation it was run under and its arguments, then replays the
# recorded reply for the call, unless the case names that call in git_fail. A clone writes the
# scene's clone source into its destination, with a .git of its own, as the real clone writes the
# repository's files and its history.
write_git_stand_in() {
  render > "$bin/git" <<'STAND_IN'
#!/usr/bin/env bash
scene="@SCENE@"
replies="@REPLIES@"
picture_replies="@PICTURE_REPLIES@"
printf 'config=%s,%s args=%s\n' "${GIT_CONFIG_NOSYSTEM:-}" "${GIT_CONFIG_GLOBAL:-}" "$*" >> "$scene/log/git.log"
dir=""
sub=""
while [ $# -gt 0 ]; do
  case "$1" in
    -C) dir="$2"; shift 2;;
    -c) shift 2;;
    *) sub="$1"; shift; break;;
  esac
done
fail="$(cat "$scene/git_fail")"
replay() {
  [ ! -f "$replies/$1.stdout" ] || cat "$replies/$1.stdout"
  [ ! -f "$replies/$1.stderr" ] || cat "$replies/$1.stderr" >&2
  exit "$(cat "$replies/$1.status")"
}
case "$sub" in
  rev-parse)
    [ "$fail" != rev-parse ] || replay rev_parse_not_a_repository
    cat "$scene/hash"
    exit "$(cat "$replies/rev_parse_head.status")";;
  clone)
    for last; do :; done
    case "$last" in */build) kind=clone-build;; *) kind=clone-fixture;; esac
    [ "$fail" != "$kind" ] || replay clone_fail
    mkdir -p "$last"
    cp -R "$scene/clone_source/." "$last"
    mkdir -p "$last/.git"
    replay clone_ok;;
  checkout)
    case "$dir" in */build) kind=checkout-build;; *) kind=checkout-fixture;; esac
    [ "$fail" != "$kind" ] || replay checkout_fail
    replay checkout_ok;;
  init)
    [ "$fail" != init ] || replay init_fail
    if [ -e "$dir/.git" ]; then echo present > "$scene/log/init_state"; else echo absent > "$scene/log/init_state"; fi
    mkdir -p "$dir/.git"
    replay init_ok;;
  symbolic-ref)
    [ "$fail" != symbolic-ref ] || replay init_fail
    replay symbolic_ref_ok;;
  add)
    [ "$fail" != add ] || replay add_fail
    replay add_ok;;
  commit)
    [ "$fail" != commit ] || replay commit_fail
    replay commit_ok;;
  ls-files)
    cat "$picture_replies/ls_files_hit.stdout"
    exit "$(cat "$picture_replies/ls_files_hit.status")";;
  *)
    echo "stand-in git: no recorded reply for: $sub" >&2
    exit 99;;
esac
STAND_IN
  chmod +x "$bin/git"
}

# What a clone of the product holds: the two files the versions are read from, the clone's own
# ka-reader-mac/assemble.sh (a stand-in that records its environment and writes a bundle folder
# holding one executable),
# and a CHANGELOG.md for the fixture to leave untracked.
write_clone_source() {
  source_root="$scene/clone_source"
  mkdir -p "$source_root/ka-reader-mac"
  printf '[workspace]\nmembers = []\n\n[workspace.package]\nversion = "0.1.0"\nedition = "2024"\n' > "$source_root/Cargo.toml"
  printf '<plist version="1.0">\n<dict>\n  <key>CFBundleShortVersionString</key>\n  <string>0.1.0</string>\n</dict>\n</plist>\n' > "$source_root/ka-reader-mac/Info.plist"
  printf 'changes\n' > "$source_root/CHANGELOG.md"
  printf 'readme\n' > "$source_root/README.md"
  render > "$source_root/ka-reader-mac/assemble.sh" <<'STAND_IN'
#!/usr/bin/env bash
scene="@SCENE@"
printf 'ran=%s\nCARGO_NET_OFFLINE=%s\n' "$0" "${CARGO_NET_OFFLINE:-}" >> "$scene/log/assemble.log"
bundle="${0%/*}/../target/release/bundle/macos/KA-Reader.app"
case "$(cat "$scene/assemble_bundle")" in
  yes) mkdir -p "$bundle/Contents/MacOS"; : > "$bundle/Contents/MacOS/ka-reader";;
  empty) mkdir -p "$bundle/Contents/MacOS";;
esac
exit "$(cat "$scene/assemble_status")"
STAND_IN
  chmod +x "$source_root/ka-reader-mac/assemble.sh"
}

# Sets the two versions the next clone carries, each a word.
set_versions() {
  sed -e "s|^version = .*|version = \"$1\"|" "$scene/clone_source/Cargo.toml" > "$scene/cargo.next"
  mv "$scene/cargo.next" "$scene/clone_source/Cargo.toml"
  sed -e "s|<string>.*</string>|<string>$2</string>|" "$scene/clone_source/ka-reader-mac/Info.plist" > "$scene/plist.next"
  mv "$scene/plist.next" "$scene/clone_source/ka-reader-mac/Info.plist"
}

# A stand-in whose body is the text on standard input, run with $scene set to this scene's folder.
stand_in_script() {
  name="$1"
  {
    echo '#!/usr/bin/env bash'
    echo "scene=\"$scene\""
    echo "printf '%s\\n' \"\$*\" >> \"\$scene/log/$name.log\""
    cat
  } > "$bin/$name"
  chmod +x "$bin/$name"
}

# The stand-ins for the launch, the capture, the probe and the names the metadata is held against.
# Every one answers from a file of the scene, so a case sets its reply by writing that file.
write_launch_stand_ins() {
  printf 'ok\n' > "$scene/screencapture_mode"
  printf '0\n' > "$scene/open_status"
  printf 'start\n' > "$scene/open_mode"
  printf '4242\n' > "$scene/launch_pid"
  printf 'no\n' > "$scene/ps_before_mode"
  printf 'normal\n' > "$scene/kill_mode"
  printf '0\n' > "$scene/swiftc_status"
  printf 'one\n' > "$scene/probe_window"
  printf '31337\n' > "$scene/window_number"
  printf '0\n' > "$scene/probe_metadata_status"
  printf 'container.PixelWidth = 10\nimage.PixelHeight = 10\n' > "$scene/probe_metadata"
  printf 'scratchuser\n' > "$scene/login_name"
  printf 'Scratch Person\n' > "$scene/full_name"
  printf 'scratchhost\n' > "$scene/host_name"
  printf 'Scratch Computer\n' > "$scene/computer_name"
  printf 'scratch-local\n' > "$scene/local_host_name"
  printf 'none\n' > "$scene/unreadable"
  printf '\211PNG\r\n\032\nstand-in pixels\n' > "$scene/png_source"
  printf '\n' > "$scene/stdin"
  : > "$scene/running"
  : > "$scene/stopped"
  stand_in_script sleep <<'STAND_IN'
exit 0
STAND_IN
  stand_in_script open <<'STAND_IN'
[ "$(cat "$scene/open_status")" = 0 ] || exit "$(cat "$scene/open_status")"
if [ "$(cat "$scene/open_mode")" = start ]; then
  for exe in "$2"/Contents/MacOS/*; do :; done
  printf '%s %s\n' "$(cat "$scene/launch_pid")" "$exe" >> "$scene/running"
fi
exit 0
STAND_IN
  stand_in_script ps <<'STAND_IN'
if [ "$(cat "$scene/ps_before_mode")" = yes ]; then
  for exe in "$scene"/tmp/ka-reader-picture.*/build/target/release/bundle/macos/KA-Reader.app/Contents/MacOS/*; do
    [ -f "$exe" ] || continue
    dir="$(cd "${exe%/*}" && pwd -P)"
    printf '777 %s/%s\n' "$dir" "${exe##*/}"
  done
fi
cat "$scene/running"
exit 0
STAND_IN
  stand_in_script kill <<'STAND_IN'
case "$1" in
  -0)
    awk -v wanted="$2" '$1 == wanted { found = 1 } END { exit !found }' "$scene/running" || exit 1
    ! grep -q -x -F -e "$2" "$scene/stopped" || exit 1
    exit 0;;
  *)
    [ "$(cat "$scene/kill_mode")" = stubborn ] || printf '%s\n' "$2" >> "$scene/stopped"
    exit 0;;
esac
STAND_IN
  stand_in_script screencapture <<'STAND_IN'
for last; do :; done
case "$(cat "$scene/screencapture_mode")" in
  fail) exit 5;;
  empty) : > "$last"; exit 0;;
  notpng) printf 'not a png\n' > "$last"; exit 0;;
  *) cp "$scene/png_source" "$last"; exit 0;;
esac
STAND_IN
  render > "$scene/probe_template" <<'PROBE'
#!/usr/bin/env bash
scene="@SCENE@"
printf '%s\n' "$*" >> "$scene/log/probe.log"
case "$1" in
  window)
    case "$(cat "$scene/probe_window")" in
      one) cat "$scene/window_number"; exit 0;;
      zero) echo "ka-reader-window-probe: process $2 owns 0 on-screen windows at layer 0, and exactly 1 is needed" >&2; exit 1;;
      two) echo "ka-reader-window-probe: process $2 owns 2 on-screen windows at layer 0, and exactly 1 is needed" >&2; exit 1;;
      *) echo "ka-reader-window-probe: cannot read the list of windows on screen" >&2; exit 1;;
    esac;;
  metadata)
    [ "$(cat "$scene/probe_metadata_status")" = 0 ] || { echo "ka-reader-window-probe: cannot open $2 as an image" >&2; exit 1; }
    cat "$scene/probe_metadata"
    exit 0;;
esac
exit 2
PROBE
  chmod +x "$scene/probe_template"
  stand_in_script swiftc <<'STAND_IN'
status="$(cat "$scene/swiftc_status")"
if [ "$status" != 0 ]; then
  echo "main.swift:1:1: error: stand-in compile error" >&2
  exit "$status"
fi
out=""
while [ $# -gt 0 ]; do
  [ "$1" != -o ] || out="$2"
  shift
done
cp "$scene/probe_template" "$out"
exit 0
STAND_IN
  stand_in_script id <<'STAND_IN'
case "$*" in
  -un) reader=login; file=login_name;;
  -F) reader=full; file=full_name;;
  *) exit 1;;
esac
[ "$(cat "$scene/unreadable")" != "$reader" ] || exit 1
cat "$scene/$file"
STAND_IN
  stand_in_script hostname <<'STAND_IN'
[ "$(cat "$scene/unreadable")" != host ] || exit 1
cat "$scene/host_name"
STAND_IN
  stand_in_script scutil <<'STAND_IN'
case "$*" in
  "--get ComputerName") reader=computer; file=computer_name;;
  "--get LocalHostName") reader=local; file=local_host_name;;
  *) exit 1;;
esac
[ "$(cat "$scene/unreadable")" != "$reader" ] || exit 1
cat "$scene/$file"
STAND_IN
}

# Builds one scene: the PATH directory, the scratch product root, the home, the stand-ins and their
# logs. $1, when given, is a program the scene leaves off PATH.
fixture() {
  left_off="${1:-}"
  scene="$(mktemp -d "$WORK/scene.XXXXXX")"
  bin="$scene/bin"
  tree="$scene/root"
  home="$scene/home"
  logs="$scene/log"
  mkdir -p "$bin" "$tree/checks" "$home" "$scene/tmp" "$logs"
  for tool in $TOOLS; do
    ln -s "$(command -v "$tool")" "$bin/$tool"
  done
  printf 'Darwin\n' > "$scene/host_os"
  printf '0\n' > "$scene/uname_status"
  printf '1\n' > "$scene/host_vmm"
  printf '0\n' > "$scene/sysctl_status"
  printf 'scratch\n' > "$scene/mktemp_mode"
  : > "$scene/made"
  : > "$logs/git.log"
  stand_in uname "cat \"$scene/host_os\"; exit \"\$(cat \"$scene/uname_status\")\""
  stand_in sysctl "cat \"$scene/host_vmm\"; exit \"\$(cat \"$scene/sysctl_status\")\""
  : > "$scene/git_fail"
  printf '%s\n' "$COMMIT_HASH" > "$scene/hash"
  printf '0\n' > "$scene/assemble_status"
  printf 'yes\n' > "$scene/assemble_bundle"
  write_git_stand_in
  write_clone_source
  write_launch_stand_ins
  stand_in mktemp "
case \"\$(cat \"$scene/mktemp_mode\")\" in
  under_home) parent=\"$home\" ;;
  *) parent=\"$scene/tmp\" ;;
esac
folder=\"\$parent/ka-reader-picture.\$\$\"
mkdir -p \"\$folder\"
printf '%s\\n' \"\$folder\" >> \"$scene/made\"
printf '%s\\n' \"\$folder\""
  if [ -n "$left_off" ]; then
    rm -f "$bin/$left_off"
  fi
  cp "$SCRIPT" "$tree/checks/readme-capture.sh"
  chmod +x "$tree/checks/readme-capture.sh"
  printf 'the product root, as the scratch holds it\n' > "$tree/README.md"
}

# The tree as a list of paths and digests, to hold a run to no change.
snapshot() {
  (cd "$1" && find . -type f -exec shasum -a 256 {} \; | LC_ALL=C sort)
}

# Runs the real script in the scratch product root, under env -i with only the built PATH and a
# HOME inside the scratch. Standard input is the scene's stdin file: one Enter, unless the case sets it.
run_capture() {
  before="$(snapshot "$tree")"
  status=0
  (cd "$tree" && /usr/bin/env -i PATH="$bin" HOME="$home" "$tree/checks/readme-capture.sh" "$@") < "$scene/stdin" > "$scene/out" 2> "$scene/err" || status=$?
  stdout="$(cat "$scene/out")"
  stderr="$(cat "$scene/err")"
  after="$(snapshot "$tree")"
}

# --- assertions ---

expect_status() {
  [ "$status" -eq "$1" ] || fail "expected exit $1, got $status. stderr: $stderr"
}

expect_one_stderr_line() {
  [ -n "$stderr" ] && [ "$(printf '%s\n' "$stderr" | wc -l | tr -d ' ')" -eq 1 ] || fail "expected one line on stderr, got: $stderr"
}

expect_stderr_names() {
  case "$stderr" in
    *"$1"*) ;;
    *) fail "stderr does not name $1: $stderr";;
  esac
}

expect_usage_line() {
  case "$stderr" in
    *"Usage: checks/readme-capture.sh"*) ;;
    *) fail "stderr carries no usage line. stderr: $stderr";;
  esac
}

# Each stand-in named is one the case expects untouched.
expect_untouched() {
  for untouched in "$@"; do
    [ ! -s "$logs/$untouched.log" ] || fail "the $untouched stand-in was called: $(cat "$logs/$untouched.log")" || return 1
  done
}

expect_nothing_launched() {
  expect_untouched git open ps kill screencapture swiftc || return 1
}

expect_product_root_unchanged() {
  [ "$before" = "$after" ] || fail "something was written into the product root: $(diff <(printf '%s\n' "$before") <(printf '%s\n' "$after") | tr '\n' ' ')"
}

# Every folder the mktemp stand-in made is gone.
expect_work_folders_gone() {
  while IFS= read -r made_folder; do
    [ -z "$made_folder" ] || [ ! -e "$made_folder" ] || fail "the work folder is still there: $made_folder" || return 1
  done < "$scene/made"
}

# The stderr lines that are no progress line of the script: the refusals.
refusal_lines() {
  printf '%s\n' "$stderr" | grep -v -E "^readme-capture.sh: (building |built |making the fixture|the fixture repository is ready|compiling |launching |KA-Reader is running|in its Open panel|keep Files|when the window shows|capturing window|checking the picture|the picture's metadata holds none)" || true
}

# A refusal is one line among the progress lines the run printed before it.
expect_one_refusal() {
  [ "$(refusal_lines | grep -c .)" -eq 1 ] || fail "expected one line on stderr, got: $stderr"
}

# Nothing was launched, and the build did not run.
expect_nothing_started() {
  expect_untouched open ps kill screencapture swiftc || return 1
  [ ! -s "$logs/assemble.log" ] || fail "the ka-reader-mac/assemble.sh stand-in was called: $(cat "$logs/assemble.log")"
}

# Nothing under docs/readme/ and nothing else new in the product root.
expect_nothing_written() {
  [ ! -e "$tree/docs/readme" ] || fail "something was written into the product root: docs/readme" || return 1
  expect_product_root_unchanged
}

# True when one line of the git log holds every fragment given.
git_log_line() {
  matched="$(cat "$logs/git.log")"
  for fragment in "$@"; do
    matched="$(printf '%s\n' "$matched" | grep -F -e "$fragment" || true)"
  done
  [ -n "$matched" ]
}

# --- cases ---

# CP-1372, QC-65: off a virtual machine the script refuses with one line, having launched, cloned,
# built and read nothing.
test_off_a_vm_it_exits_non_zero_having_launched_nothing_and_read_nothing() {
  SUB="sysctl reads 0"
  fixture
  printf '0\n' > "$scene/host_vmm"
  run_capture
  expect_status 1 && expect_one_stderr_line && expect_untouched git open swiftc mktemp || return 1

  SUB="uname reads another system"
  fixture
  printf 'Linux\n' > "$scene/host_os"
  run_capture
  expect_status 1 && expect_one_stderr_line && expect_untouched git open swiftc mktemp || return 1

  SUB="uname fails while printing Darwin"
  fixture
  printf '1\n' > "$scene/uname_status"
  run_capture
  expect_status 1 && expect_one_stderr_line && expect_untouched git open swiftc mktemp || return 1

  SUB="sysctl fails while printing 1"
  fixture
  printf '1\n' > "$scene/sysctl_status"
  run_capture
  expect_status 1 && expect_one_stderr_line && expect_untouched git open swiftc mktemp || return 1
  SUB=""
}

# QC-70: any argument is exit 2 with the usage line, after admission and before anything is made.
test_any_argument_is_a_usage_error_before_anything_is_launched() {
  SUB="one argument"
  fixture
  run_capture one
  expect_status 2 && expect_usage_line && expect_nothing_launched && expect_untouched mktemp \
    && expect_product_root_unchanged || return 1

  SUB="two arguments"
  fixture
  run_capture one two
  expect_status 2 && expect_usage_line && expect_nothing_launched && expect_untouched mktemp \
    && expect_product_root_unchanged || return 1
  SUB=""
}

# Each of the eleven programs, left off PATH in turn, is refused by name before a work folder is made.
test_a_missing_tool_is_refused_before_anything_is_made() {
  for missing in $LOOKED_UP; do
    SUB="$missing left off PATH"
    fixture "$missing"
    run_capture
    expect_status 1 && expect_one_stderr_line && expect_stderr_names "$missing was not found on PATH" || return 1
    expect_nothing_launched || return 1
    made="$(find "$scene/tmp" "$home" -mindepth 1)"
    [ -z "$made" ] || fail "a work folder was made: $made" || return 1
  done
  SUB=""
}

# A work folder that lies under HOME is refused with one line, and removed on the way out.
test_a_work_folder_under_the_home_is_refused() {
  fixture
  printf 'under_home\n' > "$scene/mktemp_mode"
  run_capture
  expect_status 1 && expect_one_stderr_line && expect_stderr_names "lies under the home folder" || return 1
  expect_nothing_launched || return 1
  [ -s "$scene/made" ] || fail "the mktemp stand-in made no folder: $(cat "$logs/mktemp.log")" || return 1
  expect_work_folders_gone
}

# The work folder is gone after each way out the script has so far: the refusal for a missing tool,
# the refusal for a folder under the home, and the script's own end.
test_the_work_folder_is_removed_on_every_way_out() {
  SUB="a missing tool"
  fixture swiftc
  run_capture
  expect_status 1 && expect_work_folders_gone || return 1

  SUB="a work folder under the home"
  fixture
  printf 'under_home\n' > "$scene/mktemp_mode"
  run_capture
  expect_status 1 && expect_work_folders_gone || return 1

  SUB="the script's own end"
  fixture
  real_tmp_before="$(ls -d /tmp/ka-reader-picture.* 2> /dev/null || true)"
  run_capture
  real_tmp_after="$(ls -d /tmp/ka-reader-picture.* 2> /dev/null || true)"
  expect_status 0 || return 1
  [ -s "$scene/made" ] || fail "the mktemp stand-in made no folder: $(cat "$logs/mktemp.log")" || return 1
  expect_work_folders_gone || return 1
  [ "$real_tmp_before" = "$real_tmp_after" ] || fail "the work folder is still there: $real_tmp_after" || return 1
  SUB=""
}

# CP-1367, CP-1371: the bundle is built in a clone checked out at exactly the hash HEAD gave, by the
# clone's own assemble.sh, with Cargo held offline.
test_the_bundle_is_built_from_the_recorded_commit_offline() {
  fixture
  run_capture
  expect_status 0 || return 1
  work_folder="$(head -1 "$scene/made")"
  tree_real="$(cd "$tree" && pwd -P)"
  git_log_line "rev-parse HEAD" || fail "the build clone was not checked out at $COMMIT_HASH: $(cat "$logs/git.log")" || return 1
  git_log_line "clone --quiet --no-hardlinks $tree_real $work_folder/build" \
    || fail "the build clone was not checked out at $COMMIT_HASH: $(cat "$logs/git.log")" || return 1
  git_log_line "-C $work_folder/build" "checkout --quiet --detach $COMMIT_HASH" \
    || fail "the build clone was not checked out at $COMMIT_HASH: $(cat "$logs/git.log")" || return 1
  [ -s "$logs/assemble.log" ] || fail "the assemble.sh that ran is not the build clone's: nothing ran" || return 1
  grep -F -x -q "ran=$work_folder/build/ka-reader-mac/assemble.sh" "$logs/assemble.log" \
    || fail "the assemble.sh that ran is not the build clone's: $(cat "$logs/assemble.log")" || return 1
  grep -F -x -q "CARGO_NET_OFFLINE=true" "$logs/assemble.log" \
    || fail "assemble.sh did not see CARGO_NET_OFFLINE=true: $(cat "$logs/assemble.log")" || return 1
}

# CP-1374: the two versions are read from the clone and must agree, before the build runs.
test_versions_that_disagree_are_refused_before_the_build() {
  SUB="Cargo.toml at 0.1.0 and Info.plist at 0.2.0"
  fixture
  set_versions 0.1.0 0.2.0
  run_capture
  expect_status 1 && expect_one_refusal && expect_stderr_names "0.1.0" && expect_stderr_names "0.2.0" \
    && expect_nothing_started && expect_nothing_written || return 1

  SUB="Cargo.toml holds no version"
  fixture
  sed -e '/^version/d' "$scene/clone_source/Cargo.toml" > "$scene/cargo.next"
  mv "$scene/cargo.next" "$scene/clone_source/Cargo.toml"
  run_capture
  expect_status 1 && expect_one_refusal && expect_stderr_names "Cargo.toml" \
    && expect_nothing_started && expect_nothing_written || return 1

  SUB="Info.plist holds no version"
  fixture
  sed -e '/CFBundleShortVersionString/d' "$scene/clone_source/ka-reader-mac/Info.plist" > "$scene/plist.next"
  mv "$scene/plist.next" "$scene/clone_source/ka-reader-mac/Info.plist"
  run_capture
  expect_status 1 && expect_one_refusal && expect_stderr_names "ka-reader-mac/Info.plist" \
    && expect_nothing_started && expect_nothing_written || return 1
  SUB=""
}

# CP-1371, CP-1368: the fixture is a fresh repository made from the commit's own files, outside the
# home, with CHANGELOG.md left untracked, under the isolated config and the fixed identity.
test_the_fixture_is_a_fresh_repository_outside_the_home() {
  fixture
  run_capture
  expect_status 0 || return 1
  work_folder="$(head -1 "$scene/made")"
  fixture_folder="$work_folder/ka-reader"
  tree_real="$(cd "$tree" && pwd -P)"
  case "$fixture_folder" in
    "$scene/tmp"/*) ;;
    *) fail "the fixture $fixture_folder is not under the stand-in mktemp's folder" || return 1;;
  esac
  case "$fixture_folder" in
    "$home"/*) fail "the fixture $fixture_folder is under HOME" || return 1;;
  esac
  git_log_line "clone --quiet --no-hardlinks $tree_real $fixture_folder" \
    || fail "the git log does not show git clone in the fixture: $(cat "$logs/git.log")" || return 1
  for expected in "init --quiet" "symbolic-ref HEAD refs/heads/main" "commit --quiet"; do
    git_log_line "config=1,/dev/null" "-C $fixture_folder" "user.name=" "user.email=" "commit.gpgsign=false" "$expected" \
      || fail "the git log does not show $expected in the fixture under the isolated config and the fixed identity: $(cat "$logs/git.log")" || return 1
  done
  git_log_line "config=1,/dev/null" "-C $fixture_folder" "add -- . :(exclude)CHANGELOG.md" \
    || fail "the git log does not show git add in the fixture under the isolated config and the fixed identity: $(cat "$logs/git.log")" || return 1
  [ "$(grep -c -F 'CHANGELOG.md' "$logs/git.log")" -eq 1 ] || fail "git add included CHANGELOG.md: $(cat "$logs/git.log")" || return 1
  [ "$(cat "$logs/init_state")" = absent ] || fail "the fixture holds a .git of the product's when git init runs" || return 1
  for writing in "-C $tree_real init" "-C $tree_real add" "-C $tree_real commit" "-C $tree_real symbolic-ref"; do
    ! git_log_line "$writing" || fail "a git command ran in the product root: $(cat "$logs/git.log")" || return 1
  done
  expect_stderr_names "$fixture_folder"
}

# Each stage that can fail, failing in turn, is one stderr line, exit 1, nothing in the product root
# and the work folder gone. The three added at the end are the edges the stages themselves imply.
test_a_failed_clone_checkout_build_or_fixture_step_is_refused_and_cleaned_up() {
  for failing in clone-build checkout-build assemble clone-fixture checkout-fixture init symbolic-ref add commit rev-parse bundle-missing; do
    SUB="$failing fails"
    fixture
    case "$failing" in
      assemble) printf '3\n' > "$scene/assemble_status";;
      bundle-missing) printf 'no\n' > "$scene/assemble_bundle";;
      *) printf '%s\n' "$failing" > "$scene/git_fail";;
    esac
    run_capture
    expect_status 1 && expect_one_refusal && expect_untouched open ps kill screencapture swiftc && expect_nothing_written || return 1
    expect_work_folders_gone || return 1
    case "$failing" in
      assemble) expect_stderr_names "exited with status 3" || return 1;;
      bundle-missing) expect_stderr_names "is not there" || return 1;;
    esac
  done
  SUB=""
}

# The launched process, recorded by the `open` stand-in as pid 4242, was sent TERM.
expect_launched_process_stopped() {
  grep -F -q -e "-TERM 4242" "$logs/kill.log" 2> /dev/null || fail "the launched process 4242 was not stopped: $(cat "$logs/kill.log" 2> /dev/null)"
}

# No process was launched, so none was stopped.
expect_no_process_stopped() {
  [ ! -s "$logs/kill.log" ] || fail "the kill stand-in was called, with no process launched: $(cat "$logs/kill.log")"
}

# What a refusal after the launch leaves: one line, nothing in the repository, the work folder gone and
# the launched process stopped.
expect_clean_refusal_after_launch() {
  expect_status 1 && expect_one_refusal && expect_nothing_written && expect_work_folders_gone && expect_launched_process_stopped
}

# CP-1370, CP-1374: one run, with Enter on standard input, writes the picture and the record, and
# the real check then passes on the tree that holds them with the README line, tracked.
test_one_run_writes_the_picture_and_the_record_and_the_check_then_passes() {
  SUB="a run to the end"
  fixture
  run_capture
  expect_status 0 || return 1
  work_folder="$(head -1 "$scene/made")"
  new_entries="$(printf '%s\n' "$after" | grep -v -F -x -f <(printf '%s\n' "$before") || true)"
  new_paths="$(printf '%s\n' "$new_entries" | awk '{ print $2 }' | LC_ALL=C sort | tr '\n' ' ')"
  [ "$new_paths" = "./docs/readme/shell.png ./docs/readme/shell.record " ] \
    || fail "the new entries in the product root are not the picture and the record alone: $new_paths" || return 1
  [ "$(printf '%s\n' "$before" | grep -v -F -x -f <(printf '%s\n' "$after") | wc -l | tr -d ' ')" -eq 0 ] \
    || fail "an entry of the product root was changed or removed" || return 1
  cmp -s "$scene/png_source" "$tree/docs/readme/shell.png" || fail "docs/readme/shell.png is not the supplied PNG's bytes" || return 1
  digest="$(shasum -a 256 "$scene/png_source" | awk '{ print $1 }')"
  expected_record="picture: docs/readme/shell.png
version: 0.1.0
commit: $COMMIT_HASH
sha256: $digest"
  [ "$(cat "$tree/docs/readme/shell.record")" = "$expected_record" ] \
    || fail "docs/readme/shell.record is not the four lines in order: $(cat "$tree/docs/readme/shell.record")" || return 1
  [ "$(wc -l < "$tree/docs/readme/shell.record" | tr -d ' ')" -eq 4 ] || fail "docs/readme/shell.record is not four lines" || return 1
  [ "$(printf '%s\n' "$stdout" | wc -l | tr -d ' ')" -eq 1 ] || fail "expected one stdout line, got: $stdout" || return 1
  case "$stdout" in
    *"docs/readme/shell.png"*"0.1.0"*"$COMMIT_HASH"*) ;;
    *) fail "the stdout line does not name the picture, the version and the commit: $stdout" || return 1;;
  esac
  expect_stderr_names "$work_folder/ka-reader" || return 1
  expect_stderr_names "after the row of links, before the ### Install heading" || return 1
  expect_work_folders_gone || return 1
  [ ! -e "$work_folder/build" ] && [ ! -e "$work_folder/ka-reader" ] || fail "a clone or the fixture is still there" || return 1
  expect_launched_process_stopped || return 1

  # The programs were asked what the task states: the probe compiled with the icon probe's flags, the
  # bundle opened as a new instance, the one window of the recorded pid captured alone and without its
  # shadow, and the picture read back through the probe's metadata mode.
  grep -F -q -e "-swift-version 6 -warnings-as-errors -strict-memory-safety" "$logs/swiftc.log" \
    || fail "swiftc was not run with the icon probe's flags: $(cat "$logs/swiftc.log")" || return 1
  grep -F -q -e "checks/window_probe/main.swift" "$logs/swiftc.log" \
    || fail "swiftc was not given checks/window_probe/main.swift: $(cat "$logs/swiftc.log")" || return 1
  grep -q -E -e '^-n .*/ka-reader-picture\.[^/]+/build/target/release/bundle/macos/KA-Reader\.app$' "$logs/open.log" \
    || fail "open was not run with -n on the built bundle: $(cat "$logs/open.log")" || return 1
  grep -F -x -q -e "window 4242" "$logs/probe.log" \
    || fail "the probe was not asked for the window of the launched pid: $(cat "$logs/probe.log")" || return 1
  grep -F -q -e "metadata $work_folder/shell.png" "$logs/probe.log" \
    || fail "the probe was not asked for the picture's metadata: $(cat "$logs/probe.log")" || return 1
  grep -F -x -q -e "-x -o -l31337 $work_folder/shell.png" "$logs/screencapture.log" \
    || fail "screencapture was not run on window 31337 alone, with no shadow: $(cat "$logs/screencapture.log")" || return 1

  # The real check, on the tree the capture wrote, with the README line and the picture tracked.
  cp "$ROOT/checks/readme-picture.sh" "$tree/checks/readme-picture.sh"
  chmod +x "$tree/checks/readme-picture.sh"
  mkdir -p "$tree/ka-reader-mac"
  cp "$scene/clone_source/Cargo.toml" "$tree/Cargo.toml"
  cp "$scene/clone_source/ka-reader-mac/Info.plist" "$tree/ka-reader-mac/Info.plist"
  printf 'The description.\n\n![The shell.](docs/readme/shell.png)\n' > "$tree/README.md"
  check_status=0
  (cd "$tree" && /usr/bin/env -i PATH="$bin" "$tree/checks/readme-picture.sh") > "$scene/check_out" 2> "$scene/check_err" || check_status=$?
  [ "$check_status" -eq 0 ] && [ ! -s "$scene/check_err" ] \
    || fail "the real check did not pass on the capture's output: exit $check_status, $(cat "$scene/check_err")" || return 1

  SUB="a process of the same executable was running before"
  fixture
  printf 'yes\n' > "$scene/ps_before_mode"
  run_capture
  expect_status 0 && expect_launched_process_stopped || return 1
  ! grep -q -e "777" "$logs/kill.log" || fail "a process that was running before open was named to kill: $(cat "$logs/kill.log")" || return 1
  SUB=""
}

# One signal sent to the run while it waits for Enter, in a shell of its own so job control, which
# the background job needs for INT to reach it, is on for this run alone. $1 is the signal and $2 the
# status it ends a run with.
interrupt_while_waiting_for_enter() {
  signal_name="$1"
  allowed="$2"
  SUB="$signal_name while waiting for Enter"
  fixture
  mkfifo "$scene/stdin_pipe"
  exec 3<> "$scene/stdin_pipe"
  before="$(snapshot "$tree")"
  cd "$tree" || return 1
  # One simple command in the background, so $! is the script's own pid. The fifo's write end is held
  # open, so standard input does not end.
  set -m
  /usr/bin/env -i PATH="$bin" HOME="$home" "$tree/checks/readme-capture.sh" < "$scene/stdin_pipe" > "$scene/out" 2> "$scene/err" &
  pid=$!
  waited=0
  while ! grep -q -F "press Enter here" "$scene/err" && [ "$waited" -lt 1200 ]; do
    sleep 0.05
    waited=$((waited + 1))
  done
  kill -s "$signal_name" "$pid" 2> /dev/null
  status=0
  wait "$pid" || status=$?
  set +m
  exec 3>&-
  stderr="$(cat "$scene/err")"
  after="$(snapshot "$tree")"
  if [ "$status" -ne "$allowed" ] && [ "$status" -ne 1 ]; then
    fail "ended with $status, expected $allowed or 1, never 0. stderr: $stderr" || return 1
  fi
  expect_launched_process_stopped && expect_work_folders_gone && expect_nothing_written
}

# Task 7's launch: the script tells the person what to do and then waits for Enter, for as long as the
# person takes. Standard input stays open with no line on it for longer than any slice the wait could
# be cut into; the run is still waiting, has captured and written nothing, and Enter then finishes it.
test_the_run_waits_for_enter_until_the_person_presses_it() {
  fixture
  mkfifo "$scene/stdin_pipe"
  exec 3<> "$scene/stdin_pipe"
  before="$(snapshot "$tree")"
  (cd "$tree" && exec /usr/bin/env -i PATH="$bin" HOME="$home" "$tree/checks/readme-capture.sh") \
    < "$scene/stdin_pipe" > "$scene/out" 2> "$scene/err" &
  pid=$!
  waited=0
  while ! grep -q -F "press Enter here" "$scene/err" && [ "$waited" -lt 1200 ]; do
    sleep 0.05
    waited=$((waited + 1))
  done
  grep -q -F "press Enter here" "$scene/err" || { exec 3>&-; wait "$pid"; fail "the run never asked for Enter: $(cat "$scene/err")"; return 1; }
  sleep 3
  still_waiting=0
  kill -0 "$pid" 2> /dev/null || still_waiting=1
  captured="$(cat "$logs/screencapture.log" 2> /dev/null || true)"
  printf '\n' >&3
  status=0
  wait "$pid" || status=$?
  exec 3>&-
  stderr="$(cat "$scene/err")"
  after="$(snapshot "$tree")"
  [ "$still_waiting" -eq 0 ] || fail "the run stopped waiting for Enter before the person pressed it: exit $status. stderr: $stderr" || return 1
  [ -z "$captured" ] || fail "the window was captured before Enter: $captured" || return 1
  expect_status 0 || return 1
  [ -f "$tree/docs/readme/shell.png" ] && [ -f "$tree/docs/readme/shell.record" ] \
    || fail "Enter did not finish the run with the picture and the record written. stderr: $stderr"
}

# Task 6's build reads the two versions "by the same rules as Task 1's check": the capture's two awk
# programs are the check's, line for line, so the version a record names is the one the check reads.
test_the_capture_reads_the_versions_by_the_checks_own_rules() {
  check="$ROOT/checks/readme-picture.sh"
  for pair in "CARGO_VERSION_PROGRAM:cargo_program" "PLIST_VERSION_PROGRAM:plist_program"; do
    capture_name="${pair%%:*}"
    check_name="${pair##*:}"
    capture_text="$(sed -n "/^$capture_name='\$/,/^'\$/p" "$SCRIPT")"
    check_text="$(sed -n "/^$check_name='\$/,/^'\$/p" "$check")"
    [ -n "$capture_text" ] || fail "checks/readme-capture.sh holds no $capture_name program" || return 1
    [ -n "$check_text" ] || fail "checks/readme-picture.sh holds no $check_name program" || return 1
    [ "$(printf '%s\n' "$capture_text" | sed '1d')" = "$(printf '%s\n' "$check_text" | sed '1d')" ] \
      || fail "the capture's $capture_name is not the check's $check_name, line for line" || return 1
  done
}

# QC-70: TERM and INT while the script waits for Enter end it with 143 and 130 (or 1, never 0), with
# the launched process stopped, the work folder gone and nothing in docs/readme/. A process that will
# not stop is named to the person.
test_an_interrupted_run_removes_everything_it_made() {
  (interrupt_while_waiting_for_enter TERM 143) || return 1
  (interrupt_while_waiting_for_enter INT 130) || return 1

  SUB="the launched process cannot be stopped"
  fixture
  printf 'stubborn\n' > "$scene/kill_mode"
  run_capture
  expect_status 0 && expect_stderr_names "could not stop KA-Reader (pid 4242)" || return 1
  grep -F -q -e "-KILL 4242" "$logs/kill.log" || fail "the process was not sent KILL after TERM: $(cat "$logs/kill.log")" || return 1
  SUB=""
}

# Each way the launch, the window, the capture or the probe can fail is one line, exit 1, nothing in
# the repository, the work folder gone and, once launched, the process stopped.
test_each_refusal_writes_nothing_in_the_repository() {
  SUB="the input ends before Enter"
  fixture
  : > "$scene/stdin"
  run_capture
  expect_clean_refusal_after_launch && expect_stderr_names "the input ended before Enter" || return 1

  SUB="open fails"
  fixture
  printf '3\n' > "$scene/open_status"
  run_capture
  expect_status 1 && expect_one_refusal && expect_nothing_written && expect_work_folders_gone \
    && expect_stderr_names "exited with status 3" && expect_no_process_stopped || return 1

  SUB="no new process appears"
  fixture
  printf 'noprocess\n' > "$scene/open_mode"
  run_capture
  expect_status 1 && expect_one_refusal && expect_nothing_written && expect_work_folders_gone \
    && expect_stderr_names "no new KA-Reader process appeared within 20 seconds" && expect_no_process_stopped || return 1

  SUB="the probe reports zero windows"
  fixture
  printf 'zero\n' > "$scene/probe_window"
  run_capture
  expect_clean_refusal_after_launch && expect_stderr_names "has no window on screen" || return 1

  SUB="the probe reports two windows"
  fixture
  printf 'two\n' > "$scene/probe_window"
  run_capture
  expect_clean_refusal_after_launch && expect_stderr_names "has 2 windows on screen" || return 1

  SUB="the probe cannot read the window list"
  fixture
  printf 'unreadable\n' > "$scene/probe_window"
  run_capture
  expect_clean_refusal_after_launch && expect_stderr_names "could not read the list of windows on screen" || return 1

  SUB="screencapture fails"
  fixture
  printf 'fail\n' > "$scene/screencapture_mode"
  run_capture
  expect_clean_refusal_after_launch && expect_stderr_names "screencapture exited with status 5" || return 1

  SUB="screencapture writes an empty file"
  fixture
  printf 'empty\n' > "$scene/screencapture_mode"
  run_capture
  expect_clean_refusal_after_launch && expect_stderr_names "screencapture wrote an empty file" || return 1

  SUB="screencapture writes a file that is not a PNG"
  fixture
  printf 'notpng\n' > "$scene/screencapture_mode"
  run_capture
  expect_clean_refusal_after_launch && expect_stderr_names "is not a PNG" || return 1

  SUB="the probe does not compile"
  fixture
  printf '1\n' > "$scene/swiftc_status"
  run_capture
  expect_status 1 && expect_one_refusal && expect_nothing_written && expect_work_folders_gone \
    && expect_stderr_names "swiftc could not compile checks/window_probe/main.swift" \
    && expect_stderr_names "stand-in compile error" && expect_untouched open ps kill screencapture || return 1

  SUB="the probe cannot read the picture's metadata"
  fixture
  printf '1\n' > "$scene/probe_metadata_status"
  run_capture
  expect_clean_refusal_after_launch && expect_stderr_names "could not read the picture's metadata" || return 1

  SUB="the bundle holds no executable"
  fixture
  printf 'empty\n' > "$scene/assemble_bundle"
  run_capture
  expect_status 1 && expect_one_refusal && expect_nothing_written && expect_work_folders_gone \
    && expect_stderr_names "exactly one executable" && expect_untouched open ps kill screencapture swiftc || return 1
  SUB=""
}

# CP-1369: the picture's decoded metadata is held against six names, each as a fixed string. A name
# found, or a name that cannot be read, holds the picture back, and an empty full name is nothing to
# look for.
test_a_picture_whose_metadata_names_the_machine_is_refused() {
  for held in "login name:scratchuser:login_name" "full name:Scratch Person:full_name" "home folder:@HOME@:" \
    "host name:scratchhost:host_name" "computer name:Scratch Computer:computer_name" "local host name:scratch-local:local_host_name"; do
    label="${held%%:*}"
    rest="${held#*:}"
    value="${rest%:*}"
    SUB="the metadata holds the $label"
    fixture
    [ "$value" != "@HOME@" ] || value="$home"
    printf 'container.Description = made for %s\n' "$value" > "$scene/probe_metadata"
    run_capture
    expect_clean_refusal_after_launch && expect_stderr_names "the picture's metadata holds this" && expect_stderr_names "$value" || return 1
  done

  for unreadable in login full host computer local; do
    SUB="the $unreadable name cannot be read"
    fixture
    printf '%s\n' "$unreadable" > "$scene/unreadable"
    run_capture
    expect_clean_refusal_after_launch && expect_stderr_names "could not read this" || return 1
  done

  SUB="the full name is empty"
  fixture
  : > "$scene/full_name"
  run_capture
  expect_status 0 && [ -f "$tree/docs/readme/shell.png" ] || fail "an empty full name refused the run, or nothing was written: $stderr" || return 1

  SUB="a name is in the picture's bytes and not in its properties"
  fixture
  printf '\211PNG\r\n\032\nscratchuser Scratch Person scratchhost\n' > "$scene/png_source"
  run_capture
  expect_status 0 && [ -f "$tree/docs/readme/shell.png" ] || fail "the raw bytes were searched, and the picture was refused: $stderr" || return 1
  SUB=""
}

# CP-1371, CP-1379: the script reads no variable of its own (no `${NAME:-` form but HOME, which the
# platform sets) and names no network tool. Layer 6: reads the script as text, comments removed.
test_the_capture_reads_no_variable_of_its_own_and_names_no_network_tool() {
  [ -f "$SCRIPT" ] || fail "checks/readme-capture.sh does not exist, so there is no text to scan" || return 1
  code="$(grep -v -E '^[[:space:]]*#' "$SCRIPT")"
  [ -n "$code" ] || fail "checks/readme-capture.sh holds no code to scan" || return 1
  own="$(printf '%s\n' "$code" | grep -E '\$\{[A-Za-z_][A-Za-z0-9_]*:-' | grep -v -F '${HOME:-' | head -1 || true)"
  [ -z "$own" ] || fail "checks/readme-capture.sh reads a variable of its own: $own" || return 1
  network="$(printf '%s\n' "$code" | grep -w -E 'curl|wget|nc|ssh|scp' | head -1 || true)"
  [ -z "$network" ] || fail "checks/readme-capture.sh names a network tool: $network" || return 1
  network="$(printf '%s\n' "$code" | grep -E 'git( -C [^ ]+)? (fetch|pull|push|remote)' | head -1 || true)"
  [ -z "$network" ] || fail "checks/readme-capture.sh names a network tool: $network" || return 1
}

# --- the gate, read as text ---

# The same reading of checks/gate.sh as checks/tests/test_readme_picture.sh makes, copied: each suite is its
# own runner and holds the helpers it uses.

# The steps of a gate file, one per line: the name, a tab, the command. Only a top-level call in the
# gate's literal form is read. From the first call to the end of the file, the list holds nothing
# but calls, comments and blank lines; any other line there is read as no list at all, because an
# `if` around a call or a `|| true` after it leaves a call that does not stop the run.
gate_steps_of() {
  [ -f "$1" ] || return 0
  first="$(grep -n -m 1 "^run_step '" "$1" | cut -d: -f1 || true)"
  [ -n "$first" ] || return 0
  stray="$(tail -n +"$first" "$1" | grep -v -E "^run_step '[^']*' '.*'\$|^[[:space:]]*(#.*)?\$" || true)"
  [ -z "$stray" ] || return 0
  sed -n "s/^run_step '\([^']*\)' '\(.*\)'\$/\1${TAB}\2/p" "$1"
}

# Holds the step $2 of the gate file $1 to its command $3 and its place $4 (`between:<after>:<before>`
# for a relative place, `directly_before:<name>` for an adjacent one). Each failure names itself and
# returns 1.
gate_step_holds() {
  gate_file="$1"; step="$2"; command="$3"; place="$4"
  steps="$(gate_steps_of "$gate_file")"
  count="$(printf '%s\n' "$steps" | awk -F'\t' -v want="$step" '$1 == want' | wc -l | tr -d ' ')"
  if [ "$count" -eq 0 ]; then
    conditional="$(grep -F "'$step'" "$gate_file" | grep -v '^[[:space:]]*#' | head -1 || true)"
    if [ -n "$conditional" ]; then
      echo "checks/gate.sh runs the step $step under a condition: $conditional"
    else
      echo "checks/gate.sh holds no step named $step"
    fi
    return 1
  fi
  [ "$count" -le 1 ] || { echo "checks/gate.sh holds the step $step more than once"; return 1; }
  line="$(printf '%s\n' "$steps" | awk -F'\t' -v want="$step" '$1 == want { print substr($0, length($1) + 2) }')"
  [ "$line" = "$command" ] || { echo "checks/gate.sh runs the step $step with a command other than $command: run_step '$step' '$line'"; return 1; }
  names="$(printf '%s\n' "$steps" | awk -F'\t' '{ print $1 }')"
  position() { printf '%s\n' "$names" | grep -n -x -F "$1" | head -1 | cut -d: -f1; }
  at="$(position "$step")"
  case "$place" in
    between:*)
      rest="${place#between:}"; after="${rest%%:*}"; before="${rest#*:}"
      if [ "$(position "$after")" -lt "$at" ] && [ "$at" -lt "$(position "$before")" ]; then return 0; fi
      echo "checks/gate.sh puts the step $step outside its place, which is after $after and before $before"
      return 1;;
    directly_before:*)
      next="${place#directly_before:}"
      if [ "$(position "$next")" -eq $((at + 1)) ]; then return 0; fi
      echo "checks/gate.sh puts the step $step outside its place, which is directly before $next"
      return 1;;
  esac
}

# The gate with the step's line deleted, commented, followed by `|| true`, or inside `if false`.
mutate_gate() {
  case "$1" in
    "the step deleted") sed "/^run_step '$2' /d" "$GATE";;
    "the step commented out") sed "s|^run_step '$2' |# &|" "$GATE";;
    "the step followed by || true") sed "/^run_step '$2' /s|\$| \|\| true|" "$GATE";;
    "the step inside if false") awk -v want="run_step '$2' " 'index($0, want) == 1 { print "if false; then"; print; print "fi"; next } { print }' "$GATE";;
  esac
}

# The step holds in the real gate, and each of the four mutations of its line fails the same check.
gate_step_is_one_fatal_step() {
  holds="$(gate_step_holds "$GATE" "$1" "$2" "$3")" || { fail "$holds"; return 1; }
  for mutation in "the step deleted" "the step commented out" "the step followed by || true" "the step inside if false"; do
    mutate_gate "$mutation" "$1" > "$WORK/mutated_gate"
    if gate_step_holds "$WORK/mutated_gate" "$1" "$2" "$3" > /dev/null; then
      fail "$mutation: the case did not fail on a gate with this change" || return 1
    fi
  done
}

# CP-1378: the suite is one fatal step of the gate, once, unconditional, after "Git beta walk suite" and
# before "Launch the built bundle". The capture script is a person's tool and no gate step runs it.
test_the_suite_is_one_fatal_step_before_the_real_launch() {
  gate_step_is_one_fatal_step "README picture capture suite" "checks/tests/test_readme_capture.sh" "between:Git beta walk suite:Launch the built bundle" || return 1
  script_steps="$(gate_steps_of "$GATE" | grep -F 'readme-capture.sh' | grep -v -F 'test_readme_capture.sh' || true)"
  [ -z "$script_steps" ] || fail "checks/gate.sh runs checks/readme-capture.sh, a person's tool: $script_steps" || return 1
}

# --- the runner ---

WORK="$(mktemp -d)"
cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

failed=0
total=0
for case_name in $CASES; do
  total=$((total + 1))
  SUB=""
  if result="$("$case_name" 2>&1)"; then
    echo "ok   $case_name"
  else
    echo "FAIL $case_name"
    [ -z "$result" ] || echo "$result"
    failed=$((failed + 1))
  fi
done

echo "$((total - failed)) of $total passed"
[ "$failed" -eq 0 ]

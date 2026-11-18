#!/usr/bin/env bash
# Version: 1.0.0 — first version: the capture's admission, usage, tool lookup and work folder, and
#   the scan that holds it to no variable of its own and no network tool
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
#   lands in the real /tmp, and HOME points into the scratch. No case runs the host's git, tar or
#   cargo.
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
SCRIPT="$ROOT/checks/readme-capture.sh"
TOOLS="bash awk sed grep cat tr head wc cmp cp mkdir rm sleep shasum"
# The eleven programs the script looks up, each of which a case may leave off PATH.
LOOKED_UP="git open ps kill screencapture swiftc shasum mktemp id hostname scutil"
# Every stand-in the harness builds; a program the suite links in as an ordinary tool is not one.
STAND_INS="uname sysctl git open ps kill screencapture swiftc mktemp id hostname scutil"

WORK=""
SUB=""

CASES="
test_off_a_vm_it_exits_non_zero_having_launched_nothing_and_read_nothing
test_any_argument_is_a_usage_error_before_anything_is_launched
test_a_missing_tool_is_refused_before_anything_is_made
test_a_work_folder_under_the_home_is_refused
test_the_work_folder_is_removed_on_every_way_out
test_the_capture_reads_no_variable_of_its_own_and_names_no_network_tool
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
  stand_in uname "cat \"$scene/host_os\"; exit \"\$(cat \"$scene/uname_status\")\""
  stand_in sysctl "cat \"$scene/host_vmm\"; exit \"\$(cat \"$scene/sysctl_status\")\""
  stand_in git 'echo "stand-in git: no recorded reply for: $*" >&2; exit 99'
  for plain in open ps kill screencapture swiftc id hostname scutil; do
    stand_in "$plain" 'exit 0'
  done
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
# HOME inside the scratch. Standard input is closed.
run_capture() {
  before="$(snapshot "$tree")"
  status=0
  (cd "$tree" && /usr/bin/env -i PATH="$bin" HOME="$home" "$tree/checks/readme-capture.sh" "$@") < /dev/null > "$scene/out" 2> "$scene/err" || status=$?
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
    made="$(ls "$scene/tmp" "$home")"
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

#!/usr/bin/env bash
# Version: 1.0.0 — first version: the refusal assertion the six guarded
#   scripts' cases share (NFDR QC-65)
#
# checks/tests/support/vm_refusal.sh — SOURCED, never run. The one place a case asserts that a
# guarded script refuses on a host that does not read as a macOS virtual machine.
#
# WHY THIS EXISTS
#   Six scripts refuse the same way (docs/nfdr.md QC-65), and each needs a case that goes red when
#   its refusal is removed. One assertion, written once, is what lets that case be pointed at the
#   real script and, unchanged, at a copy with only its admission removed (the mutation run the
#   change's review notes record). It lives under support/, outside the top-level checks/tests/*.sh
#   set, so no suite loop and no workflow step mistakes it for a suite.
#   It sets no shell option: a sourced file must not change the
#   options of the suite that sources it.
#
# USAGE
#   VMR_TMP=<a directory the caller owns and removes>     set before any call
#   source checks/tests/support/vm_refusal.sh
#   VMR_ENV=(NAME=value ...)                              extra environment for the next calls
#   (optional) VMR_SCENE=<a directory the subject must leave unchanged>   (optional;
#   the run's own cwd and home are
#                                                         always checked as well)
#   VMR_HOME_FILES="<path> ..."                           files to create under the run's home first
#   (optional) vmr_assert_refuses <reading> <subject> <bare name> [args...]
#   vmr_assert_refuses_all <subject> <bare name> [args...]     every refusing reading, one after
#   another vmr_assert_no_work_traced <subject> <bare name> [args...]  the traced run: nothing
#   before the refusal vmr_assert_refusal <subject> <bare name> [args...]         the two above
#   vmr_run_on <reading> <subject> [args...]                   one run on any
#   reading, `admit` included; leaves
#                                                              vmr_status,
#                                                              $vmr_case/stdout and $vmr_case/stderr
#   vmr_install_admission <bin dir>                            only the
#   admitting uname and sysctl, for a case
#                                                              that builds the rest
#                                                              of its own stand-ins
#   vmr_install_standins <bin dir> <log dir> <reading>         every stand-in, for the reading
#   Each assertion prints what failed on stdout and returns 1; it returns
#   0 only when every check holds.
#
# THE READINGS
#   The subject finds `uname` and `sysctl` through PATH, as it would on any host, and is given a
#   PATH whose first directory holds stand-ins and whose other directory holds links to ordinary
#   tools only. The subject is never told which reading it has: there is no variable, flag or
#   argument for it to read. A "missing" reading is a PATH with no such
#   tool, not a stand-in that says so.
#
# WHAT A REFUSAL IS (docs/nfdr.md QC-65; change_spec CP-797, CP-798)
#   stdout empty; stderr exactly one line, `<name>: refused: …`, ended by one newline; exit 1; no
#   `open` call and no call of a compilation, probing, fixture-reading or
#   waiting tool; the scene unchanged.

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  echo "vm_refusal.sh: sourced by a suite, never run" >&2
  exit 1
fi

VMR_ENV=()
VMR_HOME_FILES=""
VMR_CASES=0

# Ordinary tools a script may reach once admitted. `uname` and `sysctl` are not among them: a
# reading is the stand-in's, or it is missing.
VMR_ORDINARY_TOOLS="bash env sh awk sed cat cut tr sort uniq comm find xargs mktemp rm mkdir rmdir dirname basename cp mv ls head tail wc grep expr date kill chmod ln cmp readlink touch stat cksum pwd"
# Tools that compile, probe, read a fixture or wait. A stand-in fails and records the call.
VMR_MARKER_TOOLS="swiftc rustc cargo codesign sample plutil ps ditto xcrun sleep git tar"

# The refusal line for the script whose bare file name is $1.
vmr_expected_line() {
  printf '%s: refused: this host does not read as a macOS virtual machine. This step launches KA-Reader.app or reads this machine'\''s home, and runs only in a macOS virtual machine (docs/nfdr.md QC-65).\n' "$1"
}

# Every reading that must refuse. `admit` is the one reading that does not, and is not listed.
vmr_readings() {
  echo "physical uname-missing uname-failing uname-failing-prints-darwin uname-empty uname-malformed uname-multiline nondarwin-1 sysctl-missing sysctl-failing sysctl-failing-prints-1 sysctl-empty sysctl-malformed sysctl-non1 sysctl-multiline"
}

# A stand-in executable $1 that prints $2 to stdout, $3 to stderr, and exits $4.
vmr_write_reader() {
  {
    echo '#!/bin/sh'
    [ -z "$3" ] || printf "printf '%%s\\\\n' '%s' >&2\n" "$3"
    [ -z "$2" ] || printf "printf '%%b' '%s'\n" "$2"
    echo "exit $4"
  } > "$1"
  chmod +x "$1"
}

# Stand-ins into directory $1, markers recorded under directory $2, for reading $3.
vmr_install_standins() {
  bin="$1"
  log="$2"
  reading="$3"
  mkdir -p "$bin" "$log"
  uname_out="Darwin\\n"
  uname_err=""
  uname_status=0
  uname_present=1
  sysctl_out="1\\n"
  sysctl_err=""
  sysctl_status=0
  sysctl_present=1
  case "$reading" in
    admit) ;;
    physical) sysctl_out="0\\n" ;;
    uname-missing) uname_present=0 ;;
    uname-failing) uname_out=""; uname_err="uname: stand-in failure"; uname_status=1 ;;
    uname-failing-prints-darwin) uname_err="uname: stand-in failure"; uname_status=1 ;;
    uname-empty) uname_out="" ;;
    uname-malformed) uname_out="darwin\\n" ;;
    uname-multiline) uname_out="Darwin\\nDarwin\\n" ;;
    nondarwin-1) uname_out="Linux\\n" ;;
    sysctl-missing) sysctl_present=0 ;;
    sysctl-failing) sysctl_out=""; sysctl_err="sysctl: stand-in failure"; sysctl_status=1 ;;
    sysctl-failing-prints-1) sysctl_err="sysctl: stand-in failure"; sysctl_status=1 ;;
    sysctl-empty) sysctl_out="" ;;
    sysctl-malformed) sysctl_out="yes\\n" ;;
    sysctl-non1) sysctl_out="2\\n" ;;
    sysctl-multiline) sysctl_out="1\\n1\\n" ;;
    *) echo "vmr_install_standins: unknown reading $reading" >&2; return 1 ;;
  esac
  [ "$uname_present" -eq 0 ] || vmr_write_reader "$bin/uname" "$uname_out" "$uname_err" "$uname_status"
  [ "$sysctl_present" -eq 0 ] || vmr_write_reader "$bin/sysctl" "$sysctl_out" "$sysctl_err" "$sysctl_status"
  {
    echo '#!/bin/sh'
    echo "printf 'open %s\\n' \"\$*\" >> '$log/open'"
    echo 'exit 0'
  } > "$bin/open"
  chmod +x "$bin/open"
  for marker in $VMR_MARKER_TOOLS; do
    {
      echo '#!/bin/sh'
      echo "printf '$marker %s\\n' \"\$*\" >> '$log/tool'"
      echo 'exit 97'
    } > "$bin/$marker"
    chmod +x "$bin/$marker"
  done
}

# The admitting reading alone (Darwin, 1) into directory $1, ahead of
# the real tools on a case's PATH.
vmr_install_admission() {
  mkdir -p "$1"
  vmr_write_reader "$1/uname" "Darwin\\n" "" 0
  vmr_write_reader "$1/sysctl" "1\\n" "" 0
}

# Links to the ordinary tools in directory $1.
vmr_install_ordinary() {
  mkdir -p "$1"
  for tool in $VMR_ORDINARY_TOOLS; do
    found="$(command -v "$tool" 2> /dev/null || true)"
    case "$found" in
      /*) ln -sf "$found" "$1/$tool" ;;
    esac
  done
}

# A fresh case directory for one run: bin, ordinary, log, cwd, home. Sets vmr_case.
vmr_new_case() {
  [ -n "${VMR_TMP:-}" ] && [ -d "$VMR_TMP" ] || { echo "  vm_refusal.sh: VMR_TMP must name a directory the caller owns"; return 1; }
  VMR_CASES=$((VMR_CASES + 1))
  vmr_case="$VMR_TMP/vmr.$VMR_CASES"
  rm -rf "$vmr_case"
  mkdir -p "$vmr_case/cwd" "$vmr_case/home/Library" "$vmr_case/log"
  : > "$vmr_case/cwd/scene.txt"
  for home_file in $VMR_HOME_FILES; do
    mkdir -p "$vmr_case/home/$(dirname "$home_file")"
    : > "$vmr_case/home/$home_file"
  done
  vmr_install_ordinary "$vmr_case/ordinary"
}

# A listing and a checksum of every file under $1, for a before and after comparison.
vmr_snapshot() {
  if [ -d "$1" ]; then
    (cd "$1" && find . -print | LC_ALL=C sort && find . -type f -exec cksum {} \; | LC_ALL=C sort)
  else
    echo "absent: $1"
  fi
}

# Runs subject $1 with arguments "${@:2}" in the current case, as `$vmr_runner`, stdout to
# $vmr_case/stdout, stderr to $vmr_case/stderr. Sets vmr_status.
vmr_run() {
  vmr_subject="$1"
  shift
  (
    cd "$vmr_case/cwd" || exit 99
    exec /usr/bin/env -i \
      PATH="$vmr_case/bin:$vmr_case/ordinary" HOME="$vmr_case/home" \
      ${VMR_ENV[@]+"${VMR_ENV[@]}"} \
      $vmr_runner "$vmr_subject" "$@"
  ) > "$vmr_case/stdout" 2> "$vmr_case/stderr"
  vmr_status=$?
}

# Checks the run's marker logs and the scene against the snapshots taken
# before it. Prints each failure.
vmr_check_no_work() {
  vmr_ok=0
  if [ -s "$vmr_case/log/open" ]; then
    echo "  $1: open was called: $(cat "$vmr_case/log/open")"
    vmr_ok=1
  fi
  if [ -s "$vmr_case/log/tool" ]; then
    echo "  $1: a tool was called before the refusal: $(cat "$vmr_case/log/tool")"
    vmr_ok=1
  fi
  after_cwd="$(vmr_snapshot "$vmr_case/cwd")"
  after_home="$(vmr_snapshot "$vmr_case/home")"
  if [ "$after_cwd" != "$vmr_before_cwd" ] || [ "$after_home" != "$vmr_before_home" ]; then
    echo "  $1: the run changed its working directory or its home"
    vmr_ok=1
  fi
  if [ -n "${VMR_SCENE:-}" ] && [ "$(vmr_snapshot "$VMR_SCENE")" != "$vmr_before_scene" ]; then
    echo "  $1: the run changed the scene $VMR_SCENE"
    vmr_ok=1
  fi
  return "$vmr_ok"
}

# One run of subject $2 (arguments "${@:3}") on reading $1, which may be `admit`. Leaves vmr_status,
# $vmr_case/stdout, $vmr_case/stderr and the marker logs under $vmr_case/log for the caller to read.
vmr_run_on() {
  reading="$1"
  subject="$2"
  shift 2
  vmr_new_case || return 1
  vmr_install_standins "$vmr_case/bin" "$vmr_case/log" "$reading" || return 1
  vmr_runner=""
  vmr_run "$subject" "$@"
}

# Asserts the whole refusal of subject $2 (bare name $3, arguments "${@:4}") on reading $1.
vmr_assert_refuses() {
  reading="$1"
  subject="$2"
  name="$3"
  shift 3
  vmr_new_case || return 1
  vmr_install_standins "$vmr_case/bin" "$vmr_case/log" "$reading" || return 1
  vmr_before_cwd="$(vmr_snapshot "$vmr_case/cwd")"
  vmr_before_home="$(vmr_snapshot "$vmr_case/home")"
  vmr_before_scene=""
  [ -z "${VMR_SCENE:-}" ] || vmr_before_scene="$(vmr_snapshot "$VMR_SCENE")"
  vmr_runner=""
  vmr_run "$subject" "$@"
  failed=0
  if [ -s "$vmr_case/stdout" ]; then
    echo "  $reading: stdout is not empty: $(cat "$vmr_case/stdout")"
    failed=1
  fi
  vmr_expected_line "$name" > "$vmr_case/expected"
  if ! cmp -s "$vmr_case/expected" "$vmr_case/stderr"; then
    echo "  $reading: stderr is not exactly the refusal line for $name. got: $(cat "$vmr_case/stderr")"
    failed=1
  fi
  if [ "$vmr_status" -ne 1 ]; then
    echo "  $reading: expected exit 1, got $vmr_status"
    failed=1
  fi
  vmr_check_no_work "$reading" || failed=1
  return "$failed"
}

# Asserts the refusal of the subject on every refusing reading. Prints each reading that fails.
vmr_assert_refuses_all() {
  all_ok=0
  for each_reading in $(vmr_readings); do
    vmr_assert_refuses "$each_reading" "$@" || all_ok=1
  done
  return "$all_ok"
}

# A trace line is allowed before the refusal only if it is the shell's option setup, one of the two
# host observations, the capture of their values, a string comparison of those
# values, or the refusal itself.
VMR_ALLOWED_TRACE='^\++ (set -[a-z]+|uname( |$)|sysctl( |$)|host_[a-z_]+=|(\[|'\''\['\'') [^-]|echo |exit 1$)'

# The traced run: the subject under `bash -x` on the physical reading. Nothing may run before the
# refusal except the allowed lines, so no file predicate, root or fixture discovery, directory
# change, temporary directory or case body is reached. The trace is a
# file apart from the output proof.
vmr_assert_no_work_traced() {
  subject="$1"
  name="$2"
  shift 2
  vmr_new_case || return 1
  vmr_install_standins "$vmr_case/bin" "$vmr_case/log" physical || return 1
  vmr_runner="bash -x"
  vmr_run "$subject" "$@"
  failed=0
  grep '^+' "$vmr_case/stderr" > "$vmr_case/trace" || true
  grep -v '^+' "$vmr_case/stderr" > "$vmr_case/untraced" || true
  vmr_expected_line "$name" > "$vmr_case/expected"
  if ! cmp -s "$vmr_case/expected" "$vmr_case/untraced"; then
    echo "  traced: the refusal line is not the only untraced stderr line. got: $(cat "$vmr_case/untraced")"
    failed=1
  fi
  if ! grep -q -E '^\++ uname( |$)' "$vmr_case/trace" || ! grep -q -E '^\++ sysctl( |$)' "$vmr_case/trace"; then
    echo "  traced: the trace shows no host observation, so it proves nothing about what came first"
    failed=1
  fi
  early="$(grep -v -E "$VMR_ALLOWED_TRACE" "$vmr_case/trace" || true)"
  if [ -n "$early" ]; then
    echo "  traced: work before the refusal: $early"
    failed=1
  fi
  if [ "$vmr_status" -ne 1 ]; then
    echo "  traced: expected exit 1, got $vmr_status"
    failed=1
  fi
  return "$failed"
}

# The whole assertion: the matrix of readings and the traced run.
vmr_assert_refusal() {
  matrix_ok=0
  vmr_assert_refuses_all "$@" || matrix_ok=1
  vmr_assert_no_work_traced "$@" || matrix_ok=1
  return "$matrix_ok"
}

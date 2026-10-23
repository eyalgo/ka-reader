#!/usr/bin/env bash
# Version: 1.0.0 — first version: the real checks/secret-scan.sh over a disposable repository, clean
#   and then with a planted secret-shaped string
#
# checks/tests/test_secret_scan_planted.sh — the planted-secret control of checks/secret-scan.sh.
#
# WHY THIS EXISTS
#   checks/secret-scan.sh is the gate's scan of every commit reachable from HEAD (docs/nfdr.md
#   QC-28). A scan that can never report a finding passes every history, so a green "Secret scan"
#   step means nothing until the same scan has been seen to turn red. This suite is that control. It
#   runs the real script, with the real gitleaks fetched and checked against its pinned SHA-256 as
#   the "Secret scan" step fetches it, twice over one disposable Git repository: first over a commit
#   that holds no secret-shaped string, which must exit 0, then after one more commit that adds a
#   secret-shaped string, which must exit non-zero and print a finding at that commit. Nothing in it
#   is a stand-in. checks/tests/test_secret_scan.sh proves the script's protocol with a stand-in
#   gitleaks; this suite shows that the pinned gitleaks reports one planted string, and nothing about
#   the other kinds of secret gitleaks looks for.
#
# THE PLANTED STRING
#   It has the shape of a GitHub personal access token, which gitleaks's github-pat rule reports. It
#   is made up for this suite, joined from fragments while the suite runs, and written only into the
#   disposable repository, so no file of this product holds the whole string for the "Secret scan"
#   step to find. The suite never prints it, and the scan prints a finding by its commit, file, line
#   and rule and never by its value.
#
# THE RESULT CHECK
#   One check decides whether a scan's result is what its run expects. It reads the scan's exit
#   status, its output and the planted commit. The cases after the two real scans give that same
#   check altered records of a scan, a status changed or a line removed, and expect it to fail each
#   one and say why. None of them is a scan, and none counts as one of the two.
#
# GIT CONFIGURATION
#   The disposable repository reads none of the machine's Git configuration: global and system
#   configuration are switched off, the author and committer are fixed, and a hooks path, repository
#   or index the calling session sets is cleared for this suite and the commands it runs. So the
#   result is the same on a machine whose own commit hook would refuse the suite's commits, or that
#   sets no user identity. The caller's configuration and repositories are left as they were.
#
# WHAT IT LEAVES BEHIND
#   Everything a run creates, the disposable repository and the scanner's own working files among
#   them, is made under one temporary directory, and that directory is removed when the suite exits,
#   pass or fail, or is stopped by a signal it can catch. A run killed outright (SIGKILL), or cut off
#   by the machine stopping, leaves it behind. The suite writes nothing to the product's checkout and
#   does not move its HEAD.
#
# USAGE
#   checks/tests/test_secret_scan_planted.sh
#   Run from the product root, with no argument. Each run downloads gitleaks's release archive from
#   GitHub twice, once per scan, so it needs the network: without it the clean run does not pass and
#   neither does the suite. No argument or environment variable skips a scan or lets the suite pass
#   without both. It exits 0 only when the clean run exited 0, the planted run exited non-zero with a
#   finding at the planted commit, and both printed the line saying the release archive matched its
#   pinned SHA-256. Anything else is non-zero.
#
# WHY NO `set -e`
#   A case that does not pass must not end the run before the remaining cases report. Each case
#   returns its own status and the runner counts them.

set -uo pipefail

PRODUCT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SUITE="$PRODUCT_ROOT/checks/tests/$(basename "$0")"
SCAN="$PRODUCT_ROOT/checks/secret-scan.sh"

RUN_ROOT=""
RECORDS=""
CASE_DIR=""
SCAN_TMP=""
FIXTURE=""
EMPTY_HOOKS=""
EMPTY_TEMPLATE=""

CASES="
test_clean_repository_scans_with_exit_0
test_planted_commit_turns_the_scan_red
test_clean_run_that_exits_non_zero_does_not_pass
test_clean_run_with_no_output_does_not_pass
test_run_with_no_scan_record_does_not_pass
test_planted_run_that_exits_0_does_not_pass
test_planted_run_without_a_finding_line_does_not_pass
test_planted_run_with_no_output_does_not_pass
test_finding_at_the_clean_commit_does_not_count
test_shortened_planted_hash_does_not_count
test_finding_text_inside_another_line_does_not_count
test_clean_run_without_the_archive_line_does_not_pass
test_planted_run_without_the_archive_line_does_not_pass
test_missing_archive_line_is_named_beside_another_failure
test_planted_run_whose_download_did_not_complete_does_not_pass
test_fixture_commits_survive_a_hostile_parent_git_environment
test_no_secret_shaped_literal_in_the_suite_text
test_no_option_or_variable_skips_a_scan
"

# --- the explanations: one whole sentence each, as the case prints it ---

explain_clean_nonzero() {
  printf '%s\n' "The clean run did not pass: the scan exited with status $1 over a disposable repository whose one commit holds no secret-shaped string. The scan's own output follows; read it for why the scan exited."
}

explain_clean_without_archive_line() {
  printf '%s\n' "The clean run's output has no line saying gitleaks's release archive matched its pinned SHA-256, so this run does not show that the real scanner ran. Run checks/secret-scan.sh gitleaks git from the product root and compare the first line it prints with the scan's own output, which follows."
}

explain_planted_not_run() {
  printf '%s\n' "The planted run did not happen, because the clean run did not pass. The clean run's case says why."
}

explain_planted_exit_zero() {
  printf '%s\n' "The planted run exited with status 0: the scan did not turn red after commit $1 added a secret-shaped string, so this suite cannot show that the scan reports a secret. Check whether the gitleaks version checks/secret-scan.sh pins still reports the planted string's shape, a GitHub personal access token. The scan's own output follows."
}

explain_planted_without_finding() {
  printf '%s\n' "The planted run exited with status $1 but printed no line beginning secret-scan.sh: finding at commit $2, the commit that added the secret-shaped string. The scan's own output follows; read it for what the scan printed instead."
}

explain_planted_without_archive_line() {
  printf '%s\n' "The planted run's output has no line saying gitleaks's release archive matched its pinned SHA-256, so this run does not show that the real scanner ran. Run checks/secret-scan.sh gitleaks git from the product root and compare the first line it prints with the scan's own output, which follows."
}

explain_no_temporary_directory() {
  printf '%s\n' "The suite could not create its temporary directory under $1, so neither scan ran. Make $1 writable, then run the suite again."
}

explain_no_scanner() {
  printf '%s\n' "The suite found no executable checks/secret-scan.sh at $1, so neither scan ran. Run the suite from the root of a clone of KA-Reader."
}

explain_no_clean_commit() {
  printf '%s\n' "Git could not make the clean commit in the disposable repository, so neither scan ran. Git's own output follows; correct what it reports, then run the suite again."
}

explain_no_planted_commit() {
  printf '%s\n' "Git could not make the planted commit in the disposable repository, so the planted run did not happen. Git's own output follows; correct what it reports, then run the suite again."
}

explain_stopped() {
  printf '%s\n' "The suite was stopped before both scans finished, so it has not passed. Run it again to the end."
}

explain_check_passed_record() {
  printf '%s\n' "The result check passed this altered record, and it has to fail it. Correct the result check in this suite so that it does not pass the record, then run the suite again."
}

explain_check_lacks_explanation() {
  printf '%s\n' "The result check failed this altered record without the explanation it has to give: $1 Correct the result check so that its explanation includes that sentence, then run the suite again."
}

# --- the result check ---

# Succeeds when the transcript $1 carries the scan's whole matched-archive announcement as a line.
has_archive_line() {
  printf '%s\n' "$1" | awk '
    /^secret-scan\.sh: running gitleaks [0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*, whose release archive matched its pinned SHA-256, over every commit reachable from [0-9a-f][0-9a-f]*$/ { found = 1 }
    END { exit !found }'
}

# Succeeds when the transcript $1 has a line that starts with the scan's finding prefix, the whole
# commit $2 and the field delimiter.
has_finding_at() {
  [ -n "$2" ] || return 1
  printf '%s\n' "$1" | awk -v prefix="secret-scan.sh: finding at commit $2," '
    index($0, prefix) == 1 { found = 1 }
    END { exit !found }'
}

# Decides whether one scan's record is what its phase expects. The inputs are the phase (clean or
# planted), the status the scan returned, the transcript it printed and the planted commit. An unmet
# expectation prints its explanation and the transcript; the result is non-zero when any is unmet.
check_scan_outcome() {
  return 0
}

# --- the real scans ---

# Makes the disposable repository $1 with no commit in it.
init_fixture() {
  git -c init.defaultBranch=main init -q --template="$EMPTY_TEMPLATE" "$1" \
    && git -C "$1" config core.hooksPath "$EMPTY_HOOKS" \
    && git -C "$1" config commit.gpgsign false
}

commit_clean() {
  printf 'a disposable file that holds nothing secret-shaped\n' > "$1/notes.txt" \
    && git -C "$1" add notes.txt \
    && git -C "$1" commit -q -m "clean commit"
}

# The planted string, joined from fragments no one of which matches the github-pat rule on its own.
planted_string() {
  local shape_head="gh" shape_mark="p_"
  local fragment_one="aB3dE5fG7" fragment_two="hJ9kM2nP4" fragment_three="qR6sT8uV1"
  local fragment_four="wX3yZ5aC7"
  printf '%s%s%s%s%s%s\n' "$shape_head" "$shape_mark" "$fragment_one" "$fragment_two" \
    "$fragment_three" "$fragment_four"
}

commit_planted() {
  planted_string > "$1/config.txt" \
    && git -C "$1" add config.txt \
    && git -C "$1" commit -q -m "planted commit"
}

# Git reads nothing from the machine or from the session that launched this suite.
isolate_git_environment() {
  local name
  for name in $(compgen -e | grep '^GIT_' || true); do
    unset "$name"
  done
  export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null GIT_CONFIG_NOSYSTEM=1
  export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
  export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid
  export HOME="$RUN_ROOT/home"
  mkdir -p "$HOME"
}

# Runs the real scan from inside the fixture and records its status and its output apart.
run_recorded_scan() {
  local phase="$1" status=0
  ( cd "$FIXTURE" && env TMPDIR="$SCAN_TMP" "$SCAN" gitleaks git ) > "$RECORDS/$phase.out" 2>&1 \
    || status=$?
  printf '%s\n' "$status" > "$RECORDS/$phase.status"
}

record_text() {
  [ ! -f "$1" ] || cat "$1"
}

# Judges the recorded phase $1 the way the suite's own result check does.
judge_recorded_phase() {
  local phase="$1"
  check_scan_outcome "$phase" "$(record_text "$RECORDS/$phase.status")" \
    "$(record_text "$RECORDS/$phase.out")" "$(record_text "$RECORDS/planted.commit")"
}

# Succeeds only when both recorded phases are what their runs expect.
suite_may_pass() {
  judge_recorded_phase clean && judge_recorded_phase planted
}

# --- the cases ---

# Succeeds when the result check refuses the altered record (phase, status, transcript, planted
# commit) and each of the explanations after those four is among what it printed.
expect_refusal() {
  local phase="$1" status="$2" transcript="$3" commit="$4" verdict verdict_status=0 expected
  shift 4
  verdict="$(check_scan_outcome "$phase" "$status" "$transcript" "$commit")" || verdict_status=$?
  if [ "$verdict_status" -eq 0 ]; then
    explain_check_passed_record
    return 1
  fi
  for expected in "$@"; do
    case "$verdict" in
      *"$expected"*) ;;
      *)
        explain_check_lacks_explanation "$expected"
        return 1
        ;;
    esac
  done
}

fail() {
  echo "  $*"
  return 1
}

test_clean_repository_scans_with_exit_0() {
  if [ -f "$RECORDS/clean.setup_failure" ]; then
    cat "$RECORDS/clean.setup_failure"
    return 1
  fi
  judge_recorded_phase clean
}

test_planted_commit_turns_the_scan_red() {
  if [ -f "$RECORDS/planted.not_run" ]; then
    explain_planted_not_run
    return 1
  fi
  if [ -f "$RECORDS/planted.setup_failure" ]; then
    cat "$RECORDS/planted.setup_failure"
    return 1
  fi
  judge_recorded_phase planted
}

test_clean_run_that_exits_non_zero_does_not_pass() {
  local transcript
  transcript="$(record_text "$RECORDS/clean.out")"
  expect_refusal clean 1 "$transcript" "" "$(explain_clean_nonzero 1)" "$transcript"
}

test_clean_run_with_no_output_does_not_pass() {
  expect_refusal clean 0 "" "" "$(explain_clean_without_archive_line)"
}

test_run_with_no_scan_record_does_not_pass() {
  mkdir -p "$CASE_DIR/no-records"
  ( RECORDS="$CASE_DIR/no-records"; ! suite_may_pass > /dev/null 2>&1 ) \
    || fail "a final pass was reachable with no record of either scan"
}

test_planted_run_that_exits_0_does_not_pass() {
  local transcript commit
  transcript="$(record_text "$RECORDS/planted.out")"
  commit="$(record_text "$RECORDS/planted.commit")"
  expect_refusal planted 0 "$transcript" "$commit" "$(explain_planted_exit_zero "$commit")" \
    "$transcript"
}

test_planted_run_without_a_finding_line_does_not_pass() {
  local transcript commit
  commit="$(record_text "$RECORDS/planted.commit")"
  transcript="$(record_text "$RECORDS/planted.out" | grep -v '^secret-scan\.sh: finding at commit' || true)"
  expect_refusal planted 1 "$transcript" "$commit" "$(explain_planted_without_finding 1 "$commit")" \
    "$transcript"
}

test_planted_run_with_no_output_does_not_pass() {
  local commit
  commit="$(record_text "$RECORDS/planted.commit")"
  expect_refusal planted 1 "" "$commit" "$(explain_planted_without_finding 1 "$commit")" \
    "$(explain_planted_without_archive_line)"
}

test_finding_at_the_clean_commit_does_not_count() {
  local transcript commit clean_commit
  commit="$(record_text "$RECORDS/planted.commit")"
  clean_commit="$(record_text "$RECORDS/clean.commit")"
  transcript="$(record_text "$RECORDS/planted.out" | sed "s/$commit/$clean_commit/g")"
  expect_refusal planted 1 "$transcript" "$commit" "$(explain_planted_without_finding 1 "$commit")"
}

test_shortened_planted_hash_does_not_count() {
  local transcript commit
  commit="$(record_text "$RECORDS/planted.commit")"
  transcript="$(record_text "$RECORDS/planted.out" \
    | sed "s/finding at commit $commit,/finding at commit ${commit:0:12},/")"
  expect_refusal planted 1 "$transcript" "$commit" "$(explain_planted_without_finding 1 "$commit")"
}

test_finding_text_inside_another_line_does_not_count() {
  local transcript commit
  commit="$(record_text "$RECORDS/planted.commit")"
  transcript="$(record_text "$RECORDS/planted.out" \
    | sed 's/^secret-scan\.sh: finding at commit/see: secret-scan.sh: finding at commit/')"
  expect_refusal planted 1 "$transcript" "$commit" "$(explain_planted_without_finding 1 "$commit")"
}

test_clean_run_without_the_archive_line_does_not_pass() {
  local transcript
  transcript="$(record_text "$RECORDS/clean.out" | grep -v -F 'whose release archive matched its pinned SHA-256' || true)"
  expect_refusal clean 0 "$transcript" "" "$(explain_clean_without_archive_line)"
}

test_planted_run_without_the_archive_line_does_not_pass() {
  local transcript commit
  commit="$(record_text "$RECORDS/planted.commit")"
  transcript="$(record_text "$RECORDS/planted.out" | grep -v -F 'whose release archive matched its pinned SHA-256' || true)"
  expect_refusal planted 1 "$transcript" "$commit" "$(explain_planted_without_archive_line)"
}

test_missing_archive_line_is_named_beside_another_failure() {
  local transcript commit
  commit="$(record_text "$RECORDS/planted.commit")"
  transcript="$(record_text "$RECORDS/planted.out" | grep -v -F 'whose release archive matched its pinned SHA-256' || true)"
  expect_refusal planted 0 "$transcript" "$commit" "$(explain_planted_exit_zero "$commit")" \
    "$(explain_planted_without_archive_line)"
}

test_planted_run_whose_download_did_not_complete_does_not_pass() {
  local status=0 dead="http://127.0.0.1:9" transcript commit
  commit="$(record_text "$RECORDS/planted.commit")"
  mkdir -p "$CASE_DIR"
  ( cd "$FIXTURE" && env TMPDIR="$SCAN_TMP" https_proxy="$dead" HTTPS_PROXY="$dead" \
      all_proxy="$dead" ALL_PROXY="$dead" "$SCAN" gitleaks git ) > "$CASE_DIR/download.out" 2>&1 \
    || status=$?
  transcript="$(record_text "$CASE_DIR/download.out")"
  expect_refusal planted "$status" "$transcript" "$commit" \
    "$(explain_planted_without_finding "$status" "$commit")" \
    "$(explain_planted_without_archive_line)"
}

# A fingerprint of every file below $1, so a change anywhere in it shows.
tree_fingerprint() {
  find "$1" -type f -exec cksum {} + | sort
}

test_fixture_commits_survive_a_hostile_parent_git_environment() {
  local dir="$CASE_DIR/hostile" sentinel hooks parent_before parent_after tree_before head_before
  sentinel="$dir/sentinel"
  hooks="$dir/hooks"
  mkdir -p "$hooks" "$dir/home"
  printf '#!/bin/sh\n: > "$(dirname "$0")/../hook-ran"\nexit 1\n' > "$hooks/pre-commit"
  cp "$hooks/pre-commit" "$hooks/commit-msg"
  chmod +x "$hooks/pre-commit" "$hooks/commit-msg"
  printf '[core]\n\thooksPath = %s\n[user]\n\tuseConfigOnly = true\n' "$hooks" > "$dir/hostile.gitconfig"
  git -c init.defaultBranch=main init -q --template="$EMPTY_TEMPLATE" "$sentinel" \
    && git -C "$sentinel" config core.hooksPath "$EMPTY_HOOKS" \
    && echo sentinel > "$sentinel/sentinel.txt" \
    && git -C "$sentinel" add sentinel.txt \
    && git -C "$sentinel" commit -q -m sentinel || fail "the sentinel repository could not be made"
  head_before="$(git -C "$sentinel" rev-parse HEAD)"
  tree_before="$(tree_fingerprint "$sentinel")"
  parent_before="$(env | grep '^GIT_' | sort)"
  (
    unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL EMAIL
    export HOME="$dir/home"
    export GIT_CONFIG_GLOBAL="$dir/hostile.gitconfig"
    export GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0="$hooks"
    export GIT_CONFIG_PARAMETERS="'core.hooksPath'='$hooks'"
    export GIT_DIR="$sentinel/.git" GIT_WORK_TREE="$sentinel" GIT_INDEX_FILE="$sentinel/.git/index"
    isolate_git_environment
    init_fixture "$dir/fixture" && commit_clean "$dir/fixture" && commit_planted "$dir/fixture"
  ) > "$dir/build.out" 2>&1 || fail "the fixture commits failed under the hostile environment: $(cat "$dir/build.out")" || return 1
  [ "$(git -C "$dir/fixture" rev-list --count HEAD)" = 2 ] || fail "expected two commits in the fixture" || return 1
  [ ! -e "$dir/hook-ran" ] || fail "the refusing hook ran" || return 1
  [ "$(git -C "$sentinel" rev-parse HEAD)" = "$head_before" ] || fail "the sentinel's HEAD moved" || return 1
  [ "$(tree_fingerprint "$sentinel")" = "$tree_before" ] || fail "the sentinel repository changed" || return 1
  parent_after="$(env | grep '^GIT_' | sort)"
  [ "$parent_after" = "$parent_before" ] || fail "the calling session's Git variables changed"
}

test_no_secret_shaped_literal_in_the_suite_text() {
  local prefix_probe="gh"
  prefix_probe="${prefix_probe}p_"
  ! grep -q -F "$prefix_probe" "$SUITE" || fail "the suite's text holds the planted string's prefix" || return 1
  ! grep -q -E '[0-9A-Za-z]{36}' "$SUITE" || fail "the suite's text holds a run of 36 letters and digits"
}

test_no_option_or_variable_skips_a_scan() {
  local region reads
  region="$(sed -n '/^# --- the runner ---$/,$p' "$SUITE")"
  ! printf '%s\n' "$region" | grep -q -E '\$[@*#1-9]|\$\{[1-9@*#]|(^|[^a-z_])(shift|getopts)([^a-z_]|$)' \
    || fail "the runner reads an argument" || return 1
  ! printf '%s\n' "$region" | grep -q -E '(^|[^a-z_])exit 0' || fail "the runner exits 0 early" || return 1
  reads="$(grep -o -E '\$\{[A-Za-z_][A-Za-z_0-9]*:?[-=+?]' "$SUITE" | sort -u)"
  [ "$reads" = '${TMPDIR:-' ] || fail "the suite reads a variable with a default besides TMPDIR: $reads" || return 1
  ! grep -q -i -E '\$\{?[A-Za-z_]*(s[k]ip|q[u]iet|o[f]fline|o[n]ly)' "$SUITE" \
    || fail "the suite reads a variable whose name says it skips or quiets"
}

# --- the runner ---

on_signal() {
  explain_stopped >&2
  exit 1
}

cleanup() {
  [ -z "$RUN_ROOT" ] || rm -rf "$RUN_ROOT"
}
trap cleanup EXIT
trap on_signal INT TERM HUP

if [ ! -x "$SCAN" ]; then
  explain_no_scanner "$SCAN"
  exit 1
fi

temp_parent="${TMPDIR:-/tmp}"
temp_parent="${temp_parent%/}"
RUN_ROOT="$(mktemp -d "$temp_parent/planted-secret-suite.XXXXXX" 2>/dev/null)" || RUN_ROOT=""
if [ -z "$RUN_ROOT" ]; then
  explain_no_temporary_directory "$temp_parent"
  exit 1
fi
RECORDS="$RUN_ROOT/records"
CASE_DIR="$RUN_ROOT/cases"
SCAN_TMP="$RUN_ROOT/scan-tmp"
FIXTURE="$RUN_ROOT/fixture"
EMPTY_HOOKS="$RUN_ROOT/empty-hooks"
EMPTY_TEMPLATE="$RUN_ROOT/empty-template"
mkdir -p "$RECORDS" "$CASE_DIR" "$SCAN_TMP" "$EMPTY_HOOKS" "$EMPTY_TEMPLATE" 2>/dev/null \
  || { explain_no_temporary_directory "$temp_parent"; exit 1; }

isolate_git_environment

if git_output="$(init_fixture "$FIXTURE" 2>&1 && commit_clean "$FIXTURE" 2>&1)"; then
  git -C "$FIXTURE" rev-parse HEAD > "$RECORDS/clean.commit"
  echo "Clean run: scanning a disposable repository whose one commit holds no secret-shaped string."
  run_recorded_scan clean
  cat "$RECORDS/clean.out"
else
  { explain_no_clean_commit; printf '%s\n' "$git_output"; } > "$RECORDS/clean.setup_failure"
fi

if judge_recorded_phase clean > /dev/null 2>&1; then
  if git_output="$(commit_planted "$FIXTURE" 2>&1)"; then
    git -C "$FIXTURE" rev-parse HEAD > "$RECORDS/planted.commit"
    echo "Planted run: scanning the same repository after commit $(cat "$RECORDS/planted.commit") added a secret-shaped string."
    run_recorded_scan planted
    cat "$RECORDS/planted.out"
  else
    { explain_no_planted_commit; printf '%s\n' "$git_output"; } > "$RECORDS/planted.setup_failure"
  fi
else
  : > "$RECORDS/planted.not_run"
fi

failed=0
total=0
for case_name in $CASES; do
  total=$((total + 1))
  if result="$("$case_name" 2>&1)"; then
    echo "ok   $case_name"
  else
    echo "FAIL $case_name"
    [ -z "$result" ] || printf '%s\n' "$result" | sed 's/^/  /'
    failed=$((failed + 1))
  fi
done

echo "$((total - failed)) of $total passed"
[ "$failed" -eq 0 ] && suite_may_pass > /dev/null 2>&1

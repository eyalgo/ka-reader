#!/usr/bin/env bash
# Version: 1.0.0 — first version: drives the real checks/secret-scan.sh and the real checks/gate.sh
#   against disposable repositories, with stand-in tools on PATH
#
# checks/tests/test_secret_scan.sh — the tests of checks/secret-scan.sh and its place in checks/gate.sh.
#
# WHY THIS EXISTS
#   checks/secret-scan.sh is the gate's scan of every commit reachable from HEAD (docs/nfdr.md QC-28).
#   A bug in it is a secret nobody is looking for, or a green gate over half a history. These cases run
#   the real script, never a copy of its logic, against disposable Git repositories. `uname`, `curl`
#   and `shasum` are stand-ins on PATH, and the gitleaks the script unpacks is a stand-in that records
#   what it was called with and answers with the status and report a case chooses. So the suite proves
#   the script's protocol (what it passes, what it checks, what it prints, when it exits 0) and not the
#   vendor's detection: the planted-secret control is not part of this change, and the first real scan
#   of the product's own history is recorded in the change's report. That the pinned digests are the
#   vendor's own is held by review.
#   The cases that read checks/gate.sh run the real gate in a disposable fixture whose other steps are
#   stand-ins, so no bundle is launched and this suite is not run again from inside itself.
#
# USAGE
#   checks/tests/test_secret_scan.sh
#     KA_READER_TEST_ONLY=<case> runs one case.
#   Runs on any host that has git, tar and a shasum: nothing here reaches the network.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SCAN="$ROOT/checks/secret-scan.sh"
GATE="$ROOT/checks/gate.sh"
TAB=$'\t'
PINNED_VERSION="8.30.1"

# A fixture repository must not depend on the machine's Git configuration, on a hook's variables or on
# a hooks path a launching session sets through GIT_CONFIG_COUNT.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_CONFIG_COUNT GIT_CONFIG_PARAMETERS
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null
export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.invalid
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.invalid

WORK=""
SCENE=""
REPO=""
OUT=""
ERR=""
STATUS=0
SCAN_ENV=()

CASES="
test_count_equals_rev_list_count_on_a_mixed_history
test_scanner_receives_head_sha_full_history_and_merge_diffs_only
test_head_change_during_scan_prevents_success_report
test_shallow_clone_refused_before_download
test_non_repository_or_unreadable_history_fails
test_no_count_printed_on_refusal_or_scanner_error
test_verified_download_selects_archive_by_architecture
test_download_missing_bad_digest_failed_extraction_wrong_version_unsupported_arch_each_fail
test_ambient_path_gitleaks_is_never_used
test_only_clean_scanner_status_returns_zero
test_invalid_or_extra_wrapper_arguments_fail
test_ambient_gitleaks_config_does_not_weaken_the_scan
test_report_template_and_flags_are_metadata_only
test_missing_allow_file_means_no_allowances
test_commented_exact_commit_fingerprint_is_accepted
test_malformed_global_wildcard_range_or_uncommented_entries_are_refused
test_fingerprint_differs_by_commit_file_rule_and_line
test_gate_holds_exactly_one_literal_scan_call_and_its_suite_as_whole_steps
test_scan_moved_after_own_state_is_rejected_by_the_existing_order_case
test_gate_stops_and_names_secret_scan_when_the_scan_fails_or_the_tool_is_missing
test_failing_scanner_suite_stops_before_the_scan
test_clean_scan_continues_to_the_next_step
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# The digest the script pins for one Darwin architecture (ARM64 or X64).
pin_for() {
  sed -n "s/^PIN_SHA256_$1=\"\\([0-9a-f]*\\)\"\$/\\1/p" "$SCAN"
}

# Builds a repository with a root commit, an ordinary one, an empty one, a deletion-only one, a merge
# and a branch HEAD does not reach.
make_mixed_repo() {
  repo="$1"
  mkdir -p "$repo"
  git -C "$repo" init -q
  git -C "$repo" symbolic-ref HEAD refs/heads/main
  echo one > "$repo/a.txt"
  git -C "$repo" add a.txt
  git -C "$repo" commit -q -m root
  echo two > "$repo/b.txt"
  git -C "$repo" add b.txt
  git -C "$repo" commit -q -m ordinary
  git -C "$repo" commit -q --allow-empty -m empty
  git -C "$repo" rm -q a.txt
  git -C "$repo" commit -q -m deletion-only
  git -C "$repo" checkout -q -b side
  echo side > "$repo/side.txt"
  git -C "$repo" add side.txt
  git -C "$repo" commit -q -m side
  git -C "$repo" checkout -q main
  echo main > "$repo/main2.txt"
  git -C "$repo" add main2.txt
  git -C "$repo" commit -q -m main-after-fork
  git -C "$repo" merge -q --no-ff side -m merge
  git -C "$repo" checkout -q -b unrelated main~1
  echo other > "$repo/other.txt"
  git -C "$repo" add other.txt
  git -C "$repo" commit -q -m unrelated
  git -C "$repo" checkout -q main
}

# Stand-in tools on PATH: uname, curl and shasum, and a PATH gitleaks that must never be called.
write_stand_ins() {
  bin="$1/bin"
  mkdir -p "$bin"
  cat > "$bin/uname" <<'STUB'
#!/bin/sh
case "$1" in
  -s) echo "${FAKE_UNAME_S:-Darwin}" ;;
  -m) echo "${FAKE_UNAME_M:-arm64}" ;;
  *) exec /usr/bin/uname "$@" ;;
esac
STUB
  cat > "$bin/curl" <<'STUB'
#!/bin/sh
out=""
url=""
while [ $# -gt 0 ]; do
  case "$1" in
    --output|-o) out="$2"; shift 2 ;;
    -*) shift ;;
    *) url="$1"; shift ;;
  esac
done
echo "$url" >> "$FAKE_CURL_LOG"
[ -z "${FAKE_CURL_FAIL:-}" ] || exit "$FAKE_CURL_FAIL"
cp "$FAKE_ARCHIVE" "$out"
STUB
  cat > "$bin/shasum" <<'STUB'
#!/bin/sh
echo "$FAKE_SHA  $3"
STUB
  chmod +x "$bin/uname" "$bin/curl" "$bin/shasum"
}

# The gitleaks the stand-in archive holds. It records its call and answers as the case says.
write_fake_gitleaks() {
  cat > "$1" <<'STUB'
#!/bin/sh
if [ "${1:-}" = version ]; then
  printf '%s\n' "${FAKE_REPORTED_VERSION-8.30.1}"
  exit "${FAKE_VERSION_STATUS:-0}"
fi
: > "$FAKE_ARGV_LOG"
for a in "$@"; do printf '%s\n' "$a" >> "$FAKE_ARGV_LOG"; done
env | grep '^GITLEAKS_' > "$FAKE_ENV_LOG"
template=""
report=""
config=""
while [ $# -gt 0 ]; do
  case "$1" in
    --report-template) template="$2"; shift 2 ;;
    --report-path) report="$2"; shift 2 ;;
    --config) config="$2"; shift 2 ;;
    *) shift ;;
  esac
done
[ -z "$template" ] || cp "$template" "$FAKE_TEMPLATE_COPY"
[ -z "$config" ] || cp "$config" "$FAKE_CONFIG_COPY"
[ -z "${FAKE_MOVE_HEAD:-}" ] || git -C "$FAKE_REPO" commit -q --allow-empty -m moved
[ -n "${FAKE_NO_REPORT:-}" ] || printf '%s' "${FAKE_REPORT_BODY:-}" > "$report"
exit "${FAKE_SCAN_STATUS:-0}"
STUB
  chmod +x "$1"
}

# A fresh scene: stand-ins, an archive, a mixed repository and the environment the script runs in.
new_scene() {
  SCENE="$WORK/$1"
  REPO="$SCENE/repo"
  mkdir -p "$SCENE"
  write_stand_ins "$SCENE"
  mkdir -p "$SCENE/pack"
  write_fake_gitleaks "$SCENE/pack/gitleaks"
  tar -czf "$SCENE/archive.tgz" -C "$SCENE/pack" gitleaks
  make_mixed_repo "$REPO"
  SCAN_ENV=(
    "PATH=$SCENE/bin:$PATH"
    "FAKE_CURL_LOG=$SCENE/curl.log"
    "FAKE_ARCHIVE=$SCENE/archive.tgz"
    "FAKE_SHA=$(pin_for ARM64)"
    "FAKE_ARGV_LOG=$SCENE/argv.log"
    "FAKE_ENV_LOG=$SCENE/env.log"
    "FAKE_TEMPLATE_COPY=$SCENE/template.copy"
    "FAKE_CONFIG_COPY=$SCENE/config.copy"
    "FAKE_REPO=$REPO"
  )
}

# Runs the script in directory $1 with the arguments after it.
run_scan() {
  dir="$1"
  shift
  OUT="$(cd "$dir" && env "${SCAN_ENV[@]}" "$SCAN" "$@" 2>"$SCENE/stderr")"
  STATUS=$?
  ERR="$(cat "$SCENE/stderr")"
}

expect_zero() {
  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. stdout: $OUT stderr: $ERR"
}

expect_nonzero() {
  [ "$STATUS" -ne 0 ] || fail "expected a non-zero exit, got 0. stdout: $OUT"
}

expect_no_count() {
  case "$OUT$ERR" in
    *"commits scanned"*) fail "a commit count was printed. stdout: $OUT stderr: $ERR" ;;
    *) return 0 ;;
  esac
}

expect_contains() {
  case "$2" in
    *"$1"*) return 0 ;;
    *) fail "expected to find: $1. in: $2" ;;
  esac
}

expect_no_download() {
  [ ! -s "$SCENE/curl.log" ] || fail "something was downloaded: $(cat "$SCENE/curl.log")"
}

expect_no_scanner_call() {
  [ ! -e "$SCENE/argv.log" ] || fail "the scanner was called: $(cat "$SCENE/argv.log")"
}

# Succeeds when the scanner was called with exactly the argument $1.
argv_has() {
  grep -q -x -F -- "$1" "$SCENE/argv.log"
}

# The value after the option $1 in the scanner's recorded call.
argv_value() {
  awk -v opt="$1" 'prev == opt { print; exit } { prev = $0 }' "$SCENE/argv.log"
}

head_sha() {
  git -C "$REPO" rev-parse HEAD
}

# --- cases ---

test_count_equals_rev_list_count_on_a_mixed_history() {
  new_scene count || return 1
  run_scan "$REPO" gitleaks git
  expect_zero || return 1
  want="$(git -C "$REPO" rev-list --count HEAD)"
  everything="$(git -C "$REPO" rev-list --all --count)"
  [ "$want" != "$everything" ] || fail "the fixture's unrelated branch added no commit" || return 1
  expect_contains "commits scanned: $want" "$OUT" || return 1
  lines="$(printf '%s\n' "$OUT" | grep -c 'commits scanned')"
  [ "$lines" -eq 1 ] || fail "expected one count line, found $lines: $OUT"
}

test_scanner_receives_head_sha_full_history_and_merge_diffs_only() {
  new_scene argv || return 1
  run_scan "$REPO" gitleaks git
  expect_zero || return 1
  sha="$(head_sha)"
  opts="$(argv_value --log-opts)"
  [ "$opts" = "--full-history --diff-merges=first-parent $sha" ] \
    || fail "the log options were not HEAD's SHA with full history and first-parent merge diffs. got: $opts" || return 1
  for refused in --all --first-parent --baseline-path -b --staged --pre-commit --no-git --verbose -v --debug; do
    ! argv_has "$refused" || fail "the scanner was passed $refused" || return 1
  done
  case "$opts" in
    *..*) fail "the log options hold a range: $opts" || return 1 ;;
  esac
  [ "$(argv_value --exit-code)" = 2 ] || fail "finding and tool error would share an exit status" || return 1
  [ "$(sed -n '$p' "$SCENE/argv.log")" = "$(cd "$REPO" && pwd -P)" ] \
    || fail "the repository path is not the last argument: $(cat "$SCENE/argv.log")"
}

test_head_change_during_scan_prevents_success_report() {
  new_scene moved || return 1
  SCAN_ENV+=("FAKE_MOVE_HEAD=1")
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  expect_no_count || return 1
  expect_contains "HEAD no longer names" "$ERR"
}

test_shallow_clone_refused_before_download() {
  new_scene shallow || return 1
  git clone -q --depth 1 "file://$REPO" "$SCENE/clone" 2>/dev/null || fail "could not make a shallow clone" || return 1
  [ "$(git -C "$SCENE/clone" rev-parse --is-shallow-repository)" = true ] || fail "the fixture clone is not shallow" || return 1
  run_scan "$SCENE/clone" gitleaks git
  expect_nonzero || return 1
  expect_contains "history is shallow" "$ERR" || return 1
  expect_no_download || return 1
  expect_no_scanner_call || return 1
  expect_no_count
}

test_non_repository_or_unreadable_history_fails() {
  new_scene unreadable || return 1
  mkdir "$SCENE/plain"
  run_scan "$SCENE/plain" gitleaks git
  expect_nonzero || return 1
  expect_no_count || return 1
  expect_contains "git could not read the history at HEAD" "$ERR" || return 1
  expect_no_download || return 1
  mkdir "$SCENE/empty-repo"
  git -C "$SCENE/empty-repo" init -q
  run_scan "$SCENE/empty-repo" gitleaks git
  expect_nonzero || return 1
  expect_no_count || return 1
  expect_no_download
}

test_no_count_printed_on_refusal_or_scanner_error() {
  new_scene nocount || return 1
  run_scan "$REPO" gitleaks
  expect_nonzero || return 1
  expect_no_count || return 1
  SCAN_ENV+=("FAKE_SCAN_STATUS=1")
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  expect_no_count || return 1
  expect_contains "exited with status 1 and listed no finding" "$ERR"
}

test_verified_download_selects_archive_by_architecture() {
  new_scene arm || return 1
  run_scan "$REPO" gitleaks git
  expect_zero || return 1
  expect_contains "gitleaks $PINNED_VERSION" "$OUT" || return 1
  case "$(tail -n 1 "$SCENE/curl.log")" in
    *"gitleaks_${PINNED_VERSION}_darwin_arm64.tar.gz") ;;
    *) fail "arm64 did not fetch the arm64 archive: $(cat "$SCENE/curl.log")" || return 1 ;;
  esac
  new_scene x64 || return 1
  SCAN_ENV+=("FAKE_UNAME_M=x86_64" "FAKE_SHA=$(pin_for X64)")
  run_scan "$REPO" gitleaks git
  expect_zero || return 1
  expect_contains "gitleaks $PINNED_VERSION" "$OUT" || return 1
  case "$(tail -n 1 "$SCENE/curl.log")" in
    *"gitleaks_${PINNED_VERSION}_darwin_x64.tar.gz") ;;
    *) fail "x86_64 did not fetch the x64 archive: $(cat "$SCENE/curl.log")" || return 1 ;;
  esac
  # The other architecture's digest is not accepted: each archive is held to its own pin.
  new_scene x64-wrong-pin || return 1
  SCAN_ENV+=("FAKE_UNAME_M=x86_64" "FAKE_SHA=$(pin_for ARM64)")
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  expect_no_count
}

test_download_missing_bad_digest_failed_extraction_wrong_version_unsupported_arch_each_fail() {
  new_scene each-fails || return 1
  base=("${SCAN_ENV[@]}")

  SCAN_ENV=("${base[@]}" "FAKE_CURL_FAIL=22")
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  expect_no_count || return 1
  expect_contains "did not complete (curl exited with status 22)" "$ERR" || return 1

  SCAN_ENV=("${base[@]}" "FAKE_SHA=$(pin_for X64)")
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  expect_no_count || return 1
  expect_contains "so it was not unpacked and nothing was scanned" "$ERR" || return 1
  expect_no_scanner_call || return 1

  echo "not an archive" > "$SCENE/garbage"
  SCAN_ENV=("${base[@]}" "FAKE_ARCHIVE=$SCENE/garbage")
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  expect_no_count || return 1
  expect_contains "while unpacking" "$ERR" || return 1

  SCAN_ENV=("${base[@]}" "FAKE_REPORTED_VERSION=8.30.0")
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  expect_no_count || return 1
  expect_contains "reports version 8.30.0" "$ERR" || return 1
  expect_no_scanner_call || return 1

  SCAN_ENV=("${base[@]}" "FAKE_REPORTED_VERSION=")
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  expect_no_count || return 1

  : > "$SCENE/curl.log"
  SCAN_ENV=("${base[@]}" "FAKE_UNAME_M=armv7")
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  expect_no_count || return 1
  expect_contains "only for macOS (Darwin) on arm64 or x86_64" "$ERR" || return 1
  expect_no_download || return 1

  SCAN_ENV=("${base[@]}" "FAKE_UNAME_S=Linux")
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  expect_no_count || return 1
  expect_no_download
}

test_ambient_path_gitleaks_is_never_used() {
  new_scene ambient || return 1
  mkdir "$SCENE/pathbin"
  cat > "$SCENE/pathbin/gitleaks" <<STUB
#!/bin/sh
echo called >> "$SCENE/path-gitleaks.log"
echo 9.9.9
STUB
  chmod +x "$SCENE/pathbin/gitleaks"
  SCAN_ENV[0]="PATH=$SCENE/pathbin:$SCENE/bin:$PATH"
  run_scan "$REPO" gitleaks git
  expect_zero || return 1
  [ ! -e "$SCENE/path-gitleaks.log" ] || fail "the gitleaks on PATH was run" || return 1
  expect_contains "gitleaks $PINNED_VERSION" "$OUT" || return 1
  case "$OUT$ERR" in
    *9.9.9*) fail "the PATH gitleaks's version reached the output" ;;
  esac
}

test_only_clean_scanner_status_returns_zero() {
  new_scene statuses || return 1
  base=("${SCAN_ENV[@]}")
  finding="$(head_sha)${TAB}docs/a.md${TAB}12${TAB}generic-api-key${TAB}$(head_sha):docs/a.md:generic-api-key:12${TAB}REDACTED"$'\n'

  SCAN_ENV=("${base[@]}" "FAKE_SCAN_STATUS=0")
  run_scan "$REPO" gitleaks git
  expect_zero || return 1

  SCAN_ENV=("${base[@]}" "FAKE_SCAN_STATUS=2" "FAKE_REPORT_BODY=$finding")
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  expect_no_count || return 1
  expect_contains "reported one or more findings" "$OUT$ERR" || return 1

  SCAN_ENV=("${base[@]}" "FAKE_SCAN_STATUS=2")
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  expect_no_count || return 1

  for status in 1 3 126; do
    SCAN_ENV=("${base[@]}" "FAKE_SCAN_STATUS=$status")
    run_scan "$REPO" gitleaks git
    expect_nonzero || return 1
    expect_no_count || return 1
  done

  # A scan that claims a clean exit but wrote no report is a report failure, not a clean scan.
  SCAN_ENV=("${base[@]}" "FAKE_NO_REPORT=1")
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  expect_no_count || return 1

  # A clean exit beside a listed finding is not clean either.
  SCAN_ENV=("${base[@]}" "FAKE_REPORT_BODY=$finding")
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  expect_no_count
}

test_invalid_or_extra_wrapper_arguments_fail() {
  new_scene args || return 1
  deprecated="gitleaks ""detect"
  set --
  for arguments in "" "gitleaks" "git" "git gitleaks" "$deprecated" "gitleaks git --redact" "gitleaks git extra" "gitleaks  git x"; do
    # shellcheck disable=SC2086
    run_scan "$REPO" $arguments
    expect_nonzero || return 1
    expect_no_count || return 1
    expect_no_download || return 1
    expect_no_scanner_call || return 1
  done
  run_scan "$REPO"
  expect_contains "no arguments were given" "$ERR" || return 1
  run_scan "$REPO" gitleaks git extra
  expect_contains "it was given gitleaks git extra" "$ERR"
}

test_ambient_gitleaks_config_does_not_weaken_the_scan() {
  new_scene config || return 1
  SCAN_ENV+=("GITLEAKS_CONFIG=$SCENE/none.toml" "GITLEAKS_CONFIG_TOML=[allowlist]" "GITLEAKS_ENABLE_RULE=none")
  run_scan "$REPO" gitleaks git
  expect_zero || return 1
  [ ! -s "$SCENE/env.log" ] || fail "an ambient gitleaks variable reached the scanner: $(cat "$SCENE/env.log")" || return 1
  grep -q '^useDefault = true$' "$SCENE/config.copy" || fail "the config does not extend the defaults: $(cat "$SCENE/config.copy")" || return 1
  if grep -qi 'allowlist\|stopwords\|regexes\|paths' "$SCENE/config.copy"; then
    fail "the config carries an exclusion: $(cat "$SCENE/config.copy")" || return 1
  fi
  argv_has --ignore-gitleaks-allow || fail "source-level allow annotations are not ignored"
}

test_report_template_and_flags_are_metadata_only() {
  new_scene template || return 1
  sha="$(head_sha)"
  finding="${sha}${TAB}docs/a.md${TAB}12${TAB}generic-api-key${TAB}${sha}:docs/a.md:generic-api-key:12${TAB}REDACTED"$'\n'
  SCAN_ENV+=("FAKE_SCAN_STATUS=2" "FAKE_REPORT_BODY=$finding")
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  fields="$(grep -o '\.[A-Z][A-Za-z]*' "$SCENE/template.copy" | sort -u | tr '\n' ' ')"
  [ "$fields" = ".Commit .File .Fingerprint .RuleID .StartLine " ] \
    || fail "the template selects fields beyond commit, file, line, rule and fingerprint: $fields" || return 1
  grep -q 'REDACTED' "$SCENE/template.copy" || fail "the template carries no redaction marker" || return 1
  argv_has --redact=100 || fail "redaction is not full: $(cat "$SCENE/argv.log")" || return 1
  argv_has --report-format || fail "the report is not a template report" || return 1
  [ "$(argv_value --report-format)" = template ] || fail "the report format is not template" || return 1
  for refused in -v --verbose --debug --log-level=debug --log-level=trace --log-level=info --report-format=json; do
    ! argv_has "$refused" || fail "the scanner was passed $refused" || return 1
  done
  argv_has --log-level=error || fail "the scanner's own count line is not suppressed" || return 1
  expect_contains "finding at commit $sha, file docs/a.md, line 12, rule generic-api-key; matched text redacted; fingerprint $sha:docs/a.md:generic-api-key:12" "$OUT$ERR"
}

# Writes the reviewed exceptions file of the scene's repository from the lines given.
write_allow_file() {
  printf '%s\n' "$@" > "$REPO/.gitleaksignore"
}

test_missing_allow_file_means_no_allowances() {
  new_scene no-allow || return 1
  [ ! -e "$REPO/.gitleaksignore" ] || fail "fixture error: an allow file exists" || return 1
  run_scan "$REPO" gitleaks git
  expect_zero || return 1
  expect_contains "reported no finding in the history of $(head_sha); commits scanned:" "$OUT" || return 1
  case "$OUT" in
    *"beyond those"*) fail "a pass line speaks of exceptions with none in force: $OUT" ;;
  esac
}

test_commented_exact_commit_fingerprint_is_accepted() {
  new_scene allow-ok || return 1
  sha="$(head_sha)"
  write_allow_file "# a documentation example, not a key" "$sha:docs/a.md:generic-api-key:12" "" "# a second example" "$sha:docs/b.md:generic-api-key:3"
  run_scan "$REPO" gitleaks git
  expect_zero || return 1
  expect_contains "beyond those .gitleaksignore covers; commits scanned: $(git -C "$REPO" rev-list --count HEAD)" "$OUT" || return 1
  [ "$(argv_value --gitleaks-ignore-path)" = "$(cd "$REPO" && pwd -P)" ] \
    || fail "the scanner was not pointed at the product root's allow file: $(cat "$SCENE/argv.log")"
}

test_malformed_global_wildcard_range_or_uncommented_entries_are_refused() {
  new_scene allow-bad || return 1
  sha="$(head_sha)"
  other="$(git -C "$REPO" rev-parse HEAD~1)"
  checked=0
  # one entry per refusal, each placed under a valid reason comment
  while IFS= read -r entry; do
    checked=$((checked + 1))
    rm -f "$SCENE/argv.log"
    write_allow_file "# a reason" "$entry"
    run_scan "$REPO" gitleaks git
    expect_nonzero || return 1
    expect_no_count || return 1
    expect_contains "line 2 of .gitleaksignore is not one commit-specific fingerprint" "$ERR" || return 1
    expect_no_scanner_call || return 1
  done <<ENTRIES
docs/a.md:generic-api-key:12
$sha:docs/*:generic-api-key:12
$sha:docs/a.md:*:12
$sha:docs/a.md:generic-api-key:*
$sha..$other
$sha:docs/a.md
$sha:docs/a.md:generic-api-key:0
$sha:docs/a.md:generic-api-key:12-20
${sha%?}:docs/a.md:generic-api-key:12
generic-api-key
docs/
$sha:docs/a.md:generic-api-key:12 # reason on the same line
ENTRIES
  [ "$checked" -eq 12 ] || fail "expected 12 refused entries, ran $checked" || return 1

  # no reason above: first line, a blank line between, and an empty comment
  write_allow_file "$sha:docs/a.md:generic-api-key:12"
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  expect_contains "line 1 of .gitleaksignore has no reason comment" "$ERR" || return 1
  write_allow_file "# a reason" "" "$sha:docs/a.md:generic-api-key:12"
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  expect_contains "line 3 of .gitleaksignore has no reason comment" "$ERR" || return 1
  write_allow_file "#   " "$sha:docs/a.md:generic-api-key:12"
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  expect_contains "line 2 of .gitleaksignore has no reason comment" "$ERR" || return 1
  expect_no_scanner_call || return 1
  expect_no_count || return 1

  # an allow file that cannot be read is not a missing one
  write_allow_file "# a reason" "$sha:docs/a.md:generic-api-key:12"
  chmod 000 "$REPO/.gitleaksignore"
  if [ -r "$REPO/.gitleaksignore" ]; then
    chmod 644 "$REPO/.gitleaksignore"
    return 0
  fi
  run_scan "$REPO" gitleaks git
  chmod 644 "$REPO/.gitleaksignore"
  expect_nonzero || return 1
  expect_contains ".gitleaksignore is in the product root but could not be read" "$ERR"
}

test_fingerprint_differs_by_commit_file_rule_and_line() {
  new_scene fingerprints || return 1
  sha="$(head_sha)"
  parent="$(git -C "$REPO" rev-parse HEAD~1)"
  base="$sha:docs/a.md:generic-api-key:12"
  variants="$parent:docs/a.md:generic-api-key:12
$sha:docs/b.md:generic-api-key:12
$sha:docs/a.md:aws-access-token:12
$sha:docs/a.md:generic-api-key:13"
  report=""
  lines="$base
$variants"
  while IFS= read -r fingerprint; do
    commit="${fingerprint%%:*}"
    report="$report$commit${TAB}file${TAB}1${TAB}rule${TAB}$fingerprint${TAB}REDACTED"$'\n'
  done <<LINES
$lines
LINES
  # each of the five is a valid exception on its own line, and each is reported as itself
  write_allow_file "# base" "$base" "# commit" "$parent:docs/a.md:generic-api-key:12" "# file" "$sha:docs/b.md:generic-api-key:12" "# rule" "$sha:docs/a.md:aws-access-token:12" "# line" "$sha:docs/a.md:generic-api-key:13"
  run_scan "$REPO" gitleaks git
  expect_zero || return 1
  SCAN_ENV+=("FAKE_SCAN_STATUS=2" "FAKE_REPORT_BODY=$report")
  run_scan "$REPO" gitleaks git
  expect_nonzero || return 1
  distinct="$(printf '%s\n' "$OUT$ERR" | grep -o 'fingerprint [0-9a-f]*:[^ ]*' | sort -u | wc -l | tr -d ' ')"
  [ "$distinct" -eq 5 ] || fail "expected five distinct fingerprints in the output, found $distinct: $OUT$ERR"
}

# The gate's steps as name<TAB>command.
gate_steps() {
  sed -n "s/^run_step '\\([^']*\\)' '\\(.*\\)'\$/\\1${TAB}\\2/p" "$1"
}

# The line number of the step named $2 among the steps of the gate file $1.
step_position() {
  gate_steps "$1" | awk -F'\t' -v want="$2" '$1 == want { print NR }'
}

test_gate_holds_exactly_one_literal_scan_call_and_its_suite_as_whole_steps() {
  scans="$(grep -c "^run_step .*gitleaks git" "$GATE")"
  [ "$scans" -eq 1 ] || fail "checks/gate.sh holds $scans lines that run the scan, not one" || return 1
  grep -q -x -F "run_step 'Secret scan' 'checks/secret-scan.sh gitleaks git'" "$GATE" \
    || fail "checks/gate.sh has no literal step 'Secret scan' whose whole command is checks/secret-scan.sh gitleaks git" || return 1
  grep -q -x -F "run_step 'Secret scan suite' 'checks/tests/test_secret_scan.sh'" "$GATE" \
    || fail "checks/gate.sh has no literal step 'Secret scan suite' whose whole command is checks/tests/test_secret_scan.sh" || return 1
  toolchain="$(step_position "$GATE" "Toolchain")"
  suite="$(step_position "$GATE" "Secret scan suite")"
  scan="$(step_position "$GATE" "Secret scan")"
  build="$(step_position "$GATE" "Build the workspace")"
  own="$(step_position "$GATE" "Own state")"
  total="$(gate_steps "$GATE" | wc -l | tr -d ' ')"
  [ "$toolchain" -lt "$suite" ] && [ "$suite" -lt "$scan" ] && [ "$scan" -lt "$build" ] \
    || fail "the scan and its suite are not after Toolchain and before Build the workspace (positions $toolchain $suite $scan $build)" || return 1
  [ "$own" -eq "$total" ] || fail "Own state is not the last step" || return 1
  # The deprecated subcommand is built here at run time, so this assertion leaves no hit of its own.
  deprecated="gitleaks ""detect"
  hits="$(grep -rIn -F "$deprecated" "$ROOT/checks" "$ROOT/.github" || true)"
  [ -z "$hits" ] || fail "the deprecated subcommand appears: $hits"
}

test_scan_moved_after_own_state_is_rejected_by_the_existing_order_case() {
  grep -q "^run_step 'Secret scan' " "$GATE" || fail "checks/gate.sh has no 'Secret scan' step to move" || return 1
  copy="$WORK/moved-copy"
  mkdir -p "$copy/checks/tests" "$copy/.github"
  cp "$GATE" "$copy/checks/gate.sh"
  cp "$ROOT/checks/tests/test_vm_refusal.sh" "$copy/checks/tests/"
  cp -R "$ROOT/checks/tests/support" "$copy/checks/tests/"
  cp -R "$ROOT/.github/workflows" "$copy/.github/"
  grep -v "^run_step 'Secret scan' " "$GATE" > "$copy/checks/gate.sh"
  echo "run_step 'Secret scan' 'checks/secret-scan.sh gitleaks git'" >> "$copy/checks/gate.sh"
  result="$(KA_READER_TEST_ONLY=test_moved_steps_are_single_line_commands_in_order "$copy/checks/tests/test_vm_refusal.sh" 2>&1)"
  code=$?
  [ "$code" -ne 0 ] || fail "the order case accepted the scan after Own state. output: $result" || return 1
  expect_contains '"Own state" is not the last step' "$result"
}

# A fixture holding the real gate and the real scanner, with every other step a stand-in.
new_gate_fixture() {
  new_scene "$1" || return 1
  GATE_FIXTURE="$SCENE/product"
  mkdir -p "$GATE_FIXTURE/checks/tests"
  cp "$GATE" "$GATE_FIXTURE/checks/gate.sh"
  cp "$SCAN" "$GATE_FIXTURE/checks/secret-scan.sh"
  cat > "$GATE_FIXTURE/checks/tests/test_secret_scan.sh" <<'STUB'
#!/bin/sh
echo suite >> "$GATE_LOG"
exit "${FAKE_SUITE_STATUS:-0}"
STUB
  chmod +x "$GATE_FIXTURE/checks/tests/test_secret_scan.sh" "$GATE_FIXTURE/checks/gate.sh" "$GATE_FIXTURE/checks/secret-scan.sh"
  for tool in swift xcrun cargo; do
    cat > "$SCENE/bin/$tool" <<'STUB'
#!/bin/sh
echo "$(basename "$0") $*" >> "$GATE_LOG"
exit "${FAKE_TOOL_STATUS:-0}"
STUB
    chmod +x "$SCENE/bin/$tool"
  done
  git -C "$GATE_FIXTURE" init -q
  git -C "$GATE_FIXTURE" symbolic-ref HEAD refs/heads/main
  echo x > "$GATE_FIXTURE/x.txt"
  git -C "$GATE_FIXTURE" add x.txt
  git -C "$GATE_FIXTURE" commit -q -m fixture
  GATE_LOG="$SCENE/gate.log"
  : > "$GATE_LOG"
  SCAN_ENV+=("GATE_LOG=$GATE_LOG" "FAKE_REPO=$GATE_FIXTURE")
}

run_gate_fixture() {
  OUT="$(cd "$GATE_FIXTURE" && env "${SCAN_ENV[@]}" ./checks/gate.sh 2>"$SCENE/stderr")"
  STATUS=$?
  ERR="$(cat "$SCENE/stderr")"
}

test_gate_stops_and_names_secret_scan_when_the_scan_fails_or_the_tool_is_missing() {
  new_gate_fixture gate-missing || return 1
  SCAN_ENV+=("FAKE_CURL_FAIL=7")
  run_gate_fixture
  [ "$STATUS" -eq 1 ] || fail "expected the gate to exit 1, got $STATUS. stderr: $ERR" || return 1
  expect_contains "gate.sh: step failed: Secret scan" "$ERR" || return 1
  case "$ERR" in
    *"step failed: Secret scan") ;;
    *"step failed: Secret scan"$'\n'*) fail "output follows the failed step line: $ERR" || return 1 ;;
  esac
  ! grep -q '^cargo' "$GATE_LOG" || fail "a step after the scan ran: $(cat "$GATE_LOG")" || return 1
  grep -q '^swift' "$GATE_LOG" || fail "the step before the scan did not run: $(cat "$GATE_LOG")" || return 1
  grep -q '^suite' "$GATE_LOG" || fail "the scan's suite did not run before the scan" || return 1

  # a finding fails the step the same way
  new_gate_fixture gate-finding || return 1
  SCAN_ENV+=("FAKE_SCAN_STATUS=2" "FAKE_REPORT_BODY=$(head_sha_of "$GATE_FIXTURE")${TAB}f${TAB}1${TAB}r${TAB}c:f:r:1${TAB}REDACTED"$'\n')
  run_gate_fixture
  [ "$STATUS" -eq 1 ] || fail "expected exit 1 on a finding, got $STATUS" || return 1
  expect_contains "gate.sh: step failed: Secret scan" "$ERR" || return 1
  ! grep -q '^cargo' "$GATE_LOG" || fail "a step after the failed scan ran"
}

head_sha_of() {
  git -C "$1" rev-parse HEAD
}

test_failing_scanner_suite_stops_before_the_scan() {
  new_gate_fixture gate-suite || return 1
  SCAN_ENV+=("FAKE_SUITE_STATUS=1")
  run_gate_fixture
  [ "$STATUS" -eq 1 ] || fail "expected exit 1, got $STATUS" || return 1
  expect_contains "gate.sh: step failed: Secret scan suite" "$ERR" || return 1
  expect_no_download || return 1
  expect_no_scanner_call || return 1
  ! grep -q '^cargo' "$GATE_LOG" || fail "a later step ran"
}

test_clean_scan_continues_to_the_next_step() {
  new_gate_fixture gate-clean || return 1
  # Build the workspace is the next step; its stand-in fails so the fixture stops there.
  cat > "$SCENE/bin/cargo" <<'STUB'
#!/bin/sh
echo "cargo $*" >> "$GATE_LOG"
exit 9
STUB
  run_gate_fixture
  [ "$STATUS" -eq 1 ] || fail "expected the gate to stop at the next step with 1, got $STATUS. stderr: $ERR" || return 1
  expect_contains "commits scanned: 1" "$OUT" || return 1
  expect_contains "gate.sh: step failed: Build the workspace" "$ERR" || return 1
  grep -q '^cargo build' "$GATE_LOG" || fail "the next step did not run: $(cat "$GATE_LOG")"
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
  if [ -n "${KA_READER_TEST_ONLY:-}" ] && [ "$case_name" != "$KA_READER_TEST_ONLY" ]; then
    continue
  fi
  total=$((total + 1))
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

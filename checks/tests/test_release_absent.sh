#!/usr/bin/env bash
# checks/tests/test_release_absent.sh — the tests of checks/release-absent.sh, the refusal to
# release a tag that already has a Release (CP-1180).
# Version: 1.0.0 — first version: the real script against a stand-in gh, with the draft, the later
#   page, the longer tag and the failed listing each shown to be handled, and every exit status
#   asserted
#
# WHY THIS EXISTS
#   A second Release for one tag must never replace or sit beside the first. The script lists every
#   Release of the repository, drafts included, and refuses when one carries the tag. The cases run
#   the real script — never a copy of its logic — with a stand-in gh first on PATH that prints the
#   tag names a case sets, records the arguments it was given, and exits as the case sets. The
#   failures that matter most are the quiet ones: a listing that fails, a gh that is not there, and
#   a tag that is only a prefix of another must each read as what they are, and never as "absent".
#
# USAGE
#   checks/tests/test_release_absent.sh
#     KA_READER_TEST_ONLY=<case> runs one case.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.
#
# WHERE IT WRITES
#   Only below one `mktemp -d` directory, removed by a trap on exit.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPT="$ROOT/checks/release-absent.sh"
REPOSITORY="example-owner/example-repo"

STATUS=0
OUT=""
ERR=""
WORK=""
BIN=""

CASES="
test_no_match_is_absent
test_a_draft_for_the_tag_is_refused
test_a_published_release_for_the_tag_is_refused
test_a_match_on_the_second_page_is_refused
test_a_longer_tag_is_not_a_match
test_a_failing_listing_is_never_absent
test_no_gh_on_the_path_is_refused
test_the_listing_asks_for_every_page_of_the_list_endpoint
test_an_empty_tag_is_refused
test_a_wrong_argument_count_exits_2
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

show_output() {
  printf '%s\n%s\n' "$OUT" "$ERR" | sed '/^$/d; s/^/  /'
}

# A stand-in gh in a fresh folder named $1 under the work folder: it records its arguments in argv,
# prints the file out, and exits with the number in status. Sets BIN to the folder.
new_gh() {
  BIN="$WORK/$1"
  rm -rf "$BIN"
  mkdir -p "$BIN"
  : > "$BIN/out"
  printf '0' > "$BIN/status"
  cat > "$BIN/gh" <<'STUB'
#!/usr/bin/env bash
here="$(cd "$(dirname "$0")" && pwd)"
printf '%s\n' "$@" > "$here/argv"
cat "$here/out"
exit "$(cat "$here/status")"
STUB
  chmod 755 "$BIN/gh"
}

# Runs the script with the stand-in first on PATH, keeping its status and its two streams.
run_script() {
  PATH="$BIN:$PATH" "$SCRIPT" "$@" > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?
  OUT="$(cat "$WORK/stdout")"
  ERR="$(cat "$WORK/stderr")"
}

expect_status() {
  [ "$STATUS" -eq "$1" ] && return 0
  fail "expected exit $1, got $STATUS. Its output follows."
  show_output
  return 1
}

expect_err_has() {
  case "$ERR" in
    *"$1"*) return 0 ;;
  esac
  fail "stderr does not say \"$1\". Its output follows."
  show_output
  return 1
}

# --- cases ---

test_no_match_is_absent() {
  new_gh no-match
  printf 'v0.0.1\nv0.0.2\n' > "$BIN/out"
  run_script "$REPOSITORY" v0.1.0
  expect_status 0 || return 1
}

test_a_draft_for_the_tag_is_refused() {
  new_gh draft
  printf 'v0.0.1\nv0.1.0\n' > "$BIN/out"
  run_script "$REPOSITORY" v0.1.0
  expect_status 1 || return 1
  expect_err_has "v0.1.0" || return 1
}

test_a_published_release_for_the_tag_is_refused() {
  new_gh published
  printf 'v0.1.0\n' > "$BIN/out"
  run_script "$REPOSITORY" v0.1.0
  expect_status 1 || return 1
  expect_err_has "v0.1.0" || return 1
}

test_a_match_on_the_second_page_is_refused() {
  new_gh second-page
  # gh --paginate prints one page after another; the tag is on the second.
  printf 'v0.0.1\nv0.0.2\n' > "$BIN/out"
  printf 'v0.1.0\n' >> "$BIN/out"
  run_script "$REPOSITORY" v0.1.0
  expect_status 1 || return 1
}

# A whole-line compare: v0.1.0-rc is not v0.1.0, and neither is a line that merely holds it.
test_a_longer_tag_is_not_a_match() {
  new_gh longer
  printf 'v0.1.0-rc\nxv0.1.0\nv0.1.01\n' > "$BIN/out"
  run_script "$REPOSITORY" v0.1.0
  expect_status 0 || return 1
}

# Fail closed: a listing that fails is never read as "none", whatever it printed before it failed.
test_a_failing_listing_is_never_absent() {
  new_gh fails
  printf 'v0.0.1\n' > "$BIN/out"
  printf '1' > "$BIN/status"
  run_script "$REPOSITORY" v0.1.0
  expect_status 1 || return 1
  expect_err_has "listing" || return 1
}

test_no_gh_on_the_path_is_refused() {
  tools="$WORK/no-gh-path"
  rm -rf "$tools"
  mkdir -p "$tools"
  ln -s /bin/bash "$tools/bash"
  ln -s /usr/bin/grep "$tools/grep"
  PATH="$tools" "$SCRIPT" "$REPOSITORY" v0.1.0 > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?
  OUT="$(cat "$WORK/stdout")"
  ERR="$(cat "$WORK/stderr")"
  expect_status 1 || return 1
  expect_err_has "gh was not found on PATH" || return 1
}

# CP-1180: a draft shows only on the list endpoint, and every page of it must be read.
test_the_listing_asks_for_every_page_of_the_list_endpoint() {
  new_gh argv
  run_script "$REPOSITORY" v0.1.0
  expect_status 0 || return 1
  [ -f "$BIN/argv" ] || { fail "the stand-in gh was never called"; return 1; }
  grep -q -x -F -- '--paginate' "$BIN/argv" || { fail "gh was not given --paginate: $(cat "$BIN/argv")"; return 1; }
  grep -q -x -F -- "repos/$REPOSITORY/releases" "$BIN/argv" || { fail "gh was not given the list endpoint repos/$REPOSITORY/releases: $(cat "$BIN/argv")"; return 1; }
  if grep -q -F -- 'releases/tags/' "$BIN/argv"; then
    fail "gh was given the by-tag endpoint, which never returns a draft: $(cat "$BIN/argv")"
    return 1
  fi
}

# An empty tag would match an empty line of the listing, so it is refused.
test_an_empty_tag_is_refused() {
  new_gh empty-tag
  run_script "$REPOSITORY" ""
  expect_status 1 || return 1
  expect_err_has "no tag was given" || return 1
}

test_a_wrong_argument_count_exits_2() {
  new_gh counts
  run_script
  expect_status 2 || return 1
  case "$ERR" in *sage*) ;; *) fail "no usage line on stderr: $ERR"; return 1 ;; esac
  run_script "$REPOSITORY"
  expect_status 2 || return 1
  run_script "$REPOSITORY" v0.1.0 extra
  expect_status 2 || return 1
}

# --- the runner ---

TMP_BASE="${TMPDIR:-/tmp}"
TMP_BASE="${TMP_BASE%/}"
if ! WORK="$(mktemp -d "$TMP_BASE/release-absent-suite.XXXXXX" 2> /dev/null)"; then
  echo "The suite could not create its temporary directory under $TMP_BASE, so no case ran. Make $TMP_BASE writable, then run the suite again."
  exit 1
fi
cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

ran=0
passed=0
for case_name in $CASES; do
  if [ -n "${KA_READER_TEST_ONLY:-}" ] && [ "$case_name" != "$KA_READER_TEST_ONLY" ]; then
    continue
  fi
  ran=$((ran + 1))
  if result="$("$case_name" 2>&1)"; then
    echo "ok   $case_name"
    passed=$((passed + 1))
  else
    echo "FAIL $case_name"
  fi
  [ -z "$result" ] || echo "$result"
done

echo "$passed of $ran passed"
[ "$ran" -gt 0 ] && [ "$passed" -eq "$ran" ]

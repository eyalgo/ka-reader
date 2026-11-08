#!/usr/bin/env bash
# checks/tests/test_release_sums.sh — the tests of checks/release-sums.sh, which writes the
# release's SHA256SUMS (CP-1177).
# Version: 1.0.0 — first version: the one-line file in shasum form, the verify command the workflow
#   runs, the refusals that write nothing, and every exit status the script returns
#
# WHY THIS EXISTS
#   SHA256SUMS is what a person checks a download against, and the workflow runs shasum -c on it
#   before it offers the Release. These cases run the real script — never a copy of its logic — on
#   scratch folders holding a file named like the image. The checksum reads bytes, not an image, so
#   the stand-in file is plain text. The cases assert the file's exact form, that the very command the
#   workflow's verify step runs passes on it and fails once the image changes, and that every refusal
#   leaves the folder as it found it.
#
# USAGE
#   checks/tests/test_release_sums.sh
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
SCRIPT="$ROOT/checks/release-sums.sh"
IMAGE="KA-Reader-0.0.0.dmg"

STATUS=0
OUT=""
ERR=""
WORK=""

CASES="
test_one_line_in_shasum_form
test_the_verify_passes
test_an_altered_image_fails_the_verify
test_a_missing_directory_is_refused
test_an_empty_directory_is_refused
test_two_images_are_refused
test_an_extra_file_is_refused
test_an_existing_sums_file_is_refused
test_a_folder_named_like_the_image_is_refused
test_a_refusal_writes_nothing
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

# Runs the script with the arguments given, keeping its status and its two streams.
run_script() {
  "$SCRIPT" "$@" > "$WORK/stdout" 2> "$WORK/stderr"
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

# A fresh folder named $1 holding the stand-in image; its path is in $dir.
new_dir() {
  dir="$WORK/$1"
  rm -rf "$dir"
  mkdir -p "$dir"
  printf 'not an image, only bytes\n' > "$dir/$IMAGE"
}

# The folder $1's entries, one per line, with a checksum of each file's bytes.
snapshot() {
  (cd "$1" && ls -A | while IFS= read -r entry; do
    printf '%s %s\n' "$entry" "$(shasum -a 256 "$entry" | cut -d ' ' -f 1)"
  done)
}

# The last run's stderr holds the text $1 (each refusal says which rule refused).
expect_err_has() {
  case "$ERR" in
    *"$1"*) return 0 ;;
  esac
  fail "the refusal does not say \"$1\". Its output follows."
  show_output
  return 1
}

# Runs the script on $1, which must refuse with status 1 saying $2, and leave the folder as it was.
expect_refusal_that_writes_nothing() {
  before="$(snapshot "$1")"
  run_script "$1"
  expect_status 1 || return 1
  expect_err_has "$2" || return 1
  [ "$(snapshot "$1")" = "$before" ] || { fail "a refusal changed the folder $1"; return 1; }
}

# --- cases ---

# CP-1177: exactly one line, in the form shasum -a 256 prints.
test_one_line_in_shasum_form() {
  new_dir one-line
  run_script "$dir"
  expect_status 0 || return 1
  [ "$(wc -l < "$dir/SHA256SUMS" | tr -d ' ')" -eq 1 ] || { fail "SHA256SUMS is not one line"; return 1; }
  grep -q -E '^[0-9a-f]{64}  KA-Reader-0\.0\.0\.dmg$' "$dir/SHA256SUMS" \
    || { fail "SHA256SUMS is not in the shasum form: $(cat "$dir/SHA256SUMS")"; return 1; }
}

# CP-1178: the command the workflow's verify step runs.
test_the_verify_passes() {
  new_dir verify
  run_script "$dir"
  expect_status 0 || return 1
  (cd "$dir" && shasum -a 256 -c SHA256SUMS) > /dev/null 2>&1 || { fail "shasum -a 256 -c SHA256SUMS failed on the written file"; return 1; }
}

test_an_altered_image_fails_the_verify() {
  new_dir altered
  run_script "$dir"
  expect_status 0 || return 1
  printf 'changed\n' >> "$dir/$IMAGE"
  if (cd "$dir" && shasum -a 256 -c SHA256SUMS) > /dev/null 2>&1; then
    fail "shasum -a 256 -c SHA256SUMS passed on an image changed after the sums were written"
    return 1
  fi
}

test_a_missing_directory_is_refused() {
  run_script "$WORK/not-there"
  expect_status 1 || return 1
  expect_err_has "is not a folder" || return 1
  [ ! -e "$WORK/not-there" ] || { fail "a refusal created the folder"; return 1; }
}

test_an_empty_directory_is_refused() {
  mkdir -p "$WORK/empty"
  expect_refusal_that_writes_nothing "$WORK/empty" "is empty"
}

test_two_images_are_refused() {
  new_dir two-images
  printf 'second\n' > "$dir/KA-Reader-0.0.1.dmg"
  expect_refusal_that_writes_nothing "$dir" "more than one entry"
}

test_an_extra_file_is_refused() {
  new_dir extra
  printf 'stray\n' > "$dir/notes.txt"
  expect_refusal_that_writes_nothing "$dir" "more than one entry"
}

test_an_existing_sums_file_is_refused() {
  new_dir has-sums
  printf 'keep this\n' > "$dir/SHA256SUMS"
  expect_refusal_that_writes_nothing "$dir" "already holds" || return 1
  [ "$(cat "$dir/SHA256SUMS")" = "keep this" ] || { fail "the existing SHA256SUMS was changed"; return 1; }
}

test_a_folder_named_like_the_image_is_refused() {
  mkdir -p "$WORK/folder-image/KA-Reader-0.0.0.dmg"
  expect_refusal_that_writes_nothing "$WORK/folder-image" "is not a file"
}

# The folder holds what it held before, and a refusal made no SHA256SUMS.
test_a_refusal_writes_nothing() {
  mkdir -p "$WORK/nothing/empty" "$WORK/nothing/two" "$WORK/nothing/extra" "$WORK/nothing/wrong-name"
  printf 'a\n' > "$WORK/nothing/two/KA-Reader-0.0.0.dmg"
  printf 'b\n' > "$WORK/nothing/two/KA-Reader-0.0.1.dmg"
  printf 'a\n' > "$WORK/nothing/extra/KA-Reader-0.0.0.dmg"
  printf 'c\n' > "$WORK/nothing/extra/other.txt"
  printf 'a\n' > "$WORK/nothing/wrong-name/image.dmg"
  printf 'is empty' > "$WORK/nothing/empty.says"
  printf 'more than one entry' > "$WORK/nothing/two.says"
  printf 'more than one entry' > "$WORK/nothing/extra.says"
  printf 'not a KA-Reader-*.dmg' > "$WORK/nothing/wrong-name.says"
  for name in empty two extra wrong-name; do
    expect_refusal_that_writes_nothing "$WORK/nothing/$name" "$(cat "$WORK/nothing/$name.says")" || return 1
    [ ! -e "$WORK/nothing/$name/SHA256SUMS" ] || { fail "a refusal wrote SHA256SUMS in $name"; return 1; }
  done
}

test_a_wrong_argument_count_exits_2() {
  run_script
  expect_status 2 || return 1
  case "$ERR" in *sage*) ;; *) fail "no usage line on stderr: $ERR"; return 1 ;; esac
  run_script "$WORK/one" "$WORK/two"
  expect_status 2 || return 1
}

# --- the runner ---

TMP_BASE="${TMPDIR:-/tmp}"
TMP_BASE="${TMP_BASE%/}"
if ! WORK="$(mktemp -d "$TMP_BASE/release-sums-suite.XXXXXX" 2> /dev/null)"; then
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

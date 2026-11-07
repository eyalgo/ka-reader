#!/usr/bin/env bash
# Version: 1.0.0 — first version: drives the real checks/offline-page.sh over the committed repo
#   fixture, over scratch folders, and with stand-ins on PATH for the programs it finds there
#
# checks/tests/test_offline_page.sh — the tests of checks/offline-page.sh.
#
# WHY THIS EXISTS
#   checks/offline-page.sh is the proof that a page reads the same with the network denied, so a
#   bug in it is a proof nobody is checking. These cases run the real script — never a copy of its
#   logic. Some run it with the real `cargo`, `sandbox-exec` and `nc`. The rest put a stand-in for
#   one program in a folder of their own, ahead of the real tools on PATH, so each refusal has a
#   case that makes exactly that refusal happen. No case changes a committed fixture, and none sets
#   a variable the script reads: the script takes its programs from PATH alone.
#
# USAGE
#   checks/tests/test_offline_page.sh
#   A missing prerequisite (cargo, sandbox-exec, nc, shasum) FAILS the suite with a stated message
#   and runs no case: a skip would let CI conclude green having proved nothing.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OFFLINE_PAGE_SH="$ROOT/checks/offline-page.sh"
REPO_FIXTURE="checks/fixtures/repo"

OUT=""
ERR=""
STATUS=0
WORK=""

CASES="
test_the_repo_fixture_reads_the_same_with_the_network_denied
test_a_page_that_differs_between_the_two_runs_is_named
test_a_denial_that_does_not_hold_is_refused
test_a_folder_with_no_markdown_file_is_refused
test_a_run_that_did_not_complete_is_refused
test_a_denied_run_that_did_not_complete_is_refused
test_a_denied_render_that_finds_no_markdown_file_is_refused
test_a_markdown_extension_page_is_rendered_not_refused_as_no_markdown
test_no_argument_and_two_arguments_print_usage_and_exit_two
test_a_file_as_the_argument_is_refused_naming_it
test_a_run_leaves_the_folder_as_it_found_it
test_the_check_reads_no_variable_of_its_own
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# Runs the script from the product root with the arguments given. OUT is its stdout alone, ERR its
# stderr alone, so a case can say which stream a thing appeared on.
run_offline_page() {
  OUT="$(cd "$ROOT" && "$OFFLINE_PAGE_SH" "$@" 2> "$WORK/stderr")"
  STATUS=$?
  ERR="$(cat "$WORK/stderr")"
}

# Same, with the stand-in directory $1 ahead of the real tools on PATH.
run_offline_page_with_stand_ins() {
  stand_ins="$1"
  shift
  OUT="$(cd "$ROOT" && PATH="$stand_ins:$PATH" "$OFFLINE_PAGE_SH" "$@" 2> "$WORK/stderr")"
  STATUS=$?
  ERR="$(cat "$WORK/stderr")"
}

# A stand-in walk program in folder $1, whose body is $2. It is what a stand-in `cargo` names.
make_walk_stand_in() {
  mkdir -p "$1"
  printf '#!/bin/sh\n%s\n' "$2" > "$1/walk"
  chmod +x "$1/walk"
}

# A stand-in `cargo` in folder $1 that builds nothing and prints the one JSON line the script reads
# the walk program from, naming the stand-in walk program in the same folder.
make_cargo_stand_in() {
  mkdir -p "$1"
  printf '#!/bin/sh\necho '"'"'{"reason":"compiler-artifact","target":{"name":"walk"},"executable":"%s/walk"}'"'"'\n' \
    "$1" > "$1/cargo"
  chmod +x "$1/cargo"
}

# A stand-in `sandbox-exec` in folder $1 that drops `-p <profile>` and runs the rest undenied.
make_undenied_sandbox_exec_stand_in() {
  mkdir -p "$1"
  printf '#!/bin/sh\nshift 2\nexec "$@"\n' > "$1/sandbox-exec"
  chmod +x "$1/sandbox-exec"
}

# One line per entry under $1 — relative path, kind, and the bytes (a checksum) or a link's target —
# read with `shasum` and `readlink`, so a case compares folders with a yardstick the script under
# test does not supply. Links are never followed.
manifest_of() {
  (
    cd "$1" || exit 1
    find . -mindepth 1 | LC_ALL=C sort | while IFS= read -r entry; do
      if [ -L "$entry" ]; then
        printf '%s link %s\n' "$entry" "$(readlink "$entry")"
      elif [ -d "$entry" ]; then
        printf '%s dir\n' "$entry"
      elif [ -f "$entry" ]; then
        printf '%s file %s\n' "$entry" "$(shasum < "$entry" | cut -d ' ' -f 1)"
      else
        printf '%s other\n' "$entry"
      fi
    done
  )
}

# The lines of manifest $2 that are not in manifest $1, on one line separated by single spaces.
only_in_second() {
  printf '%s\n' "$1" | LC_ALL=C sort > "$WORK/manifest-first"
  printf '%s\n' "$2" | LC_ALL=C sort > "$WORK/manifest-second"
  comm -13 "$WORK/manifest-first" "$WORK/manifest-second" | tr '\n' ' ' | sed 's/ $//'
}

expect_status() {
  [ "$STATUS" -eq "$1" ] || fail "expected exit $1, got $STATUS. stdout: $OUT stderr: $ERR"
}

expect_nonzero_status() {
  [ "$STATUS" -ne 0 ] || fail "expected a non-zero exit, got 0. stdout: $OUT"
}

expect_stdout_is() {
  [ "$OUT" = "$1" ] || fail "expected stdout exactly [$1], got [$OUT]. stderr: $ERR"
}

expect_stdout_lacks_same() {
  case "$OUT" in
    *same*) fail "stdout says same: $OUT" ;;
  esac
}

expect_stderr_contains() {
  case "$ERR" in
    *"$1"*) return 0 ;;
  esac
  fail "expected stderr to contain: $1. stderr: $ERR"
}

# --- the cases ---

# CP-1131, CP-1132, CP-1136: the real cargo, sandbox-exec and nc over the committed fixture.
test_the_repo_fixture_reads_the_same_with_the_network_denied() {
  run_offline_page "$REPO_FIXTURE"

  expect_status 0 || return 1
  expect_stdout_is "same"
}

# One page differs between the two runs: the stand-in walk program prints another page for guide.md
# the second time it runs, keeping its count in the case's own folder. The check starts the allowed
# render first and the denied one second.
test_a_page_that_differs_between_the_two_runs_is_named() {
  local stand_ins="$WORK/differs"
  make_cargo_stand_in "$stand_ins"
  make_walk_stand_in "$stand_ins" "counter='$stand_ins/count'
runs=1
[ ! -f \"\$counter\" ] || runs=\$((\$(cat \"\$counter\") + 1))
echo \"\$runs\" > \"\$counter\"
printf 'README.md\\tthe same page\\n'
printf 'guide.md\\tpage of run %s\\n' \"\$runs\""

  run_offline_page_with_stand_ins "$stand_ins" "$REPO_FIXTURE"

  expect_status 1 || return 1
  expect_stdout_is "guide.md"
}

# CP-1133: a denial that is not in force. The stand-in sandbox-exec runs its command undenied, so the
# connection the check expects to be refused succeeds.
test_a_denial_that_does_not_hold_is_refused() {
  local stand_ins="$WORK/undenied"
  make_cargo_stand_in "$stand_ins"
  make_walk_stand_in "$stand_ins" "printf 'README.md\\tpage\\n'"
  make_undenied_sandbox_exec_stand_in "$stand_ins"

  run_offline_page_with_stand_ins "$stand_ins" "$REPO_FIXTURE"

  expect_nonzero_status || return 1
  expect_stdout_lacks_same || return 1
  expect_stderr_contains "offline-page.sh: the denial did not hold"
}

# CP-1133: a folder that holds only a text file renders no page.
test_a_folder_with_no_markdown_file_is_refused() {
  mkdir -p "$WORK/no-markdown"
  printf 'not a page\n' > "$WORK/no-markdown/note.txt"

  run_offline_page "$WORK/no-markdown"

  expect_nonzero_status || return 1
  expect_stdout_lacks_same || return 1
  expect_stderr_contains "found no Markdown file under" || return 1
  expect_stderr_contains "offline-page.sh: the render with the network allowed found no Markdown file under"
}

# CP-1133: a render that ends non-zero did not complete, and its reason stays on stderr.
test_a_run_that_did_not_complete_is_refused() {
  local stand_ins="$WORK/did-not-complete"
  make_cargo_stand_in "$stand_ins"
  make_walk_stand_in "$stand_ins" "echo 'the stand-in walk stops here' >&2
exit 3"

  run_offline_page_with_stand_ins "$stand_ins" "$REPO_FIXTURE"

  expect_nonzero_status || return 1
  expect_stdout_lacks_same || return 1
  expect_stderr_contains "did not complete over"
}

# The denied render alone fails to complete: the stand-in walk program prints the same page both
# times and exits non-zero the second time, so a check that ignored the denied render's status would
# find two equal pages and say `same`.
test_a_denied_run_that_did_not_complete_is_refused() {
  local stand_ins="$WORK/denied-did-not-complete"
  make_cargo_stand_in "$stand_ins"
  make_walk_stand_in "$stand_ins" "counter='$stand_ins/count'
runs=1
[ ! -f \"\$counter\" ] || runs=\$((\$(cat \"\$counter\") + 1))
echo \"\$runs\" > \"\$counter\"
printf 'README.md\\tthe same page\\n'
[ \"\$runs\" -eq 1 ] || exit 3"

  run_offline_page_with_stand_ins "$stand_ins" "$REPO_FIXTURE"

  expect_nonzero_status || return 1
  expect_stdout_lacks_same || return 1
  expect_stderr_contains "offline-page.sh: the render denied the network did not complete over"
}

# The denied render completes and finds no Markdown file though the allowed one found one.
test_a_denied_render_that_finds_no_markdown_file_is_refused() {
  local stand_ins="$WORK/denied-finds-none"
  make_cargo_stand_in "$stand_ins"
  make_walk_stand_in "$stand_ins" "counter='$stand_ins/count'
runs=1
[ ! -f \"\$counter\" ] || runs=\$((\$(cat \"\$counter\") + 1))
echo \"\$runs\" > \"\$counter\"
[ \"\$runs\" -ne 1 ] || printf 'README.md\\tthe same page\\n'"

  run_offline_page_with_stand_ins "$stand_ins" "$REPO_FIXTURE"

  expect_nonzero_status || return 1
  expect_stdout_lacks_same || return 1
  expect_stderr_contains "offline-page.sh: the render denied the network found no Markdown file under"
}

# CP-1125, CP-1131: the pages mode and the walk share one predicate that decides a Markdown file by
# the answer, so a `.markdown` page is rendered and not refused as no Markdown.
test_a_markdown_extension_page_is_rendered_not_refused_as_no_markdown() {
  mkdir -p "$WORK/markdown-extension"
  cp "$ROOT/$REPO_FIXTURE/diagram.png" "$WORK/markdown-extension/diagram.png"
  printf '# Notes\n\n![beside](diagram.png)\n\n![outside](https://example.com/n.png)\n' \
    > "$WORK/markdown-extension/notes.markdown"

  run_offline_page "$WORK/markdown-extension"

  expect_status 0 || return 1
  expect_stdout_is "same"
}

# CP-1132: the argument count is not one.
test_no_argument_and_two_arguments_print_usage_and_exit_two() {
  run_offline_page
  expect_status 2 || return 1
  expect_stdout_is "" || return 1
  expect_stderr_contains "offline-page.sh: usage: offline-page.sh <folder>" || return 1

  run_offline_page "$REPO_FIXTURE" "$REPO_FIXTURE"
  expect_status 2 || return 1
  expect_stdout_is "" || return 1
  expect_stderr_contains "offline-page.sh: usage: offline-page.sh <folder>"
}

# CP-1132: the argument is a file.
test_a_file_as_the_argument_is_refused_naming_it() {
  local argument="$REPO_FIXTURE/guide.md"

  run_offline_page "$argument"

  expect_status 1 || return 1
  expect_stdout_is "" || return 1
  expect_stderr_contains "offline-page.sh: not a folder: $argument"
}

# CP-1134: a scratch copy of the fixture holds the same paths, kinds and bytes after a real run. The
# run must have said `same`, so a refusal that wrote nothing cannot pass for a run that left the
# folder alone.
test_a_run_leaves_the_folder_as_it_found_it() {
  local copy="$WORK/copy" before after
  mkdir -p "$copy"
  cp -R "$ROOT/$REPO_FIXTURE/." "$copy"
  before="$(manifest_of "$copy")"

  run_offline_page "$copy"
  expect_status 0 || return 1
  expect_stdout_is "same" || return 1

  after="$(manifest_of "$copy")"
  [ "$before" = "$after" ] \
    || fail "the copy of the repository fixture changed. Only after the run: [$(only_in_second "$before" "$after")] Only before it: [$(only_in_second "$after" "$before")]"
}

# CP-1137, QC-67: the script reads no variable of its own. A source-text negative, read over every
# line that is not a comment: no `${NAME:-…}` or `${NAME-…}`, and no read of an upper-case name the
# script does not itself assign. PATH, HOME and TMPDIR are the platform's.
test_the_check_reads_no_variable_of_its_own() {
  local script="$ROOT/checks/offline-page.sh" assigned entry number text reference name
  assigned=" $(grep -oE '^[A-Z][A-Z0-9_]*=' "$script" | tr -d '=' | tr '\n' ' ') PATH HOME TMPDIR "
  while IFS= read -r entry; do
    number="${entry%%:*}"
    text="${entry#*:}"
    if printf '%s\n' "$text" | grep -qE '\$\{[A-Z][A-Z0-9_]*:?-'; then
      fail "checks/offline-page.sh reads a variable it does not assign: $number: $text" || return 1
    fi
    for reference in $(printf '%s\n' "$text" | grep -oE '\$\{?[A-Z][A-Z0-9_]*' || true); do
      name="${reference#\$}"
      name="${name#\{}"
      case "$assigned" in
        *" $name "*) ;;
        *) fail "checks/offline-page.sh reads a variable it does not assign: $number: $text" || return 1 ;;
      esac
    done
  done < <(grep -nv '^[[:space:]]*#' "$script")
}

# --- the runner ---

for tool in cargo sandbox-exec nc shasum; do
  if ! command -v "$tool" > /dev/null 2>&1; then
    echo "test_offline_page.sh: a prerequisite is absent: $tool — put it on PATH; the suite does not skip" >&2
    exit 1
  fi
done

WORK="$(mktemp -d)"
cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

failed=0
total=0
for case_name in $CASES; do
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

#!/usr/bin/env bash
# Version: 1.0.0 — first version: drives the real checks/strings.sh against temporary copies of
#   the message catalogue and of docs/CONTENT.md, with the negative controls that prove the suite
#   and the every-term case can fail
#
# checks/tests/test_strings.sh — the tests of checks/strings.sh, the QC-53 catalogue lint.
#
# WHY THIS EXISTS
#   checks/strings.sh fails the build when a string literal under ka-reader-mac/Sources/Surfaces
#   holds a term docs/CONTENT.md bans in the words KA-Reader writes. A lint that passes everything
#   looks the same as a lint that works, so these cases run the real script — never a copy of its
#   logic — against temporary copies of the catalogue with a banned word planted in a literal, in
#   an identifier and in a comment, and require the first to fail and the others to pass. The
#   every-term case reads the table itself with code that shares nothing with the lint and plants
#   each term alone, so a term the lint misses fails the suite. Three cases run this suite again
#   against a copy of the lint altered to miss a finding, to show that the suite then turns red.
#
# USAGE
#   checks/tests/test_strings.sh
#     KA_READER_TEST_ONLY=<case> runs one case.
#   Two variables exist for the cases that run this suite against an altered lint, and a person
#   running the suite sets neither: KA_READER_STRINGS_SH names the lint under test (the tree's own
#   checks/strings.sh when unset) and KA_READER_TEST_CONTENT names the file the every-term case
#   reads its terms from (the tree's docs/CONTENT.md when unset).
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.
#
# WHERE IT WRITES
#   Only below one `mktemp -d` directory outside the product tree, removed by a trap on exit. The
#   product tree is read: its catalogue and docs/CONTENT.md are copied, and
#   test_originating_tree_is_unchanged compares git status and the bytes of both before and after.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SUITE_SH="$ROOT/checks/tests/test_strings.sh"
STRINGS_SH="${KA_READER_STRINGS_SH:-$ROOT/checks/strings.sh}"
ORACLE_CONTENT="${KA_READER_TEST_CONTENT:-$ROOT/docs/CONTENT.md}"
CONTENT_REAL="$ROOT/docs/CONTENT.md"
SURFACES="ka-reader-mac/Sources/Surfaces"
PLANT_FILE="$SURFACES/ConditionSentences.swift"
BANNED_TITLE="Banned in the words KA-Reader writes"
NL="
"

OUT=""
STDOUT=""
STDERR=""
STATUS=0
WORK=""
COPY=""

CASES="
test_both_files_are_executable_and_carry_a_version_line
test_both_files_parse_under_bash_n
test_swift_file_in_a_subfolder_is_read
test_swift_file_outside_the_catalogue_is_not_read
test_non_swift_file_in_the_catalogue_is_not_read
test_multiline_literal_is_checked
test_raw_literal_is_checked
test_line_comment_quoting_a_term_passes
test_nested_block_comment_passes
test_comment_markers_inside_a_literal_are_literal_text
test_interpolation_code_is_not_checked
test_literal_text_on_both_sides_of_an_interpolation_is_checked
test_gloss_in_parentheses_is_not_part_of_the_term
test_term_ending_in_a_colon_is_reported_as_the_table_writes_it
test_term_is_found_in_any_letter_case_and_at_a_literal_edge
test_term_inside_a_longer_word_is_not_a_hit
test_real_snake_case_values_are_not_hits
test_one_line_per_file_and_term_pair
test_unchanged_catalogue_copy_passes
test_missing_catalogue_folder_fails_naming_it
test_catalogue_with_no_swift_file_fails_naming_it
test_content_without_the_banned_table_fails_naming_it
test_error_planted_in_a_literal_fails
test_term_from_another_row_planted_in_a_literal_fails
test_error_in_an_identifier_passes
test_error_in_a_comment_passes_bare_and_quoted
test_every_banned_term_planted_alone_fails
test_every_term_case_fails_when_the_check_misses_a_term
test_a_missed_finding_fails_its_case_and_the_suite
test_raw_multiline_and_multi_hash_literals_are_checked
test_escapes_are_checked_as_spelled
test_doc_comments_and_multiline_comments_pass
test_literal_after_a_comment_is_checked
test_backticked_identifier_and_regex_literal_are_not_checked
test_nested_interpolation_is_wholly_skipped
test_raw_literal_interpolation_follows_its_hashes
test_missing_content_fails_naming_it
test_empty_never_column_fails_naming_it
test_every_term_case_fails_when_it_reads_no_term
test_term_added_to_the_table_is_caught_without_editing_the_check
test_term_in_another_table_or_column_is_not_banned
test_repeats_in_one_file_give_one_line_per_term
test_distinct_terms_in_one_literal_are_all_reported
test_punctuation_in_a_term_is_matched_as_written
test_root_argument_with_spaces_from_another_directory
test_default_root_is_the_checkout_the_script_sits_in
test_separate_literals_are_not_joined
test_spacing_is_checked_as_written
test_failing_case_still_cleans_up_and_fails_the_suite
test_originating_tree_is_unchanged
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# The captured stdout and stderr of the last run, indented under the line that introduced them.
show_output() {
  printf '%s\n%s\n' "$STDOUT" "$STDERR" | sed '/^$/d; s/^/  /'
}

# A fresh copy of the catalogue and of docs/CONTENT.md at the directory $1.
new_copy_at() {
  COPY="$1"
  rm -rf "$COPY"
  mkdir -p "$COPY/docs" "$COPY/$SURFACES"
  cp "$CONTENT_REAL" "$COPY/docs/CONTENT.md"
  cp -R "$ROOT/$SURFACES/." "$COPY/$SURFACES/"
}

new_copy() {
  new_copy_at "$WORK/copy-$1"
}

# Writes stdin to the file $1, creating its folder.
put_file() {
  mkdir -p "$(dirname "$1")"
  cat > "$1"
}

# Appends stdin to the file $1 after a newline, so a last line without one cannot swallow it.
append_file() {
  printf '\n' >> "$1"
  cat >> "$1"
}

# Runs the lint under test with the arguments given, keeping its status and its two streams.
run_lint() {
  "$STRINGS_SH" "$@" > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?
  STDOUT="$(cat "$WORK/stdout")"
  STDERR="$(cat "$WORK/stderr")"
}

# The same, from the working directory $1.
run_lint_from() {
  local dir="$1"
  shift
  (cd "$dir" && "$STRINGS_SH" "$@") > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?
  STDOUT="$(cat "$WORK/stdout")"
  STDERR="$(cat "$WORK/stderr")"
}

# Whether the last run printed a finding line for file $1 and term $2.
has_finding() {
  printf '%s\n' "$STDERR" | awk -v prefix="$1: QC-53: a string literal holds \"$2\"," \
    'index($0, prefix) == 1 { found = 1 } END { exit !found }'
}

# The last run failed and named file $1 and term $2.
expect_hit() {
  if [ "$STATUS" -eq 0 ]; then
    fail "checks/strings.sh exited 0 on a copy where \"$2\" was planted in a string literal of $1, so it did not report the planted term. Its output follows."
    show_output
    return 1
  fi
  has_finding "$1" "$2" && return 0
  fail "checks/strings.sh exited with status $STATUS but printed no QC-53 line naming $1 and \"$2\". Its output follows."
  show_output
  return 1
}

# The last run passed with no QC-53 line, on a copy where no literal it reads holds a banned term.
expect_clean() {
  if [ "$STATUS" -ne 0 ]; then
    fail "checks/strings.sh exited with status $STATUS on a copy where no string literal it reads holds a banned term. Its output follows."
    show_output
    return 1
  fi
  case "$STDOUT$NL$STDERR" in
    *QC-53*)
      fail "checks/strings.sh exited 0 but printed a QC-53 line on a copy where no string literal it reads holds a banned term. Its output follows."
      show_output
      return 1
      ;;
  esac
}

# The last run failed with exactly one stderr line, and the line names the input $1.
expect_one_line_naming() {
  local lines
  lines="$(printf '%s\n' "$STDERR" | grep -c .)"
  if [ "$STATUS" -eq 0 ] || [ "$lines" -ne 1 ] || ! printf '%s' "$STDERR" | grep -qF -- "$1"; then
    fail "checks/strings.sh did not stop with one stderr line naming $1, which this copy lacks. Its exit status was $STATUS; its output follows."
    show_output
    return 1
  fi
}

# The number of QC-53 lines the last run printed on stderr.
finding_count() {
  printf '%s\n' "$STDERR" | grep -c 'QC-53'
}

# The last run's findings as "<path> <term>" lines, in sorted order.
findings_set() {
  printf '%s\n' "$STDERR" | grep 'QC-53' \
    | sed 's/^\(.*\): QC-53: a string literal holds "\(.*\)", matched in any letter case.*$/\1 \2/' \
    | LC_ALL=C sort
}

# The last run's findings are exactly the pairs given as arguments "<path> <term>", no more, no less.
expect_exactly_pairs() {
  local expected found wanted
  wanted="$#"
  expected="$(printf '%s\n' "$@" | LC_ALL=C sort)"
  found="$(finding_count)"
  if [ "$found" -ne "$wanted" ] || [ "$(findings_set)" != "$expected" ]; then
    fail "checks/strings.sh printed a different number of QC-53 lines than the file and term pairs planted; lines printed: $found; pairs planted: $wanted. Its output follows."
    show_output
    return 1
  fi
}

# Every path a finding names is relative to the root $1 the run was given.
expect_relative_paths() {
  local line path
  while IFS= read -r line; do
    path="${line%%: QC-53:*}"
    case "$path" in
      /* | "$1"*)
        fail "checks/strings.sh printed a QC-53 line naming $path, which is not a path relative to the root it was given, $1. Its output follows."
        show_output
        return 1
        ;;
    esac
  done <<EOF
$(printf '%s\n' "$STDERR" | grep 'QC-53')
EOF
  return 0
}

# The terms of the Never column, read from the table without any of the lint's code: the lines from
# the table's title to the next heading, the rows, the first column, the glosses cut, the commas split.
oracle_terms() {
  sed -n "/^\*\*$BANNED_TITLE:\*\*\$/,/^### /p" "$ORACLE_CONTENT" 2> /dev/null \
    | grep '^| ' | sed '1,2d' | cut -d'|' -f2 | sed 's/([^)]*)//g' | tr ',' '\n' \
    | sed 's/^ *//; s/ *$//' | grep -v '^$'
}

fail_read_no_term() {
  fail 'The case read no term from the Never column of the "Banned in the words KA-Reader writes" table in docs/CONTENT.md, so it checked nothing. Run the suite from a KA-Reader checkout whose docs/CONTENT.md has that table.'
}

# A copy of the lint at $1 that drops the term $2 right after the line that reads the terms.
make_altered_lint() {
  local line
  mkdir -p "$(dirname "$1")"
  : > "$1"
  while IFS= read -r line || [ -n "$line" ]; do
    printf '%s\n' "$line" >> "$1"
    case "$line" in
      'terms='*)
        printf '%s\n' "terms=\"\$(printf '%s\\n' \"\$terms\" | grep -vxF -- '$2')\"" >> "$1"
        ;;
    esac
  done < "$ROOT/checks/strings.sh"
  chmod +x "$1"
}

# Runs this suite again, for the one case $1, with the variables given after it set.
NESTED_OUT=""
NESTED_STATUS=0
run_nested() {
  local case_name="$1"
  shift
  NESTED_OUT="$(env KA_READER_SUITE_NESTED=1 KA_READER_TEST_ONLY="$case_name" "$@" bash "$SUITE_SH" 2>&1)"
  NESTED_STATUS=$?
}

nested_output_indented() {
  printf '%s\n' "$NESTED_OUT" | sed 's/^/  /'
}

# The rows of the tree's git status and the checksums of the files the suite must not change.
tree_status() {
  git -C "$ROOT" status --porcelain 2> /dev/null
}

tree_sums() {
  (
    cd "$ROOT" || exit 0
    find docs/CONTENT.md "$SURFACES" -type f 2> /dev/null | LC_ALL=C sort | while IFS= read -r file; do
      printf '%s %s\n' "$(cksum < "$file")" "$file"
    done
  )
}

# --- cases ---

# CP-913.
test_both_files_are_executable_and_carry_a_version_line() {
  local file
  for file in checks/strings.sh checks/tests/test_strings.sh; do
    [ -x "$ROOT/$file" ] || fail "$file is not executable. Make it executable with chmod +x $file, then run the suite again." || return 1
    [ "$(head -20 "$ROOT/$file" | grep -c '^# Version:')" -ge 1 ] \
      || fail "$file has no line beginning # Version: in its first 20 lines. Add one, as every other script under checks/ carries, then run the suite again." || return 1
  done
}

test_both_files_parse_under_bash_n() {
  local file result
  for file in checks/strings.sh checks/tests/test_strings.sh; do
    if ! result="$(bash -n "$ROOT/$file" 2>&1)"; then
      fail "bash -n stopped on $file. Its output follows."
      printf '%s\n' "$result" | sed 's/^/  /'
      return 1
    fi
  done
}

# CP-914: a file at any depth under the folder is read.
test_swift_file_in_a_subfolder_is_read() {
  new_copy subfolder
  put_file "$COPY/$SURFACES/More/NewSentences.swift" <<'EOF'
let message = "An error happened."
EOF
  run_lint "$COPY"
  expect_hit "$SURFACES/More/NewSentences.swift" error
}

# CP-914: a .swift file outside the folder is not read.
test_swift_file_outside_the_catalogue_is_not_read() {
  new_copy outside
  put_file "$COPY/ka-reader-mac/Sources/Other.swift" <<'EOF'
let message = "An error happened."
EOF
  run_lint "$COPY"
  expect_clean
}

# CP-914: a file inside the folder that is not a .swift file is not read.
test_non_swift_file_in_the_catalogue_is_not_read() {
  new_copy non-swift
  put_file "$COPY/$SURFACES/Notes.txt" <<'EOF'
let message = "An error happened."
EOF
  put_file "$COPY/$SURFACES/Old.swift.bak" <<'EOF'
let message = "An error happened."
EOF
  run_lint "$COPY"
  expect_clean
}

# CP-915: a multiline literal.
test_multiline_literal_is_checked() {
  new_copy multiline
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let planted = """
    Please choose a folder.
    """
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" please
}

# CP-915: a raw literal.
test_raw_literal_is_checked() {
  new_copy raw
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let planted = #"The repo is here."#
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" repo
}

# CP-915: a comment quoting a banned word is not a literal.
test_line_comment_quoting_a_term_passes() {
  new_copy line-comment
  append_file "$COPY/$PLANT_FILE" <<'EOF'
// Not "error": the sentence names what KA-Reader observed
EOF
  run_lint "$COPY"
  expect_clean
}

test_nested_block_comment_passes() {
  new_copy nested-comment
  append_file "$COPY/$PLANT_FILE" <<'EOF'
/* the user /* nested */ sees this */
/* outer /* inner */ "error" still in the outer comment */
EOF
  run_lint "$COPY"
  expect_clean
}

# CP-915: inside a literal, // and /* are text.
test_comment_markers_inside_a_literal_are_literal_text() {
  new_copy markers-line
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let planted = "See https://example.com // error"
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" error || return 1

  new_copy markers-block
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let planted = "keep /* error */ here"
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" error
}

# CP-916: the code inside an interpolation is not text.
test_interpolation_code_is_not_checked() {
  new_copy interpolation
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let planted = "\(failedName) can't be shown as text."
let second = "\(failed) was not read."
EOF
  run_lint "$COPY"
  expect_clean
}

# CP-916: the text on both sides of an interpolation is.
test_literal_text_on_both_sides_of_an_interpolation_is_checked() {
  new_copy both-sides
  put_file "$COPY/$SURFACES/Planted/After.swift" <<'EOF'
let planted = "\(name) failed to load."
EOF
  put_file "$COPY/$SURFACES/Planted/Before.swift" <<'EOF'
let planted = "Reading failed \(name)."
EOF
  run_lint "$COPY"
  expect_hit "$SURFACES/Planted/After.swift" failed || return 1
  expect_hit "$SURFACES/Planted/Before.swift" failed
}

# CP-917: the gloss is not part of the term.
test_gloss_in_parentheses_is_not_part_of_the_term() {
  new_copy gloss
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let planted = "Using the floor."
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" "the floor"
}

# CP-917, CP-919: the finding names the term as the table writes it.
test_term_ending_in_a_colon_is_reported_as_the_table_writes_it() {
  new_copy colon
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let planted = "NOTE: this is new."
let other = "Note: this is new."
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" "Note:"
}

# CP-918: letter case does not matter, and the edges of a literal count as boundaries.
test_term_is_found_in_any_letter_case_and_at_a_literal_edge() {
  new_copy case
  put_file "$COPY/$SURFACES/Planted/Capital.swift" <<'EOF'
let planted = "Error reading."
EOF
  put_file "$COPY/$SURFACES/Planted/Upper.swift" <<'EOF'
let planted = "ERROR"
EOF
  put_file "$COPY/$SURFACES/Planted/Stop.swift" <<'EOF'
let planted = "it was an error."
EOF
  put_file "$COPY/$SURFACES/Planted/Alone.swift" <<'EOF'
let planted = "error"
EOF
  run_lint "$COPY"
  expect_hit "$SURFACES/Planted/Capital.swift" error || return 1
  expect_hit "$SURFACES/Planted/Upper.swift" error || return 1
  expect_hit "$SURFACES/Planted/Stop.swift" error || return 1
  expect_hit "$SURFACES/Planted/Alone.swift" error
}

# CP-918: a letter, digit or underscore beside an end of the term, a non-ASCII letter included, is
# not a whole word; a non-ASCII punctuation mark is not a letter.
test_term_inside_a_longer_word_is_not_a_hit() {
  new_copy longer
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let a = "errors"
let b = "errorCount"
let c = "error1 and 1error"
let d = "error_ and _error"
let e = "xerror and errorx"
EOF
  printf 'let f = "\303\251error and error\303\251"\n' >> "$COPY/$PLANT_FILE"
  run_lint "$COPY"
  expect_clean || return 1

  new_copy dash
  printf '\nlet planted = "\342\200\224error\342\200\224"\n' >> "$COPY/$PLANT_FILE"
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" error
}

# CP-918: the real values of the catalogue that carry a banned word joined by an underscore.
test_real_snake_case_values_are_not_hits() {
  new_copy snake
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let a = "invalid_utf8"
let b = "invalid_utf16"
let c = "repository_read_failed"
EOF
  run_lint "$COPY"
  expect_clean
}

# CP-919: one line for each file and term pair, compared as a set.
test_one_line_per_file_and_term_pair() {
  new_copy pairs
  put_file "$COPY/$SURFACES/Planted/A.swift" <<'EOF'
let planted = "A fatal error."
EOF
  put_file "$COPY/$SURFACES/Planted/B.swift" <<'EOF'
let planted = "A fatal error."
EOF
  run_lint "$COPY"
  expect_exactly_pairs "$SURFACES/Planted/A.swift error" "$SURFACES/Planted/A.swift fatal" \
    "$SURFACES/Planted/B.swift error" "$SURFACES/Planted/B.swift fatal" || return 1
  expect_relative_paths "$COPY"
}

# CP-920, CP-923 (a): the passing control.
test_unchanged_catalogue_copy_passes() {
  new_copy unchanged
  run_lint "$COPY"
  expect_clean
}

# CP-921.
test_missing_catalogue_folder_fails_naming_it() {
  new_copy no-folder
  rm -rf "${COPY:?}/$SURFACES"
  run_lint "$COPY"
  expect_one_line_naming "$SURFACES"
}

test_catalogue_with_no_swift_file_fails_naming_it() {
  new_copy no-swift
  find "$COPY/$SURFACES" -name '*.swift' -delete
  run_lint "$COPY"
  expect_one_line_naming "$SURFACES"
}

test_content_without_the_banned_table_fails_naming_it() {
  new_copy no-table
  printf '# Content\n\nNo table is written here.\n' > "$COPY/docs/CONTENT.md"
  run_lint "$COPY"
  expect_one_line_naming docs/CONTENT.md
}

# CP-923 (b): the evidence is the finding itself, shown under the ok line.
test_error_planted_in_a_literal_fails() {
  new_copy plant-error
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let planted = "An error happened."
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" error || return 1
  if [ -z "${KA_READER_SUITE_NESTED:-}" ]; then
    run_nested test_error_planted_in_a_literal_fails
    if ! printf '%s\n' "$NESTED_OUT" | grep -q '^ok   test_error_planted_in_a_literal_fails$' \
      || ! printf '%s\n' "$NESTED_OUT" | grep -q '^  .*QC-53'; then
      fail "The suite ran this case again and its result output did not carry the QC-53 finding the check printed. Its output follows."
      nested_output_indented
      return 1
    fi
  fi
  printf '%s\n' "$STDERR" | grep 'QC-53' | sed 's/^/  /'
}

# CP-923 (c): a term of another row of the table.
test_term_from_another_row_planted_in_a_literal_fails() {
  local term
  term="$(oracle_terms | head -1)"
  [ -n "$term" ] || { fail_read_no_term; return 1; }
  new_copy plant-other
  printf '\nlet planted = "Using %s here."\n' "$term" >> "$COPY/$PLANT_FILE"
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" "$term" || return 1
  printf '%s\n' "$STDERR" | grep 'QC-53' | sed 's/^/  /'
}

# CP-923 (d).
test_error_in_an_identifier_passes() {
  new_copy identifier
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let error = 1
func error() {}
var errorCount = error
EOF
  run_lint "$COPY"
  expect_clean
}

# CP-923 (e).
test_error_in_a_comment_passes_bare_and_quoted() {
  new_copy comments
  append_file "$COPY/$PLANT_FILE" <<'EOF'
// error
// "error"
/* error */
/* "error" */
EOF
  run_lint "$COPY"
  expect_clean
}

# CP-924: every term of the table, read by code that is not the lint's, planted alone.
test_every_banned_term_planted_alone_fails() {
  local terms term count=0 bad=0
  terms="$(oracle_terms)"
  [ -n "$terms" ] || { fail_read_no_term; return 1; }
  while IFS= read -r term; do
    count=$((count + 1))
    new_copy "every-$count"
    printf '\nlet planted = "before %s after"\n' "$term" >> "$COPY/$PLANT_FILE"
    run_lint "$COPY"
    expect_hit "$PLANT_FILE" "$term" || bad=1
    rm -rf "$COPY"
  done <<EOF
$terms
EOF
  [ "$bad" -eq 0 ]
}

# CP-924: a lint altered to miss a term fails the every-term case.
test_every_term_case_fails_when_the_check_misses_a_term() {
  local term
  [ -z "${KA_READER_SUITE_NESTED:-}" ] || return 0
  term="$(oracle_terms | head -1)"
  [ -n "$term" ] || { fail_read_no_term; return 1; }
  make_altered_lint "$WORK/altered-term/checks/strings.sh" "$term"
  run_nested test_every_banned_term_planted_alone_fails KA_READER_STRINGS_SH="$WORK/altered-term/checks/strings.sh"
  if ! printf '%s\n' "$NESTED_OUT" | grep -q '^FAIL test_every_banned_term_planted_alone_fails$'; then
    fail "The every-term case passed against a copy of checks/strings.sh altered to miss \"$term\", so it does not catch a term the check misses. Its output follows."
    nested_output_indented
    return 1
  fi
}

# CP-926: a lint altered to miss a finding turns its case red and the suite's exit non-zero.
test_a_missed_finding_fails_its_case_and_the_suite() {
  [ -z "${KA_READER_SUITE_NESTED:-}" ] || return 0
  make_altered_lint "$WORK/altered-finding/checks/strings.sh" error
  run_nested test_error_planted_in_a_literal_fails KA_READER_STRINGS_SH="$WORK/altered-finding/checks/strings.sh"
  if ! printf '%s\n' "$NESTED_OUT" | grep -q '^FAIL test_error_planted_in_a_literal_fails$'; then
    fail "The suite ran against a copy of checks/strings.sh altered to miss a finding, and test_error_planted_in_a_literal_fails did not report FAIL. Its output follows."
    nested_output_indented
    return 1
  fi
  if [ "$NESTED_STATUS" -eq 0 ]; then
    fail "The suite ran against a copy of checks/strings.sh altered to miss a finding and exited 0, so a failing case does not fail the suite. Its output follows."
    nested_output_indented
    return 1
  fi
}

# CP-915: raw multiline literals and delimiters of two hashes; a quote or a hash count that does
# not match the opening does not end the literal.
test_raw_multiline_and_multi_hash_literals_are_checked() {
  new_copy raw-forms-clean
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let a = ##"quote "# stays open, then it closes"## // "error"
let b = #"""
    one "quote" and three """ stay text
    """# // "failed"
EOF
  run_lint "$COPY"
  expect_clean || return 1

  new_copy raw-two-hashes
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let planted = ##"a quote "# does not end it, and error is inside"##
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" error || return 1

  new_copy raw-multiline
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let planted = #"""
    a quote " and """ do not end it
    the line says failed
    """#
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" failed
}

# CP-915: a backslash does not end the literal it is in, and an escape is not decoded into a term.
test_escapes_are_checked_as_spelled() {
  new_copy escaped-quotes
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let planted = "say \"error\" now"
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" error || return 1

  new_copy escaped-backslash
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let a = "ends with a backslash\\" // "error"
let b = "err\u{6f}r and \u{65}rror"
EOF
  run_lint "$COPY"
  expect_clean || return 1

  new_copy escape-is-a-boundary
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let planted = "first line\nerror second"
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" error
}

# CP-915: every comment form, a quoted word inside it included.
test_doc_comments_and_multiline_comments_pass() {
  new_copy comment-forms
  append_file "$COPY/$PLANT_FILE" <<'EOF'
/// the "error" is shown
/** "failed" in a block of docs */
/* line "error"
   more "fatal" lines */
EOF
  run_lint "$COPY"
  expect_clean
}

test_literal_after_a_comment_is_checked() {
  new_copy after-comment
  append_file "$COPY/$PLANT_FILE" <<'EOF'
/* "error" */ let a = "it failed to open"
// "error"
let b = "fatal"
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" failed || return 1
  expect_hit "$PLANT_FILE" fatal || return 1
  if has_finding "$PLANT_FILE" error; then
    fail "checks/strings.sh printed a QC-53 line naming $PLANT_FILE and \"error\" for a word inside a comment. Its output follows."
    show_output
    return 1
  fi
}

# CP-915: text that looks like a string and is not one.
test_backticked_identifier_and_regex_literal_are_not_checked() {
  new_copy outside-strings
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let `error "failed" name` = 1
let r1 = #/"error"/#
let r2 = /"failed"/
EOF
  run_lint "$COPY"
  expect_clean || return 1

  new_copy outside-strings-control
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let `error "failed" name` = 1
let r1 = #/"error"/#
let r2 = /"failed"/
let planted = "a fatal sentence"
EOF
  run_lint "$COPY"
  expect_exactly_pairs "$PLANT_FILE fatal"
}

# CP-916: an interpolation is skipped whole, with what it holds.
test_nested_interpolation_is_wholly_skipped() {
  new_copy nested-interpolation
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let a = "\(compute(open("error"), /* "failed" */ (1 + 2))) done"
EOF
  run_lint "$COPY"
  expect_clean || return 1

  new_copy nested-interpolation-after
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let b = "\(compute(1)) failed ok"
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" failed || return 1

  new_copy nested-interpolation-quoted-paren
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let c = "\(f(")")) failed"
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" failed
}

# CP-916: in a raw literal the interpolation is the one marked with the literal's own hashes.
test_raw_literal_interpolation_follows_its_hashes() {
  new_copy raw-interpolation-active
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let a = #"\#(open("error")) ok"#
let b = ##"\##(open("failed")) ok"##
EOF
  run_lint "$COPY"
  expect_clean || return 1

  new_copy raw-interpolation-inactive-one
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let planted = #"\(failed) here"#
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" failed || return 1

  new_copy raw-interpolation-inactive-two
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let planted = ##"\#(failed) here"##
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" failed
}

# CP-921.
test_missing_content_fails_naming_it() {
  new_copy no-content
  rm -f "$COPY/docs/CONTENT.md"
  run_lint "$COPY"
  expect_one_line_naming docs/CONTENT.md
}

test_empty_never_column_fails_naming_it() {
  new_copy empty-never
  cat > "$COPY/docs/CONTENT.md" <<'EOF'
**Banned in the words KA-Reader writes:**

| Never | Say instead | Why |
|---|---|---|
|  | nothing | none |
|   | nothing | none |
EOF
  run_lint "$COPY"
  expect_one_line_naming docs/CONTENT.md
}

# CP-924: the every-term case reading no term is a failure, not a pass.
test_every_term_case_fails_when_it_reads_no_term() {
  [ -z "${KA_READER_SUITE_NESTED:-}" ] || return 0
  printf '# Content\n\nNo table is written here.\n' > "$WORK/content-without-table.md"
  run_nested test_every_banned_term_planted_alone_fails KA_READER_TEST_CONTENT="$WORK/content-without-table.md"
  if ! printf '%s\n' "$NESTED_OUT" | grep -q '^FAIL test_every_banned_term_planted_alone_fails$' \
    || ! printf '%s\n' "$NESTED_OUT" | grep -qF 'The case read no term from the Never column'; then
    fail "The suite ran against a copy of checks/strings.sh altered to miss a finding, and test_every_banned_term_planted_alone_fails did not report FAIL. Its output follows."
    nested_output_indented
    return 1
  fi
}

# CP-917: the terms are read from the file when the check runs.
test_term_added_to_the_table_is_caught_without_editing_the_check() {
  new_copy added-term
  awk '{ print } f == 1 { print "| zorpnik | nothing | none |"; f = 0 } /^\| Never \| Say instead \| Why \|$/ { f = 1 }' \
    "$CONTENT_REAL" > "$COPY/docs/CONTENT.md"
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let planted = "A zorpnik appears."
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" zorpnik
}

# CP-917: only the Never column of the banned table is the banned set.
test_term_in_another_table_or_column_is_not_banned() {
  new_copy other-column
  cp "$CONTENT_REAL" "$COPY/docs/CONTENT.md"
  cat >> "$COPY/docs/CONTENT.md" <<'EOF'

**A different table:**

| Never | Say instead |
|---|---|
| quorp | blorp |
EOF
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let a = "Say quorp"
let b = "Say blorp"
let c = "Say repository now"
let d = "Say link now"
EOF
  run_lint "$COPY"
  expect_clean
}

# CP-919: repeats in one file give one line for each term.
test_repeats_in_one_file_give_one_line_per_term() {
  new_copy repeats
  put_file "$COPY/$SURFACES/Planted/Repeats.swift" <<'EOF'
let a = "fatal error one"
let b = "another error"
let c = "error again"
EOF
  run_lint "$COPY"
  expect_exactly_pairs "$SURFACES/Planted/Repeats.swift error" "$SURFACES/Planted/Repeats.swift fatal"
}

test_distinct_terms_in_one_literal_are_all_reported() {
  new_copy distinct
  put_file "$COPY/$SURFACES/Planted/Distinct.swift" <<'EOF'
let planted = "A fatal error failed."
EOF
  run_lint "$COPY"
  expect_exactly_pairs "$SURFACES/Planted/Distinct.swift error" "$SURFACES/Planted/Distinct.swift fatal" \
    "$SURFACES/Planted/Distinct.swift failed"
}

# CP-918: a term is data. Its punctuation is never a pattern.
test_punctuation_in_a_term_is_matched_as_written() {
  new_copy punctuation-hits
  cat > "$COPY/docs/CONTENT.md" <<'EOF'
**Banned in the words KA-Reader writes:**

| Never | Say instead | Why |
|---|---|---|
| a.c, x+y | nothing | none |
| p*q, uh-oh, don't worry | nothing | none |
| only takes a second, Note: | nothing | none |
EOF
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let a = "see a.c here"
let b = "1 x+y 2"
let c = "p*q"
let d = "Oh uh-oh."
let e = "oh, don't worry."
let f = "it only takes a second."
let g = "Note: look"
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" "a.c" || return 1
  expect_hit "$PLANT_FILE" "x+y" || return 1
  expect_hit "$PLANT_FILE" "p*q" || return 1
  expect_hit "$PLANT_FILE" "uh-oh" || return 1
  expect_hit "$PLANT_FILE" "don't worry" || return 1
  expect_hit "$PLANT_FILE" "only takes a second" || return 1
  expect_hit "$PLANT_FILE" "Note:" || return 1

  new_copy punctuation-misses
  cp "$WORK/copy-punctuation-hits/docs/CONTENT.md" "$COPY/docs/CONTENT.md"
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let a = "see abc here"
let b = "xxy"
let c = "ppq"
let d = "uh oh"
let e = "dont worry"
let f = "it only takes second"
let g = "Notes look"
EOF
  run_lint "$COPY"
  expect_clean
}

# CP-914: an explicit root is the tree the check reads, whatever the working directory is.
test_root_argument_with_spaces_from_another_directory() {
  local spaced="$WORK/a root with spaces"
  new_copy_at "$spaced"
  append_file "$spaced/$PLANT_FILE" <<'EOF'
let planted = "An error happened."
EOF
  mkdir -p "$WORK/elsewhere"
  run_lint_from "$WORK/elsewhere" "$spaced"
  expect_hit "$PLANT_FILE" error || return 1
  expect_relative_paths "$spaced"
}

# CP-914: with no argument the root is the checkout the script sits in.
test_default_root_is_the_checkout_the_script_sits_in() {
  local mini="$WORK/mini-checkout"
  new_copy_at "$mini"
  mkdir -p "$mini/checks"
  cp "$STRINGS_SH" "$mini/checks/strings.sh"
  chmod +x "$mini/checks/strings.sh"
  mkdir -p "$WORK/elsewhere"
  (cd "$WORK/elsewhere" && "$mini/checks/strings.sh") > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?
  STDOUT="$(cat "$WORK/stdout")"
  STDERR="$(cat "$WORK/stderr")"
  expect_clean || return 1

  append_file "$mini/$PLANT_FILE" <<'EOF'
let planted = "An error happened."
EOF
  (cd "$WORK/elsewhere" && "$mini/checks/strings.sh") > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?
  STDOUT="$(cat "$WORK/stdout")"
  STDERR="$(cat "$WORK/stderr")"
  expect_hit "$PLANT_FILE" error
}

# Out of Scope: literals are never joined across discarded code.
test_separate_literals_are_not_joined() {
  new_copy not-joined
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let a = "stack " + "trace"
let b = "stack \(x)trace"
let c = "stack \(f("error")) trace"
let d = "stack \(x)" + "trace"
EOF
  run_lint "$COPY"
  expect_clean
}

test_spacing_is_checked_as_written() {
  new_copy spacing-two
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let planted = "stack  trace"
EOF
  run_lint "$COPY"
  expect_clean || return 1

  new_copy spacing-one
  append_file "$COPY/$PLANT_FILE" <<'EOF'
let planted = "stack trace"
EOF
  run_lint "$COPY"
  expect_hit "$PLANT_FILE" "stack trace"
}

# CP-925, CP-926: a failing case fails the suite and still removes its temporary directory, and the
# product tree is the same afterwards.
test_failing_case_still_cleans_up_and_fails_the_suite() {
  local before after left
  [ -z "${KA_READER_SUITE_NESTED:-}" ] || return 0
  make_altered_lint "$WORK/altered-cleanup/checks/strings.sh" error
  mkdir -p "$WORK/nested-tmp"
  before="$(tree_status)"
  run_nested test_error_planted_in_a_literal_fails KA_READER_STRINGS_SH="$WORK/altered-cleanup/checks/strings.sh" \
    TMPDIR="$WORK/nested-tmp"
  after="$(tree_status)"
  if ! printf '%s\n' "$NESTED_OUT" | grep -q '^FAIL test_error_planted_in_a_literal_fails$'; then
    fail "The suite ran against a copy of checks/strings.sh altered to miss a finding, and test_error_planted_in_a_literal_fails did not report FAIL. Its output follows."
    nested_output_indented
    return 1
  fi
  if [ "$NESTED_STATUS" -eq 0 ]; then
    fail "The suite ran against a copy of checks/strings.sh altered to miss a finding and exited 0, so a failing case does not fail the suite. Its output follows."
    nested_output_indented
    return 1
  fi
  left="$(find "$WORK/nested-tmp" -mindepth 1 -maxdepth 1 | head -1)"
  if [ -n "$left" ]; then
    fail "The suite left its temporary directory $left behind after a run with a failing case."
    return 1
  fi
  if [ "$before" != "$after" ]; then
    fail "git status --porcelain at the product root printed something different after the suite ran than before it. Both outputs follow, before and then after, so you can see which paths changed."
    printf '%s\n' "$before" "$after" | sed 's/^/  /'
    return 1
  fi
}

# CP-925: run after the other cases. The tree's status and the bytes of the catalogue and CONTENT
# are what they were when the suite started.
test_originating_tree_is_unchanged() {
  local line path
  if [ "$(tree_status)" != "$SNAPSHOT_STATUS" ]; then
    fail "git status --porcelain at the product root printed something different after the suite ran than before it. Both outputs follow, before and then after, so you can see which paths changed."
    printf '%s\n' "$SNAPSHOT_STATUS" "$(tree_status)" | sed 's/^/  /'
    return 1
  fi
  local after_sums
  after_sums="$(tree_sums)"
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    if ! printf '%s\n' "$after_sums" | grep -qxF -- "$line"; then
      path="${line#* * }"
      fail "$path in the product checkout is not byte for byte what it was before the suite ran. See what changed with git diff -- $path." || return 1
    fi
  done <<EOF
$SNAPSHOT_SUMS
EOF
  return 0
}

# --- the runner ---

TMP_BASE="${TMPDIR:-/tmp}"
TMP_BASE="${TMP_BASE%/}"
if ! WORK="$(mktemp -d "$TMP_BASE/strings-suite.XXXXXX" 2> /dev/null)"; then
  echo "The suite could not create its temporary directory under $TMP_BASE, so no case ran. Make $TMP_BASE writable, then run the suite again."
  exit 1
fi
cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

if [ ! -x "$STRINGS_SH" ]; then
  echo "The suite found no executable checks/strings.sh at $STRINGS_SH, so no case ran. Run the suite from the root of a clone of KA-Reader."
  exit 1
fi

SNAPSHOT_STATUS="$(tree_status)"
SNAPSHOT_SUMS="$(tree_sums)"

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

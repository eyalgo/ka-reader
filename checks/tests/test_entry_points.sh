#!/usr/bin/env bash
# Version: 1.0.1 — CI green again: scene-building git runs no background maintenance, Swift builds with Xcode 16.2, and the entry-points suite reads metadata with plutil -extract
# Version: 1.0.0 — first version: drives the real checks/entry-points.sh with every read, list and
# resolution fault planted in a temporary copy
#
# checks/tests/test_entry_points.sh — the tests of checks/entry-points.sh and
# checks/entry-points.allow.
#
# WHY THIS EXISTS
#   checks/entry-points.sh is the review gate on the environment and argument reads of the linked
#   dependency tree (NFDR QC-30, half 2). A scan that cannot go red is a gate that has not run, so
#   each failure it names is planted here and the script is shown to catch it, and the clean tree is
#   shown to pass. The cases run the real script, never a copy of its logic, through its two seams:
#   `cargo` found on PATH, and ENTRY_POINTS_ALLOW_FILE. A stub `cargo` runs the real one and edits
#   its output, so the suite never lists the tree's crates by hand; it plants only into copies of
#   `itoa` and `quote`, under one temporary work directory, and writes nothing under the product
#   root or under a registry package directory. The last case proves that. The runner is this file:
#   the product has no Python (docs/nfdr.md § 9 names its toolchains), which is why the shell
#   packet's pytest runner is not used here — the same reason test_no_network.sh gives.
#
# USAGE
#   checks/tests/test_entry_points.sh
#     KA_READER_TEST_ONLY=<case> [<case> ...] runs the named cases. A name that is no case fails the
#     run.
#
# CASE NAMES
#   `test_case_<n>_` is a row of CP-410's table; `test_c<n>_` is a further case of change_design.md
#   § 5.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SUITE="$ROOT/checks/tests/test_entry_points.sh"
SCRIPT="$ROOT/checks/entry-points.sh"
REAL_LIST="$ROOT/checks/entry-points.allow"
REAL_CARGO="$(command -v cargo)"

# The six names, in full, as CP-402 writes them.
SIX_NAMES="env::var env::var_os env::vars env::vars_os env::args env::args_os"

CASES="
test_case_1_clean_tree_passes
test_case_2_unlisted_read_names_its_file
test_case_3_removed_read_is_stale
test_case_4_unopenable_package_fails
test_case_5_var_is_distinct
test_case_6_var_os_is_distinct
test_case_7_vars_is_distinct
test_case_8_vars_os_is_distinct
test_case_9_args_is_distinct
test_case_10_args_os_is_distinct
test_case_11_missing_crate_is_malformed
test_case_12_missing_name_is_malformed
test_case_13_missing_explanation_is_malformed
test_case_14_grouped_import_is_found
test_c1_multiline_group_finds_each_name
test_c2_longer_identifier_is_not_a_read
test_c3_false_build_key_excepts_nothing
test_c4_build_helper_is_scanned
test_c5_default_build_script_is_excepted
test_c6_unreadable_file_fails
test_c7_removed_crate_line_is_stale
test_c8_unknown_name_is_malformed
test_c9_duplicate_line_is_malformed
test_c10_all_reachable_findings_are_reported
test_c11_unreadable_is_not_stale
test_c12_tree_resolution_failure_is_fatal
test_c13_metadata_resolution_failure_is_fatal
test_c14_new_member_is_skipped_by_membership
test_c15_comments_only_list_fails
test_c16_missing_list_fails
test_c17_repeated_occurrences_share_one_entry
test_unreadable_metadata_is_fatal
test_empty_tree_is_fatal
test_unresolved_package_is_unreadable
test_ambiguous_package_is_unreadable
test_external_source_directory_is_scanned
test_resolved_versions_share_one_reviewed_pair
test_tree_repeats_do_not_duplicate_findings
test_nested_build_script_alone_is_excepted
test_missing_default_build_script_excepts_nothing
test_unrecognised_build_key_excepts_nothing
test_unreadable_excepted_build_script_is_not_read
test_non_source_files_and_raw_text_are_scanned
test_list_fields_are_trimmed_and_text_may_contain_a_separator
test_malformed_lines_do_not_hide_other_findings
test_findings_are_distinct_and_deterministic
test_metadata_text_cannot_change_membership
test_metadata_requires_membership_array
test_linked_file_is_scanned
test_dangling_link_is_unreadable
test_fifo_is_unreadable
test_suite_selects_one_case
test_suite_rejects_unknown_case
test_suite_reports_each_failed_case
test_suite_leaves_original_inputs_unchanged
"

WORK=""
CASE=""
STUB=""
LIST=""
STATUS=0
STDOUT=""
STDERR=""
APPENDED_LINE=0
PLANT_DIR=""

# --- helpers: the real tree ---

fail() {
  echo "  $*"
  return 1
}

# name, version, id and manifest path of every package in the metadata file $1, tab separated.
# Read with plutil -extract, as checks/entry-points.sh reads it, because plutil -help calls -p "not
# for machine parsing". The table is written once beside $1 and read from there after.
metadata_packages() {
  table="$1.packages.tsv"
  if [ ! -e "$table" ]; then
    count="$(plutil -extract packages raw -expect array "$1")" || return 1
    : > "$table.partial"
    index=0
    while [ "$index" -lt "$count" ]; do
      for key in name version id manifest_path; do
        plutil -extract "packages.$index.$key" raw -expect string "$1" || return 1
      done | paste -s -d '\t' - >> "$table.partial"
      index=$((index + 1))
    done
    mv "$table.partial" "$table"
  fi
  cat "$table"
}

# The package directory the real metadata resolves for crate $1.
package_dir() {
  metadata_packages "$WORK/real-metadata.json" | awk -F '\t' -v want="$1" '$1 == want { print $4; exit }' | sed 's#/Cargo.toml$##'
}

package_version() {
  metadata_packages "$WORK/real-metadata.json" | awk -F '\t' -v want="$1" '$1 == want { print $2; exit }'
}

# The registry package directories the script reads: every package that is not a path source.
scanned_package_dirs() {
  metadata_packages "$WORK/real-metadata.json" | awk -F '\t' '$3 !~ /^path\+/ { print $4 }' | sed 's#/Cargo.toml$##' | LC_ALL=C sort -u
}

# What the suite must leave unchanged (CP-409): the product's git status, and a path|size|mtime
# listing of every scanned package directory, written to $1.status and $1.packages.
snapshot_inputs() {
  git -C "$ROOT" status --porcelain > "$1.status" 2>&1
  : > "$1.packages"
  scanned_package_dirs | while IFS= read -r package_dir; do
    find "$package_dir" -type f -exec stat -f '%N|%z|%m' {} + | LC_ALL=C sort >> "$1.packages"
  done
}

# --- helpers: one case ---

# A fresh case directory, a stub `cargo` in front of the real one, and a copy of the real list.
new_case() {
  CASE="$(mktemp -d "$WORK/case.XXXXXX")"
  STUB="$CASE/stub"
  LIST="$CASE/list.allow"
  mkdir -p "$STUB"
  cp "$REAL_LIST" "$LIST"
  cat > "$STUB/cargo" <<STUB_END
#!/usr/bin/env bash
# The real cargo, with its output edited by the files beside this stub.
set -o pipefail
here="\$(cd "\$(dirname "\$0")" && pwd)"
real="$REAL_CARGO"
case "\$1" in
  tree)
    [ ! -e "\$here/tree.fail" ] || { echo "cargo: stubbed tree failure" >&2; exit 101; }
    [ ! -e "\$here/tree.empty" ] || exit 0
    { "\$real" "\$@" || exit \$?; [ ! -e "\$here/tree.extra" ] || cat "\$here/tree.extra"; } \\
      | if [ -e "\$here/tree.repeat" ]; then awk '{ print; print \$0 " (*)"; print }'; else cat; fi
    ;;
  metadata)
    [ ! -e "\$here/meta.fail" ] || { echo "cargo: stubbed metadata failure" >&2; exit 101; }
    [ ! -e "\$here/meta.garbage" ] || { echo "this is not json"; exit 0; }
    [ ! -e "\$here/meta.array" ] || { echo "[1]"; exit 0; }
    [ ! -e "\$here/meta.json" ] || { cat "\$here/meta.json"; exit 0; }
    if [ -e "\$here/meta.sed" ]; then "\$real" "\$@" | sed -f "\$here/meta.sed"; else exec "\$real" "\$@"; fi
    ;;
  *) exec "\$real" "\$@" ;;
esac
STUB_END
  chmod +x "$STUB/cargo"
}

# Runs the real script with the stub ahead on PATH and the list at $LIST.
run_scan() {
  PATH="$STUB:$PATH" ENTRY_POINTS_ALLOW_FILE="$LIST" "$SCRIPT" > "$CASE/stdout" 2> "$CASE/stderr"
  STATUS=$?
  STDOUT="$(cat "$CASE/stdout")"
  STDERR="$(cat "$CASE/stderr")"
}

# Copies crate $1's real package directory into the case, writable, and points the stub's metadata
# at it.
plant_copy() {
  source_dir="$(package_dir "$1")"
  [ -d "$source_dir" ] || fail "no package directory for $1 in the real metadata" || return 1
  PLANT_DIR="$CASE/copy-$1"
  cp -R "$source_dir" "$PLANT_DIR"
  chmod -R u+rwX "$PLANT_DIR"
  printf 's|"manifest_path":"%s/Cargo.toml"|"manifest_path":"%s/Cargo.toml"|\n' "$source_dir" "$PLANT_DIR" >> "$STUB/meta.sed"
}

# A file $2 (relative to directory $1) holding the text $3.
plant_file() {
  mkdir -p "$(dirname "$1/$2")"
  printf '%s\n' "$3" > "$1/$2"
}

# Adds a package record to the stub's metadata: name $1, version $2, id $3, manifest path $4.
meta_add_package() {
  printf 's|"packages":\\[|"packages":[{"name":"%s","version":"%s","id":"%s","manifest_path":"%s"},|\n' "$1" "$2" "$3" "$4" >> "$STUB/meta.sed"
}

meta_add_member() {
  printf 's|"workspace_members":\\[|"workspace_members":["%s",|\n' "$1" >> "$STUB/meta.sed"
}

# Appends the line $1 to the list; APPENDED_LINE is its one-based number.
append_list_line() {
  printf '%s\n' "$1" >> "$LIST"
  APPENDED_LINE="$(wc -l < "$LIST" | tr -d ' ')"
}

# The text of the list line for crate $1 and name $2.
real_list_line() {
  grep -E "^$1[[:space:]]*\\|[[:space:]]*$2[[:space:]]*\\|" "$REAL_LIST" | head -1
}

# --- helpers: assertions ---

expect_zero_status() {
  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. stderr: $STDERR"
}

expect_nonzero_status() {
  [ "$STATUS" -ne 0 ] || fail "expected a non-zero exit, got 0. stdout: $STDOUT"
}

expect_empty_stderr() {
  [ -z "$STDERR" ] || fail "expected an empty stderr. stderr: $STDERR"
}

# stderr holds a finding line of kind $1 for crate $2 (and read name $3 when given), as whole words.
expect_finding() {
  if [ -n "${3:-}" ]; then
    printf '%s\n' "$STDERR" | grep -qE "^entry-points\\.sh: $1: $2 $3( |\$)" \
      || fail "expected a $1 finding for $2 $3. stderr: $STDERR"
  else
    printf '%s\n' "$STDERR" | grep -qE "^entry-points\\.sh: $1: $2( |\$)" \
      || fail "expected a $1 finding for $2. stderr: $STDERR"
  fi
}

expect_no_finding_kind() {
  if printf '%s\n' "$STDERR" | grep -qE "^entry-points\\.sh: $1:"; then
    fail "expected no $1 finding. stderr: $STDERR"
  fi
}

expect_no_finding_for_crate() {
  if printf '%s\n' "$STDERR" | grep -qE "^entry-points\\.sh: [a-z]+: $1( |\$)"; then
    fail "expected no finding for $1. stderr: $STDERR"
  fi
}

# stderr names read $1 and none of the other five, each matched as a whole word.
expect_only_name() {
  expect_name_present "$1" || return 1
  for other in $SIX_NAMES; do
    [ "$other" != "$1" ] || continue
    if printf '%s\n' "$STDERR" | grep -qE "(^|[^A-Za-z0-9_])$other([^A-Za-z0-9_]|\$)"; then
      fail "stderr names $other beside $1. stderr: $STDERR" || return 1
    fi
  done
}

expect_name_present() {
  printf '%s\n' "$STDERR" | grep -qE "(^|[^A-Za-z0-9_])$1([^A-Za-z0-9_]|\$)" \
    || fail "stderr does not name $1. stderr: $STDERR"
}

expect_stderr_contains() {
  case "$STDERR" in
    *"$1"*) return 0 ;;
  esac
  fail "expected stderr to contain: $1. stderr: $STDERR"
}

# A resolution failure: non-zero, says the set could not be resolved, and reports no finding.
expect_resolution_failure() {
  expect_nonzero_status || return 1
  expect_stderr_contains "the crate set could not be resolved" || return 1
  if printf '%s\n' "$STDERR" | grep -qE '^entry-points\.sh: (unlisted|stale|unreadable|malformed):'; then
    fail "a resolution failure also reported a finding. stderr: $STDERR"
  fi
}

# --- cases: CP-410's table ---

# CP-406, CP-410 row 1, C1: the real tree and the real list pass. The members cause no finding,
# stderr is empty, and stdout is the one counting line.
test_case_1_clean_tree_passes() {
  new_case
  LIST="$REAL_LIST"

  run_scan

  expect_zero_status || return 1
  expect_empty_stderr || return 1
  expect_no_finding_for_crate ka-reader-core || return 1
  expect_no_finding_for_crate ka-reader-bridge || return 1
  [ "$(printf '%s\n' "$STDOUT" | wc -l | tr -d ' ')" -eq 1 ] || fail "expected one line on stdout, got: $STDOUT" || return 1
  printf '%s\n' "$STDOUT" | grep -qE '^entry-points\.sh: ok — [0-9]+ crates scanned, [0-9]+ members skipped, [0-9]+ reads matched$' \
    || fail "stdout is not the counting line. stdout: $STDOUT"
}

# CP-410 row 2: an unlisted read names its crate, its read and the file, relative to the package.
test_case_2_unlisted_read_names_its_file() {
  new_case
  plant_copy itoa || return 1
  plant_file "$PLANT_DIR" src/planted_read.rs 'fn planted() { let _ = std::env::var("X"); }'

  run_scan

  expect_nonzero_status || return 1
  expect_finding unlisted itoa env::var || return 1
  expect_only_name env::var || return 1
  expect_stderr_contains "src/planted_read.rs" || return 1
  case "$STDERR" in
    *"$PLANT_DIR"*) fail "the file is named by an absolute path. stderr: $STDERR" ;;
  esac
}

# CP-410 row 3: a listed read that is no longer in the crate is stale.
test_case_3_removed_read_is_stale() {
  new_case
  plant_copy quote || return 1
  grep -q 'env::var_os' "$PLANT_DIR/README.md" || fail "the quote copy's README.md holds no env::var_os to remove" || return 1
  sed 's/env::var_os/env-var-os/g' "$PLANT_DIR/README.md" > "$PLANT_DIR/README.tmp" && mv "$PLANT_DIR/README.tmp" "$PLANT_DIR/README.md"

  run_scan

  expect_nonzero_status || return 1
  expect_finding stale quote env::var_os || return 1
  expect_only_name env::var_os || return 1
  expect_no_finding_kind unlisted
}

# CP-410 row 4, CP-407 (c): a package directory that cannot be opened is a finding, never a pass.
test_case_4_unopenable_package_fails() {
  new_case
  plant_copy itoa || return 1
  chmod 000 "$PLANT_DIR"

  run_scan

  expect_nonzero_status || return 1
  expect_finding unreadable itoa
}

# CP-410 rows 5 – 10: each name is its own finding, and no other of the six is named beside it.
plant_one_name_and_expect_it_alone() {
  new_case
  plant_copy itoa || return 1
  plant_file "$PLANT_DIR" src/planted_read.rs "fn planted() { let _ = std::$1(\"X\"); }"

  run_scan

  expect_nonzero_status || return 1
  expect_finding unlisted itoa "$1" || return 1
  expect_only_name "$1"
}

test_case_5_var_is_distinct() { plant_one_name_and_expect_it_alone env::var; }
test_case_6_var_os_is_distinct() { plant_one_name_and_expect_it_alone env::var_os; }
test_case_7_vars_is_distinct() { plant_one_name_and_expect_it_alone env::vars; }
test_case_8_vars_os_is_distinct() { plant_one_name_and_expect_it_alone env::vars_os; }
test_case_9_args_is_distinct() { plant_one_name_and_expect_it_alone env::args; }
test_case_10_args_os_is_distinct() { plant_one_name_and_expect_it_alone env::args_os; }

# CP-410 rows 11 – 13, CP-404: a line lacking a part is malformed, and the finding gives its list
# line number.
test_case_11_missing_crate_is_malformed() {
  new_case
  append_list_line ' | env::var | a line with no crate'

  run_scan

  expect_nonzero_status || return 1
  expect_stderr_contains "malformed: line $APPENDED_LINE: lacks its crate"
}

test_case_12_missing_name_is_malformed() {
  new_case
  append_list_line 'itoa |  | a line with no name'

  run_scan

  expect_nonzero_status || return 1
  expect_stderr_contains "malformed: line $APPENDED_LINE: lacks its name"
}

test_case_13_missing_explanation_is_malformed() {
  new_case
  append_list_line 'itoa | env::var |'

  run_scan

  expect_nonzero_status || return 1
  expect_stderr_contains "malformed: line $APPENDED_LINE: lacks its what-it-changes text"
}

# CP-410 row 14, CP-402: a grouped import is a read of each name it lists.
test_case_14_grouped_import_is_found() {
  new_case
  plant_copy itoa || return 1
  plant_file "$PLANT_DIR" src/planted_read.rs 'use std::env::{var};'

  run_scan

  expect_nonzero_status || return 1
  expect_finding unlisted itoa env::var || return 1
  expect_only_name env::var
}

# --- cases: the further cases of change_design.md § 5 ---

# C1: a group split over two lines yields both names.
test_c1_multiline_group_finds_each_name() {
  new_case
  plant_copy itoa || return 1
  printf 'use std::env::{var,\n    args};\n' > "$PLANT_DIR/src/planted_read.rs"

  run_scan

  expect_nonzero_status || return 1
  expect_finding unlisted itoa env::var || return 1
  expect_finding unlisted itoa env::args
}

# C2: the name after `env::` is a whole word, so a longer identifier is no read.
test_c2_longer_identifier_is_not_a_read() {
  new_case
  plant_copy itoa || return 1
  plant_file "$PLANT_DIR" src/planted_read.rs 'fn planted() { let _ = env::variable(); }'

  run_scan

  expect_zero_status || return 1
  expect_empty_stderr
}

# C3: with `build = false` nothing is excepted, so a root build.rs is scanned.
test_c3_false_build_key_excepts_nothing() {
  new_case
  plant_copy itoa || return 1
  grep -q '^build = false' "$PLANT_DIR/Cargo.toml" || fail "the itoa copy does not set build = false" || return 1
  plant_file "$PLANT_DIR" build.rs 'fn main() { let _ = std::env::var("X"); }'

  run_scan

  expect_nonzero_status || return 1
  expect_finding unlisted itoa env::var || return 1
  expect_stderr_contains "build.rs"
}

# C4: an explicit build script is excepted; the file it includes is not.
test_c4_build_helper_is_scanned() {
  new_case
  plant_copy itoa || return 1
  sed 's/^build = false/build = "build.rs"/' "$PLANT_DIR/Cargo.toml" > "$PLANT_DIR/Cargo.tmp" && mv "$PLANT_DIR/Cargo.tmp" "$PLANT_DIR/Cargo.toml"
  printf 'fn main() { let _ = std::env::args(); }\ninclude!("helper.rs");\n' > "$PLANT_DIR/build.rs"
  plant_file "$PLANT_DIR" helper.rs 'fn helper() { let _ = std::env::var("X"); }'

  run_scan

  expect_nonzero_status || return 1
  expect_finding unlisted itoa env::var || return 1
  expect_stderr_contains "helper.rs" || return 1
  if printf '%s\n' "$STDERR" | grep -qE '(^|[^A-Za-z0-9_])env::args([^A-Za-z0-9_]|$)'; then
    fail "the excepted build script's env::args was reported. stderr: $STDERR"
  fi
}

# C5: with no build key, the root build.rs is the build script and is excepted.
test_c5_default_build_script_is_excepted() {
  new_case
  plant_copy itoa || return 1
  grep -v '^build = ' "$PLANT_DIR/Cargo.toml" > "$PLANT_DIR/Cargo.tmp" && mv "$PLANT_DIR/Cargo.tmp" "$PLANT_DIR/Cargo.toml"
  plant_file "$PLANT_DIR" build.rs 'fn main() { let _ = std::env::args(); }'

  run_scan

  expect_zero_status || return 1
  expect_empty_stderr
}

# C6: one unreadable file in a readable package fails that crate.
test_c6_unreadable_file_fails() {
  new_case
  plant_copy itoa || return 1
  chmod 000 "$PLANT_DIR/src/lib.rs"

  run_scan

  expect_nonzero_status || return 1
  expect_finding unreadable itoa
}

# C7: a line for a crate the set does not hold is stale, naming both.
test_c7_removed_crate_line_is_stale() {
  new_case
  append_list_line 'tokio | env::var | a crate the lock no longer resolves'

  run_scan

  expect_nonzero_status || return 1
  expect_finding stale tokio env::var
}

# C8: a name outside the six is malformed, with its line number.
test_c8_unknown_name_is_malformed() {
  new_case
  append_list_line 'itoa | env::getenv | not one of the six'

  run_scan

  expect_nonzero_status || return 1
  expect_stderr_contains "malformed: line $APPENDED_LINE:"
}

# C9: a repeated crate and name is malformed at the second line; the earlier line stays effective.
test_c9_duplicate_line_is_malformed() {
  new_case
  line="$(real_list_line syn env::args)"
  [ -n "$line" ] || fail "the real list has no syn / env::args line to repeat" || return 1
  append_list_line "$line"

  run_scan

  expect_nonzero_status || return 1
  expect_stderr_contains "malformed: line $APPENDED_LINE:" || return 1
  expect_no_finding_kind stale || return 1
  expect_no_finding_kind unlisted
}

# C10: an unlisted read and a stale line in one run are both reported.
test_c10_all_reachable_findings_are_reported() {
  new_case
  plant_copy itoa || return 1
  plant_file "$PLANT_DIR" src/planted_read.rs 'fn planted() { let _ = std::env::var("X"); }'
  append_list_line 'tokio | env::var | a crate the lock no longer resolves'

  run_scan

  expect_nonzero_status || return 1
  expect_finding unlisted itoa env::var || return 1
  expect_finding stale tokio env::var
}

# C11: an unreadable crate's reads are unknown, so its listed read is not also called stale.
test_c11_unreadable_is_not_stale() {
  new_case
  plant_copy quote || return 1
  chmod 000 "$PLANT_DIR"

  run_scan

  expect_nonzero_status || return 1
  expect_finding unreadable quote || return 1
  expect_no_finding_for_crate_kind stale quote
}

expect_no_finding_for_crate_kind() {
  if printf '%s\n' "$STDERR" | grep -qE "^entry-points\\.sh: $1: $2( |\$)"; then
    fail "expected no $1 finding for $2. stderr: $STDERR"
  fi
}

# C12: a failed crate-set command ends the run before any scan, with no fallback.
test_c12_tree_resolution_failure_is_fatal() {
  new_case
  : > "$STUB/tree.fail"

  run_scan

  expect_resolution_failure || return 1
  expect_stderr_contains "cargo tree exited"
}

# C13: a failed metadata command is the same.
test_c13_metadata_resolution_failure_is_fatal() {
  new_case
  : > "$STUB/meta.fail"

  run_scan

  expect_resolution_failure || return 1
  expect_stderr_contains "cargo metadata exited"
}

# C14: a member added to the tree and to workspace_members, with no package directory, is skipped by
# membership; no name is the test.
test_c14_new_member_is_skipped_by_membership() {
  new_case
  printf 'ka-reader-third v0.0.0 (/nowhere/crates/ka-reader-third)\n' > "$STUB/tree.extra"
  member_id="path+file:///nowhere/crates/ka-reader-third#0.0.0"
  meta_add_package ka-reader-third 0.0.0 "$member_id" /nowhere/crates/ka-reader-third/Cargo.toml
  meta_add_member "$member_id"

  run_scan

  expect_zero_status || return 1
  expect_empty_stderr
}

# C15: a list holding only comments and blank lines fails, naming the list.
test_c15_comments_only_list_fails() {
  new_case
  printf '# only a comment\n\n   \n# another\n' > "$LIST"

  run_scan

  expect_nonzero_status || return 1
  expect_stderr_contains "the reviewed list holds no entry line: $LIST"
}

# C16: a list path that does not exist fails, naming it.
test_c16_missing_list_fails() {
  new_case
  LIST="$CASE/no-such-list.allow"

  run_scan

  expect_nonzero_status || return 1
  expect_stderr_contains "the reviewed list is missing: $LIST"
}

# C17: the same read in two files of one crate is one read, covered by one line.
test_c17_repeated_occurrences_share_one_entry() {
  new_case
  plant_copy itoa || return 1
  plant_file "$PLANT_DIR" src/planted_a.rs 'fn a() { let _ = std::env::var("X"); }'
  plant_file "$PLANT_DIR" src/planted_b.rs 'fn b() { let _ = std::env::var("Y"); }'
  append_list_line 'itoa | env::var | planted, twice'

  run_scan

  expect_zero_status || return 1
  expect_no_finding_kind malformed || return 1
  expect_no_finding_kind unlisted
}

# --- cases: the edges of the script's contract ---

# change_design.md § 3 A: metadata that cannot be read is a resolution failure, whether the JSON is
# bad, the reader fails, or the reader is absent.
test_unreadable_metadata_is_fatal() {
  new_case
  : > "$STUB/meta.garbage"
  run_scan
  expect_resolution_failure || return 1
  expect_stderr_contains "plutil could not read the metadata" || return 1

  new_case
  : > "$STUB/meta.array"
  run_scan
  expect_resolution_failure || return 1
  expect_stderr_contains "not a JSON object" || return 1

  new_case
  printf '#!/bin/sh\necho "plutil: stubbed failure" >&2\nexit 1\n' > "$STUB/plutil"
  chmod +x "$STUB/plutil"
  run_scan
  expect_resolution_failure || return 1
  expect_stderr_contains "plutil could not read the metadata" || return 1

  new_case
  tools="$CASE/tools-without-plutil"
  mkdir -p "$tools"
  for tool in awk basename bash cat chmod cp cut dirname env find grep head ls mktemp mv printf rm sed sh sort tail tr uname uniq wc xargs comm expr; do
    found="$(command -v "$tool" 2> /dev/null)" || continue
    ln -sf "$found" "$tools/$tool"
  done
  limited_path="$STUB:$tools:$(dirname "$REAL_CARGO")"
  [ -z "$(PATH="$limited_path" command -v plutil 2> /dev/null)" ] || fail "the limited PATH still finds plutil" || return 1
  PATH="$limited_path" ENTRY_POINTS_ALLOW_FILE="$LIST" "$SCRIPT" > "$CASE/stdout" 2> "$CASE/stderr"
  STATUS=$?
  STDOUT="$(cat "$CASE/stdout")"
  STDERR="$(cat "$CASE/stderr")"
  expect_resolution_failure || return 1
  expect_stderr_contains "plutil is not on PATH"
}

# change_design.md § 3 A: an empty crate set is a resolution failure and never an empty pass.
test_empty_tree_is_fatal() {
  new_case
  : > "$STUB/tree.empty"

  run_scan

  expect_resolution_failure
}

# A tree entry with no metadata package is unreadable, never skipped, and the other findings still
# come.
test_unresolved_package_is_unreadable() {
  new_case
  printf 'ghost v1.2.3\n' > "$STUB/tree.extra"
  plant_copy itoa || return 1
  plant_file "$PLANT_DIR" src/planted_read.rs 'fn planted() { let _ = std::env::var("X"); }'

  run_scan

  expect_nonzero_status || return 1
  expect_finding unreadable ghost || return 1
  expect_stderr_contains "no package of that name and version" || return 1
  expect_finding unlisted itoa env::var
}

# A tree entry that joins two metadata packages is unreadable too.
test_ambiguous_package_is_unreadable() {
  new_case
  version="$(package_version itoa)"
  [ -n "$version" ] || fail "no itoa version in the real metadata" || return 1
  meta_add_package itoa "$version" "registry+duplicate#itoa@$version" "$CASE/nowhere/Cargo.toml"

  run_scan

  expect_nonzero_status || return 1
  expect_finding unreadable itoa || return 1
  expect_stderr_contains "2 packages of that name and version"
}

# A non-member package outside any registry is scanned: membership controls the skip, not its source
# or the way its directory is spelled.
test_external_source_directory_is_scanned() {
  new_case
  external="$CASE/external/extcrate"
  mkdir -p "$external/src"
  printf '[package]\nname = "extcrate"\nversion = "0.0.1"\nbuild = false\n' > "$external/Cargo.toml"
  printf 'fn read() { let _ = std::env::var_os("X"); }\n' > "$external/src/lib.rs"
  printf 'extcrate v0.0.1\n' > "$STUB/tree.extra"
  meta_add_package extcrate 0.0.1 "path+file://$external#extcrate@0.0.1" "$external/Cargo.toml"

  run_scan

  expect_nonzero_status || return 1
  expect_finding unlisted extcrate env::var_os || return 1
  expect_stderr_contains "src/lib.rs"
}

# Two resolved versions of one name share their reads and one list line; a line is stale only when
# neither version holds the read.
test_resolved_versions_share_one_reviewed_pair() {
  new_case
  second="$CASE/itoa-second"
  printf 'itoa v9.9.9\n' > "$STUB/tree.extra"
  meta_add_package itoa 9.9.9 "registry+second#itoa@9.9.9" "$second/Cargo.toml"
  mkdir -p "$second/src"
  printf '[package]\nname = "itoa"\nversion = "9.9.9"\nbuild = false\n' > "$second/Cargo.toml"
  printf 'fn read() { let _ = std::env::var("X"); }\n' > "$second/src/lib.rs"

  # The read is in the second version only; one line covers it.
  append_list_line 'itoa | env::var | read by the second resolved version'
  run_scan
  expect_zero_status || return 1
  expect_empty_stderr || return 1

  # Neither version holds it: the line is stale.
  printf 'fn read() {}\n' > "$second/src/lib.rs"
  run_scan
  expect_nonzero_status || return 1
  expect_finding stale itoa env::var || return 1

  # The second version holds it and no line covers it: unlisted, once.
  printf 'fn read() { let _ = std::env::var("X"); }\n' > "$second/src/lib.rs"
  cp "$REAL_LIST" "$LIST"
  run_scan
  expect_nonzero_status || return 1
  expect_finding unlisted itoa env::var
}

# Repeated tree lines and Cargo's `(*)` marker do not duplicate scanned entries or findings.
test_tree_repeats_do_not_duplicate_findings() {
  new_case
  : > "$STUB/tree.repeat"
  run_scan
  expect_zero_status || return 1
  expect_empty_stderr || return 1
  baseline_stdout="$STDOUT"

  new_case
  : > "$STUB/tree.repeat"
  plant_copy itoa || return 1
  plant_file "$PLANT_DIR" src/planted_read.rs 'fn planted() { let _ = std::env::var("X"); }'
  run_scan
  expect_nonzero_status || return 1
  [ "$(printf '%s\n' "$STDERR" | grep -c '^entry-points\.sh: unlisted: itoa env::var')" -eq 1 ] \
    || fail "expected exactly one unlisted finding. stderr: $STDERR" || return 1

  new_case
  run_scan
  [ "$STDOUT" = "$baseline_stdout" ] || fail "repeated tree lines changed the counts: '$baseline_stdout' against '$STDOUT'"
}

# An explicit nested build path is the only exception: a sibling file and a root build.rs are
# scanned.
test_nested_build_script_alone_is_excepted() {
  new_case
  plant_copy itoa || return 1
  sed 's|^build = false|build = "tools/gen/build.rs"|' "$PLANT_DIR/Cargo.toml" > "$PLANT_DIR/Cargo.tmp" && mv "$PLANT_DIR/Cargo.tmp" "$PLANT_DIR/Cargo.toml"
  plant_file "$PLANT_DIR" tools/gen/build.rs 'fn main() { let _ = std::env::args(); }'
  plant_file "$PLANT_DIR" tools/gen/sibling.rs 'fn sibling() { let _ = std::env::var("X"); }'
  plant_file "$PLANT_DIR" build.rs 'fn main() { let _ = std::env::vars(); }'

  run_scan

  expect_nonzero_status || return 1
  expect_finding unlisted itoa env::var || return 1
  expect_finding unlisted itoa env::vars || return 1
  if printf '%s\n' "$STDERR" | grep -qE '(^|[^A-Za-z0-9_])env::args([^A-Za-z0-9_]|$)'; then
    fail "the excepted nested build script's env::args was reported. stderr: $STDERR"
  fi
}

# With no build key and no root build.rs, nothing is excepted: a build.rs deeper down is an ordinary
# file.
test_missing_default_build_script_excepts_nothing() {
  new_case
  plant_copy itoa || return 1
  grep -v '^build = ' "$PLANT_DIR/Cargo.toml" > "$PLANT_DIR/Cargo.tmp" && mv "$PLANT_DIR/Cargo.tmp" "$PLANT_DIR/Cargo.toml"
  plant_file "$PLANT_DIR" tools/build.rs 'fn main() { let _ = std::env::var("X"); }'

  run_scan

  expect_nonzero_status || return 1
  expect_finding unlisted itoa env::var
}

# A build key in a form the script does not recognise excepts nothing, and does not fall back to the
# default.
test_unrecognised_build_key_excepts_nothing() {
  new_case
  plant_copy itoa || return 1
  sed 's/^build = false/build = true/' "$PLANT_DIR/Cargo.toml" > "$PLANT_DIR/Cargo.tmp" && mv "$PLANT_DIR/Cargo.tmp" "$PLANT_DIR/Cargo.toml"
  plant_file "$PLANT_DIR" build.rs 'fn main() { let _ = std::env::var("X"); }'

  run_scan

  expect_nonzero_status || return 1
  expect_finding unlisted itoa env::var
}

# CP-401: the excepted file is not read, so even an unreadable one is no finding.
test_unreadable_excepted_build_script_is_not_read() {
  new_case
  plant_copy itoa || return 1
  sed 's/^build = false/build = "build.rs"/' "$PLANT_DIR/Cargo.toml" > "$PLANT_DIR/Cargo.tmp" && mv "$PLANT_DIR/Cargo.tmp" "$PLANT_DIR/Cargo.toml"
  plant_file "$PLANT_DIR" build.rs 'fn main() { let _ = std::env::var("X"); }'
  chmod 000 "$PLANT_DIR/build.rs"

  run_scan

  expect_zero_status || return 1
  expect_empty_stderr
}

# CP-401, CP-402: every file counts at any depth, and a read counts in a comment, a string or prose.
# There is no boundary before `env`, so `myenv::var` counts.
test_non_source_files_and_raw_text_are_scanned() {
  new_case
  plant_copy itoa || return 1
  plant_file "$PLANT_DIR" docs/deep/er/notes.txt 'see env::args_os in the prose'
  plant_file "$PLANT_DIR" src/commented.rs '// env::vars is only a comment'
  plant_file "$PLANT_DIR" src/stringy.rs 'const S: &str = "env::vars_os";'
  plant_file "$PLANT_DIR" src/prefixed.rs 'fn f() { myenv::var(); }'

  run_scan

  expect_nonzero_status || return 1
  expect_finding unlisted itoa env::args_os || return 1
  expect_finding unlisted itoa env::vars || return 1
  expect_finding unlisted itoa env::vars_os || return 1
  expect_finding unlisted itoa env::var
}

# CP-403: whitespace and comments around fields are ignored, and a `|` inside the explanation
# changes nothing.
test_list_fields_are_trimmed_and_text_may_contain_a_separator() {
  new_case
  awk '
    !done && $0 !~ /^[[:space:]]*(#|$)/ {
      first = index($0, "|"); rest = substr($0, first + 1); second = index(rest, "|")
      crate = substr($0, 1, first - 1); name = substr(rest, 1, second - 1)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", crate); gsub(/^[[:space:]]+|[[:space:]]+$/, "", name)
      print "   " crate "   |   " name "   |  first part | second part   "
      done = 1; next
    }
    { print }
  ' "$REAL_LIST" > "$LIST"
  printf '    # an indented comment\n     \n' >> "$LIST"

  run_scan

  expect_zero_status || return 1
  expect_empty_stderr
}

# A malformed line is a finding and takes no part in the diff: its pair is still unlisted, and the
# other findings are still reached.
test_malformed_lines_do_not_hide_other_findings() {
  new_case
  plant_copy itoa || return 1
  plant_file "$PLANT_DIR" src/planted_read.rs 'fn planted() { let _ = std::env::var("X"); }'
  append_list_line 'itoa | env::var |'
  append_list_line 'tokio | env::var_os | a crate the lock no longer resolves'

  run_scan

  expect_nonzero_status || return 1
  expect_stderr_contains "malformed: line" || return 1
  expect_finding unlisted itoa env::var || return 1
  expect_finding stale tokio env::var_os
}

# One line per read and per fault, the same stderr on every run on one tree, ordered by kind, and an
# unlisted read names the first file in path order.
test_findings_are_distinct_and_deterministic() {
  new_case
  # The file system lists a directory in name order, which would hide a missing sort. A `find` that
  # answers in reverse order puts the later file first, so only the script's own ordering names the
  # earlier one.
  printf '#!/usr/bin/env bash\nset -o pipefail\n"%s" "$@" | LC_ALL=C sort -z -r\n' "$(command -v find)" > "$STUB/find"
  chmod +x "$STUB/find"
  plant_copy itoa || return 1
  plant_file "$PLANT_DIR" src/z_last.rs 'fn z() { let _ = std::env::var("X"); }'
  plant_file "$PLANT_DIR" src/a_first.rs 'fn a() { let _ = std::env::var("X"); }'
  append_list_line 'tokio | env::var | a crate the lock no longer resolves'
  append_list_line 'itoa | env::getenv | not one of the six'

  run_scan
  first_run="$STDERR"
  run_scan

  expect_nonzero_status || return 1
  [ "$first_run" = "$STDERR" ] || fail "two runs on one tree printed different stderr" || return 1
  [ "$(printf '%s\n' "$STDERR" | grep -c '^entry-points\.sh: unlisted: itoa env::var ')" -eq 1 ] \
    || fail "expected exactly one unlisted finding for the read. stderr: $STDERR" || return 1
  expect_stderr_contains "src/a_first.rs" || return 1
  case "$STDERR" in
    *z_last*) fail "the later file is named. stderr: $STDERR" || return 1 ;;
  esac
  kinds="$(printf '%s\n' "$STDERR" | awk '{ print $2 }')"
  [ "$kinds" = "$(printf '%s\n' "$kinds" | LC_ALL=C sort)" ] || fail "findings are not ordered by kind. stderr: $STDERR"
}

# CP-400/401: package metadata is data; text in it cannot make an external crate a member.
test_metadata_text_cannot_change_membership() {
  new_case
  external="$CASE/external"
  mkdir -p "$external"
  printf '[package]\nname = "extcrate"\nversion = "0.0.1"\n' > "$external/Cargo.toml"
  plant_file "$external" read.rs 'env::var_os("X")'
  printf 'extcrate v0.0.1\n' > "$STUB/tree.extra"
  cp "$WORK/real-metadata.json" "$STUB/meta.json"
  member_id="$(plutil -extract workspace_members.0 raw "$WORK/real-metadata.json")"
  package="{\"name\":\"extcrate\",\"version\":\"0.0.1\",\"id\":\"external\",\"manifest_path\":\"$external/Cargo.toml\",\"metadata\":{\"note\":\"\"}}"
  plutil -insert packages.0 -json "$package" "$STUB/meta.json" || return 1
  note="$(printf '\n      "id" => "%s"\nend' "$member_id")"
  plutil -replace packages.0.metadata.note -string "$note" "$STUB/meta.json" || return 1

  run_scan

  expect_nonzero_status || return 1
  expect_finding unlisted extcrate env::var_os || return 1
  expect_stderr_contains 'read.rs'
}

# CP-400 and design A: absent membership is unreadable metadata, not an empty membership set.
test_metadata_requires_membership_array() {
  new_case
  cp "$WORK/real-metadata.json" "$STUB/meta.json"
  plutil -remove workspace_members "$STUB/meta.json" || return 1

  run_scan

  expect_resolution_failure
}

# CP-401 and design A read every non-directory entry, including a link to readable bytes.
test_linked_file_is_scanned() {
  new_case
  plant_copy itoa || return 1
  plant_file "$CASE" linked-bytes 'env::vars_os()'
  ln -s "$CASE/linked-bytes" "$PLANT_DIR/linked.rs"

  run_scan

  expect_nonzero_status || return 1
  expect_finding unlisted itoa env::vars_os || return 1
  expect_stderr_contains 'linked.rs'
}

# CP-407(c): a link with no readable target is unreadable, never silently omitted.
test_dangling_link_is_unreadable() {
  new_case
  plant_copy itoa || return 1
  ln -s "$CASE/absent" "$PLANT_DIR/dangling.rs"

  run_scan

  expect_nonzero_status || return 1
  expect_finding unreadable itoa || return 1
  expect_stderr_contains 'dangling.rs'
}

# CP-407(c): a stream is not a readable package file; refuse it without waiting for a writer.
test_fifo_is_unreadable() {
  new_case
  plant_copy itoa || return 1
  mkfifo "$PLANT_DIR/stream"

  run_scan

  expect_nonzero_status || return 1
  expect_finding unreadable itoa || return 1
  expect_stderr_contains 'stream'
}

# --- cases: the suite itself ---

# KA_READER_TEST_ONLY names a case; only that case runs, and it is reported.
test_suite_selects_one_case() {
  out="$(KA_READER_TEST_ONLY=test_c16_missing_list_fails "$SUITE" 2>&1)"
  status=$?

  [ "$status" -eq 0 ] || fail "the selected run exited $status. output: $out" || return 1
  case "$out" in
    *"ok   test_c16_missing_list_fails"*) ;;
    *) fail "the selected case is not reported. output: $out" || return 1 ;;
  esac
  [ "$(printf '%s\n' "$out" | grep -c '^ok ')" -eq 1 ] || fail "more than the selected case ran. output: $out"
}

# A selection that names no case must fail, or a green run could have run nothing.
test_suite_rejects_unknown_case() {
  out="$(KA_READER_TEST_ONLY=test_no_such_case "$SUITE" 2>&1)"
  status=$?

  [ "$status" -ne 0 ] || fail "an unknown selector exited 0. output: $out" || return 1
  case "$out" in
    *test_no_such_case*) ;;
    *) fail "the failure does not name the selector. output: $out" ;;
  esac
}

# CP-411: a full run goes on past a failed case and names every failed case. The product copy holds
# a script that always fails, so both cases below must fail.
test_suite_reports_each_failed_case() {
  new_case
  copy="$CASE/product-copy"
  mkdir -p "$copy/checks/tests"
  cp "$ROOT/Cargo.toml" "$ROOT/Cargo.lock" "$ROOT/rust-toolchain.toml" "$copy/"
  cp -R "$ROOT/crates" "$copy/crates"
  cp "$REAL_LIST" "$copy/checks/entry-points.allow"
  cp "$SUITE" "$copy/checks/tests/test_entry_points.sh"
  printf '#!/usr/bin/env bash\nexit 1\n' > "$copy/checks/entry-points.sh"
  chmod +x "$copy/checks/entry-points.sh" "$copy/checks/tests/test_entry_points.sh"

  out="$(KA_READER_TEST_ONLY="test_case_1_clean_tree_passes test_case_2_unlisted_read_names_its_file" "$copy/checks/tests/test_entry_points.sh" 2>&1)"
  status=$?

  [ "$status" -ne 0 ] || fail "a run with failing cases exited 0. output: $out" || return 1
  case "$out" in
    *"FAIL test_case_1_clean_tree_passes"*) ;;
    *) fail "case 1 is not named as failed. output: $out" || return 1 ;;
  esac
  case "$out" in
    *"FAIL test_case_2_unlisted_read_names_its_file"*) ;;
    *) fail "case 2 is not named as failed, so the run stopped at the first. output: $out" ;;
  esac
}

# CP-409: the product's status and every scanned package directory are what they were. This case is
# last, so in a full run it compares against the state before the first case; it also runs the cases
# that write and change permissions as a selected run and compares around that.
test_suite_leaves_original_inputs_unchanged() {
  snapshot_inputs "$WORK/now"
  cmp -s "$WORK/baseline.status" "$WORK/now.status" || fail "the product's git status changed since the run began" || return 1
  cmp -s "$WORK/baseline.packages" "$WORK/now.packages" || fail "a scanned package directory changed since the run began" || return 1

  snapshot_inputs "$WORK/before"
  out="$(KA_READER_TEST_ONLY="test_case_2_unlisted_read_names_its_file test_case_4_unopenable_package_fails test_c6_unreadable_file_fails" "$SUITE" 2>&1)"
  status=$?
  [ "$status" -eq 0 ] || fail "the selected run exited $status. output: $out" || return 1
  snapshot_inputs "$WORK/after"
  cmp -s "$WORK/before.status" "$WORK/after.status" || fail "a selected run changed the product's git status" || return 1
  cmp -s "$WORK/before.packages" "$WORK/after.packages" || fail "a selected run changed a scanned package directory"
}

# --- the runner ---

WORK="$(mktemp -d)"
cleanup() {
  chmod -R u+rwX "$WORK" 2> /dev/null
  rm -rf "$WORK"
}
trap cleanup EXIT

normalised_cases="$(echo $CASES)"
selected="${KA_READER_TEST_ONLY:-}"
for wanted in $selected; do
  case " $normalised_cases " in
    *" $wanted "*) ;;
    *)
      echo "test_entry_points.sh: no such case: $wanted" >&2
      exit 1
      ;;
  esac
done

# The real metadata, read once: it says where each crate's package directory is, and it is never the
# script's input. The state the suite must leave unchanged is recorded before the first case.
(cd "$ROOT" && "$REAL_CARGO" metadata --format-version 1 --locked --filter-platform aarch64-apple-darwin) > "$WORK/real-metadata.json" 2> "$WORK/real-metadata.err" \
  || { echo "test_entry_points.sh: cargo metadata failed: $(cat "$WORK/real-metadata.err")" >&2; exit 1; }
snapshot_inputs "$WORK/baseline"

failed=0
failed_names=""
for case_name in $CASES; do
  if [ -n "$selected" ]; then
    case " $selected " in
      *" $case_name "*) ;;
      *) continue ;;
    esac
  fi
  if result="$("$case_name" 2>&1)"; then
    echo "ok   $case_name"
  else
    echo "FAIL $case_name"
    [ -z "$result" ] || echo "$result"
    failed=$((failed + 1))
    failed_names="$failed_names $case_name"
  fi
done

if [ "$failed" -ne 0 ]; then
  echo "test_entry_points.sh: $failed case(s) failed:$failed_names" >&2
  exit 1
fi

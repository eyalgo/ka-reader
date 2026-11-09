#!/usr/bin/env bash
# Version: 1.2.0 — the copyright-lines rule: the stand-in `cargo` answers `metadata` with packages that have
#   directories of their own, and the cases hold what the rule reads, carries, refuses and orders
# Version: 1.1.0 — the missing names' byte order is held under a locale that orders them otherwise,
#   and a name at the start of the file or directly between table bars is held as present
# Version: 1.0.0 — first version: drives the real checks/notices.sh over fixture notices files with a
#   stand-in `cargo`, and over the real tree
#
# checks/tests/test_notices.sh — the tests of checks/notices.sh.
#
# WHY THIS EXISTS
#   checks/notices.sh is the check that every name `cargo tree` reports is in
#   THIRD_PARTY_NOTICES.md. A bug in it is a dependency shipped without its notice, so these cases
#   run the real script — never a copy of its logic — by its absolute path. Every case but the last
#   runs it with its working directory a work directory of this suite's own, which holds a fixture
#   notices file, and with a stand-in `cargo` first on PATH. The stand-in prints `--prefix
#   none`-shaped lines, with versions, a `(*)` mark and a `[build-dependencies]` line, so the
#   script's real reading is exercised, and answers `cargo metadata` with one package object for
#   each name, each at a directory under the case's stub directory that holds no file until a case
#   writes one. The last case runs the real `cargo` on the real tree. The runner is this file: the
#   product has no Python (docs/nfdr.md § 9 names its toolchains), which is why the shell packet's
#   pytest runner is not used here.
#
# USAGE
#   checks/tests/test_notices.sh
#     KA_READER_TEST_ONLY=<case> runs one case.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
NOTICES_SH="$ROOT/checks/notices.sh"
ARGS_EXPECTED="tree --workspace --locked --offline --prefix none --target aarch64-apple-darwin --target x86_64-apple-darwin"
METADATA_EXPECTED="metadata --locked --offline --format-version 1 --filter-platform aarch64-apple-darwin --filter-platform x86_64-apple-darwin"

STATUS=0
WORK=""

CASES="
test_covering_file_passes
test_two_missing_names_are_both_named_in_byte_order
test_a_name_inside_a_longer_name_or_in_another_case_is_missing
test_missing_names_are_in_byte_order_under_another_locale
test_a_name_between_non_name_characters_or_at_the_end_of_the_file_is_present
test_absent_notices_file_is_a_refusal
test_unreadable_notices_file_is_a_refusal
test_cargo_tree_failing_is_a_refusal
test_cargo_tree_reporting_no_name_is_a_refusal
test_wrong_argument_count_is_a_usage_error
test_a_signal_never_ends_with_zero
test_cargo_is_asked_for_the_locked_offline_two_architecture_set
test_writes_no_file
test_reads_nothing_from_the_environment_but_path
test_copyright_lines_in_their_entries_pass
test_no_licence_file_and_no_copyright_line_pass
test_terms_headings_and_placeholders_are_not_copyright_lines
test_a_line_with_four_digits_and_a_bracketed_span_is_asked_for
test_each_kind_of_copyright_line_is_asked_for
test_a_copyright_line_not_carried_is_named
test_missing_lines_are_named_in_order
test_a_line_in_another_entry_or_section_is_not_carried
test_a_line_in_another_case_is_not_carried
test_outer_whitespace_is_free
test_outer_whitespace_in_the_entry_is_free
test_misses_are_ordered_by_name_then_file_then_version_then_line_number
test_a_changed_copyright_line_is_not_carried
test_a_name_miss_comes_before_a_copyright_miss
test_both_versions_of_one_name_are_read
test_licence_files_under_other_names_are_read
test_a_notice_file_and_a_file_below_the_root_are_not_read
test_a_heading_inside_a_fence_does_not_end_an_entry
test_a_level_two_or_three_heading_ends_an_entry
test_the_last_entry_runs_to_the_end_of_the_file
test_only_the_first_entry_of_a_name_counts
test_a_version_with_build_metadata_is_located
test_unreadable_licence_file_is_a_refusal
test_the_first_unreadable_licence_file_in_byte_order_is_named
test_packages_not_located_is_a_refusal
test_the_first_package_not_located_in_byte_order_is_named
test_the_name_checks_refusals_read_no_licence_file
test_real_tree_passes_and_is_left_as_it_was
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# A case's directories: the working directory the script runs in, and the directory of its
# stand-ins.
case_dirs() {
  CWD="$WORK/$1"
  STUBS="$WORK/$1-stubs"
  mkdir -p "$CWD" "$STUBS"
}

# The directory of the package $2 at version $3, under the stand-in's directory $1.
package_dir() {
  echo "$1/packages/$2-$3"
}

# A stand-in `cargo` in $1 that records its arguments in $1/args, whatever it is asked, and answers
#   tree      with the names that follow, in the shape of `cargo tree --prefix none`: versions,
#             a `(*)` mark on a repeat, a blank line and a `[build-dependencies]` line;
#   metadata  with one line of JSON in cargo's key order: one package object for each name, each
#             with a dependency object and a target object that carry a "name" key of their own, and
#             a `manifest_path` inside a package directory the stand-in makes. The `resolve` section
#             after the packages repeats their ids. A package directory holds no file until a case
#             writes one.
# A name is `name` at version 1.2.3, or `name@version`. The files in $1 that hold the answers are
# `tree`, `packages.tsv` (name, version, license_file and manifest_path as JSON, tab-separated) and,
# to make `metadata` end non-zero, `metadata_status`.
make_cargo() {
  dir="$1"
  shift
  : > "$dir/tree"
  : > "$dir/packages.tsv"
  first=""
  for spec in "$@"; do
    case "$spec" in
      *@*) name="${spec%%@*}"; version="${spec#*@}" ;;
      *) name="$spec"; version="1.2.3" ;;
    esac
    [ -n "$first" ] || first="$name v$version (*)"
    mkdir -p "$(package_dir "$dir" "$name" "$version")"
    echo "$name v$version (/somewhere/$name)" >> "$dir/tree"
    printf '%s\t%s\tnull\t"%s/Cargo.toml"\n' "$name" "$version" "$(package_dir "$dir" "$name" "$version")" >> "$dir/packages.tsv"
  done
  { echo "$first"; echo; echo '[build-dependencies]'; } >> "$dir/tree"
  cat > "$dir/cargo" <<'CARGO'
#!/bin/sh
d="$(dirname "$0")"
echo "$*" >> "$d/args"
case "$1" in
  tree) cat "$d/tree" ;;
  metadata)
    if [ -f "$d/metadata_status" ]; then exit "$(cat "$d/metadata_status")"; fi
    cat "$d/metadata.json" ;;
  *) exit 64 ;;
esac
CARGO
  chmod +x "$dir/cargo"
  write_metadata "$dir"
}

# Writes $1/metadata.json from $1/packages.
write_metadata() {
  awk -F'\t' '
    BEGIN { printf "{\"packages\":[" }
    {
      id = "registry+https://example.test/index#" $1 "@" $2
      ids[NR] = id
      if (NR > 1) printf ","
      printf "{\"name\":\"%s\",\"version\":\"%s\",\"id\":\"%s\",\"license\":\"MIT\",\"license_file\":%s,", $1, $2, id, $3
      printf "\"description\":\"A stand-in package.\",\"source\":\"registry+https://example.test/index\","
      printf "\"dependencies\":[{\"name\":\"%s\",\"source\":\"registry+https://example.test/index\",\"req\":\"^1\",\"kind\":null}],", $1
      printf "\"targets\":[{\"kind\":[\"lib\"],\"crate_types\":[\"lib\"],\"name\":\"%s\",\"src_path\":\"/x/lib.rs\"}],", $1
      printf "\"features\":{},\"manifest_path\":%s,\"metadata\":null}", $4
    }
    END {
      printf "],\"workspace_members\":[],\"resolve\":{\"nodes\":["
      for (i = 1; i <= NR; i++) printf "%s{\"id\":\"%s\",\"dependencies\":[]}", (i > 1 ? "," : ""), ids[i]
      printf "],\"root\":null},\"target_directory\":\"/x\",\"version\":1,\"workspace_root\":\"/x\",\"metadata\":null}\n"
    }
  ' "$1/packages.tsv" > "$1/metadata.json"
}

# The package $2 names the file $3 as its license_file.
set_license_file() {
  awk -F'\t' -v OFS='\t' -v name="$2" -v file="$3" '$1 == name { $3 = "\"" file "\"" } { print }' "$1/packages.tsv" > "$1/packages.tsv.new"
  mv "$1/packages.tsv.new" "$1/packages.tsv"
  write_metadata "$1"
}

# The package $2 prints $3 as its manifest_path, the JSON string with its quotes.
set_manifest_path() {
  awk -F'\t' -v OFS='\t' -v name="$2" -v path="$3" '$1 == name { $4 = path } { print }' "$1/packages.tsv" > "$1/packages.tsv.new"
  mv "$1/packages.tsv.new" "$1/packages.tsv"
  write_metadata "$1"
}

# `cargo metadata` lists no object for the package $2 (the tree still lists it).
drop_package() {
  awk -F'\t' -v name="$2" '$1 != name { print }' "$1/packages.tsv" > "$1/packages.tsv.new"
  mv "$1/packages.tsv.new" "$1/packages.tsv"
  write_metadata "$1"
}

# `cargo metadata` ends with the status $2.
metadata_ends() {
  echo "$2" > "$1/metadata_status"
}

# Writes the file $3 in the directory of the package $2 (at 1.2.3) under $1, holding the lines that
# follow.
licence_file() {
  dir="$1"
  name="$2"
  file="$3"
  shift 3
  printf '%s\n' "$@" > "$(package_dir "$dir" "$name" 1.2.3)/$file"
}

# Appends to the fixture notices file in the directory $1 an entry for the crate $2, which holds the
# lines that follow inside a text fence, or says it has none when no line follows.
fixture_entry() {
  dir="$1"
  name="$2"
  shift 2
  {
    printf '### `%s`\n\n`%s` is under `MIT`.\n\n' "$name" "$name"
    if [ "$#" -gt 0 ]; then
      printf 'Below is every copyright line its licence file states.\n\n```text\n'
      printf '%s\n' "$@"
      printf '```\n\n'
    else
      printf 'Its licence file states no copyright line.\n\n'
    fi
  } >> "$dir/THIRD_PARTY_NOTICES.md"
}

# A stand-in `cargo` in $1 whose whole body is $2.
make_cargo_with_body() {
  printf '#!/bin/sh\n%s\n' "$2" > "$1/cargo"
  chmod +x "$1/cargo"
}

# Runs the script with the working directory $1 and the stand-ins $2 ahead on PATH, with the
# arguments that follow. The streams are kept apart in $WORK/stdout and $WORK/stderr.
run_notices() {
  cwd="$1"
  stubs="$2"
  shift 2
  ( cd "$cwd" && PATH="$stubs:$PATH" "$NOTICES_SH" "$@" ) > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?
}

expect_status() {
  [ "$STATUS" -eq "$1" ] || fail "expected exit $1, got $STATUS. stdout: $(cat "$WORK/stdout"). stderr: $(cat "$WORK/stderr")"
}

expect_stdout_empty() {
  [ ! -s "$WORK/stdout" ] || fail "expected nothing on stdout, got: $(cat "$WORK/stdout")"
}

expect_stderr_empty() {
  [ ! -s "$WORK/stderr" ] || fail "expected nothing on stderr, got: $(cat "$WORK/stderr")"
}

# The stream file $1 is exactly the lines of $2, one per line.
expect_lines() {
  [ "$(cat "$1")" = "$2" ] || fail "expected exactly: $2. got: $(cat "$1")"
}

# One stderr line, holding the text $1, and nothing on stdout.
expect_one_stderr_line_with() {
  expect_stdout_empty || return 1
  [ "$(wc -l < "$WORK/stderr" | tr -d ' ')" -eq 1 ] || fail "expected one stderr line, got: $(cat "$WORK/stderr")" || return 1
  case "$(cat "$WORK/stderr")" in
    *"$1"*) return 0 ;;
  esac
  fail "expected the stderr line to hold: $1. got: $(cat "$WORK/stderr")"
}

miss_line() {
  printf 'notices.sh: %s — in cargo tree and not in THIRD_PARTY_NOTICES.md' "$1"
}

# One copyright-miss line: the component $1, the licence file $2, the line $3.
copyright_miss_line() {
  printf 'notices.sh: %s — copyright line in %s and not in its THIRD_PARTY_NOTICES.md entry: %s' "$1" "$2" "$3"
}

# --- cases ---

# CP-1199: every name is present — exit 0, the pass line on stdout with the count of distinct names,
# and nothing on stderr.
test_covering_file_passes() {
  case_dirs covering
  make_cargo "$STUBS" alpha beta gamma
  printf '| `alpha` | `MIT` |\n| `beta` | `MIT` |\n| `gamma` | `MIT` |\n' > "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"

  expect_status 0 || return 1
  expect_lines "$WORK/stdout" "notices.sh: 3 names in cargo tree, each in THIRD_PARTY_NOTICES.md" || return 1
  expect_stderr_empty
}

# CP-1200: every missing name is named, in byte order, in the full miss form; nothing on stdout.
test_two_missing_names_are_both_named_in_byte_order() {
  case_dirs two-missing
  make_cargo "$STUBS" beta gamma zeta alpha
  printf '| `beta` | `MIT` |\n| `gamma` | `MIT` |\n' > "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_stdout_empty || return 1
  expect_lines "$WORK/stderr" "$(miss_line alpha)
$(miss_line zeta)"
}

# CP-1198, CP-1200: a name inside a longer name, or in another case, is not present.
test_a_name_inside_a_longer_name_or_in_another_case_is_missing() {
  case_dirs longer-name
  make_cargo "$STUBS" thiserror regex serde
  printf '`regex-automata` `regex-syntax` `serde_json` `thiserror-impl` `Regex`\n' > "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_stdout_empty || return 1
  expect_lines "$WORK/stderr" "$(miss_line regex)
$(miss_line serde)
$(miss_line thiserror)"
}

# CP-1200: the missing names come in byte order whatever the locale the run inherits. Under a
# US-English collation `alpha` sorts before `Zeta`, and in bytes after it, so this pair tells a byte
# sort from a locale one where `alpha` and `zeta` cannot.
test_missing_names_are_in_byte_order_under_another_locale() {
  case_dirs byte-order
  make_cargo "$STUBS" beta alpha Zeta
  printf '| `beta` | `MIT` |\n' > "$CWD/THIRD_PARTY_NOTICES.md"

  ( cd "$CWD" && LC_ALL=en_US.UTF-8 PATH="$STUBS:$PATH" "$NOTICES_SH" ) > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?

  expect_status 1 || return 1
  expect_stdout_empty || return 1
  expect_lines "$WORK/stderr" "$(miss_line Zeta)
$(miss_line alpha)"
}

# CP-1198: a name between non-name characters, directly between table bars, at the very start of the
# file, or at the very end of it, is present.
test_a_name_between_non_name_characters_or_at_the_end_of_the_file_is_present() {
  case_dirs boundaries
  make_cargo "$STUBS" alpha beta delta epsilon gamma
  printf 'delta\n`alpha`\n| beta |\n|epsilon|\ngamma' > "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"

  expect_status 0 || return 1
  expect_lines "$WORK/stdout" "notices.sh: 5 names in cargo tree, each in THIRD_PARTY_NOTICES.md" || return 1
  expect_stderr_empty
}

# CP-1201: no notices file — a refusal, one stderr line, nothing on stdout.
test_absent_notices_file_is_a_refusal() {
  case_dirs absent
  make_cargo "$STUBS" alpha

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_one_stderr_line_with "cannot read THIRD_PARTY_NOTICES.md"
}

# CP-1201: a notices file that cannot be read is a refusal too. The mode is restored before cleanup.
test_unreadable_notices_file_is_a_refusal() {
  case_dirs unreadable
  make_cargo "$STUBS" alpha
  printf '`alpha`\n' > "$CWD/THIRD_PARTY_NOTICES.md"
  chmod 000 "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"
  chmod 644 "$CWD/THIRD_PARTY_NOTICES.md"

  expect_status 1 || return 1
  expect_one_stderr_line_with "cannot read THIRD_PARTY_NOTICES.md"
}

# CP-1201: a `cargo tree` that ends non-zero is one stderr line and none of cargo's own message.
test_cargo_tree_failing_is_a_refusal() {
  case_dirs cargo-fails
  make_cargo_with_body "$STUBS" 'echo "error: a message of cargo'"'"'s own" >&2; exit 101'
  printf '`alpha`\n' > "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_one_stderr_line_with "cargo tree ended with status 101" || return 1
  case "$(cat "$WORK/stderr")" in
    *"a message of cargo's own"*) fail "cargo's own stderr was passed through: $(cat "$WORK/stderr")" ;;
  esac
}

# CP-1201: a `cargo tree` that ends 0 with no name is a refusal, never a pass.
test_cargo_tree_reporting_no_name_is_a_refusal() {
  case_dirs no-names
  make_cargo_with_body "$STUBS" 'echo; echo "[build-dependencies]"; echo'
  printf '`alpha`\n' > "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_one_stderr_line_with "cargo tree printed no name"
}

# CP-1202: any argument is a usage error, exit 2, and `cargo` is never called.
test_wrong_argument_count_is_a_usage_error() {
  case_dirs arguments
  make_cargo "$STUBS" alpha
  printf '`alpha`\n' > "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS" extra
  expect_status 2 || return 1
  expect_one_stderr_line_with "takes no argument; arguments given: 1" || return 1

  run_notices "$CWD" "$STUBS" a b
  expect_status 2 || return 1
  expect_one_stderr_line_with "takes no argument; arguments given: 2" || return 1

  [ ! -e "$STUBS/args" ] || fail "cargo was called: $(cat "$STUBS/args")"
}

# CP-1202: a signal ends the run with 143, or with 1 when it lands in a command substitution.
# Never 0. The stand-in sends TERM to its parent and returns, so the case is deterministic. A suite
# cannot deliver INT to a background job of a non-interactive shell; the same trap holds INT (130).
test_a_signal_never_ends_with_zero() {
  case_dirs signal
  make_cargo_with_body "$STUBS" 'kill -TERM $PPID; exit 0'
  printf '`alpha`\n' > "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"

  case "$STATUS" in
    143 | 1) return 0 ;;
  esac
  fail "expected 143 or 1, got $STATUS. stderr: $(cat "$WORK/stderr")"
}

# CP-1197, CP-1203: cargo is asked for exactly the locked, offline, two-architecture set, and then,
# once, for the packages' places, locked and offline too. No other call is made.
test_cargo_is_asked_for_the_locked_offline_two_architecture_set() {
  case_dirs arguments-asked
  make_cargo "$STUBS" alpha
  printf '`alpha`\n' > "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"

  expect_status 0 || return 1
  [ "$(sed -n 1p "$STUBS/args")" = "$ARGS_EXPECTED" ] || fail "line 1 of args is not the name set's call: $(sed -n 1p "$STUBS/args")" || return 1
  [ "$(sed -n '2,$p' "$STUBS/args" | grep -c .)" -eq 1 ] || fail "expected one call after the name set's: $(cat "$STUBS/args")" || return 1
  [ "$(sed -n 2p "$STUBS/args")" = "$METADATA_EXPECTED" ] || fail "the second call is not the metadata call: $(sed -n 2p "$STUBS/args")" || return 1
  [ "$(grep -c -e '--locked' -e '--offline' "$STUBS/args")" -eq 2 ] || fail "a call is not locked and offline: $(cat "$STUBS/args")"
}

# CP-1203: the script writes no file, in the working directory or in TMPDIR, on a pass or on a miss.
test_writes_no_file() {
  case_dirs writes
  make_cargo "$STUBS" alpha beta
  mkdir -p "$WORK/writes-tmp"
  printf '`alpha` `beta`\n' > "$CWD/THIRD_PARTY_NOTICES.md"
  before="$(ls -A "$CWD"; echo '--'; ls -A "$WORK/writes-tmp")"

  ( cd "$CWD" && TMPDIR="$WORK/writes-tmp" PATH="$STUBS:$PATH" "$NOTICES_SH" ) > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?
  expect_status 0 || return 1
  [ "$(ls -A "$CWD"; echo '--'; ls -A "$WORK/writes-tmp")" = "$before" ] || fail "a pass wrote a file" || return 1

  printf '`alpha`\n' > "$CWD/THIRD_PARTY_NOTICES.md"
  ( cd "$CWD" && TMPDIR="$WORK/writes-tmp" PATH="$STUBS:$PATH" "$NOTICES_SH" ) > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?
  expect_status 1 || return 1
  [ "$(ls -A "$CWD"; echo '--'; ls -A "$WORK/writes-tmp")" = "$before" ] || fail "a miss wrote a file"
}

# CP-1204: nothing but PATH reaches the script — the same bytes and the same status under the host's
# whole environment and under an environment of PATH alone.
test_reads_nothing_from_the_environment_but_path() {
  case_dirs environment
  make_cargo "$STUBS" alpha beta
  printf '`alpha` `beta`\n' > "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"
  host_status="$STATUS"
  expect_status 0 || return 1
  expect_lines "$WORK/stdout" "notices.sh: 2 names in cargo tree, each in THIRD_PARTY_NOTICES.md" || return 1
  host_stdout="$(cat "$WORK/stdout")"
  host_stderr="$(cat "$WORK/stderr")"

  ( cd "$CWD" && env -i PATH="$STUBS:/usr/bin:/bin" "$NOTICES_SH" ) > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?

  [ "$STATUS" -eq "$host_status" ] || fail "status under PATH alone was $STATUS, under the host's environment $host_status" || return 1
  [ "$(cat "$WORK/stdout")" = "$host_stdout" ] || fail "stdout differs under PATH alone: $(cat "$WORK/stdout")" || return 1
  [ "$(cat "$WORK/stderr")" = "$host_stderr" ] || fail "stderr differs under PATH alone: $(cat "$WORK/stderr")"
}

# CP-1237: lines that stand in their entries pass. `alpha`'s MIT file states one line and its Apache
# file only the appendix placeholder, so the entry carries the one line and the placeholder is never
# asked for.
test_copyright_lines_in_their_entries_pass() {
  case_dirs lines-pass
  make_cargo "$STUBS" alpha beta
  licence_file "$STUBS" alpha LICENSE-MIT 'Copyright (c) 2014 Alex Crichton' '' 'Permission is hereby granted'
  licence_file "$STUBS" alpha LICENSE-APACHE 'Copyright [yyyy] [name of copyright owner]'
  licence_file "$STUBS" beta LICENSE 'Copyright (c) 2015 B'
  fixture_entry "$CWD" alpha 'Copyright (c) 2014 Alex Crichton'
  fixture_entry "$CWD" beta 'Copyright (c) 2015 B'

  run_notices "$CWD" "$STUBS"

  expect_status 0 || return 1
  expect_lines "$WORK/stdout" "notices.sh: 2 names in cargo tree, each in THIRD_PARTY_NOTICES.md" || return 1
  expect_stderr_empty
}

# CP-1234: a package with no licence file, and one whose licence file states no copyright line, have
# nothing to carry; their entries say so and the run passes.
test_no_licence_file_and_no_copyright_line_pass() {
  case_dirs nothing-to-carry
  make_cargo "$STUBS" alpha beta
  licence_file "$STUBS" beta LICENSE 'Permission is hereby granted, free of charge, to any person obtaining a copy' 'of this software, to deal in the Software without restriction.'
  fixture_entry "$CWD" alpha
  fixture_entry "$CWD" beta

  run_notices "$CWD" "$STUBS"

  expect_status 0 || return 1
  expect_lines "$WORK/stdout" "notices.sh: 2 names in cargo tree, each in THIRD_PARTY_NOTICES.md" || return 1
  expect_stderr_empty
}

# CP-1226: terms, headings and placeholders are not copyright lines.
test_terms_headings_and_placeholders_are_not_copyright_lines() {
  case_dirs not-lines
  make_cargo "$STUBS" alpha
  licence_file "$STUBS" alpha LICENSE-APACHE \
    'copyright notice that is included in or attached to the work' \
    '(c) You must retain, in the Source form of any Derivative Works' \
    'COPYRIGHT AND PERMISSION NOTICE' \
    'COPYRIGHT AND PERMISSION NOTICE (ICU 58 and later)' \
    'Copyright [yyyy] [name of copyright owner]' \
    'Copyright {yyyy} {name of copyright owner}' \
    'Copyright (C) <year>  <name of author>'
  fixture_entry "$CWD" alpha

  run_notices "$CWD" "$STUBS"

  expect_status 0 || return 1
  expect_stderr_empty
}

# CP-1226: a placeholder holds no run of four digits, so a line with a year is asked for whatever
# bracketed span it holds, an address in angle brackets among them.
test_a_line_with_four_digits_and_a_bracketed_span_is_asked_for() {
  case_dirs year-and-brackets
  make_cargo "$STUBS" alpha
  licence_file "$STUBS" alpha LICENSE \
    'Copyright (c) 2016 Jane Doe <jane@example.com>' \
    'Copyright [2019] Square Holder' \
    'Copyright {2018} Brace Holder' \
    '(c) 2017 Paren Holder <paren@example.com>'
  fixture_entry "$CWD" alpha

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_stdout_empty || return 1
  expect_lines "$WORK/stderr" "$(copyright_miss_line alpha LICENSE 'Copyright (c) 2016 Jane Doe <jane@example.com>')
$(copyright_miss_line alpha LICENSE 'Copyright [2019] Square Holder')
$(copyright_miss_line alpha LICENSE 'Copyright {2018} Brace Holder')
$(copyright_miss_line alpha LICENSE '(c) 2017 Paren Holder <paren@example.com>')"
}

# CP-1226: every kind of line the rule takes in is asked for, each as its own line, in the order the
# file states them.
test_each_kind_of_copyright_line_is_asked_for() {
  case_dirs each-kind
  make_cargo "$STUBS" alpha
  licence_file "$STUBS" alpha LICENSE \
    'Copyright (c) 2014 Alex Crichton' \
    'Copyright 2015 Google Inc. All rights reserved.' \
    'Copyright © 1991-2023 Unicode, Inc.' \
    'Copyright (c) 2016--2023' \
    'Copyright 2015 Nicholas Allegra (comex).' \
    'Copyrights in the `rustix` project are retained by their contributors.' \
    'Copyright (C) 1989, 1991 Free Software Foundation, Inc.' \
    'Copyright (c) The Rust Project Developers' \
    'COPYRIGHT 2021 Upper Holder' \
    '(c) 2019 Paren Holder' \
    '(C) 2018 Cap Holder' \
    '© 2017 Sign Holder'
  fixture_entry "$CWD" alpha

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_stdout_empty || return 1
  expected=""
  while IFS= read -r line; do
    expected="$expected$(copyright_miss_line alpha LICENSE "$line")
"
  done < "$STUBS/packages/alpha-1.2.3/LICENSE"
  expect_lines "$WORK/stderr" "${expected%?}"
}

# CP-1235: a line the entry does not carry is named in the pinned shape; nothing on stdout.
test_a_copyright_line_not_carried_is_named() {
  case_dirs not-carried
  make_cargo "$STUBS" alpha
  licence_file "$STUBS" alpha LICENSE 'Copyright (c) 2020 A'
  fixture_entry "$CWD" alpha

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_stdout_empty || return 1
  expect_lines "$WORK/stderr" "$(copyright_miss_line alpha LICENSE 'Copyright (c) 2020 A')"
}

# CP-1235: the lines come ordered by name, then file name, each in byte order, whatever order the
# tree lists the names in and whatever the locale; a line stated twice under one file name is named
# once.
test_missing_lines_are_named_in_order() {
  case_dirs order
  make_cargo "$STUBS" beta alpha
  licence_file "$STUBS" alpha LICENSE 'Copyright (c) 2020 A'
  licence_file "$STUBS" beta LICENSE-MIT 'Copyright (c) 2020 B-MIT' 'Copyright (c) 2020 B-MIT'
  licence_file "$STUBS" beta LICENSE-APACHE 'Copyright (c) 2020 B-APACHE'
  fixture_entry "$CWD" alpha
  fixture_entry "$CWD" beta
  expected="$(copyright_miss_line alpha LICENSE 'Copyright (c) 2020 A')
$(copyright_miss_line beta LICENSE-APACHE 'Copyright (c) 2020 B-APACHE')
$(copyright_miss_line beta LICENSE-MIT 'Copyright (c) 2020 B-MIT')"

  run_notices "$CWD" "$STUBS"
  expect_status 1 || return 1
  expect_lines "$WORK/stderr" "$expected" || return 1

  ( cd "$CWD" && LC_ALL=en_US.UTF-8 PATH="$STUBS:$PATH" "$NOTICES_SH" ) > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?
  expect_status 1 || return 1
  expect_lines "$WORK/stderr" "$expected"
}

# CP-1232, CP-1234: a line carried by another component's entry, or by a later section, is not
# carried.
test_a_line_in_another_entry_or_section_is_not_carried() {
  case_dirs other-entry
  make_cargo "$STUBS" alpha beta
  licence_file "$STUBS" alpha LICENSE 'Copyright (c) 2020 A'
  fixture_entry "$CWD" alpha
  fixture_entry "$CWD" beta 'Copyright (c) 2020 A'

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_lines "$WORK/stderr" "$(copyright_miss_line alpha LICENSE 'Copyright (c) 2020 A')" || return 1

  case_dirs other-section
  make_cargo "$STUBS" alpha
  licence_file "$STUBS" alpha LICENSE 'Copyright (c) 2020 A'
  fixture_entry "$CWD" alpha
  printf '## Licence texts\n\n### MIT\n\nCopyright (c) 2020 A\n' >> "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_lines "$WORK/stderr" "$(copyright_miss_line alpha LICENSE 'Copyright (c) 2020 A')"
}

# CP-1234: the same characters in the same case — a line in another case is not carried.
test_a_line_in_another_case_is_not_carried() {
  case_dirs other-case
  make_cargo "$STUBS" alpha
  licence_file "$STUBS" alpha LICENSE 'Copyright (c) 2020 A'
  fixture_entry "$CWD" alpha 'Copyright (C) 2020 A'

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_lines "$WORK/stderr" "$(copyright_miss_line alpha LICENSE 'Copyright (c) 2020 A')"
}

# CP-1234: only the whitespace before and after a line is free: spaces, tabs and a carriage return.
test_outer_whitespace_is_free() {
  case_dirs whitespace
  make_cargo "$STUBS" alpha
  printf '  \t Copyright (c) 2020 A \r\n' > "$STUBS/packages/alpha-1.2.3/LICENSE"
  fixture_entry "$CWD" alpha 'Copyright (c) 2020 A'

  run_notices "$CWD" "$STUBS"

  expect_status 0 || return 1
  expect_stderr_empty || return 1

  # The same file against an entry without the line: the line was read, with its outer whitespace
  # removed, and not passed over unrecognised, which exit 0 above cannot tell apart.
  case_dirs whitespace-read
  make_cargo "$STUBS" alpha
  printf '  \t Copyright (c) 2020 A \r\n' > "$STUBS/packages/alpha-1.2.3/LICENSE"
  fixture_entry "$CWD" alpha

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_lines "$WORK/stderr" "$(copyright_miss_line alpha LICENSE 'Copyright (c) 2020 A')"
}

# CP-1230: the entry's line is trimmed the same way, so an indented or carriage-return-ended line in
# the entry carries a licence file's bare line.
test_outer_whitespace_in_the_entry_is_free() {
  case_dirs entry-whitespace
  make_cargo "$STUBS" alpha
  licence_file "$STUBS" alpha LICENSE 'Copyright (c) 2020 A'
  printf '### `alpha`\n\n```text\n  \t Copyright (c) 2020 A \r\n```\n' > "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"

  expect_status 0 || return 1
  expect_stderr_empty
}

# CP-1235: the misses stand in the order name, file, version, line number, each by byte but the line
# number, which is by value. The line numbers here run against every other key: `beta` is listed
# first and misses at line 1, `alpha` misses at lines 10 and 2, and `alpha`'s two versions are
# listed newest first.
test_misses_are_ordered_by_name_then_file_then_version_then_line_number() {
  case_dirs order-keys
  make_cargo "$STUBS" beta alpha@2.0.0 alpha@1.2.3
  licence_file "$STUBS" beta LICENSE 'Copyright (c) 2020 B'
  printf '%s\n' x 'Copyright (c) 2020 A-two' x x x x x x x 'Copyright (c) 2020 A-ten' > "$STUBS/packages/alpha-1.2.3/LICENSE"
  printf '%s\n' 'Copyright (c) 2021 A-newer' > "$STUBS/packages/alpha-2.0.0/LICENSE"
  fixture_entry "$CWD" alpha
  fixture_entry "$CWD" beta

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_lines "$WORK/stderr" "$(copyright_miss_line alpha LICENSE 'Copyright (c) 2020 A-two')
$(copyright_miss_line alpha LICENSE 'Copyright (c) 2020 A-ten')
$(copyright_miss_line alpha LICENSE 'Copyright (c) 2021 A-newer')
$(copyright_miss_line beta LICENSE 'Copyright (c) 2020 B')"
}

# CP-1235: a crate update that changes a line makes the old line stale, and the new line is named.
test_a_changed_copyright_line_is_not_carried() {
  case_dirs changed-line
  make_cargo "$STUBS" cc
  licence_file "$STUBS" cc LICENSE-MIT 'Copyright (c) 2014-2027 Alex Crichton'
  fixture_entry "$CWD" cc 'Copyright (c) 2014 Alex Crichton'

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_lines "$WORK/stderr" "$(copyright_miss_line cc LICENSE-MIT 'Copyright (c) 2014-2027 Alex Crichton')"
}

# CP-1236: a name miss is printed first, and the missing name gets no copyright-miss line.
test_a_name_miss_comes_before_a_copyright_miss() {
  case_dirs name-first
  make_cargo "$STUBS" alpha zeta
  licence_file "$STUBS" alpha LICENSE 'Copyright (c) 2020 A'
  licence_file "$STUBS" zeta LICENSE 'Copyright (c) 2020 Z'
  fixture_entry "$CWD" alpha

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_stdout_empty || return 1
  expect_lines "$WORK/stderr" "$(miss_line zeta)
$(copyright_miss_line alpha LICENSE 'Copyright (c) 2020 A')"
}

# CP-1227: two versions of one name are two packages, and both are read.
test_both_versions_of_one_name_are_read() {
  case_dirs two-versions
  make_cargo "$STUBS" alpha@1.2.3 alpha@2.0.0
  printf 'Copyright (c) 2020 Old\n' > "$STUBS/packages/alpha-1.2.3/LICENSE"
  printf 'Copyright (c) 2024 New\n' > "$STUBS/packages/alpha-2.0.0/LICENSE"
  fixture_entry "$CWD" alpha 'Copyright (c) 2020 Old'

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_lines "$WORK/stderr" "$(copyright_miss_line alpha LICENSE 'Copyright (c) 2024 New')" || return 1

  case_dirs two-versions-carried
  make_cargo "$STUBS" alpha@1.2.3 alpha@2.0.0
  printf 'Copyright (c) 2020 Old\n' > "$STUBS/packages/alpha-1.2.3/LICENSE"
  printf 'Copyright (c) 2024 New\n' > "$STUBS/packages/alpha-2.0.0/LICENSE"
  fixture_entry "$CWD" alpha 'Copyright (c) 2020 Old' 'Copyright (c) 2024 New'

  run_notices "$CWD" "$STUBS"

  expect_status 0 || return 1
  expect_stderr_empty
}

# CP-1225: a licence file is found by its name in any case, and by the package's license_file.
test_licence_files_under_other_names_are_read() {
  case_dirs other-names
  make_cargo "$STUBS" alpha beta gamma
  licence_file "$STUBS" alpha LICENCE.txt 'Copyright (c) 2020 A'
  licence_file "$STUBS" beta license-mit 'Copyright (c) 2020 B'
  licence_file "$STUBS" gamma LEGAL 'Copyright (c) 2020 G'
  set_license_file "$STUBS" gamma LEGAL
  fixture_entry "$CWD" alpha
  fixture_entry "$CWD" beta
  fixture_entry "$CWD" gamma

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_lines "$WORK/stderr" "$(copyright_miss_line alpha LICENCE.txt 'Copyright (c) 2020 A')
$(copyright_miss_line beta license-mit 'Copyright (c) 2020 B')
$(copyright_miss_line gamma LEGAL 'Copyright (c) 2020 G')"
}

# CP-1225: a NOTICE file, a file below the root and a directory named like a licence file are not
# read.
test_a_notice_file_and_a_file_below_the_root_are_not_read() {
  case_dirs not-read
  make_cargo "$STUBS" alpha
  root="$STUBS/packages/alpha-1.2.3"
  mkdir -p "$root/sub" "$root/LICENSES"
  printf 'Copyright (c) 2020 N\n' > "$root/NOTICE"
  printf 'Copyright (c) 2020 S\n' > "$root/sub/LICENSE"
  printf 'Copyright (c) 2020 D\n' > "$root/LICENSES/MIT"
  fixture_entry "$CWD" alpha

  run_notices "$CWD" "$STUBS"

  expect_status 0 || return 1
  expect_stderr_empty
}

# CP-1232: a fence keeps its lines: a `### ` line inside one does not end the entry.
test_a_heading_inside_a_fence_does_not_end_an_entry() {
  case_dirs heading-in-fence
  make_cargo "$STUBS" alpha
  licence_file "$STUBS" alpha LICENSE 'Copyright (c) 2020 A'
  fixture_entry "$CWD" alpha '### a line that looks like a heading' 'Copyright (c) 2020 A'

  run_notices "$CWD" "$STUBS"

  expect_status 0 || return 1
  expect_stderr_empty
}

# CP-1232: a `## ` heading, and a `### ` heading outside a fence, each end an entry.
test_a_level_two_or_three_heading_ends_an_entry() {
  case_dirs heading-two
  make_cargo "$STUBS" alpha
  licence_file "$STUBS" alpha LICENSE 'Copyright (c) 2020 A'
  fixture_entry "$CWD" alpha
  printf '## Another section\n\nCopyright (c) 2020 A\n' >> "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_lines "$WORK/stderr" "$(copyright_miss_line alpha LICENSE 'Copyright (c) 2020 A')" || return 1

  case_dirs heading-three
  make_cargo "$STUBS" alpha
  licence_file "$STUBS" alpha LICENSE 'Copyright (c) 2020 A'
  fixture_entry "$CWD" alpha
  printf '### `beta`\n\nCopyright (c) 2020 A\n' >> "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_lines "$WORK/stderr" "$(copyright_miss_line alpha LICENSE 'Copyright (c) 2020 A')" || return 1

  # A `### ` heading that is no crate's, as a library's or a licence text's is, ends the entry too.
  case_dirs heading-three-plain
  make_cargo "$STUBS" alpha
  licence_file "$STUBS" alpha LICENSE 'Copyright (c) 2020 A'
  fixture_entry "$CWD" alpha
  printf '### MIT\n\nCopyright (c) 2020 A\n' >> "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_lines "$WORK/stderr" "$(copyright_miss_line alpha LICENSE 'Copyright (c) 2020 A')"
}

# CP-1232: the last entry of the file runs to the end of the file, and its last line has no newline.
test_the_last_entry_runs_to_the_end_of_the_file() {
  case_dirs last-entry
  make_cargo "$STUBS" alpha
  licence_file "$STUBS" alpha LICENSE 'Copyright (c) 2020 A'
  printf '### `alpha`\n\nCopyright (c) 2020 A' > "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"

  expect_status 0 || return 1
  expect_stderr_empty
}

# CP-1232: a name with two entries has the first read; a line only under the second is not carried.
test_only_the_first_entry_of_a_name_counts() {
  case_dirs two-entries
  make_cargo "$STUBS" alpha
  licence_file "$STUBS" alpha LICENSE 'Copyright (c) 2020 A'
  fixture_entry "$CWD" alpha
  fixture_entry "$CWD" alpha 'Copyright (c) 2020 A'

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_lines "$WORK/stderr" "$(copyright_miss_line alpha LICENSE 'Copyright (c) 2020 A')"
}

# CP-1234: a version with build metadata, as `libgit2-sys 0.18.8+1.9.7` is, pairs the listing and
# the metadata object, and is never the not-located refusal.
test_a_version_with_build_metadata_is_located() {
  case_dirs build-metadata
  make_cargo "$STUBS" alpha@1.2.3+4.5.6
  printf 'Copyright (c) 2020 A\n' > "$STUBS/packages/alpha-1.2.3+4.5.6/LICENSE"
  fixture_entry "$CWD" alpha 'Copyright (c) 2020 A'

  run_notices "$CWD" "$STUBS"

  expect_status 0 || return 1
  expect_stderr_empty
}

# CP-1238: a licence file that cannot be read is a refusal naming the component and the file, never
# a pass. Mode 000 does not stop root from reading, so the case reports that it cannot run when the
# file is still readable after the chmod, and never passes without testing the refusal. Mode is
# restored.
test_unreadable_licence_file_is_a_refusal() {
  case_dirs unreadable-licence
  make_cargo "$STUBS" alpha
  licence_file "$STUBS" alpha LICENSE 'Copyright (c) 2020 A'
  fixture_entry "$CWD" alpha 'Copyright (c) 2020 A'
  file="$STUBS/packages/alpha-1.2.3/LICENSE"
  chmod 000 "$file"
  if [ -r "$file" ]; then
    chmod 644 "$file"
    fail "cannot run: the licence file is still readable after chmod 000 (running as root?)"
    return 1
  fi

  run_notices "$CWD" "$STUBS"
  chmod 644 "$file"

  expect_status 1 || return 1
  expect_one_stderr_line_with "cannot read LICENSE in alpha's package, so nothing was checked" || return 1
  expect_one_stderr_line_with "Check that $file can be read"
}

# CP-1238: with several licence files that cannot be read, the refusal names the first component
# and file in byte order, whatever order the tree lists the names in: `beta` is listed first, and
# `alpha`'s `LICENSE-APACHE` sorts before its `LICENSE-MIT`. Mode is restored, and the case reports
# that it cannot run when a file is still readable after the chmod.
test_the_first_unreadable_licence_file_in_byte_order_is_named() {
  case_dirs unreadable-first
  make_cargo "$STUBS" beta alpha
  licence_file "$STUBS" beta LICENSE 'Copyright (c) 2020 B'
  licence_file "$STUBS" alpha LICENSE-MIT 'Copyright (c) 2020 A'
  licence_file "$STUBS" alpha LICENSE-APACHE 'Copyright (c) 2020 A'
  fixture_entry "$CWD" alpha 'Copyright (c) 2020 A'
  fixture_entry "$CWD" beta 'Copyright (c) 2020 B'
  beta_file="$STUBS/packages/beta-1.2.3/LICENSE"
  alpha_mit="$STUBS/packages/alpha-1.2.3/LICENSE-MIT"
  alpha_apache="$STUBS/packages/alpha-1.2.3/LICENSE-APACHE"
  chmod 000 "$beta_file" "$alpha_mit" "$alpha_apache"
  if [ -r "$beta_file" ] || [ -r "$alpha_mit" ] || [ -r "$alpha_apache" ]; then
    chmod 644 "$beta_file" "$alpha_mit" "$alpha_apache"
    fail "cannot run: a licence file is still readable after chmod 000 (running as root?)"
    return 1
  fi

  run_notices "$CWD" "$STUBS"
  chmod 644 "$beta_file" "$alpha_mit" "$alpha_apache"

  expect_status 1 || return 1
  expect_one_stderr_line_with "cannot read LICENSE-APACHE in alpha's package, so nothing was checked"
}

# CP-1238: with several packages that cannot be located, the refusal names the first in byte order,
# whatever order the tree lists the names in.
test_the_first_package_not_located_in_byte_order_is_named() {
  case_dirs not-located-first
  make_cargo "$STUBS" zeta beta alpha
  drop_package "$STUBS" zeta
  drop_package "$STUBS" beta
  fixture_entry "$CWD" alpha
  fixture_entry "$CWD" beta
  fixture_entry "$CWD" zeta

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_one_stderr_line_with "found no package for beta 1.2.3 in what cargo metadata printed"
}

# CP-1238: packages whose sources could not be located are one refusal line, however it came about,
# and nothing on stdout even with a name missing beside it: `cargo metadata` ending non-zero, no
# object for a package, and a printed path holding a backslash (a JSON string is never unescaped).
test_packages_not_located_is_a_refusal() {
  case_dirs not-located-status
  make_cargo "$STUBS" alpha beta
  metadata_ends "$STUBS" 101
  fixture_entry "$CWD" alpha

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_one_stderr_line_with "cargo metadata ended with status 101, so the packages' sources could not be located and nothing was checked" || return 1

  case_dirs not-located-object
  make_cargo "$STUBS" alpha beta
  drop_package "$STUBS" beta
  fixture_entry "$CWD" alpha

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_one_stderr_line_with "found no package for beta 1.2.3 in what cargo metadata printed, so the packages' sources could not be located and nothing was checked" || return 1

  case_dirs not-located-backslash
  make_cargo "$STUBS" alpha beta
  set_manifest_path "$STUBS" beta '"C:\\\\somewhere\\\\Cargo.toml"'
  fixture_entry "$CWD" alpha

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_one_stderr_line_with "the path cargo metadata printed for beta's package holds a backslash" || return 1
  expect_one_stderr_line_with "so the packages' sources could not be located and nothing was checked" || return 1

  case_dirs not-located-directory
  make_cargo "$STUBS" alpha beta
  rmdir "$STUBS/packages/beta-1.2.3"
  fixture_entry "$CWD" alpha

  run_notices "$CWD" "$STUBS"

  expect_status 1 || return 1
  expect_one_stderr_line_with "cargo metadata placed beta's package at $STUBS/packages/beta-1.2.3, and that is not a directory, so the packages' sources could not be located and nothing was checked"
}

# CP-1238: the name check's own refusals end the run before `cargo metadata` is asked for.
test_the_name_checks_refusals_read_no_licence_file() {
  case_dirs early-refusals
  make_cargo "$STUBS" alpha

  run_notices "$CWD" "$STUBS"
  expect_status 1 || return 1
  ! grep -q '^metadata' "$STUBS/args" 2> /dev/null || fail "metadata was asked for with no notices file" || return 1

  case_dirs early-tree-fails
  make_cargo_with_body "$STUBS" 'echo "$*" >> "$(dirname "$0")/args"; exit 101'
  printf '`alpha`\n' > "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"
  expect_status 1 || return 1
  ! grep -q '^metadata' "$STUBS/args" || fail "metadata was asked for after a failing tree call" || return 1

  case_dirs early-no-names
  make_cargo_with_body "$STUBS" 'echo "$*" >> "$(dirname "$0")/args"; echo; echo "[build-dependencies]"'
  printf '`alpha`\n' > "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"
  expect_status 1 || return 1
  ! grep -q '^metadata' "$STUBS/args" || fail "metadata was asked for after an empty listing"
}

# CP-1203, CP-1206: the real cargo on the real tree passes, and leaves the repository as it was.
test_real_tree_passes_and_is_left_as_it_was() {
  before="$(git -C "$ROOT" status --porcelain --ignored)"
  lock_before="$(cksum < "$ROOT/Cargo.lock")"

  ( cd "$ROOT" && "$NOTICES_SH" ) > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?

  expect_status 0 || return 1
  case "$(cat "$WORK/stdout")" in
    "notices.sh: "[0-9]*" names in cargo tree, each in THIRD_PARTY_NOTICES.md") ;;
    *) fail "the passing line is not in the pass form: $(cat "$WORK/stdout")" || return 1 ;;
  esac
  expect_stderr_empty || return 1
  [ "$(git -C "$ROOT" status --porcelain --ignored)" = "$before" ] || fail "the repository's status changed" || return 1
  [ "$(cksum < "$ROOT/Cargo.lock")" = "$lock_before" ] || fail "Cargo.lock changed"
}

# --- the runner ---

WORK="$(mktemp -d)"
cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

failed=0
for case_name in $CASES; do
  if [ -n "${KA_READER_TEST_ONLY:-}" ] && [ "$case_name" != "$KA_READER_TEST_ONLY" ]; then
    continue
  fi
  if result="$("$case_name" 2>&1)"; then
    echo "ok   $case_name"
  else
    echo "FAIL $case_name"
    [ -z "$result" ] || echo "$result"
    failed=$((failed + 1))
  fi
done

if [ "$failed" -ne 0 ]; then
  echo "test_notices.sh: $failed case(s) failed" >&2
  exit 1
fi

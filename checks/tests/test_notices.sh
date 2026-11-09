#!/usr/bin/env bash
# Version: 1.0.0 — first version: drives the real checks/notices.sh over fixture notices files with a
#   stand-in `cargo`, and over the real tree
#
# checks/tests/test_notices.sh — the tests of checks/notices.sh.
#
# WHY THIS EXISTS
#   checks/notices.sh is the check that every name `cargo tree` reports is in
#   THIRD_PARTY_NOTICES.md. A bug in it is a dependency shipped without its notice, so these cases run
#   the real script — never a copy of its logic — by its absolute path. Every case but the last runs
#   it with its working directory a work directory of this suite's own, which holds a fixture notices
#   file, and with a stand-in `cargo` first on PATH. The stand-in prints `--prefix none`-shaped lines,
#   with versions, a `(*)` mark and a `[build-dependencies]` line, so the script's real reading is
#   exercised. The last case runs the real `cargo` on the real tree. The runner is this file: the
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

STATUS=0
WORK=""

CASES="
test_covering_file_passes
test_two_missing_names_are_both_named_in_byte_order
test_a_name_inside_a_longer_name_or_in_another_case_is_missing
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
test_real_tree_passes_and_is_left_as_it_was
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# A case's directories: the working directory the script runs in, and the directory of its stand-ins.
case_dirs() {
  CWD="$WORK/$1"
  STUBS="$WORK/$1-stubs"
  mkdir -p "$CWD" "$STUBS"
}

# A stand-in `cargo` in $1 that records its arguments in $1/args and prints the names that follow, in
# the shape of `cargo tree --prefix none`: versions, a `(*)` mark on a repeat, a blank line and a
# `[build-dependencies]` line.
make_cargo() {
  dir="$1"
  shift
  {
    echo '#!/bin/sh'
    echo "echo \"\$*\" >> \"$dir/args\""
    for name in "$@"; do
      echo "echo '$name v1.2.3 (/somewhere/$name)'"
    done
    echo "echo '$1 v1.2.3 (*)'"
    echo "echo"
    echo "echo '[build-dependencies]'"
  } > "$dir/cargo"
  chmod +x "$dir/cargo"
}

# A stand-in `cargo` in $1 whose whole body is $2.
make_cargo_with_body() {
  printf '#!/bin/sh\n%s\n' "$2" > "$1/cargo"
  chmod +x "$1/cargo"
}

# Runs the script with the working directory $1 and the stand-ins $2 ahead on PATH, with the arguments
# that follow. The streams are kept apart in $WORK/stdout and $WORK/stderr.
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

# CP-1198: a name between non-name characters, or at the very end of the file, is present.
test_a_name_between_non_name_characters_or_at_the_end_of_the_file_is_present() {
  case_dirs boundaries
  make_cargo "$STUBS" alpha beta gamma
  printf '`alpha`\n| beta |\ngamma' > "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"

  expect_status 0 || return 1
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

# CP-1202: a signal ends the run with 143, or with 1 when it lands in a command substitution. Never 0.
# The stand-in sends TERM to its parent and returns, so the case is deterministic. A suite cannot
# deliver INT to a background job of a non-interactive shell; the same trap holds INT (130).
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

# CP-1197, CP-1203: cargo is asked for exactly the locked, offline, two-architecture set.
test_cargo_is_asked_for_the_locked_offline_two_architecture_set() {
  case_dirs arguments-asked
  make_cargo "$STUBS" alpha
  printf '`alpha`\n' > "$CWD/THIRD_PARTY_NOTICES.md"

  run_notices "$CWD" "$STUBS"

  expect_status 0 || return 1
  expect_lines "$STUBS/args" "$ARGS_EXPECTED"
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

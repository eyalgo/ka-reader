#!/usr/bin/env bash
# Version: 1.0.0 — first version: drives the real checks/no-network.sh against the real tree and against stubbed ones
#
# checks/tests/test_no_network.sh — the tests of checks/no-network.sh and checks/deps.allow.
#
# WHY THIS EXISTS
#   checks/no-network.sh is the review gate on what the product is built from: a name in the tree that
#   nobody put in checks/deps.allow fails the build. A bug in it is a tree nobody is reviewing. These
#   cases run the real script — never a copy of its logic — against the real tree and against stubbed
#   ones, with `cargo`, `pnpm` and `uname` stubbed on PATH. A stub that must keep the real tree's shape
#   runs the real tool and edits its output, so this suite never lists the tree's names by hand.
#   The runner is this file: the product has no Python (docs/nfdr.md § 9 names its toolchains), which
#   is why the shell packet's pytest runner is not used here.
#
# USAGE
#   checks/tests/test_no_network.sh
#     NOZOKI_TEST_ONLY=<case> runs one case.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its own
#   status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
NO_NETWORK_SH="$ROOT/checks/no-network.sh"
ALLOWLIST="$ROOT/checks/deps.allow"
REAL_CARGO="$(command -v cargo)"

OUT=""
STATUS=0
WORK=""

CASES="
test_clean_tree_passes
test_crate_not_in_the_allowlist_fails
test_allowlist_entry_not_in_the_tree_fails
test_pnpm_reporting_no_package_is_an_error
test_verdict_is_unchanged_on_an_x64_machine
test_no_transport_or_libgit2_crate
test_log_is_the_only_logging_facade
test_swapped_log_writer_fails
test_comments_and_blank_lines_are_ignored
test_a_cargo_section_name_does_not_satisfy_the_pnpm_section
"

# --- helpers ---

run_no_network_sh() {
  OUT="$("$NO_NETWORK_SH" "$@" 2>&1)"
  STATUS=$?
}

# Same, with a stub directory ahead of the real tools on PATH.
run_with_stubs() {
  stubs="$1"
  shift
  OUT="$(PATH="$stubs:$PATH" "$NO_NETWORK_SH" "$@" 2>&1)"
  STATUS=$?
}

make_stub() {
  printf '#!/bin/sh\n%s\n' "$3" > "$1/$2"
  chmod +x "$1/$2"
}

fail() {
  echo "  $*"
  return 1
}

expect_zero_status() {
  [ "$STATUS" -eq 0 ] || fail "expected exit 0, got $STATUS. output: $OUT"
}

expect_nonzero_status() {
  [ "$STATUS" -ne 0 ] || fail "expected a non-zero exit, got 0. output: $OUT"
}

expect_output_contains() {
  case "$OUT" in
    *"$1"*) return 0 ;;
  esac
  fail "expected the output to contain: $1. output: $OUT"
}

# A line of $2 that is exactly $1.
file_has_line() {
  grep -qxF -- "$1" "$2"
}

# `cargo` that runs the real one and pipes what it prints through the sed program $2.
cargo_edited_by() {
  make_stub "$1" cargo "\"$REAL_CARGO\" \"\$@\" | sed '$2'"
}

# --- cases ---

# CP-47: both trees equal their allowlist sections, and nothing names a dependency on stdout.
test_clean_tree_passes() {
  run_no_network_sh

  expect_zero_status || return 1
  [ "$(printf '%s\n' "$OUT" | wc -l | tr -d ' ')" -eq 1 ] || fail "expected one line of output, got: $OUT" || return 1
  case "$OUT" in
    "no-network.sh: ok — "*) ;;
    *) fail "the passing line is not the one that names counts only. output: $OUT" ;;
  esac
}

# CP-47, CP-48: a name in the tree with no allowlist line is named, with its section and its side.
test_crate_not_in_the_allowlist_fails() {
  mkdir -p "$WORK/stubs-added"
  cargo_edited_by "$WORK/stubs-added" '$a\
left-pad-rs v1.0.0
'

  run_with_stubs "$WORK/stubs-added"

  expect_nonzero_status || return 1
  expect_output_contains "cargo: left-pad-rs" || return 1
  expect_output_contains "in the tree and not in checks/deps.allow"
}

# CP-47, CP-48: an allowlist entry the tree does not hold is named, with its section and its side.
test_allowlist_entry_not_in_the_tree_fails() {
  mkdir -p "$WORK/stubs-removed"
  cargo_edited_by "$WORK/stubs-removed" '/^anyhow v/d'

  run_with_stubs "$WORK/stubs-removed"

  expect_nonzero_status || return 1
  expect_output_contains "cargo: anyhow" || return 1
  expect_output_contains "in checks/deps.allow and not in the tree"
}

# CP-47, rule-implied: a pnpm that reports no package is a missing install, never an empty set that
# compares clean against an empty section.
test_pnpm_reporting_no_package_is_an_error() {
  mkdir -p "$WORK/stubs-nopnpm"
  make_stub "$WORK/stubs-nopnpm" pnpm 'echo "[{\"name\":\"nozoki-ui\",\"version\":\"0.0.0\"}]"'

  run_with_stubs "$WORK/stubs-nopnpm"

  expect_nonzero_status || return 1
  expect_output_contains "pnpm ls reported no package" || return 1
  expect_output_contains "pnpm install --frozen-lockfile"
}

# CP-50: the compared set does not depend on the running CPU. Held by construction — the cargo half names
# both Apple-Darwin triples itself rather than taking the host's — so the case checks both halves of that:
# the verdict under a stubbed `uname`, and the triples on the command line.
test_verdict_is_unchanged_on_an_x64_machine() {
  mkdir -p "$WORK/stubs-x64"
  make_stub "$WORK/stubs-x64" uname 'echo x86_64'
  make_stub "$WORK/stubs-x64" cargo "echo \"\$@\" > \"$WORK/cargo-argv\"; \"$REAL_CARGO\" \"\$@\""

  run_with_stubs "$WORK/stubs-x64"

  expect_zero_status || return 1
  argv="$(cat "$WORK/cargo-argv" 2> /dev/null || true)"
  case "$argv" in
    *"--target aarch64-apple-darwin"*"--target x86_64-apple-darwin"* | *"--target x86_64-apple-darwin"*"--target aarch64-apple-darwin"*) ;;
    *) fail "the cargo half did not name both Apple-Darwin triples. argv: $argv" ;;
  esac
}

# CP-51, the runnable half: no libgit2 binding and none of the named TLS or SSH transport crates, in
# the core's own tree and in the allowlist. The domain closure past these names is a review gate.
test_no_transport_or_libgit2_crate() {
  # An absent allowlist names nothing, which would pass every check below for the wrong reason.
  [ -f "$ALLOWLIST" ] || fail "checks/deps.allow does not exist" || return 1
  core_tree="$("$REAL_CARGO" tree -p nozoki-core --locked --offline --prefix none 2>&1)" \
    || fail "cargo tree on nozoki-core failed: $core_tree" || return 1
  for name in git2 libgit2-sys openssl-sys native-tls rustls libssh2-sys; do
    if printf '%s\n' "$core_tree" | grep -q "^$name "; then
      fail "the nozoki-core tree holds $name" || return 1
    fi
    if file_has_line "$name" "$ALLOWLIST"; then
      fail "checks/deps.allow names $name" || return 1
    fi
  done
}

# CP-52, the runnable half: `log` is named, and no second facade or third-party writer is.
test_log_is_the_only_logging_facade() {
  [ -f "$ALLOWLIST" ] || fail "checks/deps.allow does not exist" || return 1
  file_has_line log "$ALLOWLIST" || fail "checks/deps.allow does not name log" || return 1
  for name in tracing slog log4rs env_logger fern simplelog; do
    if file_has_line "$name" "$ALLOWLIST"; then
      fail "checks/deps.allow names $name" || return 1
    fi
  done
}

# CP-52, CP-47: the log writer swapped for env_logger fails on the new name.
test_swapped_log_writer_fails() {
  mkdir -p "$WORK/stubs-swapped"
  cargo_edited_by "$WORK/stubs-swapped" 's/^log v.*/env_logger v0.11.0/'

  run_with_stubs "$WORK/stubs-swapped"

  expect_nonzero_status || return 1
  expect_output_contains "cargo: env_logger"
}

# Added by the plan: blank lines and comments in checks/deps.allow enter neither compared set — a comment
# that reads like a name must not become one.
test_comments_and_blank_lines_are_ignored() {
  awk '{ print; print ""; print "# a-comment-that-reads-like-a-name" }' "$ALLOWLIST" > "$WORK/noisy.allow"

  OUT="$(NO_NETWORK_ALLOW_FILE="$WORK/noisy.allow" "$NO_NETWORK_SH" 2>&1)"
  STATUS=$?

  expect_zero_status
}

# Added by the plan: the two sections are compared independently, so a crate name and an npm package
# name cannot mask one another. Checked in both directions on tiny canned trees.
test_a_cargo_section_name_does_not_satisfy_the_pnpm_section() {
  mkdir -p "$WORK/stubs-sections"
  make_stub "$WORK/stubs-sections" cargo 'printf "shared v1.0.0\ncargo-only v1.0.0\n"'
  make_stub "$WORK/stubs-sections" pnpm 'cat <<JSON
[
  {
    "name": "nozoki-ui",
    "dependencies": {
      "shared": {
        "from": "shared",
        "version": "1.0.0"
      }
    }
  }
]
JSON'

  # `shared` is allowed under cargo only; the pnpm tree holds it too.
  printf 'cargo:\ncargo-only\nshared\npnpm:\n' > "$WORK/cargo-only.allow"
  OUT="$(PATH="$WORK/stubs-sections:$PATH" NO_NETWORK_ALLOW_FILE="$WORK/cargo-only.allow" "$NO_NETWORK_SH" 2>&1)"
  STATUS=$?
  expect_nonzero_status || return 1
  expect_output_contains "pnpm: shared" || return 1
  expect_output_contains "in the tree and not in checks/deps.allow" || return 1

  # The reverse: `cargo-only` is allowed under pnpm as well, and the cargo tree holds it, while cargo:
  # does not list it.
  printf 'cargo:\nshared\npnpm:\ncargo-only\nshared\n' > "$WORK/pnpm-only.allow"
  OUT="$(PATH="$WORK/stubs-sections:$PATH" NO_NETWORK_ALLOW_FILE="$WORK/pnpm-only.allow" "$NO_NETWORK_SH" 2>&1)"
  STATUS=$?
  expect_nonzero_status || return 1
  expect_output_contains "cargo: cargo-only" || return 1
  expect_output_contains "pnpm: cargo-only"
}

# --- the runner ---

WORK="$(mktemp -d)"
cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

failed=0
for case_name in $CASES; do
  if [ -n "${NOZOKI_TEST_ONLY:-}" ] && [ "$case_name" != "$NOZOKI_TEST_ONLY" ]; then
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
  echo "test_no_network.sh: $failed case(s) failed" >&2
  exit 1
fi

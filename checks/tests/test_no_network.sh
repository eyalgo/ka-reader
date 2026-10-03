#!/usr/bin/env bash
# Version: 1.2.0 — git-reader probes the root — libgit2 bound behind the Git port, six fixture scenes
# Version: 1.1.0 — the Tauri build leaves — native bundle assembled, bundle.sh and no-network.sh read it, CI builds it, boundaries and README pinned
# Version: 1.0.0 — first version: drives the real checks/no-network.sh against the real tree and against stubbed ones
#
# checks/tests/test_no_network.sh — the tests of checks/no-network.sh and checks/deps.allow.
#
# WHY THIS EXISTS
#   checks/no-network.sh is the review gate on what the product is built from: a name in the tree that
#   nobody put in checks/deps.allow fails the build. A bug in it is a tree nobody is reviewing. These
#   cases run the real script — never a copy of its logic — against the real tree and against stubbed
#   ones, with `cargo`, `swift`, `pnpm` (only as a guard that is never called) and `uname` stubbed on
#   PATH. A stub that must keep the real tree's shape runs the real tool and edits its output, so this
#   suite never lists the tree's names by hand. Every case but the real-tree pass stubs `swift` and
#   points the Swift package at a work directory, so no case depends on the machine's toolchain.
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
test_pnpm_section_is_refused_as_malformed
test_verdict_is_unchanged_on_an_x64_machine
test_binding_has_no_https_or_ssh_transport
test_log_is_the_only_logging_facade
test_swapped_log_writer_fails
test_comments_and_blank_lines_are_ignored
test_declared_dependency_fails
test_declared_dependency_names_the_default_manifest
test_remote_binary_target_fails
test_local_binary_target_is_admitted
test_swift_that_fails_is_refused
test_swift_absent_is_refused
test_unreadable_dump_is_refused
test_package_resolved_at_the_package_root_fails
test_package_resolved_nested_deep_fails
test_local_binary_target_with_a_null_url_is_admitted
test_each_package_resolved_is_named
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
  OUT="$(PATH="$stubs:$PATH" NO_NETWORK_SWIFT_PACKAGE_DIR="$WORK/pkg-clean" "$NO_NETWORK_SH" "$@" 2>&1)"
  STATUS=$?
}

# `swift` that answers every call with the manifest dump in file $2 and does nothing else.
swift_stub() {
  make_stub "$1" swift "cat \"$2\""
}

# A stub directory holding a `swift` whose dump declares nothing.
clean_swift_stubs() {
  mkdir -p "$1"
  swift_stub "$1" "$WORK/dump-clean.json"
}

# Runs the script with the stubs directory $1 ahead on PATH and the Swift package at directory $2.
run_swift_case() {
  OUT="$(PATH="$1:$PATH" NO_NETWORK_SWIFT_PACKAGE_DIR="$2" "$NO_NETWORK_SH" 2>&1)"
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

# CP-47, CP-126, CP-127, D2-1: on the real tree, with the real `swift`, the cargo names equal their
# section and the Swift package declares nothing. One line of output names counts only, and `pnpm` —
# stubbed only as a guard — was never called.
test_clean_tree_passes() {
  mkdir -p "$WORK/stubs-clean"
  make_stub "$WORK/stubs-clean" pnpm "echo called >> \"$WORK/pnpm-calls\""

  OUT="$(PATH="$WORK/stubs-clean:$PATH" "$NO_NETWORK_SH" 2>&1)"
  STATUS=$?

  expect_zero_status || return 1
  [ "$(printf '%s\n' "$OUT" | wc -l | tr -d ' ')" -eq 1 ] || fail "expected one line of output, got: $OUT" || return 1
  case "$OUT" in
    "no-network.sh: ok — "*) ;;
    *) fail "the passing line is not the one that names counts only. output: $OUT" || return 1 ;;
  esac
  [ ! -e "$WORK/pnpm-calls" ] || fail "pnpm was called"
}

# CP-47, CP-48: a name in the tree with no allowlist line is named, with its section and its side.
test_crate_not_in_the_allowlist_fails() {
  clean_swift_stubs "$WORK/stubs-added"
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
  clean_swift_stubs "$WORK/stubs-removed"
  cargo_edited_by "$WORK/stubs-removed" '/^itoa v/d'

  run_with_stubs "$WORK/stubs-removed"

  expect_nonzero_status || return 1
  expect_output_contains "cargo: itoa" || return 1
  expect_output_contains "in checks/deps.allow and not in the tree"
}

# CP-126, D2-2: the allowlist admits one section. A `pnpm:` section goes down the unknown-section path:
# the file is called malformed and the section is named.
test_pnpm_section_is_refused_as_malformed() {
  printf 'cargo:\nitoa\npnpm:\nleft-pad\n' > "$WORK/with-pnpm.allow"

  OUT="$(NO_NETWORK_ALLOW_FILE="$WORK/with-pnpm.allow" "$NO_NETWORK_SH" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_output_contains "is malformed" || return 1
  expect_output_contains "unknown section: pnpm"
}

# CP-50: the compared set does not depend on the running CPU. Held by construction — the cargo half names
# both Apple-Darwin triples itself rather than taking the host's — so the case checks both halves of that:
# the verdict under a stubbed `uname`, and the triples on the command line.
test_verdict_is_unchanged_on_an_x64_machine() {
  clean_swift_stubs "$WORK/stubs-x64"
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

# CP-485, CP-490 (the runnable half of CP-51's successor): the libgit2 binding is admitted, with its HTTPS
# and SSH features off and libgit2 vendored, and none of the named TLS or SSH transport crates is in the
# core's tree or the allowlist. The domain closure past these names is a review gate (checks/deps.review.md).
# An inverse tree that cannot be read is a failure, never evidence that no feature resolved.
test_binding_has_no_https_or_ssh_transport() {
  # An absent allowlist names nothing, which would pass every check below for the wrong reason.
  [ -f "$ALLOWLIST" ] || fail "checks/deps.allow does not exist" || return 1
  core_tree="$("$REAL_CARGO" tree -p nozoki-core --locked --offline --prefix none 2>&1)" \
    || fail "cargo tree on nozoki-core failed: $core_tree" || return 1
  for name in openssl-sys native-tls rustls libssh2-sys; do
    if printf '%s\n' "$core_tree" | grep -q "^$name "; then
      fail "the nozoki-core tree holds $name" || return 1
    fi
    if file_has_line "$name" "$ALLOWLIST"; then
      fail "checks/deps.allow names $name" || return 1
    fi
  done

  for target in aarch64-apple-darwin x86_64-apple-darwin; do
    for crate in git2 libgit2-sys; do
      inverse="$("$REAL_CARGO" tree --locked --offline --target "$target" -e features -i "$crate" 2>&1)" \
        || fail "the $crate inverse feature tree on $target is unreadable: $inverse" || return 1
      if printf '%s\n' "$inverse" | grep -Eq 'feature "(https|ssh)"'; then
        fail "$crate resolves an https or ssh feature on $target: $inverse" || return 1
      fi
    done
    inverse="$("$REAL_CARGO" tree --locked --offline --target "$target" -e features -i git2 2>&1)"
    printf '%s\n' "$inverse" | grep -q 'feature "vendored-libgit2"' \
      || fail "git2 does not resolve vendored-libgit2 on $target: $inverse" || return 1
    inverse="$("$REAL_CARGO" tree --locked --offline --target "$target" -e features -i libgit2-sys 2>&1)"
    printf '%s\n' "$inverse" | grep -q 'feature "vendored"' \
      || fail "libgit2-sys does not resolve vendored on $target: $inverse" || return 1
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
  clean_swift_stubs "$WORK/stubs-swapped"
  cargo_edited_by "$WORK/stubs-swapped" 's/^log v.*/env_logger v0.11.0/'

  run_with_stubs "$WORK/stubs-swapped"

  expect_nonzero_status || return 1
  expect_output_contains "cargo: env_logger"
}

# Added by the plan: blank lines and comments in checks/deps.allow enter neither compared set — a comment
# that reads like a name must not become one.
test_comments_and_blank_lines_are_ignored() {
  awk '{ print; print ""; print "# a-comment-that-reads-like-a-name" }' "$ALLOWLIST" > "$WORK/noisy.allow"

  clean_swift_stubs "$WORK/stubs-noisy"

  OUT="$(PATH="$WORK/stubs-noisy:$PATH" NO_NETWORK_SWIFT_PACKAGE_DIR="$WORK/pkg-clean" NO_NETWORK_ALLOW_FILE="$WORK/noisy.allow" "$NO_NETWORK_SH" 2>&1)"
  STATUS=$?

  expect_zero_status
}

# --- the Swift half (CP-127) ---

# D2-4: a dependency in the manifest's dump fails the run, naming the manifest of the directory the
# override points at.
test_declared_dependency_fails() {
  clean_swift_stubs "$WORK/stubs-dep"
  swift_stub "$WORK/stubs-dep" "$WORK/dump-dependency.json"

  run_swift_case "$WORK/stubs-dep" "$WORK/pkg-clean"

  expect_nonzero_status || return 1
  expect_output_contains "$WORK/pkg-clean/Package.swift"
}

# CP-127 names `nozoki-mac/Package.swift`. Under an override the case above names the override's, so this
# one runs with no override and holds the default wording.
test_declared_dependency_names_the_default_manifest() {
  clean_swift_stubs "$WORK/stubs-dep-default"
  swift_stub "$WORK/stubs-dep-default" "$WORK/dump-dependency.json"

  OUT="$(PATH="$WORK/stubs-dep-default:$PATH" "$NO_NETWORK_SH" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_output_contains "nozoki-mac/Package.swift" || return 1
  case "$OUT" in
    *"$ROOT/nozoki-mac/Package.swift"*) fail "the default manifest is named by an absolute path. output: $OUT" ;;
  esac
}

# D2-5: a remote binary target declares a download the `dependencies` array does not show.
test_remote_binary_target_fails() {
  clean_swift_stubs "$WORK/stubs-remote"
  swift_stub "$WORK/stubs-remote" "$WORK/dump-remote-binary.json"

  run_swift_case "$WORK/stubs-remote" "$WORK/pkg-clean"

  expect_nonzero_status || return 1
  expect_output_contains "$WORK/pkg-clean/Package.swift"
}

# A binary target over a local artifact bundle (a path, no url) downloads nothing and stays admitted; a
# check that refused every binary target would pass every case above.
test_local_binary_target_is_admitted() {
  clean_swift_stubs "$WORK/stubs-local"
  swift_stub "$WORK/stubs-local" "$WORK/dump-local-binary.json"

  run_swift_case "$WORK/stubs-local" "$WORK/pkg-clean"

  expect_zero_status
}

# D2-6: what the manifest declares could not be read, so the run is red and never passes.
test_swift_that_fails_is_refused() {
  mkdir -p "$WORK/stubs-swift-fails"
  make_stub "$WORK/stubs-swift-fails" swift 'echo "swift: stubbed failure" >&2; exit 1'

  run_swift_case "$WORK/stubs-swift-fails" "$WORK/pkg-clean"

  expect_nonzero_status || return 1
  case "$OUT" in
    *"no-network.sh: ok"*) fail "the run passed with a swift that failed. output: $OUT" ;;
  esac
}

# D2-6: `swift` absent. PATH is built from links to the tools the script calls, so `swift` — which sits
# in /usr/bin beside awk, sort and comm — is the one thing missing.
test_swift_absent_is_refused() {
  tools="$WORK/tools-without-swift"
  mkdir -p "$tools"
  for tool in awk basename bash cat cut dirname env find grep head ls mktemp plutil rm sed sh sort tail tr uname wc xargs comm; do
    found="$(command -v "$tool" 2> /dev/null)" || continue
    ln -sf "$found" "$tools/$tool"
  done
  limited_path="$tools:$(dirname "$REAL_CARGO")"
  [ -z "$(PATH="$limited_path" command -v swift 2> /dev/null)" ] || fail "the limited PATH still finds swift" || return 1

  OUT="$(PATH="$limited_path" NO_NETWORK_SWIFT_PACKAGE_DIR="$WORK/pkg-clean" "$NO_NETWORK_SH" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  case "$OUT" in
    *"no-network.sh: ok"*) fail "the run passed with no swift. output: $OUT" ;;
  esac
}

# D2-6: a dump that cannot be read is not an empty one.
test_unreadable_dump_is_refused() {
  mkdir -p "$WORK/stubs-unreadable"
  make_stub "$WORK/stubs-unreadable" swift 'echo "this is not a manifest dump"'

  run_swift_case "$WORK/stubs-unreadable" "$WORK/pkg-clean"

  expect_nonzero_status || return 1
  case "$OUT" in
    *"no-network.sh: ok"*) fail "the run passed on a dump it could not read. output: $OUT" ;;
  esac
}

# D2-7: a resolution file at the package root, named by its path.
test_package_resolved_at_the_package_root_fails() {
  clean_swift_stubs "$WORK/stubs-resolved-root"
  mkdir -p "$WORK/pkg-resolved-root"
  echo '{}' > "$WORK/pkg-resolved-root/Package.resolved"

  run_swift_case "$WORK/stubs-resolved-root" "$WORK/pkg-resolved-root"

  expect_nonzero_status || return 1
  expect_output_contains "$WORK/pkg-resolved-root/Package.resolved"
}

# D2-7: at any depth.
test_package_resolved_nested_deep_fails() {
  clean_swift_stubs "$WORK/stubs-resolved-deep"
  mkdir -p "$WORK/pkg-resolved-deep/a/b"
  echo '{}' > "$WORK/pkg-resolved-deep/a/b/Package.resolved"

  run_swift_case "$WORK/stubs-resolved-deep" "$WORK/pkg-resolved-deep"

  expect_nonzero_status || return 1
  expect_output_contains "$WORK/pkg-resolved-deep/a/b/Package.resolved"
}

# --- added by the code-integrity review ---

# A local binary target is admitted because it carries no url (change_design.md § Architect Review Notes;
# tl_instruction.md, Task 2, "a path and no url exits 0"). A dump that writes the absent url as an explicit
# JSON null carries no url either, and is the same admitted target.
test_local_binary_target_with_a_null_url_is_admitted() {
  clean_swift_stubs "$WORK/stubs-null-url"
  swift_stub "$WORK/stubs-null-url" "$WORK/dump-local-binary-null-url.json"

  run_swift_case "$WORK/stubs-null-url" "$WORK/pkg-clean"

  expect_zero_status
}

# CP-127, D2-7: each Package.resolved is named — a script that named only the first would pass the two
# cases above.
test_each_package_resolved_is_named() {
  clean_swift_stubs "$WORK/stubs-resolved-each"
  mkdir -p "$WORK/pkg-resolved-each/a/b"
  echo '{}' > "$WORK/pkg-resolved-each/Package.resolved"
  echo '{}' > "$WORK/pkg-resolved-each/a/b/Package.resolved"

  run_swift_case "$WORK/stubs-resolved-each" "$WORK/pkg-resolved-each"

  expect_nonzero_status || return 1
  expect_output_contains "$WORK/pkg-resolved-each/Package.resolved —" || return 1
  expect_output_contains "$WORK/pkg-resolved-each/a/b/Package.resolved"
}

# --- the runner ---

WORK="$(mktemp -d)"
cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

# The manifest dumps the `swift` stubs answer with, and the package directory a case points the script at.
mkdir -p "$WORK/pkg-clean"
echo '{"dependencies":[],"targets":[{"name":"Nozoki","type":"executable"}]}' > "$WORK/dump-clean.json"
echo '{"dependencies":[{"sourceControl":[{"identity":"left-pad","location":{"remote":[{"urlString":"https://example.invalid/left-pad.git"}]}}]}],"targets":[{"name":"Nozoki","type":"executable"}]}' > "$WORK/dump-dependency.json"
echo '{"dependencies":[],"targets":[{"name":"Nozoki","type":"executable"},{"name":"Blob","type":"binary","url":"https://example.invalid/Blob.zip"}]}' > "$WORK/dump-remote-binary.json"
echo '{"dependencies":[],"targets":[{"name":"Nozoki","type":"executable"},{"name":"Blob","type":"binary","path":"Blob.artifactbundle"}]}' > "$WORK/dump-local-binary.json"
echo '{"dependencies":[],"targets":[{"name":"Nozoki","type":"executable"},{"name":"Blob","type":"binary","path":"Blob.artifactbundle","url":null}]}' > "$WORK/dump-local-binary-null-url.json"

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

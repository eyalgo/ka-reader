#!/usr/bin/env bash
# Version: 1.3.0 — test_system_target_fails: a Swift target of type system is refused, and
#   nothing else is
# Version: 1.2.0 — git-reader probes the root — libgit2 bound behind
#   the Git port, six fixture scenes
# Version: 1.1.0 — the Tauri build leaves — native bundle assembled, bundle.sh and no-network.sh
#   read it, CI builds it, boundaries and README pinned
# Version: 1.0.0 — first version: drives the real checks/no-network.sh against the
#   real tree and against stubbed ones
#
# checks/tests/test_no_network.sh — the tests of checks/no-network.sh and checks/deps.allow.
#
# WHY THIS EXISTS
#   checks/no-network.sh is the review gate on what the product is built from: a name in the tree
#   that nobody put in checks/deps.allow fails the build. A bug in it is a tree nobody is reviewing.
#   These cases run the real script — never a copy of its logic — against the real tree and against
#   stubbed ones, with `cargo`, `swift`, `pnpm` (only as a guard that is never called) and `uname`
#   stubbed on PATH. A stub that must keep the real tree's shape runs the real tool and edits its
#   output, so this suite never lists the tree's names by hand. Every case but the real-tree pass
#   stubs `swift` and points the Swift package at a work directory, so no case depends on the
#   machine's toolchain. The runner is this file: the product has no Python (docs/nfdr.md § 9 names
#   its toolchains), which is why the shell packet's pytest runner is not used here.
#
# USAGE
#   checks/tests/test_no_network.sh
#     KA_READER_TEST_ONLY=<case> runs one case.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

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
test_system_target_fails
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

# CP-126, D2-2: the allowlist admits one section. A `pnpm:` section goes down the unknown-section
# path: the file is called malformed and the section is named.
test_pnpm_section_is_refused_as_malformed() {
  printf 'cargo:\nitoa\npnpm:\nleft-pad\n' > "$WORK/with-pnpm.allow"

  OUT="$(NO_NETWORK_ALLOW_FILE="$WORK/with-pnpm.allow" "$NO_NETWORK_SH" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_output_contains "is malformed" || return 1
  expect_output_contains "unknown section: pnpm"
}

# CP-50: the compared set does not depend on the running CPU. Held by construction — the cargo half
# names both Apple-Darwin triples itself rather than taking the host's — so the case checks both
# halves of that: the verdict under a stubbed `uname`, and the triples on the command line.
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

# CP-485, CP-490 (the runnable half of CP-51's successor): the libgit2 binding is admitted, with its
# HTTPS and SSH features off and libgit2 vendored, and none of the named TLS or SSH transport crates
# is in the core's tree or the allowlist. The domain closure past these names is a review gate
# (checks/deps.review.md). An inverse tree that cannot be read is a failure, never
# evidence that no feature resolved.
test_binding_has_no_https_or_ssh_transport() {
  # An absent allowlist names nothing, which would pass every check below for the wrong reason.
  [ -f "$ALLOWLIST" ] || fail "checks/deps.allow does not exist" || return 1
  core_tree="$("$REAL_CARGO" tree -p ka-reader-core --locked --offline --prefix none 2>&1)" \
    || fail "cargo tree on ka-reader-core failed: $core_tree" || return 1
  for name in openssl-sys native-tls rustls libssh2-sys; do
    if printf '%s\n' "$core_tree" | grep -q "^$name "; then
      fail "the ka-reader-core tree holds $name" || return 1
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

# Added by the plan: blank lines and comments in checks/deps.allow enter neither compared set — a
# comment that reads like a name must not become one.
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

# CP-127 names `ka-reader-mac/Package.swift`. Under an override the case above names the override's,
# so this one runs with no override and holds the default wording.
test_declared_dependency_names_the_default_manifest() {
  clean_swift_stubs "$WORK/stubs-dep-default"
  swift_stub "$WORK/stubs-dep-default" "$WORK/dump-dependency.json"

  OUT="$(PATH="$WORK/stubs-dep-default:$PATH" "$NO_NETWORK_SH" 2>&1)"
  STATUS=$?

  expect_nonzero_status || return 1
  expect_output_contains "ka-reader-mac/Package.swift" || return 1
  case "$OUT" in
    *"$ROOT/ka-reader-mac/Package.swift"*) fail "the default manifest is named by an absolute path. output: $OUT" ;;
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

# A binary target over a local artifact bundle (a path, no url) downloads nothing and stays
# admitted; a check that refused every binary target would pass every case above.
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

# D2-6: `swift` absent. PATH is built from links to the tools the script calls, so `swift` — which
# sits in /usr/bin beside awk, sort and comm — is the one thing missing.
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

# A local binary target is admitted because it carries no url (change_design.md § Architect Review
# Notes; tl_instruction.md, Task 2, "a path and no url exits 0"). A dump that writes the absent url
# as an explicit JSON null carries no url either, and is the same admitted target.
test_local_binary_target_with_a_null_url_is_admitted() {
  clean_swift_stubs "$WORK/stubs-null-url"
  swift_stub "$WORK/stubs-null-url" "$WORK/dump-local-binary-null-url.json"

  run_swift_case "$WORK/stubs-null-url" "$WORK/pkg-clean"

  expect_zero_status
}

# CP-127, D2-7: each Package.resolved is named — a script that named only the first would pass the
# two cases above.
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

# --- the system-target refusal (CP-876 to CP-884) ---

SYSTEM_PHRASE="is of type system"
SYSTEM_CLOSING_LINE="no-network.sh: the dependencies differ from checks/deps.allow, or the Swift package declares or resolves one"
# The one dump the `swift` stub of the system-target case answers with. Each run rewrites it.
SYSTEM_DUMP=""
STDOUT=""
ERR=""

# The dump in file $1 with the target text $2 (a leading comma) added after its last target, written
# to the dump the system-target runs read. Fails when the edit did not land, so a run cannot pass
# over the unedited dump it was copied from.
system_dump_from() {
  sed "s|\"type\":\"executable\"}\]|\"type\":\"executable\"}$2]|" "$1" > "$SYSTEM_DUMP"
  grep -qF -- "$2]" "$SYSTEM_DUMP" || fail "the target was not added to the dump: $2. dump: $(cat "$SYSTEM_DUMP")"
}

# Runs the script with stub directory $1 ahead on PATH and the Swift package at directory $2
# ('' leaves the override unset). Keeps stdout and stderr apart, and together in OUT.
run_system_case() {
  if [ -n "$2" ]; then
    STDOUT="$(PATH="$1:$PATH" NO_NETWORK_SWIFT_PACKAGE_DIR="$2" "$NO_NETWORK_SH" 2> "$WORK/system-stderr" < /dev/null)"
  else
    STDOUT="$(PATH="$1:$PATH" "$NO_NETWORK_SH" 2> "$WORK/system-stderr" < /dev/null)"
  fi
  STATUS=$?
  ERR="$(cat "$WORK/system-stderr")"
  OUT="$STDOUT
$ERR"
}

expect_line_once_on_stderr() {
  count="$(printf '%s\n' "$ERR" | grep -cxF -- "$1" || true)"
  [ "$count" = 1 ] || fail "expected stderr to hold this line once, found it $count times: $1. stderr: $ERR"
}

# One complete refusal line for each name in $2 onward, naming manifest $1, and no other line that
# carries the finding.
expect_system_refusals() {
  manifest="$1"
  shift
  expected_total="$#"
  first_line=""
  for target_name in "$@"; do
    refusal="swift: $manifest — target $target_name $SYSTEM_PHRASE, a library the dependencies array does not show"
    [ -n "$first_line" ] || first_line="$refusal"
    expect_line_once_on_stderr "$refusal" || return 1
  done
  total="$(printf '%s\n' "$ERR" | grep -cF -- "$SYSTEM_PHRASE" || true)"
  [ "$total" -eq "$expected_total" ] || fail "expected stderr to hold this line once, found it $total times: $first_line. stderr: $ERR"
}

expect_closing_line_last() {
  [ "$(printf '%s\n' "$ERR" | tail -n 1)" = "$SYSTEM_CLOSING_LINE" ] \
    || fail "expected the last line on stderr to be: $SYSTEM_CLOSING_LINE. stderr: $ERR"
}

expect_no_ok_line() {
  case "$STDOUT" in
    *"no-network.sh: ok"*) fail "the ok line was printed with a target of type system in the dump. output: $OUT" ;;
  esac
}

# The dump in SYSTEM_DUMP is admitted: exit 0, the ok line, and no system finding.
expect_dump_admitted() {
  expect_zero_status || return 1
  case "$STDOUT" in
    "no-network.sh: ok — "*) ;;
    *) fail "expected the ok line for this dump: $(cat "$SYSTEM_DUMP"). output: $OUT" || return 1 ;;
  esac
  case "$OUT" in
    *"$SYSTEM_PHRASE"*) fail "expected no line for a target of type system for this dump: $(cat "$SYSTEM_DUMP"). output: $OUT" ;;
  esac
}

# CP-876 to CP-884: a target whose dump `type` is exactly the string `system` is refused, by name,
# beside every other finding; no other target is. The runs below are separate dumps of one case.
test_system_target_fails() {
  SYSTEM_DUMP="$WORK/dump-system.json"
  stubs="$WORK/stubs-system"
  mkdir -p "$stubs"
  swift_stub "$stubs" "$SYSTEM_DUMP"
  override_manifest="$WORK/pkg-clean/Package.swift"
  system_target=',{"name":"CSys","type":"system"}'

  # The isolated refusal: the clean dump plus one system target and nothing else.
  system_dump_from "$WORK/dump-clean.json" "$system_target" || return 1
  run_system_case "$stubs" "$WORK/pkg-clean"
  expect_nonzero_status || return 1
  expect_system_refusals "$override_manifest" CSys || return 1
  expect_no_ok_line || return 1
  expect_closing_line_last || return 1

  # The default manifest spelling, relative, with no product-root prefix.
  run_system_case "$stubs" ""
  expect_nonzero_status || return 1
  expect_system_refusals "ka-reader-mac/Package.swift" CSys || return 1
  case "$ERR" in
    *"$ROOT/ka-reader-mac/Package.swift"*) fail "the default manifest is named by an absolute path. output: $OUT" || return 1 ;;
  esac

  # Several system targets: one line for each, none duplicated.
  system_dump_from "$WORK/dump-clean.json" "$system_target"',{"name":"CZlib","type":"system"}' || return 1
  run_system_case "$stubs" "$WORK/pkg-clean"
  expect_nonzero_status || return 1
  expect_system_refusals "$override_manifest" CSys CZlib || return 1

  # A system target that also carries a url, at index 1: the index-based url line and the name-based
  # system line, each once.
  system_dump_from "$WORK/dump-clean.json" ',{"name":"CSys","type":"system","url":"https://example.invalid/CSys.zip"}' || return 1
  run_system_case "$stubs" "$WORK/pkg-clean"
  expect_nonzero_status || return 1
  expect_system_refusals "$override_manifest" CSys || return 1
  expect_line_once_on_stderr "swift: $override_manifest — target 1 carries a url, a download the dependencies array does not show" || return 1

  # Co-findings survive: a declared dependency, a cargo name added and one removed, and a
  # Package.resolved at the package root and a nested path.
  stubs_all="$WORK/stubs-system-all"
  mkdir -p "$stubs_all" "$WORK/pkg-system-all/a/b"
  swift_stub "$stubs_all" "$SYSTEM_DUMP"
  cargo_edited_by "$stubs_all" '/^itoa v/d
$a\
left-pad-rs v1.0.0
'
  echo '{}' > "$WORK/pkg-system-all/Package.resolved"
  echo '{}' > "$WORK/pkg-system-all/a/b/Package.resolved"
  system_dump_from "$WORK/dump-dependency.json" "$system_target" || return 1
  run_system_case "$stubs_all" "$WORK/pkg-system-all"
  all_manifest="$WORK/pkg-system-all/Package.swift"
  expect_nonzero_status || return 1
  expect_system_refusals "$all_manifest" CSys || return 1
  expect_line_once_on_stderr "cargo: left-pad-rs — in the tree and not in checks/deps.allow" || return 1
  expect_line_once_on_stderr "cargo: itoa — in checks/deps.allow and not in the tree" || return 1
  expect_line_once_on_stderr "swift: $all_manifest — declares a dependency" || return 1
  expect_line_once_on_stderr "swift: $WORK/pkg-system-all/Package.resolved — a Package.resolved, and a package with no dependency has none" || return 1
  expect_line_once_on_stderr "swift: $WORK/pkg-system-all/a/b/Package.resolved — a Package.resolved, and a package with no dependency has none" || return 1
  expect_no_ok_line || return 1
  expect_closing_line_last || return 1

  # The admitted class: every other target, and a dump that leaves the new extraction nothing to
  # read.
  while IFS= read -r extra_target; do
    system_dump_from "$WORK/dump-clean.json" "$extra_target" || return 1
    run_system_case "$stubs" "$WORK/pkg-clean"
    expect_dump_admitted || return 1
  done <<'TARGETS'
,{"name":"T","type":"regular"}
,{"name":"T","type":"executable"}
,{"name":"T","type":"test"}
,{"name":"T","type":"binary","path":"T.artifactbundle"}
,{"name":"T","type":"binary","path":"T.artifactbundle","url":null}
,{"name":"T","type":"plugin"}
,{"name":"T","type":"macro"}
,{"name":"T","type":"System"}
,{"name":"T","type":"other"}
,{"name":"T","type":"systemLibrary"}
,{"name":"T","type":"notsystem"}
,{"name":"T","type":"system "}
,{"name":"T"}
,{"name":"T","type":null}
,{"name":"T","type":1}
,{"name":"T","type":true}
,{"name":"T","type":["system"]}
,{"name":"T","type":{"system":true}}
TARGETS
  sed 's|"targets":\[.*\]|"targets":[]|' "$WORK/dump-clean.json" > "$SYSTEM_DUMP"
  grep -qF '"targets":[]}' "$SYSTEM_DUMP" || fail "the targets were not emptied: $(cat "$SYSTEM_DUMP")" || return 1
  run_system_case "$stubs" "$WORK/pkg-clean"
  expect_dump_admitted || return 1

  # The only system target, first and then last: found wherever it sits.
  sed 's|"targets":\[|"targets":[{"name":"CSys","type":"system"},|' "$WORK/dump-clean.json" > "$SYSTEM_DUMP"
  grep -qF '"targets":[{"name":"CSys","type":"system"},{' "$SYSTEM_DUMP" \
    || fail "the system target was not placed first: $(cat "$SYSTEM_DUMP")" || return 1
  run_system_case "$stubs" "$WORK/pkg-clean"
  expect_nonzero_status || return 1
  expect_system_refusals "$override_manifest" CSys || return 1
  system_dump_from "$WORK/dump-clean.json" "$system_target" || return 1
  run_system_case "$stubs" "$WORK/pkg-clean"
  expect_nonzero_status || return 1
  expect_system_refusals "$override_manifest" CSys || return 1

  # A system target with an explicit null url is refused by the system line alone.
  system_dump_from "$WORK/dump-clean.json" ',{"name":"CSys","type":"system","url":null}' || return 1
  run_system_case "$stubs" "$WORK/pkg-clean"
  expect_nonzero_status || return 1
  expect_system_refusals "$override_manifest" CSys || return 1
  case "$ERR" in
    *"carries a url"*) fail "expected no line for a url for this dump: $(cat "$SYSTEM_DUMP"). output: $OUT" || return 1 ;;
  esac

  # A remote binary target with no system target: the url line alone, as before.
  cp "$WORK/dump-remote-binary.json" "$SYSTEM_DUMP"
  run_system_case "$stubs" "$WORK/pkg-clean"
  expect_nonzero_status || return 1
  expect_line_once_on_stderr "swift: $override_manifest — target 1 carries a url, a download the dependencies array does not show" || return 1
  case "$OUT" in
    *"$SYSTEM_PHRASE"*) fail "expected no line for a target of type system for this dump: $(cat "$SYSTEM_DUMP"). output: $OUT" ;;
  esac
}

# --- the runner ---

WORK="$(mktemp -d)"
cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

# The manifest dumps the `swift` stubs answer with, and the package
# directory a case points the script at.
mkdir -p "$WORK/pkg-clean"
echo '{"dependencies":[],"targets":[{"name":"KAReader","type":"executable"}]}' > "$WORK/dump-clean.json"
echo '{"dependencies":[{"sourceControl":[{"identity":"left-pad","location":{"remote":[{"urlString":"https://example.invalid/left-pad.git"}]}}]}],"targets":[{"name":"KAReader","type":"executable"}]}' > "$WORK/dump-dependency.json"
echo '{"dependencies":[],"targets":[{"name":"KAReader","type":"executable"},{"name":"Blob","type":"binary","url":"https://example.invalid/Blob.zip"}]}' > "$WORK/dump-remote-binary.json"
echo '{"dependencies":[],"targets":[{"name":"KAReader","type":"executable"},{"name":"Blob","type":"binary","path":"Blob.artifactbundle"}]}' > "$WORK/dump-local-binary.json"
echo '{"dependencies":[],"targets":[{"name":"KAReader","type":"executable"},{"name":"Blob","type":"binary","path":"Blob.artifactbundle","url":null}]}' > "$WORK/dump-local-binary-null-url.json"

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
  echo "test_no_network.sh: $failed case(s) failed" >&2
  exit 1
fi

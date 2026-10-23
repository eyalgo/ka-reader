#!/usr/bin/env bash
# Version: 1.2.0 — a Swift target of type system is refused, by name: a library the dependencies
#   array does not show
# Version: 1.1.0 — the Tauri build leaves — native bundle assembled, bundle.sh and no-network.sh
#   read it, CI builds it, boundaries and README pinned
# Version: 1.0.0 — first version: both dependency trees compared, by name, against
#   the reviewed checks/deps.allow
#
# checks/no-network.sh — proves the product is built from nothing nobody reviewed.
#
# WHY THIS EXISTS
#   The product promises it never reaches the network (docs/SDD.md § 4 C-R6, C-I3; NFDR QC-3,
#   QC-26). What it is built from is what could break that promise. The Rust half is compared by
#   name: the names `cargo tree` reports against checks/deps.allow, the one list a reviewer has
#   read. A name in the tree that the list does not hold fails; so does a name on the list that the
#   tree no longer holds, so the list cannot go stale unnoticed. The Swift half is a claim of none:
#   the package declares no dependency, no target is a system library, and no resolution file
#   exists, so there is nothing to review.
#
# USAGE
#   checks/no-network.sh
#   Exit 0 when the cargo name set equals the `cargo:` section of checks/deps.allow and the Swift
#   package declares no dependency, has no target of type system and holds no Package.resolved,
#   printing one line that names counts and no dependency. Otherwise non-zero, naming each differing
#   cargo name and its side, and the Swift manifest, the system target or the Package.resolved path
#   at fault.
#
# THE CARGO SET DOES NOT DEPEND ON THE MACHINE
#   Both Apple-Darwin triples are named on the command line, so the set is the union Cargo.lock
#   fixes and not whatever the running CPU resolves (CP-50, by construction). It is a superset of
#   what the bundle contains (dev and build dependencies), which is the reading under which both
#   C-R6 and QC-26 hold.
#
# THE SWIFT HALF READS WHAT THE TOOLCHAIN EVALUATES
#   `swift package dump-package` prints the manifest as the toolchain reads it, so a dependency in
#   any form a manifest can declare one shows up, which a search of the manifest's text would not
#   promise. Three things fail: a non-empty top-level `dependencies` array, any target carrying a
#   `url` (a remote binary target is a download the array does not show; a binary target over a
#   local path is not, and stays admitted), and any target whose `type` is exactly the string
#   `system` (a library on the machine that the array does not show; it is named by its `name`, and
#   every other type, an absent `type` and a `type` of any other JSON kind stay admitted). The dump
#   is read with plutil, which ships with macOS and reads JSON. Unreadable is red: `swift` or `plutil` absent, `swift` failing, or a dump that
#   cannot be read each exit non-zero, and none can pass. Any file named Package.resolved under the
#   package directory, at any depth, fails too. `dump-package` writes .build/ into the package; that
#   directory is ignored and inside the scan, and a resolve that happened there is a finding.
#
# `cargo` and `swift` are found through PATH so a test can stand a tree in for the real one.
# NO_NETWORK_ALLOW_FILE overrides the list's path and NO_NETWORK_SWIFT_PACKAGE_DIR the Swift
# package's directory (ka-reader-mac under the product root), for the same reason.

set -euo pipefail

die() { echo "no-network.sh: $*" >&2; exit 1; }

root="$(cd "$(dirname "$0")/.." && pwd -P)"
allow_file="${NO_NETWORK_ALLOW_FILE:-$root/checks/deps.allow}"
[ -f "$allow_file" ] || die "the allowlist is missing: $allow_file"
# The Swift package's directory. By default ka-reader-mac under the product root, written as such in
# every message; under the override, the override's own path.
swift_package_dir="${NO_NETWORK_SWIFT_PACKAGE_DIR:-$root/ka-reader-mac}"
swift_package_name="${NO_NETWORK_SWIFT_PACKAGE_DIR:-ka-reader-mac}"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# --- the allowlist: one section ---

# A name outside a section, or a section that is not `cargo`, is a malformed list: read as written
# it would silently drop names from the comparison. A `pnpm:` section left behind is one.
malformed="$(awk '
  /^[[:space:]]*(#|$)/ { next }
  /^[^[:space:]#][^[:space:]]*:[[:space:]]*$/ {
    header = $0; sub(/:.*/, "", header)
    if (header != "cargo") { print "unknown section: " $0 }
    section = header; next
  }
  section == "" { print "name outside a section: " $0 }
' "$allow_file")"
[ -z "$malformed" ] || { echo "$malformed" >&2; die "$allow_file is malformed"; }

allowlist_section() {
  awk -v want="$1" '
    /^[[:space:]]*(#|$)/ { next }
    /^[^[:space:]#][^[:space:]]*:[[:space:]]*$/ { section = $0; sub(/:.*/, "", section); next }
    section == want { gsub(/^[[:space:]]+|[[:space:]]+$/, ""); print }
  ' "$allow_file" | LC_ALL=C sort -u
}

# --- the trees ---

cd "$root"
cargo tree --workspace --locked --offline --prefix none \
  --target aarch64-apple-darwin --target x86_64-apple-darwin > "$work/cargo.raw" 2> "$work/cargo.err" \
  || die "cargo tree failed: $(cat "$work/cargo.err")"
# The name is the first field; the version and cargo's `(*)` dedup marker are dropped, and so are
# the blank lines between workspace members.
awk 'NF && $1 !~ /^\[/ { print $1 }' "$work/cargo.raw" | LC_ALL=C sort -u > "$work/cargo.tree"
[ -s "$work/cargo.tree" ] || die "cargo tree reported no package"

# --- the comparison ---

problems=""
allowlist_section cargo > "$work/cargo.allow"
LC_ALL=C comm -13 "$work/cargo.allow" "$work/cargo.tree" > "$work/cargo.added"
LC_ALL=C comm -23 "$work/cargo.allow" "$work/cargo.tree" > "$work/cargo.removed"
while IFS= read -r name; do
  problems="${problems}cargo: $name — in the tree and not in checks/deps.allow
"
done < "$work/cargo.added"
while IFS= read -r name; do
  problems="${problems}cargo: $name — in checks/deps.allow and not in the tree
"
done < "$work/cargo.removed"

# --- the Swift package: nothing declared, nothing resolved ---

manifest="$swift_package_name/Package.swift"
declared_targets=0
if ! command -v swift > /dev/null 2>&1; then
  problems="${problems}swift: $manifest — swift is not on PATH, so what the manifest declares cannot be read
"
elif ! command -v plutil > /dev/null 2>&1; then
  problems="${problems}swift: $manifest — plutil is not on PATH, so the dump of the manifest cannot be read
"
elif ! swift package dump-package --package-path "$swift_package_dir" > "$work/swift.dump" 2> "$work/swift.err"; then
  problems="${problems}swift: $manifest — swift package dump-package failed, so what the manifest declares cannot be read: $(cat "$work/swift.err")
"
elif ! swift_dependencies="$(plutil -extract dependencies json -o - "$work/swift.dump" 2> /dev/null)" \
  || ! swift_target_count="$(plutil -extract targets raw -o - "$work/swift.dump" 2> /dev/null)" \
  || ! [ "$swift_target_count" -ge 0 ] 2> /dev/null; then
  problems="${problems}swift: $manifest — the dump of the manifest could not be read, so what it declares is unknown
"
else
  # An array with no member prints as [] whatever whitespace plutil puts inside it.
  [ "${swift_dependencies//[[:space:]]/}" = "[]" ] || problems="${problems}swift: $manifest — declares a dependency
"
  target_index=0
  while [ "$target_index" -lt "$swift_target_count" ]; do
    # The key's type, not its value: a null `url` is no download, and a `url` of any other type is
    # one. plutil names a JSON null's type `(any)`, parentheses included; the bare spellings are
    # kept so a plutil that drops them still reads a null as one.
    if url_type="$(plutil -type "targets.$target_index.url" "$work/swift.dump" 2> /dev/null)"; then
      case "$url_type" in
        "(any)" | any | null) ;;
        *)
          problems="${problems}swift: $manifest — target $target_index carries a url, a download the dependencies array does not show
"
          declared_targets=$((declared_targets + 1))
          ;;
      esac
    fi
    # The exact string `system`, and nothing else: a target with no `type`, or a `type` of another
    # JSON kind, is no system target. The kind is read first because `plutil -extract ... raw`
    # prints an object's keys, so an object holding the key `system` would read as the word. Both
    # reads sit in an `if` so a missing key cannot end the script under its shell options.
    # Independent of the url check above: a target can fail both, and the scan goes on through every
    # target.
    if [ "$(plutil -type "targets.$target_index.type" "$work/swift.dump" 2> /dev/null || true)" = "string" ] \
      && target_type="$(plutil -extract "targets.$target_index.type" raw -o - "$work/swift.dump" 2> /dev/null)" \
      && [ "$target_type" = "system" ]; then
      target_name="$(plutil -extract "targets.$target_index.name" raw -o - "$work/swift.dump" 2> /dev/null || true)"
      problems="${problems}swift: $manifest — target $target_name is of type system, a library the dependencies array does not show
"
    fi
    target_index=$((target_index + 1))
  done
fi

# Any depth, `.build/` included. A missing directory is already a
# failure above, so its find is silent.
resolved_files="$(find "$swift_package_dir" -name Package.resolved 2> /dev/null | LC_ALL=C sort || true)"
resolved_count=0
while IFS= read -r resolved; do
  [ -n "$resolved" ] || continue
  problems="${problems}swift: ${swift_package_name}${resolved#"$swift_package_dir"} — a Package.resolved, and a package with no dependency has none
"
  resolved_count=$((resolved_count + 1))
done <<< "$resolved_files"

[ -z "$problems" ] || { printf '%s' "$problems" >&2; die "the dependencies differ from checks/deps.allow, or the Swift package declares or resolves one"; }

echo "no-network.sh: ok — $(wc -l < "$work/cargo.tree" | tr -d ' ') cargo names match checks/deps.allow; the Swift package declares 0 dependencies and holds $resolved_count Package.resolved"

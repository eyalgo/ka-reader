#!/usr/bin/env bash
# Version: 1.0.0 — first version: both dependency trees compared, by name, against the reviewed checks/deps.allow
#
# checks/no-network.sh — proves the product is built from nothing nobody reviewed.
#
# WHY THIS EXISTS
#   The product promises it never reaches the network (docs/SDD.md § 4 C-R6; NFDR QC-3, QC-26). What
#   it is built from is what could break that promise, so the names `cargo tree` and `pnpm ls` report
#   are compared, by name, against checks/deps.allow — the one list a reviewer has read. A name in a
#   tree that the list does not hold fails; so does a name on the list that the tree no longer holds,
#   so the list cannot go stale unnoticed.
#
# USAGE
#   checks/no-network.sh
#   Exit 0 when both ecosystems' name sets equal their sections of checks/deps.allow, printing nothing
#   that names a dependency. Otherwise non-zero, naming each differing name, its section and the side
#   it was on.
#
# THE COMPARED SETS DO NOT DEPEND ON THE MACHINE
#   cargo: both Apple-Darwin triples are named on the command line, so the set is the union
#     Cargo.lock fixes and not whatever the running CPU resolves (CP-50, by construction).
#   pnpm: every name `pnpm ls --depth Infinity` reports, installed or not — the lockfile graph, not
#     what this machine installed. node_modules/.pnpm is pnpm's own layout and is never read.
#   The set is a superset of what the bundle contains (dev and build dependencies, the renderer
#   toolchain), which is the reading under which both C-R6 and QC-26 hold.
#
# `cargo` and `pnpm` are found through PATH so a test can stand a tree in for the real one.
# NO_NETWORK_ALLOW_FILE overrides the list's path, for the same reason.

set -euo pipefail

die() { echo "no-network.sh: $*" >&2; exit 1; }

root="$(cd "$(dirname "$0")/.." && pwd -P)"
allow_file="${NO_NETWORK_ALLOW_FILE:-$root/checks/deps.allow}"
[ -f "$allow_file" ] || die "the allowlist is missing: $allow_file"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# --- the allowlist: two sections, compared independently ---

# A name outside a section, or a section that is neither of the two, is a malformed list: read as
# written it would silently drop names from the comparison.
malformed="$(awk '
  /^[[:space:]]*(#|$)/ { next }
  /^[^[:space:]#][^[:space:]]*:[[:space:]]*$/ {
    header = $0; sub(/:.*/, "", header)
    if (header != "cargo" && header != "pnpm") { print "unknown section: " $0 }
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
# The name is the first field; the version and cargo's `(*)` dedup marker are dropped, and so are the
# blank lines between workspace members.
awk 'NF && $1 !~ /^\[/ { print $1 }' "$work/cargo.raw" | LC_ALL=C sort -u > "$work/cargo.tree"
[ -s "$work/cargo.tree" ] || die "cargo tree reported no package"

# An error, never an empty set that would compare clean against an empty section.
( cd nozoki-ui && pnpm ls --depth Infinity --json ) > "$work/pnpm.raw" 2> "$work/pnpm.err" \
  || die "pnpm ls failed: $(cat "$work/pnpm.err") — run pnpm install --frozen-lockfile in nozoki-ui"
sed -n 's/^ *"from": "\(.*\)",\{0,1\}$/\1/p' "$work/pnpm.raw" | LC_ALL=C sort -u > "$work/pnpm.tree"
[ -s "$work/pnpm.tree" ] || die "pnpm ls reported no package — nozoki-ui has no install; run pnpm install --frozen-lockfile in nozoki-ui first"

# --- the comparison ---

problems=""
for section in cargo pnpm; do
  allowlist_section "$section" > "$work/$section.allow"
  LC_ALL=C comm -13 "$work/$section.allow" "$work/$section.tree" > "$work/$section.added"
  LC_ALL=C comm -23 "$work/$section.allow" "$work/$section.tree" > "$work/$section.removed"
  while IFS= read -r name; do
    problems="${problems}$section: $name — in the tree and not in checks/deps.allow
"
  done < "$work/$section.added"
  while IFS= read -r name; do
    problems="${problems}$section: $name — in checks/deps.allow and not in the tree
"
  done < "$work/$section.removed"
done

[ -z "$problems" ] || { printf '%s' "$problems" >&2; die "the dependency trees differ from checks/deps.allow"; }

echo "no-network.sh: ok — $(wc -l < "$work/cargo.tree" | tr -d ' ') cargo names and $(wc -l < "$work/pnpm.tree" | tr -d ' ') pnpm names match checks/deps.allow"

#!/usr/bin/env bash
# Version: 1.0.0 — first version: refuses a tag that is not the product's version, before anything
#   is packed (CP-1175)
#
# checks/release-version.sh <tag> <manifest> <bundle> — whether a pushed tag names the version the
# product carries.
#
# WHY THIS EXISTS
#   A release built from a tag names itself by the tag, and the image inside carries the version
#   the build stamped. If the two differ, the release names the wrong build. The product states its
#   one version in the root Cargo.toml and the bundle carries it as CFBundleShortVersionString, so
#   the script reads both and refuses unless three things hold: (a) the tag is "v" followed by the
#   Cargo version exactly; (b) the bundle's version is the Cargo version; (c) the tag has the form
#   v0.<digits>.<digits>, nothing after it, because the product has no 1.0.0 yet and a pre-release
#   suffix names a build this workflow does not make. It evaluates all three before it reports, so
#   the one line names every condition that failed.
#
# USAGE
#   checks/release-version.sh v0.1.0 Cargo.toml target/release/bundle/macos/KA-Reader.app
#   Exit 0: all three hold, one line on stdout naming the tag and both versions.
#   Exit 1: refused, one line on stderr prefixed "release-version.sh:" naming the tag, the Cargo
#     version, the bundle version ("no version" when the key is missing) and a phrase for each
#     condition that failed. Also exit 1 when the manifest is unreadable, holds no
#     [workspace.package] version line or more than one, or the bundle has no Contents/Info.plist.
#   Exit 2: an argument count other than three, with a usage line on stderr.
#
# WHAT IT READS AND WRITES
#   The manifest and the bundle's Info.plist are read. Nothing is written. It reads no environment
#   variable of its own.

set -euo pipefail

NAME="release-version.sh"
PLIST_BUDDY="/usr/libexec/PlistBuddy"
VERSION_KEY="CFBundleShortVersionString"

if [ "$#" -ne 3 ]; then
  echo "$NAME: usage: $NAME <tag> <manifest> <bundle>" >&2
  exit 2
fi

tag="$1"
manifest="$2"
bundle="$3"

# Says why on stderr and ends with status 1.
die() {
  echo "$NAME: $*" >&2
  exit 1
}

# --- the Cargo version ---

[ -r "$manifest" ] || die "cannot read the manifest at $manifest"

# The version lines under the line [workspace.package], up to the next table header.
version_lines="$(awk '
  /^\[/ { in_table = ($0 == "[workspace.package]"); next }
  in_table && /^version = "/ { print }
' "$manifest")"
[ -n "$version_lines" ] || die "the manifest at $manifest holds no version line under [workspace.package]"
case "$version_lines" in
  *"
"*) die "the manifest at $manifest holds more than one version line under [workspace.package]" ;;
esac
cargo_version="${version_lines#version = \"}"
cargo_version="${cargo_version%%\"*}"

# --- the bundle's version ---

plist="$bundle/Contents/Info.plist"
[ -f "$plist" ] || die "the bundle at $bundle has no Contents/Info.plist"
# || true: PlistBuddy exits 1 on a missing key, which is data here, and pipefail would end the
# script before the guard below reports it.
bundle_version="$("$PLIST_BUDDY" -c "Print :$VERSION_KEY" "$plist" 2> /dev/null || true)"
bundle_shown="${bundle_version:-no version}"

# --- the three conditions, all evaluated before any report ---

failed=""
if [ "$tag" != "v$cargo_version" ]; then
  failed="$failed; (a) the tag is not v followed by the Cargo version"
fi

if [ "$bundle_version" != "$cargo_version" ]; then
  failed="$failed; (b) the bundle's version is not the Cargo version"
fi

# [[ =~ ]] is the one double-bracket form the shell packet admits: [ cannot match a pattern.
if ! [[ "$tag" =~ ^v0\.[0-9]+\.[0-9]+$ ]]; then
  failed="$failed; (c) the tag is not v0.<digits>.<digits>"
fi

if [ -n "$failed" ]; then
  die "refused tag $tag: Cargo version $cargo_version, bundle version $bundle_shown$failed"
fi
echo "$NAME: tag $tag is Cargo version $cargo_version and bundle version $bundle_shown"

#!/usr/bin/env bash
# Version: 1.0.0 — first version: builds the bridge and the package in release, lays out KA-Reader.app, copies the glyphs in, signs last
#
# ka-reader-mac/assemble.sh — builds and signs target/release/bundle/macos/KA-Reader.app. Takes no argument.
#
# WHY THIS EXISTS
#   The native shell replaced the Tauri build, which used to lay this bundle out. Nothing else does
#   now, and the checks (checks/bundle.sh, checks/tests/test_bundle.sh) and CI read the bundle at
#   exactly this path. The order is fixed by what depends on what: the bridge's static library must
#   exist before the package links it, and the seal that `codesign` writes covers every file, so a
#   file added after signing breaks it (checks/tests/test_bundle.sh) — signing is therefore last.
#
# USAGE
#   ka-reader-mac/assemble.sh
#
# WHAT IT DECIDES, AND FROM WHAT
#   Nothing is read from the environment (NFDR QC-62): every path derives from this file's own
#   location, and the deployment target is set for the one command that needs it. The bridge is built
#   with MACOSX_DEPLOYMENT_TARGET=14.0, the bundle's LSMinimumSystemVersion, so the library links into
#   a package whose floor is macOS 14 without the linker's "built for newer 'macOS'" warning.
#   The glyphs are copied from third_party/lucide/icons/ at assembly and never kept in ka-reader-mac.
#   The signature is ad hoc, with the hardened runtime and ka-reader-mac/Entitlements.plist.

set -euo pipefail

die() { echo "assemble.sh: $*" >&2; exit 1; }

[ "$#" -eq 0 ] || die "takes no argument (got: $*)"

# --- paths, all derived from this file ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
APP="$REPO_ROOT/target/release/bundle/macos/KA-Reader.app"
GLYPH_DIR="$REPO_ROOT/third_party/lucide/icons"
GLYPH_LICENSE="$REPO_ROOT/third_party/lucide/LICENSE"

for required in "$SCRIPT_DIR/Info.plist" "$SCRIPT_DIR/Entitlements.plist" "$SCRIPT_DIR/icon.icns" "$GLYPH_LICENSE"; do
  [ -f "$required" ] || die "missing $required"
done
[ -d "$GLYPH_DIR" ] || die "missing $GLYPH_DIR"

# --- 1. the bridge, in release, for the bundle's deployment floor ---
MACOSX_DEPLOYMENT_TARGET=14.0 cargo build --manifest-path "$REPO_ROOT/Cargo.toml" \
  -p ka-reader-bridge --release --locked

# --- 2. the package, in release ---
swift build --package-path "$SCRIPT_DIR" -c release
bin_path="$(swift build --package-path "$SCRIPT_DIR" -c release --show-bin-path)"
executable="$bin_path/KAReader"
[ -x "$executable" ] || die "swift build wrote no executable at $executable"

# --- 3. the layout ---
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

# --- 4. the contents ---
cp "$executable" "$APP/Contents/MacOS/KAReader"
cp "$SCRIPT_DIR/Info.plist" "$APP/Contents/Info.plist"
cp "$GLYPH_DIR"/* "$APP/Contents/Resources/"
cp "$GLYPH_LICENSE" "$APP/Contents/Resources/LICENSE"
cp "$SCRIPT_DIR/icon.icns" "$APP/Contents/Resources/icon.icns"

# --- 5. the signature, last: a file added after this breaks the seal ---
codesign --force --sign - --options runtime --entitlements "$SCRIPT_DIR/Entitlements.plist" "$APP"

echo "assemble.sh: $APP"

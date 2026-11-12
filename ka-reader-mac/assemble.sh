#!/usr/bin/env bash
# Version: 1.3.0 — the application icon is generated from docs/design/app_icon.svg at every assembly, every program the script runs is looked for first, and the stand-in icon leaves ka-reader-mac
# Version: 1.2.0 — the bundle carries the tree's LICENSE and THIRD_PARTY_NOTICES.md, copied in before the seal
# Version: 1.1.0 — the product declares the macOS 26 floor and builds its bridge for it
# Version: 1.0.0 — first version: builds the bridge and the package in release, lays out KA-Reader.app, copies the glyphs in, signs last
#
# ka-reader-mac/assemble.sh — builds and signs target/release/bundle/macos/KA-Reader.app. Takes no argument.
#
# WHY THIS EXISTS
#   The native shell replaced the Tauri build, which used to lay this bundle out. Nothing else does
#   now, and the checks (checks/bundle.sh, checks/tests/test_bundle.sh) and CI read the bundle at
#   exactly this path. The order is fixed by what depends on what: the bridge's static library must
#   exist, packaged as the package's local binary target, before anything builds the package (a
#   `swift build` and a `swift test` both resolve it), and the seal that `codesign` writes covers
#   every file, so a file added after signing breaks it (checks/tests/test_bundle.sh) — signing is
#   therefore last.
#
# USAGE
#   ka-reader-mac/assemble.sh
#
# WHAT IT DECIDES, AND FROM WHAT
#   Nothing is read from the environment (NFDR QC-62): every path derives from this file's own
#   location, and the deployment target is set for the one command that needs it. The bridge is built
#   with MACOSX_DEPLOYMENT_TARGET=26.0, the bundle's LSMinimumSystemVersion, so the library links into
#   a package whose floor is macOS 26 without the linker's "built for newer 'macOS'" warning.
#   The one release archive feeds both the debug tests and the release build: a binary target has one
#   path, no per-configuration variant. The artifact bundle, ka-reader-mac/CKAReaderBridge.artifactbundle,
#   is rebuilt from this checkout on every run (a stale or foreign-architecture one cannot survive) and
#   names only the architecture the toolchain reports it built for. It is git-ignored.
#   The glyphs are copied from third_party/lucide/icons/ at assembly and never kept in ka-reader-mac.
#   The tree's LICENSE and THIRD_PARTY_NOTICES.md are copied into Contents/Resources, as
#   KA-Reader-LICENSE and THIRD_PARTY_NOTICES.md, so the disk image carries them with the app
#   (docs/nfdr.md QC-41). The licence gets a name of its own because Contents/Resources/LICENSE is
#   the icon set's licence. Both are copied before the signature, which covers them, and
#   checks/bundle.sh holds them byte-identical to the tree's files.
#   The application icon is generated from docs/design/app_icon.svg, the signed-off drawing, on
#   every run, and no icon file is kept in ka-reader-mac. sips renders the drawing at each of an
#   iconset's ten sizes, from the drawing itself each time and never by scaling another rendering,
#   and iconutil packs the ten into one icon file. Both are part of macOS, so the icon adds no
#   dependency (docs/nfdr.md QC-26). The generation runs before the bridge build, in a temporary
#   folder outside the tree that is removed on every exit. So a drawing that does not render stops
#   the run before the long build, and no rendering lands in the tree. Without the drawing the run
#   stops before the bridge build, as it does for every other required input. The icon is copied to
#   Contents/Resources/icon.icns before the signature, which covers it. checks/app-icon.sh holds the
#   built icon to the drawing's rules, and checks/bundle.sh does not launch a bundle that still
#   carries the stand-in icon, whose bytes are kept at checks/fixtures/stand-in-icon.icns.
#   Every program the script runs is looked for on PATH before anything is built, and a missing one
#   stops the run, named.
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
TREE_LICENSE="$REPO_ROOT/LICENSE"
TREE_NOTICES="$REPO_ROOT/THIRD_PARTY_NOTICES.md"
APP_ICON_DRAWING="$REPO_ROOT/docs/design/app_icon.svg"

# The ten entries of an iconset and the pixel size each is rendered at: an @2x entry is twice its base.
ICONSET_ENTRIES="icon_16x16:16 icon_16x16@2x:32 icon_32x32:32 icon_32x32@2x:64 icon_128x128:128 icon_128x128@2x:256 icon_256x256:256 icon_256x256@2x:512 icon_512x512:512 icon_512x512@2x:1024"

for required in "$SCRIPT_DIR/Info.plist" "$SCRIPT_DIR/Entitlements.plist" "$APP_ICON_DRAWING" "$GLYPH_LICENSE" "$TREE_LICENSE" "$TREE_NOTICES"; do
  [ -f "$required" ] || die "missing $required"
done
[ -d "$GLYPH_DIR" ] || die "missing $GLYPH_DIR"

# --- the programs this script runs, each looked for before anything is built ---
command -v sips >/dev/null 2>&1 || die "sips not found on PATH — the application icon is rendered from docs/design/app_icon.svg with it"
command -v iconutil >/dev/null 2>&1 || die "iconutil not found on PATH — the rendered sizes are packed into the application icon with it"
command -v cargo >/dev/null 2>&1 || die "cargo not found on PATH — the bridge is built with it"
command -v rustc >/dev/null 2>&1 || die "rustc not found on PATH — the architecture the bridge was built for is read from it"
command -v swift >/dev/null 2>&1 || die "swift not found on PATH — the package is built with it"
command -v codesign >/dev/null 2>&1 || die "codesign not found on PATH — the bundle is signed with it"

# --- 0. the application icon, rendered from the drawing before the long build ---
# The folder is outside the tree and is removed on every exit; iconutil reads only a directory whose
# name ends .iconset. Each size is rendered from the vector itself, never scaled from another size.
ICON_WORK=""
remove_icon_work() { [ -z "$ICON_WORK" ] || rm -rf "$ICON_WORK"; }
trap remove_icon_work EXIT
ICON_WORK="$(mktemp -d)" || die "cannot create a temporary folder under ${TMPDIR:-/tmp}, so nothing was built"
ICONSET="$ICON_WORK/AppIcon.iconset"
mkdir "$ICONSET"
for entry_size in $ICONSET_ENTRIES; do
  entry="${entry_size%%:*}"
  pixels="${entry_size##*:}"
  sips_output="$(sips -s format png -z "$pixels" "$pixels" "$APP_ICON_DRAWING" --out "$ICONSET/$entry.png" 2>&1)" \
    || die "sips could not render $APP_ICON_DRAWING at $pixels px, so nothing was built. sips printed: $sips_output"
done
iconutil_output="$(iconutil -c icns -o "$ICON_WORK/icon.icns" "$ICONSET" 2>&1)" \
  || die "iconutil could not pack the rendered sizes into the application icon, so nothing was built. iconutil printed: $iconutil_output"

# --- 1. the bridge, in release, for the bundle's deployment floor ---
MACOSX_DEPLOYMENT_TARGET=26.0 cargo build --manifest-path "$REPO_ROOT/Cargo.toml" \
  -p ka-reader-bridge --release --locked

# --- 1b. the bridge, as the package's binary target ---
ARCHIVE="$REPO_ROOT/target/release/libka_reader_bridge.a"
HEADER="$REPO_ROOT/target/include/ka_reader_bridge.h"
MODULE_MAP="$SCRIPT_DIR/Sources/CKAReaderBridge/module.modulemap"
BRIDGE_BUNDLE="$SCRIPT_DIR/CKAReaderBridge.artifactbundle"
[ -f "$ARCHIVE" ] || die "the bridge build wrote no archive at $ARCHIVE"
[ -f "$HEADER" ] || die "the bridge build wrote no header at $HEADER"
[ -f "$MODULE_MAP" ] || die "missing $MODULE_MAP"

# The architecture the bridge was built for is the toolchain's host: cargo is given no --target.
host_triple="$(rustc -vV | sed -n 's/^host: //p')"
case "$host_triple" in
  aarch64-apple-darwin) bundle_triple="arm64-apple-macosx" ;;
  x86_64-apple-darwin) bundle_triple="x86_64-apple-macosx" ;;
  *) die "cannot package a bridge built for '$host_triple': only a native arm64 or x86_64 macOS build is represented" ;;
esac

rm -rf "$BRIDGE_BUNDLE"
mkdir -p "$BRIDGE_BUNDLE/include"
cp "$ARCHIVE" "$BRIDGE_BUNDLE/libka_reader_bridge.a"
cp "$HEADER" "$BRIDGE_BUNDLE/include/ka_reader_bridge.h"
cp "$MODULE_MAP" "$BRIDGE_BUNDLE/include/module.modulemap"
cat > "$BRIDGE_BUNDLE/info.json" <<JSON
{
  "schemaVersion": "1.0",
  "artifacts": {
    "CKAReaderBridge": {
      "type": "staticLibrary",
      "version": "1.0.0",
      "variants": [
        {
          "path": "libka_reader_bridge.a",
          "supportedTriples": ["$bundle_triple"],
          "staticLibraryMetadata": {
            "headerPaths": ["include"],
            "moduleMapPath": "include/module.modulemap"
          }
        }
      ]
    }
  }
}
JSON

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
cp "$TREE_LICENSE" "$APP/Contents/Resources/KA-Reader-LICENSE"
cp "$TREE_NOTICES" "$APP/Contents/Resources/THIRD_PARTY_NOTICES.md"
cp "$ICON_WORK/icon.icns" "$APP/Contents/Resources/icon.icns"

# --- 5. the signature, last: a file added after this breaks the seal ---
codesign --force --sign - --options runtime --entitlements "$SCRIPT_DIR/Entitlements.plist" "$APP"

echo "assemble.sh: $APP"

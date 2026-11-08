#!/usr/bin/env bash
# Version: 1.0.0 — first version: packs the built bundle into the release's disk image (CP-1176)
#
# checks/release-pack.sh <bundle> <outdir> — the disk image a person downloads.
#
# WHY THIS EXISTS
#   The release offers the built app as a disk image, KA-Reader-<version>.dmg, and the image has to
#   hold the bundle exactly as the build made it: ad-hoc signed, with the signature intact. The
#   script stages the bundle alone in a fresh folder, copies it with ditto (which keeps the modes and
#   sealed files the signature covers), and has hdiutil make the image from that folder. The mounted
#   volume shows one item, KA-Reader.app: no background, no volume icon, no Applications link, no
#   other file. The volume is named KA-Reader, the string the change text fixes. The version in the
#   file name is the bundle's CFBundleShortVersionString.
#   <outdir> must not exist, and the script creates it, so the folder holds one file and
#   checks/release-sums.sh can refuse anything else.
#
# USAGE
#   checks/release-pack.sh target/release/bundle/macos/KA-Reader.app dist
#   Exit 0: packed.
#   Exit 1: refused, with nothing left behind: <bundle> has no Contents/Info.plist, the bundle has no
#     usable version key, <outdir> already exists, or hdiutil failed (the partial <outdir> is
#     removed). A hang-up, interrupt or terminate signal also ends 1, after the staging is removed.
#   Exit 2: an argument count other than two, with a usage line on stderr.
#
# THE ORDER OF THE END
#   The image tool runs in the background and the script waits for it, because bash runs a trap only
#   once a foreground command has finished: a signal would otherwise wait for hdiutil. The one EXIT
#   trap stops the tool, removes the staging folder, and removes <outdir> unless the image was made.
#
# WHAT IT READS AND WRITES
#   It reads the bundle. It writes <outdir> and one staging folder made with mktemp -d. It reads no
#   environment variable of its own.

set -euo pipefail

NAME="release-pack.sh"
PLIST_BUDDY="/usr/libexec/PlistBuddy"
VERSION_KEY="CFBundleShortVersionString"
VOLUME_NAME="KA-Reader"

if [ "$#" -ne 2 ]; then
  echo "$NAME: usage: $NAME <bundle> <outdir>" >&2
  exit 2
fi

bundle="$1"
outdir="$2"

# What the EXIT trap reads. All of it is set before anything is made.
stage=""
child=""
outdir_made="no"
packed="no"

finish() {
  trap - EXIT
  if [ -n "$child" ]; then
    kill "$child" 2> /dev/null || true
  fi
  if [ -n "$stage" ]; then
    rm -rf "$stage"
  fi
  if [ "$outdir_made" = "yes" ] && [ "$packed" != "yes" ]; then
    rm -rf "$outdir"
  fi
}
trap finish EXIT
trap 'exit 1' HUP INT TERM

# Says why on stderr and ends with status 1, which the trap then exits with.
refuse() {
  echo "$NAME: $*" >&2
  exit 1
}

# --- what is being packed ---

[ -f "$bundle/Contents/Info.plist" ] || refuse "$bundle is not a bundle: it has no Contents/Info.plist"
# || true: PlistBuddy exits 1 on a missing key, which is reported on the next line, and pipefail
# would end the script first.
version="$("$PLIST_BUDDY" -c "Print :$VERSION_KEY" "$bundle/Contents/Info.plist" 2> /dev/null || true)"
[ -n "$version" ] || refuse "the bundle at $bundle has no $VERSION_KEY"
# The version is the stem of the image's file name, so a character that is not part of a name is refused.
case "$version" in
  *[!0-9A-Za-z._-]*) refuse "the bundle's version \"$version\" cannot name a file" ;;
esac
[ ! -e "$outdir" ] || refuse "$outdir already exists"

# --- the image ---

mkdir "$outdir" 2> /dev/null || refuse "cannot create $outdir"
outdir_made="yes"
stage="$(mktemp -d)"
ditto "$bundle" "$stage/KA-Reader.app"

image="$outdir/KA-Reader-$version.dmg"
hdiutil create -srcfolder "$stage" -volname "$VOLUME_NAME" -format UDZO "$image" > /dev/null &
child=$!
status=0
wait "$child" || status=$?
child=""
[ "$status" -eq 0 ] || refuse "hdiutil failed with status $status"

packed="yes"
echo "$NAME: packed $image"

#!/usr/bin/env bash
# Version: 1.0.0 — first version: writes the release's SHA256SUMS beside the disk image (CP-1177)
#
# checks/release-sums.sh <dir> — the checksum file a person verifies a download against.
#
# WHY THIS EXISTS
#   The Release offers two files, the disk image and SHA256SUMS. The script writes the second from
#   the first, in the form shasum -a 256 prints: 64 lowercase hex digits, two spaces, the bare file
#   name. The bare name is what makes `shasum -a 256 -c SHA256SUMS` work from inside the folder,
#   which is the command the workflow's verify step runs and the one a person runs after
#   downloading. <dir> must hold exactly one entry, a file matching KA-Reader-*.dmg. Together with
#   checks/release-pack.sh, which writes into an empty folder, that makes the Release's two assets
#   true by construction: nothing else can be in the folder when the Release is made.
#
# USAGE
#   checks/release-sums.sh dist
#   Exit 0: <dir>/SHA256SUMS written.
#   Exit 1: refused, with nothing written: <dir> is missing, is empty, holds two images or any other
#     entry, or already holds SHA256SUMS.
#   Exit 2: an argument count other than one, with a usage line on stderr.
#
# WHAT IT READS AND WRITES
#   It reads the image's bytes and writes <dir>/SHA256SUMS. It reads no environment variable of its
#   own.

set -euo pipefail

NAME="release-sums.sh"
SUMS="SHA256SUMS"

if [ "$#" -ne 1 ]; then
  echo "$NAME: usage: $NAME <dir>" >&2
  exit 2
fi

dir="$1"

# Says why on stderr and ends with status 1.
die() {
  echo "$NAME: $*" >&2
  exit 1
}

[ -d "$dir" ] || die "$dir is not a folder"
[ ! -e "$dir/$SUMS" ] || die "$dir already holds $SUMS"

entries="$(ls -A "$dir")"
[ -n "$entries" ] || die "$dir is empty: it must hold the disk image"
case "$entries" in
  *"
"*) die "$dir holds more than one entry: it must hold the disk image alone" ;;
esac
case "$entries" in
  KA-Reader-*.dmg) ;;
  *) die "$dir holds $entries, not a KA-Reader-*.dmg image" ;;
esac
[ -f "$dir/$entries" ] || die "$dir/$entries is not a file"

# From inside the folder, in a subshell, so the line carries the bare file name that shasum -c
# reads.
(cd "$dir" && shasum -a 256 "$entries" > "$SUMS")
echo "$NAME: wrote $dir/$SUMS"

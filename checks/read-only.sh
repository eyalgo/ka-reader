#!/usr/bin/env bash
# Version: 1.0.0 — first version: proves a walk of a fixture folder changed nothing in it
#
# checks/read-only.sh <fixture> — hash a fixture, walk it with nozoki-core's driver, hash it again.
#
# WHY THIS EXISTS
#   CP-35 and CP-36: the product must only ever read. The proof is outside the product — this script
#   hashes the folder with its own tools (never through nozoki-core), runs the in-process driver
#   (crates/nozoki-core/tests/walk.rs) over it, and hashes again. A difference is a write.
#
# USAGE
#   checks/read-only.sh checks/fixtures/plain
#   stdout carries the verdict and nothing else: `unchanged` and exit 0, or each differing relative
#   path once and a non-zero exit. Every message and all build and driver output go to stderr.
#   A walk that did not complete (the driver failed, or it made no call) is never `unchanged`.
#
# WHAT IS HASHED
#   Every entry under the fixture, `.git` included, links not followed: relative path, kind, and
#   content (the file's bytes, or a link's target). No timestamps and no modes, so a `touch` is not
#   a change. No git command runs inside the fixture.
#
# RESTORE
#   A `<fixture>.git.tar` beside the fixture is that fixture's `.git`. If the archive exists and the
#   fixture has no `.git`, it is extracted before the first hash.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="read-only.sh"

# One record per entry: <relative path> TAB <kind> TAB <digest>, sorted by path. `find` does not
# follow links, so a link is hashed as a link.
manifest() {
  (
    cd "$1"
    find . -mindepth 1 | LC_ALL=C sort | while IFS= read -r entry; do
      if [ -L "$entry" ]; then
        kind="link"
        digest="$(readlink "$entry")"
      elif [ -d "$entry" ]; then
        kind="folder"
        digest="-"
      elif [ -f "$entry" ]; then
        kind="file"
        digest="$(shasum -a 256 < "$entry" | cut -d ' ' -f 1)"
      else
        kind="other"
        digest="-"
      fi
      printf '%s\t%s\t%s\n' "${entry#./}" "$kind" "$digest"
    done
  )
}

# Every path whose record is in one manifest and not the other, once each. `diff` exits 1 when the
# manifests differ, which under pipefail would end the script, hence the `|| true`.
differing_paths() {
  diff "$1" "$2" | sed -n 's/^[<>] //p' | cut -f 1 | LC_ALL=C sort -u || true
}

if [ $# -ne 1 ]; then
  echo "$NAME: usage: $NAME <fixture folder>" >&2
  exit 2
fi

fixture="${1%/}"
if [ ! -d "$fixture" ]; then
  echo "$NAME: not a folder: $1" >&2
  exit 1
fi
absolute="$(cd "$fixture" && pwd)"

archive="$fixture.git.tar"
if [ -f "$archive" ] && [ ! -e "$fixture/.git" ]; then
  tar -xf "$archive" -C "$fixture"
fi

work="$(mktemp -d)"
cleanup() {
  rm -rf "$work"
}
trap cleanup EXIT

manifest "$absolute" > "$work/before"

# stdout is read for the call count; the driver's and cargo's stderr passes through to ours.
walked=0
if walk_output="$(cd "$ROOT" && cargo test --locked --quiet -p nozoki-core --test walk -- "$absolute")"; then
  calls="$(printf '%s\n' "$walk_output" | tail -n 1)"
  case "$calls" in
    '' | *[!0-9]*) ;;
    *) [ "$calls" -ge 1 ] && walked=1 ;;
  esac
fi
if [ "$walked" -ne 1 ]; then
  echo "$NAME: walk did not complete: $absolute" >&2
  exit 1
fi

manifest "$absolute" > "$work/after"

changed="$(differing_paths "$work/before" "$work/after")"
if [ -z "$changed" ]; then
  echo "unchanged"
else
  printf '%s\n' "$changed"
  exit 1
fi

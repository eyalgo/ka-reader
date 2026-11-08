#!/usr/bin/env bash
# Version: 1.0.0 — first version: refuses a tag that already has a GitHub Release, draft or
#   published (CP-1180)
#
# checks/release-absent.sh <owner/repository> <tag> — whether the tag is still free of a Release.
#
# WHY THIS EXISTS
#   The release workflow only ever creates a Release; it never edits or replaces one. A Release that
#   already carries the tag, published or still a draft, is left as it was, so this step stops the
#   run before it makes a second.
#   A draft shows only on the list endpoint, repos/<owner>/<repository>/releases. The endpoint that
#   asks for one tag, releases/tags/<tag>, returns published Releases alone, so it would read a
#   draft as absent. The script lists every page and compares whole lines.
#   It fails closed. A listing that fails, or a gh that is not on PATH, is never read as "none":
#   both end 1.
#
# USAGE
#   checks/release-absent.sh <owner>/<repository> v0.1.0
#   Exit 0: no Release has this tag.
#   Exit 1: a Release for the tag exists (the line names it), or the listing failed, or gh is not on
#     PATH, or the tag is empty.
#   Exit 2: an argument count other than two, with a usage line on stderr.
#
# WHAT IT READS AND WRITES
#   It reads the repository's Release list through gh and writes nothing. It reads no environment
#   variable of its own: gh reads GH_TOKEN itself.

set -euo pipefail

NAME="release-absent.sh"

if [ "$#" -ne 2 ]; then
  echo "$NAME: usage: $NAME <owner/repository> <tag>" >&2
  exit 2
fi

repository="$1"
tag="$2"

# Says why on stderr and ends with status 1.
die() {
  echo "$NAME: $*" >&2
  exit 1
}

# An empty tag would match an empty line of the listing.
[ -n "$tag" ] || die "no tag was given"
# A program the run cannot do without, guarded before it is used (shell packet, toolchain tier 2).
command -v gh > /dev/null 2>&1 || die "gh was not found on PATH, so the Releases of $repository cannot be listed"

# The listing is captured into a variable and its status checked on its own line. A failed command
# substitution inside a test argument does not fail the test, so the inline form would fail open.
status=0
tags="$(gh api --paginate "repos/$repository/releases" --jq '.[].tag_name')" || status=$?
[ "$status" -eq 0 ] || die "the listing of the Releases of $repository failed with status $status, so $tag cannot be called absent"

if printf '%s\n' "$tags" | grep -x -F -- "$tag" > /dev/null; then
  die "a Release for $tag already exists in $repository"
fi
echo "$NAME: no Release for $tag in $repository"

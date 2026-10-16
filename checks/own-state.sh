#!/usr/bin/env bash
# Version: 1.1.0 — the submodule walk runs every build — restore cases, read_git case, CI step
# Version: 1.0.0 — first version: proves a launch left nothing behind but the log
#
# checks/own-state.sh — three conditions on the machine after the app has run. Exits 0 only when all
# three hold; otherwise names each failed condition (and, under condition 2, each offending entry)
# on stderr and exits non-zero.
#
# WHY THIS EXISTS
#   CP-37: the product's own state is its log and nothing else. The app writes to one file; every
#   other trace — in a fixture it was pointed at, or in the repo — is a failure of the promise.
#
# ADMISSION
#   Before any of the three conditions, and before the root is found, the script asks the host whether it
#   is a macOS virtual machine (`uname -s` Darwin and `sysctl -n kern.hv_vmm_present` 1, both succeeding).
#   On any other reading it prints one line on stderr, nothing on stdout, and exits 1: no condition line,
#   nothing read under $HOME or the fixtures (docs/nfdr.md QC-65). Nothing it is given turns this off.
#
# THE THREE CONDITIONS
#   1. A file exists at $HOME/Library/Containers/com.kensaiapp.ka-reader/Data/Library/Logs/ka-reader.log.
#      That path is checked and no other; nothing is launched.
#   2. Every folder directly under checks/fixtures/ holds exactly what git commits there, plus the
#      folders those paths imply, plus `.git` and the archive's listing — and the folders that
#      listing implies — when a `<fixture>.git.tar` sits beside it. Anything else — ignored files
#      included — is named. The actual set is found by walking without following links. A `.git`
#      that has not been restored is missing, not extra.
#   3. `git status --porcelain checks/fixtures` prints nothing.
#
# USAGE
#   checks/own-state.sh   (from anywhere in the product repo; the root is found from this file)
#   No git command runs inside a fixture: the expected set comes from the product repo's own HEAD.

set -euo pipefail

# --- admission: this step runs only in a macOS virtual machine (docs/nfdr.md QC-65) ---
# First work of the run, inline so nothing is opened, found or read before it — the root below is not
# discovered, no condition is looked at. Both host readings must succeed and read exactly Darwin and 1;
# a reader that fails, is missing or prints anything else refuses, and a failing reader that prints 1
# does not admit (the status is kept, not only the text). Nothing the script reads changes this.
host_os="$(uname -s 2> /dev/null)" && host_vmm="$(sysctl -n kern.hv_vmm_present 2> /dev/null)" \
  && [ "$host_os" = "Darwin" ] && [ "$host_vmm" = "1" ] \
  || { echo "own-state.sh: refused: this host does not read as a macOS virtual machine. This step launches KA-Reader.app or reads this machine's home, and runs only in a macOS virtual machine (docs/nfdr.md QC-65)." >&2; exit 1; }

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="own-state.sh"
FIXTURES_REL="checks/fixtures"
LOG_SUFFIX="Library/Containers/com.kensaiapp.ka-reader/Data/Library/Logs/ka-reader.log"

work="$(mktemp -d)"
cleanup() {
  rm -rf "$work"
}
trap cleanup EXIT

failed=0

# Every folder the paths listed in file $1 imply: "a/b/c" implies "a" and "a/b".
implied_folders() {
  awk '{
    count = split($0, parts, "/")
    prefix = ""
    for (index_ = 1; index_ < count; index_++) {
      prefix = prefix (index_ > 1 ? "/" : "") parts[index_]
      print prefix
    }
  }' "$1"
}

# The expected set of fixture $1, one path per line relative to checks/fixtures/, sorted.
expected_set() {
  name="$1"
  git -C "$ROOT" ls-tree -r --name-only HEAD -- "$FIXTURES_REL/$name" \
    | sed "s|^$FIXTURES_REL/||" > "$work/tracked"
  {
    cat "$work/tracked"
    implied_folders "$work/tracked"
    archive="$ROOT/$FIXTURES_REL/$name.git.tar"
    if [ -f "$archive" ]; then
      echo "$name/.git"
      tar -tf "$archive" | sed -e 's|/$||' -e "s|^|$name/|" > "$work/archived"
      cat "$work/archived"
      # tar -tf lists no member for a folder the archive only implies, e.g. submodule/submodule.
      implied_folders "$work/archived"
    fi
  } | LC_ALL=C sort -u
}

# The actual set of fixture $1, walked without following links, relative to checks/fixtures/.
actual_set() {
  (cd "$ROOT/$FIXTURES_REL" && find "$1" -mindepth 1) | LC_ALL=C sort -u
}

# --- condition 1 ---

log_path="$HOME/$LOG_SUFFIX"
if [ ! -f "$log_path" ]; then
  echo "$NAME: condition 1 failed: no log file at $log_path" >&2
  failed=1
fi

# --- condition 2 ---

for fixture_dir in "$ROOT/$FIXTURES_REL"/*/; do
  [ -d "$fixture_dir" ] || continue
  fixture="$(basename "$fixture_dir")"
  expected_set "$fixture" > "$work/expected"
  actual_set "$fixture" > "$work/actual"
  comm -23 "$work/actual" "$work/expected" > "$work/extra"
  while IFS= read -r extra_entry; do
    echo "$NAME: condition 2 failed: extra entry under checks/fixtures: $extra_entry" >&2
    failed=1
  done < "$work/extra"
done

# --- condition 3 ---

uncommitted="$(git -C "$ROOT" status --porcelain -- "$FIXTURES_REL")"
if [ -n "$uncommitted" ]; then
  echo "$NAME: condition 3 failed: git status --porcelain $FIXTURES_REL is not empty:" >&2
  printf '%s\n' "$uncommitted" >&2
  failed=1
fi

if [ "$failed" -ne 0 ]; then
  exit 1
fi
echo "own state holds"

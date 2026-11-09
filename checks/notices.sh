#!/usr/bin/env bash
# Version: 1.0.0 — first version: every name `cargo tree` reports, found whole in THIRD_PARTY_NOTICES.md
#
# checks/notices.sh — proves the notices file names everything the product is built from.
#
# WHY THIS EXISTS
#   The product is released under a licence that obliges it to carry its third-party notices
#   (docs/nfdr.md QC-41). What it is built from is what could outgrow them. The names `cargo tree`
#   reports are compared with the notices file: a name in the tree that the file does not hold, as a
#   whole name, fails, and every such name is named.
#
# USAGE
#   checks/notices.sh
#   Run from the product root, which is the directory it reads THIRD_PARTY_NOTICES.md from. Exit 0 when
#   every name is present, printing one line that holds the count. Exit 1, naming each missing name on
#   stderr, when a name is missing, or when the notices file cannot be read, `cargo tree` ends
#   non-zero, or it reports no name: in each of those the check could not compare, and one line says
#   which. Exit 2 when given an argument. INT ends it with 130 and TERM with 143; a signal that lands
#   inside a command substitution may end it with 1. It never ends with 0 on a signal.
#
# THE NAME SET IS CHECKS/NO-NETWORK.SH'S
#   The same `cargo tree` argument list, with both Apple-Darwin triples named, and the same reading of
#   it: blank lines and `[…]` section lines dropped, the first field kept, sorted by byte. The set is
#   copied here and not shared, so checks/no-network.sh stays as it is (a reviewer of a change to one
#   list holds the other).
#
# A NAME IS PRESENT ONLY AS A WHOLE TOKEN
#   The notices file is split at every byte outside [A-Za-z0-9_-], and a name is present exactly when
#   it is one of those tokens, in its own case. `regex` is not found inside `regex-automata`.
#
# NO FILE IS WRITTEN, AND NOTHING BUT PATH IS READ
#   Both lists are held in variables and handed to `comm` through process substitution. There is no
#   temporary file, no heredoc and no here-string, since bash 3.2 writes the body of either to a
#   temporary file. The script reads no variable of its own: `cargo` is found through PATH, which is
#   how a test stands a tree in for the real one (docs/nfdr.md QC-67).

set -euo pipefail

trap 'exit 130' INT
trap 'exit 143' TERM

NOTICES_FILE="THIRD_PARTY_NOTICES.md"

# --- args ---

if [ "$#" -ne 0 ]; then
  echo "notices.sh: takes no argument; arguments given: $#. Usage: run checks/notices.sh from the repository's root." >&2
  exit 2
fi

# --- the notices file ---

directory="$(pwd)"
if [ ! -f "$NOTICES_FILE" ] || [ ! -r "$NOTICES_FILE" ]; then
  echo "notices.sh: cannot read $NOTICES_FILE in $directory, so nothing was checked. Run checks/notices.sh from the root of a KA-Reader checkout that has that file." >&2
  exit 1
fi

# --- the names in the tree ---

# cargo's own stderr is discarded, so a failure or a warning never adds a line. `cargo` is found
# through PATH, as checks/no-network.sh finds it.
cargo_status=0
cargo_tree="$(cargo tree --workspace --locked --offline --prefix none \
  --target aarch64-apple-darwin --target x86_64-apple-darwin 2> /dev/null)" || cargo_status=$?
if [ "$cargo_status" -ne 0 ]; then
  echo "notices.sh: cargo tree ended with status $cargo_status, so nothing was checked. Run cargo tree --workspace --locked --offline --prefix none --target aarch64-apple-darwin --target x86_64-apple-darwin in $directory to see its own message." >&2
  exit 1
fi

# The name is the first field; the version and cargo's `(*)` dedup marker are dropped, and so are the
# blank lines between workspace members and the `[…]` section lines.
names="$(printf '%s\n' "$cargo_tree" | awk 'NF && $1 !~ /^\[/ { print $1 }' | LC_ALL=C sort -u)"
if [ -z "$names" ]; then
  echo "notices.sh: cargo tree printed no name, so nothing was checked. Run cargo tree --workspace --locked --offline --prefix none --target aarch64-apple-darwin --target x86_64-apple-darwin in $directory to see what it prints." >&2
  exit 1
fi

# --- the comparison ---

# A name is present exactly when it is one of the tokens the file splits into at every byte outside
# [A-Za-z0-9_-]. Both lists are byte-sorted, which `comm` needs, and reach it without a file.
tokens="$(LC_ALL=C tr -cs 'A-Za-z0-9_-' '\n' < "$NOTICES_FILE" | LC_ALL=C sort -u)"
missing="$(LC_ALL=C comm -23 <(printf '%s\n' "$names") <(printf '%s\n' "$tokens"))"
if [ -n "$missing" ]; then
  printf '%s\n' "$missing" | awk '{ print "notices.sh: " $0 " — in cargo tree and not in THIRD_PARTY_NOTICES.md" }' >&2
  exit 1
fi

count="$(printf '%s\n' "$names" | wc -l | tr -d ' ')"
echo "notices.sh: $count names in cargo tree, each in THIRD_PARTY_NOTICES.md"

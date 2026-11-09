#!/usr/bin/env bash
# Version: 1.1.0 — the second rule: every copyright line the licence files of the packages in the name set state stands in that component's entry of THIRD_PARTY_NOTICES.md
# Version: 1.0.0 — first version: every name `cargo tree` reports, found whole in THIRD_PARTY_NOTICES.md
#
# checks/notices.sh — proves the notices file names everything the product is built from, and carries
# the copyright lines of the packages it is built from.
#
# WHY THIS EXISTS
#   The product is released under a licence that obliges it to carry its third-party notices
#   (docs/nfdr.md QC-41). What it is built from is what could outgrow them. The names `cargo tree`
#   reports are compared with the notices file: a name in the tree that the file does not hold, as a
#   whole name, fails, and every such name is named. Then each package in that set is asked of
#   `cargo metadata` where its sources are, and every copyright line its licence files state must stand
#   in that component's entry of the notices file: a line that does not fails, and every such line is
#   named, with the component and the licence file it came from.
#
# WHAT IT HOLDS, AND WHAT IT DOES NOT
#   It holds the names, and the copyright lines of every package in the name set. It does not hold the
#   libraries' and the icon set's lines, `NOTICE` files, the sentences that say a component has no
#   licence file or no copyright line, or the licences themselves; review holds those.
#
# USAGE
#   checks/notices.sh
#   Run from the product root, which is the directory it reads THIRD_PARTY_NOTICES.md from. Exit 0 when
#   every name is present and every copyright line is carried, printing one line that holds the count.
#   Exit 1, naming each missing name and then each copyright line not carried on stderr, when either is
#   missing. Exit 1 too, with one line that says which, when the check could not compare: the notices
#   file cannot be read, `cargo tree` ends non-zero or reports no name, `cargo metadata` ends non-zero,
#   a package in the set cannot be located in what it printed, or a licence file cannot be read. Exit 2
#   when given an argument. INT ends it with 130 and TERM with 143; a signal that lands inside a command
#   substitution may end it with 1. It never ends with 0 on a signal.
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
# THE ORDER OF A RUN
#   The argument count; the notices file; `cargo tree` and a name set that is not empty; `cargo
#   metadata`; the place of every package in the set; every licence file; and only then the comparison.
#   A finding is printed after every one of those has passed, so a refusal is always the run's one line.
#
# THE PACKAGES, THEIR LICENCE FILES AND THEIR COPYRIGHT LINES
#   The packages are read from `cargo metadata` for the two Apple-Darwin triples. It is parsed here as
#   text, since bash 3.2 has no JSON tool, and fails closed: a package object is the only object that
#   opens {"name":"<name>","version":"<version>","id":", it is paired with the first "manifest_path"
#   after it, and a JSON string is never unescaped, so a path that holds a backslash is refused. A name
#   and version the tree lists with no package object is refused; the working directory is never read
#   in its place. Two versions of one name are two packages.
#   A licence file is a regular file directly in the package's root whose name, in any case, holds
#   `licen`, `copying` or `copyright`, and the file the package's license_file names. A directory, a file
#   below the root and a NOTICE file are not one. A copyright line is a line with the spaces, tabs and
#   carriage returns before and after it removed that opens with `Copyright` and is not a placeholder, or
#   opens with `COPYRIGHT`, `©`, `(c)` or `(C)` and holds a run of four digits. A placeholder holds no
#   run of four digits and holds a bracketed span: [...], {...} or <...>.
#   A line is carried when a line of its component's entry is byte for byte the same, outer spaces, tabs
#   and carriage returns apart. An entry runs from its `### ` heading, the component's name in backticks,
#   to the line before the next `## ` or `### ` heading outside a fenced block, or to the end of the
#   file; only the first heading of a name is read.
#
# NO FILE IS WRITTEN, AND NOTHING BUT PATH IS READ
#   Every list is held in a variable and handed on through a pipe or process substitution. There is no
#   temporary file, no heredoc and no here-string, since bash 3.2 writes the body of either to a
#   temporary file. The script reads no variable of its own: `cargo` is found through PATH, which is
#   how a test stands a tree in for the real one (docs/nfdr.md QC-67). Every comparison and sort runs
#   under LC_ALL=C.

set -euo pipefail

trap 'exit 130' INT
trap 'exit 143' TERM

NOTICES_FILE="THIRD_PARTY_NOTICES.md"
TAB=$'\t'
NEWLINE=$'\n'
METADATA_COMMAND="cargo metadata --locked --offline --format-version 1 --filter-platform aarch64-apple-darwin --filter-platform x86_64-apple-darwin"

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

# A name is present exactly when it is one of the tokens the file splits into at every byte outside
# [A-Za-z0-9_-]. Both lists are byte-sorted, which `comm` needs, and reach it without a file. The names
# that are missing are printed with the findings, after the refusals below have been ruled out.
tokens="$(LC_ALL=C tr -cs 'A-Za-z0-9_-' '\n' < "$NOTICES_FILE" | LC_ALL=C sort -u)"
missing="$(LC_ALL=C comm -23 <(printf '%s\n' "$names") <(printf '%s\n' "$tokens"))"

# --- the places of the packages ---

metadata_status=0
cargo_metadata="$(cargo metadata --locked --offline --format-version 1 \
  --filter-platform aarch64-apple-darwin --filter-platform x86_64-apple-darwin 2> /dev/null)" || metadata_status=$?
if [ "$metadata_status" -ne 0 ]; then
  echo "notices.sh: cargo metadata ended with status $metadata_status, so the packages' sources could not be located and nothing was checked. Run $METADATA_COMMAND in $directory to see its own message." >&2
  exit 1
fi

# One record for each package object, in the order cargo printed them: name, version, license_file
# (`null`, or `s:` and the string as printed) and manifest_path (`p:` and the string as printed). Only
# three things are looked for: the opening of a package object, its license_file and its manifest_path.
# A dependency object opens {"name":…,"source": and a target object {"kind":, so neither is mistaken for
# a package, and the `resolve` section after the packages opens none. A string is read to its closing
# quote, a backslash and the character after it passing as one, and is never unescaped.
packages="$(printf '%s\n' "$cargo_metadata" | LC_ALL=C awk '
  {
    rest = $0
    have = 0
    while (match(rest, /[{]"name":"[^"]*","version":"[^"]*","id":"|"license_file":(null|"([^"\\]|\\.)*")|"manifest_path":"([^"\\]|\\.)*"/)) {
      token = substr(rest, RSTART, RLENGTH)
      rest = substr(rest, RSTART + RLENGTH)
      if (substr(token, 1, 2) == "{\"") {
        split(token, part, "\"")
        name = part[4]
        version = part[8]
        license_file = ""
        have = 1
      } else if (have && substr(token, 1, 15) == "\"license_file\":" && license_file == "") {
        license_file = substr(token, 16)
        license_file = (license_file == "null") ? "null" : "s:" substr(license_file, 2, length(license_file) - 2)
      } else if (have && substr(token, 1, 15) == "\"manifest_path\"") {
        manifest = substr(token, 18, length(token) - 18)
        print name "\t" version "\t" (license_file == "" ? "null" : license_file) "\tp:" manifest
        have = 0
      }
    }
  }
')"

# Every name and version the tree lists, in byte order: two versions of one name are two packages, and
# the leading `v` of a version is dropped.
pairs="$(printf '%s\n' "$cargo_tree" | awk 'NF && $1 !~ /^\[/ { version = $2; sub(/^v/, "", version); print $1 "\t" version }' | LC_ALL=C sort -u)"

# Each pair with the package object that has its name and version, the first if there are several, or
# `none`. A field is never empty, since `read` would run the tabs on.
joined="$(LC_ALL=C awk -F"$TAB" -v OFS="$TAB" '
  FNR == NR {
    key = $1 FS $2
    if (!(key in license_file)) {
      license_file[key] = $3
      manifest[key] = $4
    }
    next
  }
  {
    key = $1 FS $2
    if (key in license_file) print $1, $2, "found", license_file[key], manifest[key]
    else print $1, $2, "none", "-", "p:-"
  }
' <(printf '%s\n' "$packages") <(printf '%s\n' "$pairs"))"

# Every package is located before any licence file is read. The first that cannot be, in byte order, is
# the one named. A package's root is the directory of its manifest_path, and the working directory is
# never read in its place: a path with no directory part is not a directory here.
located=""
while IFS="$TAB" read -r name version state license_file manifest; do
  if [ "$state" = "none" ]; then
    echo "notices.sh: found no package for $name $version in what cargo metadata printed, so the packages' sources could not be located and nothing was checked. Run $METADATA_COMMAND in $directory and look for $name in what it prints." >&2
    exit 1
  fi
  manifest="${manifest#p:}"
  case "$manifest" in
    *\\*)
      echo "notices.sh: the path cargo metadata printed for $name's package holds a backslash, which this check does not read, so the packages' sources could not be located and nothing was checked. Run $METADATA_COMMAND in $directory to see the path it prints for $name." >&2
      exit 1
      ;;
  esac
  root="${manifest%/*}"
  if [ ! -d "$root" ]; then
    echo "notices.sh: cargo metadata placed $name's package at $root, and that is not a directory, so the packages' sources could not be located and nothing was checked. Check what is at $root, then run checks/notices.sh again." >&2
    exit 1
  fi
  located="$located$name$TAB$version$TAB$root$TAB$license_file$NEWLINE"
done < <(printf '%s\n' "$joined")

# --- the licence files ---

# One record for each copyright line a licence file states: component, file, version, line number, line.
records=""
while IFS="$TAB" read -r name version root license_file; do
  [ -n "$name" ] || continue
  files=""
  for path in "$root"/* "$root"/.[!.]*; do
    [ -f "$path" ] || continue
    file="${path##*/}"
    case "$file" in
      *[Ll][Ii][Cc][Ee][Nn]*|*[Cc][Oo][Pp][Yy][Ii][Nn][Gg]*|*[Cc][Oo][Pp][Yy][Rr][Ii][Gg][Hh][Tt]*)
        files="$files$file$NEWLINE"
        ;;
    esac
  done
  # The file the package's license_file names, when it is a regular file directly in the root. A name
  # that holds a backslash is a JSON string this check does not unescape, so the file is not read and
  # the run is refused rather than a licence file passed over.
  case "$license_file" in
    s:*)
      named="${license_file#s:}"
      case "$named" in
        *\\*)
          echo "notices.sh: cannot read $named in $name's package, so nothing was checked. Check that $root/$named can be read, then run checks/notices.sh again." >&2
          exit 1
          ;;
        */*) ;;
        *) if [ -f "$root/$named" ]; then files="$files$named$NEWLINE"; fi ;;
      esac
      ;;
  esac
  files="$(printf '%s' "$files" | LC_ALL=C sort -u)"
  while IFS= read -r file; do
    [ -n "$file" ] || continue
    path="$root/$file"
    read_status=0
    lines_found=""
    if [ -r "$path" ]; then
      lines_found="$(LC_ALL=C awk -v name="$name" -v file="$file" -v version="$version" '
        function four_digits(text) { return text ~ /[0-9][0-9][0-9][0-9]/ }
        function placeholder(text) {
          return !four_digits(text) && (text ~ /\[[^]]*]/ || text ~ /[{][^}]*[}]/ || text ~ /<[^>]*>/)
        }
        function copyright_line(text) {
          if (substr(text, 1, 9) == "Copyright") return !placeholder(text)
          # "\302\251" is the two bytes of the copyright sign.
          if (substr(text, 1, 9) == "COPYRIGHT" || substr(text, 1, 2) == "\302\251" || substr(text, 1, 3) == "(c)" || substr(text, 1, 3) == "(C)") return four_digits(text)
          return 0
        }
        {
          text = $0
          gsub(/^[ \t\r]+/, "", text)
          gsub(/[ \t\r]+$/, "", text)
          if (copyright_line(text)) print name "\t" file "\t" version "\t" FNR "\t" text
        }
      ' "$path" 2> /dev/null)" || read_status=$?
    else
      read_status=1
    fi
    if [ "$read_status" -ne 0 ]; then
      echo "notices.sh: cannot read $file in $name's package, so nothing was checked. Check that $path can be read, then run checks/notices.sh again." >&2
      exit 1
    fi
    if [ -n "$lines_found" ]; then
      records="$records$lines_found$NEWLINE"
    fi
  done < <(printf '%s\n' "$files")
done < <(printf '%s' "$located")

# --- the comparison ---

# The lines of each component's entry, tagged E; the names the name check reports missing, tagged M,
# which get no copyright-miss line; and the copyright lines found, tagged R. The one awk that reads the
# three streams keeps each line that is not carried, once per component, file, version and line, and
# `sort` orders them by component, file, version and line number.
copyright_misses="$({
  LC_ALL=C awk '
    function trim(text) {
      gsub(/^[ \t\r]+/, "", text)
      gsub(/[ \t\r]+$/, "", text)
      return text
    }
    {
      line = $0
      if (substr(line, 1, 3) == "```") {
        in_fence = !in_fence
      } else if (!in_fence && (substr(line, 1, 3) == "## " || substr(line, 1, 4) == "### ")) {
        current = ""
        if (line ~ /^### `[^`]+`[ \t\r]*$/) {
          name = line
          sub(/^### `/, "", name)
          sub(/`[ \t\r]*$/, "", name)
          if (!(name in seen)) {
            seen[name] = 1
            current = name
          }
        }
      } else if (current != "") {
        print "E\t" current "\t" trim(line)
      }
    }
  ' "$NOTICES_FILE"
  printf '%s\n' "$missing" | awk 'NF { print "M\t" $0 }'
  printf '%s' "$records" | awk 'NF { print "R\t" $0 }'
} | LC_ALL=C awk -F"$TAB" '
  $1 == "E" { carried[$2 FS substr($0, length($1 FS $2 FS) + 1)] = 1; next }
  $1 == "M" { not_a_name[$2] = 1; next }
  $1 == "R" {
    name = $2
    line = substr($0, length($1 FS $2 FS $3 FS $4 FS $5 FS) + 1)
    if (name in not_a_name) next
    if ((name FS line) in carried) next
    key = name FS $3 FS $4 FS line
    if (key in reported) next
    reported[key] = 1
    print name "\t" $3 "\t" $4 "\t" $5 "\t" line
  }
' | LC_ALL=C sort -t "$TAB" -k1,1 -k2,2 -k3,3 -k4,4n)" || exit 1

if [ -n "$missing" ] || [ -n "$copyright_misses" ]; then
  if [ -n "$missing" ]; then
    printf '%s\n' "$missing" | awk '{ print "notices.sh: " $0 " — in cargo tree and not in THIRD_PARTY_NOTICES.md" }' >&2
  fi
  if [ -n "$copyright_misses" ]; then
    printf '%s\n' "$copyright_misses" | awk -F"$TAB" '{ print "notices.sh: " $1 " — copyright line in " $2 " and not in its THIRD_PARTY_NOTICES.md entry: " substr($0, length($1 FS $2 FS $3 FS $4 FS) + 1) }' >&2
  fi
  exit 1
fi

count="$(printf '%s\n' "$names" | wc -l | tr -d ' ')"
echo "notices.sh: $count names in cargo tree, each in THIRD_PARTY_NOTICES.md"

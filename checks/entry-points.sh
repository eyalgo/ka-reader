#!/usr/bin/env bash
# Version: 1.0.0 — first version: the reads of the linked dependency tree's environment and
# arguments, diffed against the reviewed checks/entry-points.allow
#
# checks/entry-points.sh — proves every environment or argument read in the linked dependency tree
# is a named, reviewed member of the boundary set.
#
# WHY THIS EXISTS
#   The product promises it reads nothing from its surroundings beyond what it was given
#   (docs/fdr.md R-2; NFDR QC-30). The crates the bridge links are code nobody here wrote, and one
#   that reads the environment or its arguments changes what the shipped process does. This script
#   finds those reads in every crate the bridge resolves from outside the workspace and compares
#   them, by crate and name, with checks/entry-points.allow, the one list a reviewer has read. A
#   read the list does not hold fails; so does a line the scan no longer finds, so the list cannot
#   go stale unnoticed. A crate whose files cannot be read fails too, because a scan that skips it
#   passes it silently. The script only diffs. Whether a listed read is acceptable, and whether its
#   explanation is true, is a person's call at the review of the list; the script checks the
#   explanation is not empty and no more.
#
# USAGE
#   checks/entry-points.sh Takes no argument and reads the product root it sits in. Exit 0 with
#   empty stderr and one stdout line counting the crates scanned, the workspace members skipped and
#   the reads matched. Otherwise exit 1 and one finding per line on stderr, each prefixed
#   `entry-points.sh: ` and in one of four shapes, in this order (by kind, crate, name, line):
#     malformed: line <n>: <which fault of the list line>
#     stale: <crate> <name>
#     unlisted: <crate> <name> <file, relative to the package directory>
#     unreadable: <crate> <what could not be opened or read>
#   A crate set that cannot be resolved ends the run first, with no finding:
#     entry-points.sh: the crate set could not be resolved: <cause>
#   as does a list that is missing or holds no entry line.
#
# THE TWO SEAMS
#   `cargo` is found through PATH, so a test can stand a stub in for it. ENTRY_POINTS_ALLOW_FILE
#   overrides the list's path, which defaults to checks/entry-points.allow under the product root.
#   No other environment variable changes what is read: none names a registry, a crate or a skip.
#
# THE CRATE SET
#   The packages `cargo tree -p nozoki-bridge --target aarch64-apple-darwin -e normal --locked`
#   prints (the command QC-30 fixes), with presentation flags only. `nozoki-bridge` here is the
#   set's root and no skip. Each is joined by name and version to a package of
#   `cargo metadata --format-version 1 --locked --filter-platform aarch64-apple-darwin`. A package
#   whose id is one of the metadata's workspace_members is skipped: membership is the test, and no
#   crate name is a skip. Every other package is scanned in the directory holding its manifest,
#   whatever its source. A package that joins to none or to several is unreadable, and is never
#   skipped. The metadata is read with plutil, which ships with macOS and reads JSON; plutil absent
#   or failing ends the run.
#
# WHAT IS READ
#   Every file under a scanned crate's package directory, at any depth and whatever its extension,
#   in its raw text: a read counts in code, in a comment, in a string and in prose. A read is one of
#   the six names env::var, env::var_os, env::vars, env::vars_os, env::args and env::args_os,
#   matched as a whole word after `env::`, with no boundary before `env`, so `myenv::var` counts. A
#   name listed inside
#   `env::{ ... }` is a read of that name, across line breaks. A read is the pair (crate, name); two
#   resolved versions of one crate share their reads. One file is excepted and is not opened: the
#   crate's build script, which is the `build` key of the [package] table of that package's own
#   Cargo.toml (a string names the file, `false` excepts nothing, no key means build.rs at the
#   package root if it exists, and a key in any other form excepts nothing). Files that script pulls
#   in are read.
#
# WHAT IS NOT HELD
#   Named so that none is read as coverage:
#     - code a build script generates into OUT_DIR and a shipped crate `include!`s;
#     - a glob import followed by a bare call (`use std::env::*;` then `var(...)`);
#     - a C `getenv`;
#     - `env!` and `option_env!`, which read the build's environment;
#     - the reads the operating system's frameworks make inside the process.
#
# THE LIST
#   checks/entry-points.allow, one line per read: `<crate> | <name> | <what the read changes>`. See
#   the list's own header for the line format, the malformed rule and what a reviewer checks.
#
# `set -e` is on, so every grep that may match nothing carries `|| true`, and a guard follows it.

set -euo pipefail

die() { echo "entry-points.sh: $*" >&2; exit 1; }
unresolved() { die "the crate set could not be resolved: $*"; }

TAB="$(printf '\t')"
SIX_NAMES="var var_os vars vars_os args args_os"

root="$(cd "$(dirname "$0")/.." && pwd -P)"
allow_file="${ENTRY_POINTS_ALLOW_FILE:-$root/checks/entry-points.allow}"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# One finding per line, tab separated, so a sort orders them: kind, crate, name, line, message.
findings="$work/findings.tsv"
: > "$findings"

report_unreadable() {
  printf 'unreadable\t%s\t%s\t0\tunreadable: %s %s\n' "$1" "$2" "$1" "$2" >> "$findings"
  printf '%s\n' "$1" >> "$work/unreadable.names"
}
: > "$work/unreadable.names"

# --- the list ---

[ -f "$allow_file" ] || die "the reviewed list is missing: $allow_file"

# Lines to the well-formed pairs and the malformed findings. A malformed line takes no part in the
# diff, and a repeat is judged against the earlier well-formed lines, which stand.
awk -v names="$SIX_NAMES" -v tab="$TAB" -v good="$work/list.pairs" -v bad="$findings" -v count="$work/list.entries" '
  function trim(text) { gsub(/^[[:space:]]+|[[:space:]]+$/, "", text); return text }
  BEGIN {
    split(names, short, " ")
    for (i in short) six["env::" short[i]] = 1
    printf "" > good
  }
  {
    stripped = $0
    gsub(/^[[:space:]]+/, "", stripped)
    if (stripped == "" || substr(stripped, 1, 1) == "#") next
    entries++
    crate = ""; name = ""; text = ""
    rest = $0
    p = index(rest, "|")
    if (p == 0) { crate = rest }
    else {
      crate = substr(rest, 1, p - 1); rest = substr(rest, p + 1)
      q = index(rest, "|")
      if (q == 0) { name = rest } else { name = substr(rest, 1, q - 1); text = substr(rest, q + 1) }
    }
    crate = trim(crate); name = trim(name); text = trim(text)
    fault = ""
    if (crate == "") fault = "lacks its crate"
    else if (name == "") fault = "lacks its name"
    else if (text == "") fault = "lacks its what-it-changes text"
    else if (!(name in six)) fault = "names " name ", which is none of the six read names"
    else if ((crate SUBSEP name) in seen) fault = "repeats the crate and name of line " seen[crate SUBSEP name]
    if (fault != "") {
      printf "malformed\t\t\t%d\tmalformed: line %d: %s\n", NR, NR, fault >> bad
    } else {
      seen[crate SUBSEP name] = NR
      print crate tab name >> good
    }
  }
  END { print entries + 0 > count }
' "$allow_file"
[ "$(cat "$work/list.entries")" -gt 0 ] || die "the reviewed list holds no entry line: $allow_file"

# --- the crate set ---

command -v plutil > /dev/null 2>&1 || unresolved "plutil is not on PATH, so the metadata cannot be read"

# The tree is printed as `<name> v<version> ...`; a repeat, and Cargo's `(*)` marker, collapse to
# one line.
status=0
(cd "$root" && cargo tree -p nozoki-bridge --target aarch64-apple-darwin -e normal --locked --prefix none --format '{p}') \
  > "$work/tree.out" 2> "$work/tree.err" || status=$?
[ "$status" -eq 0 ] || unresolved "cargo tree exited $status: $(head -n 1 "$work/tree.err")"
awk -v tab="$TAB" 'NF >= 2 && $2 ~ /^v[0-9]/ { print $1 tab substr($2, 2) }' "$work/tree.out" | LC_ALL=C sort -u > "$work/set.tsv"
[ -s "$work/set.tsv" ] || unresolved "cargo tree printed no crate"

status=0
(cd "$root" && cargo metadata --format-version 1 --locked --filter-platform aarch64-apple-darwin) \
  > "$work/metadata.json" 2> "$work/metadata.err" || status=$?
[ "$status" -eq 0 ] || unresolved "cargo metadata exited $status: $(head -n 1 "$work/metadata.err")"
plutil -p "$work/metadata.json" > "$work/metadata.txt" 2> "$work/plutil.err" \
  || unresolved "plutil could not read the metadata: $(head -n 1 "$work/plutil.err")"
[ "$(head -n 1 "$work/metadata.txt")" = "{" ] || unresolved "the metadata is not a JSON object"

# plutil prints the object with its keys sorted, one per line, indented by depth: a package's own
# keys sit at six spaces, a workspace member at four.
awk -v tab="$TAB" -v packages="$work/packages.tsv" -v members="$work/members.txt" '
  function unquote(text) { sub(/^[^=]*=> "/, "", text); sub(/"$/, "", text); return text }
  function flush() { if (name != "") print name tab version tab id tab manifest >> packages; name = ""; version = ""; id = ""; manifest = "" }
  BEGIN { printf "" > packages; printf "" > members }
  /^  "[a-z_]+" => / { flush(); section = $0; sub(/^  "/, "", section); sub(/".*/, "", section); next }
  section == "packages" && /^    [0-9]+ => \{$/ { flush(); next }
  section == "packages" && /^      "name" => "/ { name = unquote($0) }
  section == "packages" && /^      "version" => "/ { version = unquote($0) }
  section == "packages" && /^      "id" => "/ { id = unquote($0) }
  section == "packages" && /^      "manifest_path" => "/ { manifest = unquote($0) }
  section == "workspace_members" && /^    [0-9]+ => "/ { print unquote($0) >> members }
  END { flush() }
' "$work/metadata.txt"

# Each set member to its package: M a workspace member, S a package to scan, X one that joins to
# none or to several. Membership is decided on the package id, before any directory is opened.
awk -v tab="$TAB" -v members="$work/members.txt" -v packages="$work/packages.tsv" '
  FILENAME == members { member[$0] = 1; next }
  FILENAME == packages {
    split($0, field, tab); key = field[1] tab field[2]
    held[key]++; id[key] = field[3]; manifest[key] = field[4]
    next
  }
  {
    split($0, field, tab); key = field[1] tab field[2]
    if (held[key] == 1 && (id[key] in member)) print "M" tab field[1] tab field[2] tab "member"
    else if (held[key] == 1) print "S" tab field[1] tab field[2] tab manifest[key]
    else if (held[key] == 0) print "X" tab field[1] tab field[2] tab "no package of that name and version in the metadata"
    else print "X" tab field[1] tab field[2] tab held[key] " packages of that name and version in the metadata"
  }
' "$work/members.txt" "$work/packages.tsv" "$work/set.tsv" > "$work/joined.tsv"

# --- the scan ---

# The build script of the package whose manifest is $1, as the package directory-relative path, or
# nothing. Read from the [package] table of that copy; a key in any form but a string or `false`
# excepts nothing.
build_script_of() {
  awk -v tab="$TAB" '
    /^[[:space:]]*\[/ { in_package = ($0 ~ /^[[:space:]]*\[package\][[:space:]]*(#.*)?$/); next }
    in_package && /^[[:space:]]*"?build"?[[:space:]]*=/ {
      found = 1
      value = $0; sub(/^[^=]*=[[:space:]]*/, "", value)
      if (value ~ /^"[^"]*"[[:space:]]*(#.*)?$/) { sub(/^"/, "", value); sub(/".*$/, "", value); kind = "string"; path = value }
      else if (value ~ /^\047[^\047]*\047[[:space:]]*(#.*)?$/) { sub(/^\047/, "", value); sub(/\047.*$/, "", value); kind = "string"; path = value }
      else if (value ~ /^false[[:space:]]*(#.*)?$/) { kind = "false" }
      else { kind = "other" }
    }
    END { if (!found) print "absent"; else if (kind == "string") print "string" tab path; else print kind }
  ' "$1"
}

# Appends the reads of crate $1 to the reads file, as crate, name, file. $2 is its manifest.
scan_crate() {
  crate="$1"
  manifest="$2"
  dir="$(dirname "$manifest")"

  if ! find "$dir" -type f -print0 > "$work/files.nul" 2> "$work/find.err"; then
    report_unreadable "$crate" "cannot open its package directory $dir"
    return 0
  fi

  excepted=""
  if [ -r "$manifest" ]; then
    spec="$(build_script_of "$manifest")"
    case "$spec" in
      string"$TAB"*)
        relative="${spec#string"$TAB"}"
        while [ "${relative#./}" != "$relative" ]; do relative="${relative#./}"; done
        excepted="$dir/$relative"
        ;;
      absent) [ ! -f "$dir/build.rs" ] || excepted="$dir/build.rs" ;;
    esac
  else
    report_unreadable "$crate" "cannot read its manifest $manifest"
  fi

  # A file that cannot be opened is a finding. The excepted build script is not opened at all.
  while IFS= read -r -d '' file; do
    [ "$file" != "$excepted" ] || continue
    if { : < "$file"; } 2> /dev/null; then
      printf '%s\0' "$file"
    else
      report_unreadable "$crate" "cannot read ${file#"$dir"/}"
    fi
  done < "$work/files.nul" > "$work/readable.nul"
  [ -s "$work/readable.nul" ] || return 0

  # One grep process over the whole directory. A name is read whole after `env::`; a group opener,
  # or an
  # `env::` that ends a line, sends its file to the second pass below.
  grep_status=0
  xargs -0 grep -a -o -H -E 'env::([A-Za-z0-9_]+|[[:space:]]*\{)|env::[[:space:]]*$' < "$work/readable.nul" \
    > "$work/grep.out" 2> "$work/grep.err" || grep_status=$?
  if [ -s "$work/grep.err" ]; then
    report_unreadable "$crate" "grep could not read its files: $(head -n 1 "$work/grep.err")"
    return 0
  fi

  awk -v crate="$crate" -v dir="$dir" -v names="$SIX_NAMES" -v tab="$TAB" -v reads="$work/reads.tsv" -v groups="$work/group.files" '
    BEGIN { split(names, short, " "); for (i in short) six[short[i]] = 1; printf "" > groups }
    {
      if (!match($0, /:env::([A-Za-z0-9_]+|[[:space:]]*\{?|[[:space:]]*)$/)) next
      path = substr($0, 1, RSTART - 1)
      found = substr($0, RSTART + 6)
      if (found ~ /^[A-Za-z0-9_]+$/) {
        if (found in six) print crate tab "env::" found tab substr(path, length(dir) + 2) >> reads
      } else {
        print path >> groups
      }
    }
  ' "$work/grep.out"

  # The grouped form, read with the file as one string so a group split over lines is seen.
  LC_ALL=C sort -u "$work/group.files" | while IFS= read -r file; do
    { tr '\000\r\n' '   ' < "$file" | grep -a -o -E 'env::[[:space:]]*\{[^}]*\}' | grep -a -o -E '[A-Za-z0-9_]+' || true; } \
      | awk -v crate="$crate" -v file="${file#"$dir"/}" -v names="$SIX_NAMES" -v tab="$TAB" -v reads="$work/reads.tsv" '
          BEGIN { split(names, short, " "); for (i in short) six[short[i]] = 1 }
          $0 in six { print crate tab "env::" $0 tab file >> reads }
        '
  done
}

: > "$work/reads.tsv"
scanned=0
skipped=0
while IFS="$TAB" read -r kind name version detail; do
  case "$kind" in
    M) skipped=$((skipped + 1)) ;;
    X) report_unreadable "$name" "$detail ($name v$version)" ;;
    S)
      scanned=$((scanned + 1))
      scan_crate "$name" "$detail"
      ;;
  esac
done < "$work/joined.tsv"

# --- the diff ---

# The first file in path order where each pair occurs is the file reported for it.
LC_ALL=C sort -t "$TAB" -k1,1 -k2,2 -k3,3 "$work/reads.tsv" | awk -F "$TAB" '!seen[$1 FS $2]++' > "$work/found.tsv"
LC_ALL=C sort -u "$work/unreadable.names" > "$work/unreadable.sorted"

awk -F "$TAB" -v good="$work/list.pairs" -v unreadable="$work/unreadable.sorted" -v found="$work/found.tsv" -v out="$findings" -v matched="$work/matched.count" '
  FILENAME == good { listed[$1 FS $2] = 1; next }
  FILENAME == unreadable { cannot[$1] = 1; next }
  { present[$1 FS $2] = 1; file[$1 FS $2] = $3; order[++n] = $1 FS $2 }
  END {
    for (i = 1; i <= n; i++) {
      key = order[i]; split(key, part, FS)
      if (key in listed) hits++
      else printf "unlisted\t%s\t%s\t0\tunlisted: %s %s %s\n", part[1], part[2], part[1], part[2], file[key] >> out
    }
    for (key in listed) {
      split(key, part, FS)
      if (!(key in present) && !(part[1] in cannot)) printf "stale\t%s\t%s\t0\tstale: %s %s\n", part[1], part[2], part[1], part[2] >> out
    }
    print hits + 0 > matched
  }
' "$work/list.pairs" "$work/unreadable.sorted" "$work/found.tsv"

if [ -s "$findings" ]; then
  LC_ALL=C sort -u -t "$TAB" -k1,1 -k2,2 -k3,3 -k4,4n "$findings" | cut -f 5- | sed 's/^/entry-points.sh: /' >&2
  exit 1
fi

echo "entry-points.sh: ok — $scanned crates scanned, $skipped members skipped, $(cat "$work/matched.count") reads matched"

#!/usr/bin/env bash
# Version: 1.0.0 — first version: the Rust source scan over crates/ — QC-9's unsafe clause
#
# checks/structure.sh — proves the Rust source holds the unit and import rules.
#
# WHY THIS EXISTS
#   The units may import only what docs/nfdr.md § 1.2 lets them, and a reviewer cannot keep watching a
#   tree for a name that does not belong in a file. This script reads it off the source, on every run
#   of CI. It reads text, never the compiler's view of it, so it needs no toolchain and no build.
#   Every rule matches the raw text of a file — code, string literals and comments alike, with no
#   comment blanked — because a forbidden name in a comment is cheap to remove and a scan that excused
#   it would have to be right about where a comment ends. The cost is a false positive when a comment
#   names a forbidden form, and that fails closed.
#
# USAGE
#   checks/structure.sh
#   No argument, and no environment variable: the product root is the parent of this script's own
#   directory, as checks/view.sh derives it, so a copy placed at <root>/checks/structure.sh reads
#   <root>.
#   A finding is one line on stderr — `<path relative to the root>:<line>: <QC-n>: <what>` — one per
#   distinct (clause, file, line), in path order and then line order. A pass is exit 0, empty stderr
#   and one stdout line: the count of files and crates read, and that nothing was found. Every other
#   ending is exit 1, and the script reads every file before it gives a verdict, so one run reports
#   every finding. It never passes having read nothing: no file in scope exits 1 with `no Rust source
#   was read` on stderr, and a file in scope that cannot be read exits 1 naming the file.
#
# WHAT IS READ
#   Every regular *.rs file at any depth under crates/<c>/, where <c> is any directory directly under
#   crates/, with or without a manifest: a crate added later is read with no edit here. <c> is the crate
#   name in every rule below. Two exclusions, both judged on the path relative to crates/<c>/: a file
#   whose first component is `tests`, and the file `build.rs` at that level. src/tests/x.rs and
#   src/build.rs are read.
#
# THE SCAN TABLE
#   A token is an identifier matched whole: a word character ([A-Za-z0-9_]) on either side means no
#   match, so `unsafe_code` is not `unsafe`. "QC-n" is docs/nfdr.md.
#     QC-9   unsafe       The token `unsafe`, in every use (block, fn, impl, extern, #[unsafe(…)]), in
#                         every crate except nozoki-bridge. Source: QC-9's "unsafe appearing in no
#                         crate but nozoki-bridge".
#
# WHAT IS NOT HELD
#   This version holds only the rules in the table above. Every other rule docs/nfdr.md names for
#   checks/structure.sh is NOT held here, and the NFDR's header sentence that each script's rules
#   become executable with the script is read as: a rule is executable from the change that adds it
#   here. Until then its gate is the design review. Not held: QC-2's write rule; QC-7; QC-10 – QC-12;
#   QC-13's imports; QC-14; QC-15's other owners and its socket clause; QC-17's Rust half; QC-20;
#   QC-30's and QC-58's first half; QC-61; § 9's layer-5 placement rule.

set -euo pipefail

die() { echo "structure.sh: $*" >&2; exit 1; }

product_root="$(cd "$(dirname "$0")/.." && pwd -P)"
crates_dir="$product_root/crates"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
: > "$work/findings"
: > "$work/causes"

# --- the scan program: one awk pass per file ---

cat > "$work/scan.awk" <<'AWK'
# One pass per file. The file is cut into tokens — identifiers as whole words, `::`, and every other
# non-blank character one by one — each with its line and a kind: k (code), c (comment) or s (string).
# Comments and strings are tokens like the rest, so the rules read raw text; the kind is kept so the
# structure of the code can be read without a comment's punctuation in it.

function push(text, ln, kind) {
  nt++
  tk[nt] = text
  tl[nt] = ln
  tkind[nt] = kind
}

function flush_word() {
  if (word != "") { push(word, wline, wkind); word = "" }
}

function put(c, ln, kind) {
  if (c ~ /[A-Za-z0-9_]/) {
    if (word == "") { wline = ln; wkind = kind }
    word = word c
  } else {
    flush_word()
    if (c !~ /[ \t\r]/) push(c, ln, kind)
  }
}

function emit_at(kind,    c) {
  c = substr(line, i, 1)
  if (c == ":" && substr(line, i + 1, 1) == ":") { flush_word(); push("::", ln, kind); i += 2 }
  else { put(c, ln, kind); i++ }
}

function note(ln, qc, what,    key) {
  key = ln SUBSEP qc
  if (!(key in found)) {
    found[key] = what
    if (ln > maxline) maxline = ln
  }
}

function add_unsafe(ln) {
  if (!is_bridge) note(ln, "QC-9", "`unsafe` outside nozoki-bridge")
}

function scan_stream(t, l, n,    k) {
  for (k = 1; k <= n; k++) {
    if (t[k] == "unsafe") add_unsafe(l[k])
  }
}

{
  ln = NR
  line = $0
  len = length(line)
  i = 1
  while (i <= len) {
    c = substr(line, i, 1)
    c2 = substr(line, i, 2)
    if (mode == "block") {
      if (c2 == "*/") { flush_word(); blk--; if (blk == 0) mode = "code"; i += 2 }
      else if (c2 == "/*") { flush_word(); blk++; i += 2 }
      else emit_at("c")
    }
    else if (mode == "str") {
      if (c == "\\") { flush_word(); i += 2 }
      else if (c == "\"") { flush_word(); push("\"", ln, "s"); mode = "code"; i++ }
      else emit_at("s")
    }
    else if (mode == "raw") {
      if (c == "\"" && substr(line, i + 1, rawhashes) == rawclose) { flush_word(); push("\"", ln, "s"); mode = "code"; i += 1 + rawhashes }
      else emit_at("s")
    }
    else {
      if (c2 == "//") { flush_word(); i += 2; while (i <= len) emit_at("c") }
      else if (c2 == "/*") { flush_word(); mode = "block"; blk = 1; i += 2 }
      else if (c == "\"") { flush_word(); push("\"", ln, "s"); mode = "str"; i++ }
      else if ((c == "r" || c == "b") && (i == 1 || substr(line, i - 1, 1) !~ /[A-Za-z0-9_]/) && match(substr(line, i), /^b?r#*"/)) {
        flush_word()
        rawtext = substr(line, i, RLENGTH)
        tmp = rawtext
        rawhashes = gsub(/#/, "", tmp)
        rawclose = ""
        for (q = 1; q <= rawhashes; q++) rawclose = rawclose "#"
        push("\"", ln, "s")
        mode = "raw"
        i += RLENGTH
      }
      else if (c == "'") {
        flush_word()
        if (substr(line, i + 1, 1) == "\\") {
          j = i + 3
          while (j <= len && substr(line, j, 1) != "'") j++
          i = j + 1
        }
        else if (substr(line, i + 2, 1) == "'" && substr(line, i + 1, 1) != "'") i += 3
        else emit_at("k")
      }
      else emit_at("k")
    }
  }
  flush_word()
}

END {
  nc = 0
  for (k = 1; k <= nt; k++) if (tkind[k] == "k") { nc++; ct[nc] = tk[k]; cl[nc] = tl[k] }
  scan_stream(tk, tl, nt)
  scan_stream(ct, cl, nc)
  split("QC-9 QC-15 QC-36", order, " ")
  for (ln = 1; ln <= maxline; ln++)
    for (q = 1; q <= 3; q++) {
      key = ln SUBSEP order[q]
      if (key in found) print rel ":" ln ": " order[q] ": " found[key]
    }
}
AWK

# --- the files in scope ---
# Exclusions are judged on the path relative to its crate, by components, never with a find pattern:
# find's `*` crosses `/` and -name matches at any depth, so either would drop src/tests/ and src/build.rs.

if [ -d "$crates_dir" ]; then
  for crate_dir in "$crates_dir"/*/; do
    [ -d "$crate_dir" ] || continue
    crate_dir="${crate_dir%/}"
    crate_name="$(basename "$crate_dir")"
    find "$crate_dir" -type f -name '*.rs' 2> /dev/null | while IFS= read -r rust_file; do
      within_crate="${rust_file#"$crate_dir"/}"
      case "$within_crate" in
        tests/* | build.rs) continue ;;
      esac
      printf '%s\n' "crates/$crate_name/$within_crate"
    done
  done | LC_ALL=C sort > "$work/files"
else
  : > "$work/files"
fi

file_count=0
if [ ! -s "$work/files" ]; then
  echo "no Rust source was read — no *.rs file in scope under crates/" >> "$work/causes"
else
  while IFS= read -r relative; do
    file_count=$((file_count + 1))
    crate_name="${relative#crates/}"
    crate_name="${crate_name%%/*}"
    is_bridge=0
    [ "$crate_name" = "nozoki-bridge" ] && is_bridge=1
    if [ ! -r "$product_root/$relative" ]; then
      echo "cannot read $relative" >> "$work/causes"
      continue
    fi
    LC_ALL=C awk -v rel="$relative" -v is_bridge="$is_bridge" \
      -f "$work/scan.awk" "$product_root/$relative" >> "$work/findings" \
      || echo "the scan could not read $relative" >> "$work/causes"
  done < "$work/files"
fi

crate_count=0
if [ -s "$work/files" ]; then
  crate_count="$(cut -d/ -f2 "$work/files" | LC_ALL=C sort -u | wc -l | tr -d ' ')"
fi

# --- the verdict ---

if [ -s "$work/findings" ] || [ -s "$work/causes" ]; then
  cat "$work/findings" >&2
  while IFS= read -r cause; do
    echo "structure.sh: $cause" >&2
  done < "$work/causes"
  exit 1
fi

echo "structure.sh: $file_count Rust files in $crate_count crates read — nothing found"

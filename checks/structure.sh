#!/usr/bin/env bash
# Version: 1.0.0 — first version: the Rust source scan over crates/ — QC-9's unsafe, Apple-framework and process clauses, QC-36's Rust half, QC-15's two filesystem owners
#
# checks/structure.sh — proves the Rust source holds the unit and import rules.
#
# WHY THIS EXISTS
#   The units may import only what docs/nfdr.md § 1.2 lets them, and a reviewer cannot keep
#   watching a tree for a name that does not belong in a file. This script reads it off the
#   source, on every run of CI. It reads text, never the compiler's view of it, so it needs no
#   toolchain and no build. Every rule matches the raw text of a file — code, string literals
#   and comments alike, with no comment blanked — because a forbidden name in a comment is cheap
#   to remove and a scan that excused it would have to be right about where a comment ends. The
#   cost is a false positive when a comment names a forbidden form, and that fails closed.
#
# USAGE
#   checks/structure.sh
#   No argument, and no environment variable: the product root is the parent of this script's
#   own directory, as checks/view.sh derives it, so a copy placed at <root>/checks/structure.sh
#   reads <root>.
#   A finding is one line on stderr — `<path relative to the root>:<line>: <QC-n>: <what>` — one
#   per distinct (clause, file, line), in path order and then line order. A pass is exit 0,
#   empty stderr and one stdout line: the count of files and crates read, and that nothing was
#   found. Every other ending is exit 1, and the script reads every file before it gives a
#   verdict, so one run reports every finding. It never passes having read nothing: no file in
#   scope exits 1 with `no Rust source was read` on stderr, and a file in scope that cannot be
#   read exits 1 naming the file.
#
# WHAT IS READ
#   Every regular *.rs file at any depth under crates/<c>/, where <c> is any directory directly
#   under crates/, with or without a manifest: a crate added later is read with no edit here.
#   <c> is the crate name in every rule below. Two exclusions, both judged on the path relative
#   to crates/<c>/: a file whose first component is `tests`, and the file `build.rs` at that
#   level. src/tests/x.rs and src/build.rs are read.
#
# THE SCAN TABLE
#   A token is an identifier matched whole: a word character ([A-Za-z0-9_]) on either side means
#   no match, so `unsafe_code` is not `unsafe`. "QC-n" is docs/nfdr.md.
#     QC-9   Apple        In nozoki-core only. The list of forms is a floor: this script may
#            framework    refuse more forms, never fewer. The attribute form
#                         `kind = "framework"`, with any whitespace (a newline included)
#                         around `=`. Each name below, in any of: a path root (`X::`, with no
#                         word character and no `::` before it — an absolute `::X::` counts,
#                         a `crate::X::` or `.X::<T>` does not), the crate of an
#                         `extern crate X`, or the first segment or a member of a `use` tree,
#                         the tree read across lines and nested. The names: objc, objc2, any
#                         objc2_*, objc_foundation, objc_id, block, block2, dispatch,
#                         dispatch2, cocoa, cocoa_foundation, core_foundation,
#                         core_foundation_sys, core_graphics, core_graphics_types, core_text,
#                         core_services, security_framework, security_framework_sys,
#                         system_configuration, system_configuration_sys, fsevent,
#                         fsevent_sys, io_kit_sys, metal. A name in a comment or a string is
#                         read as the path it spells. Source: QC-9's imports clause.
#     QC-36  process      In every crate: the path `std::process` — whitespace or newlines
#     QC-9   (in core)    around `::` change nothing, and the segment after it is the whole
#                         word, so `process_info` is not `process` — and a segment or member
#                         `process` in a `use` tree rooted at `std` or `::std`, the tree read
#                         across lines and nested, the finding at the member's own line. In
#                         nozoki-core the same occurrence is also a QC-9 finding, on the same
#                         line. Source: QC-36's Rust half, QC-9's process clause.
#     QC-15  filesystem   In every crate except in the two owner files,
#                         crates/nozoki-core/src/fs_reader.rs and
#                         crates/nozoki-bridge/src/log_writer.rs (matched by the exact path,
#                         so the same basename anywhere else is not exempt, and the exemption
#                         is for this clause only). The module `fs` in a path rooted at `std`
#                         or `rustix`, so `std::fs`, `std::os::<platform>::fs` and
#                         `rustix::fs`, whitespace or newlines around `::` changing nothing;
#                         and a segment or member `fs` in a `use` tree rooted at `std`,
#                         `::std` or `rustix`, read across lines and nested, the finding at
#                         the member's own line. A crate other than those two owns no
#                         filesystem primitive. `include_str!` and `include_bytes!` are
#                         compile-time inclusions and are not in the domain. The domain is
#                         widened to the C binding's flat file calls, because libc is on
#                         checks/deps.allow and a core file could otherwise reach `libc::open`
#                         unseen: a `libc::` path to, or a `use libc` tree member naming, one
#                         of open, openat, creat, fopen, fdopen, freopen, opendir, fdopendir,
#                         readdir, stat, lstat, fstat, fstatat, access, faccessat, mkdir,
#                         mkdirat, rmdir, unlink, unlinkat, rename, renameat, truncate,
#                         ftruncate, readlink, readlinkat, symlink, link, chmod, fchmod,
#                         chown, realpath. The fd-generic read, write and close are not
#                         named: by name they cannot be told from socket or pipe I/O.
#                         Source: QC-15's filesystem owners.
#     QC-9   unsafe       The token `unsafe`, in every use (block, fn, impl, extern,
#                         #[unsafe(…)]), in every crate except nozoki-bridge. Source: QC-9's
#                         "unsafe appearing in no crate but nozoki-bridge".
#
# WHAT IS NOT HELD
#   This version holds only the rules in the table above. Every other rule docs/nfdr.md names
#   for checks/structure.sh is NOT held here, and the NFDR's header sentence that each script's
#   rules become executable with the script is read as: a rule is executable from the change
#   that adds it here. Until then its gate is the design review. Not held: QC-2's write rule;
#   QC-7; QC-10 – QC-12; QC-13's imports; QC-14; QC-15's other owners and its socket clause;
#   QC-17's Rust half; QC-20; QC-30's and QC-58's first half; QC-61; § 9's layer-5 placement
#   rule.
#
# GAPS THE RULES ABOVE DO NOT CLOSE
#   Named so that none is read as coverage. The scan reads source text of the files in scope,
#   so it does not see: `std` reached through an alias (`use std as s;`,
#   `extern crate std as s;`); a `Path` method that touches the filesystem (exists, metadata,
#   read_dir, canonicalize), which names no filesystem module; a crate-level build.rs that
#   emits `cargo:rustc-link-lib=framework=…`, because build.rs is outside every rule; source
#   that is generated or pulled in by `include!`, or a `#[cfg(test)]` module whose body sits in
#   the excluded tests/ directory. A review catches these.

set -euo pipefail

product_root="$(cd "$(dirname "$0")/.." && pwd -P)"
crates_dir="$product_root/crates"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
: > "$work/findings"
: > "$work/causes"

# --- the scan program: one awk pass per file ---

cat > "$work/scan.awk" <<'AWK'
# One pass per file. The file is cut into tokens — identifiers as whole words, `::`, and every
# other non-blank character one by one — each with its line and a kind: k (code), c (comment) or
# s (string). Comments and strings are tokens like the rest, so the rules read raw text; the kind
# is kept so the structure of the code can be read without a comment's punctuation in it.

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

function note(ln, qc, clause, what,    key) {
  key = ln SUBSEP qc SUBSEP clause
  if (!(key in found)) {
    found[key] = what
    if (ln > maxline) maxline = ln
  }
}

function add_unsafe(ln) {
  if (!is_bridge) note(ln, "QC-9", "unsafe", "`unsafe` outside nozoki-bridge")
}

function add_apple(ln, form) {
  if (is_core) note(ln, "QC-9", "apple", "Apple framework or binding `" form "` in nozoki-core")
}

function add_process(ln) {
  note(ln, "QC-36", "process", "std::process named — no shipped crate spawns a process")
  if (is_core) note(ln, "QC-9", "process", "std::process named in nozoki-core")
}

function add_fs(ln, form) {
  if (!exempt) note(ln, "QC-15", "filesystem", "filesystem primitive `" form "` outside its owner file")
}

function is_libc_file_call(w) {
  return index(LIBC, " " w " ") > 0
}

function is_apple(w) {
  if (w ~ /^objc2_/) return 1
  return index(APPLE, " " w " ") > 0
}

function is_word_token(w) {
  return w ~ /^[A-Za-z0-9_]/
}

# A path starts here: no `.` before it (a method's turbofish) and no `::` before it unless that
# `::` is itself at the head of the path, as in `::X::`, so `crate::X::` and `a::b::X::` do not
# start at X.
function is_root(t, k,    p, pp) {
  p = (k > 1) ? t[k - 1] : ""
  if (p == ".") return 0
  if (p != "::") return 1
  pp = (k > 2) ? t[k - 2] : ""
  return !is_word_token(pp)
}

# What a segment of a `use` tree means: $1 is the path before it, $2 the first segment of its
# path, $3 the segment, $4 whether it starts a path or a member of the tree, $5 its line.
function use_segment(parent, first, w, atstart, ln) {
  if (atstart && is_apple(w)) add_apple(ln, w)
  if (first == "std" && w == "process" && parent != "") add_process(ln)
  if ((first == "std" || first == "rustix") && w == "fs" && parent != "") add_fs(ln, first "::..::fs")
  if (first == "libc" && parent == "libc" && is_libc_file_call(w)) add_fs(ln, "libc::" w)
}

# What a segment after the first of a path means, wherever the path is written: $1 is the path's
# first segment, $2 the segment, $3 how many segments follow the first up to it, $4 its line.
function chain_segment(first, seg, depth, ln) {
  if (first == "std" && seg == "process") add_process(ln)
  if ((first == "std" || first == "rustix") && seg == "fs") add_fs(ln, first "::..::fs")
  if (first == "libc" && depth == 1 && is_libc_file_call(seg)) add_fs(ln, "libc::" seg)
}

function scan_chain(t, l, k,    first, j, depth) {
  first = t[k]
  j = k + 1
  depth = 1
  while (t[j] == "::" && is_word_token(t[j + 1])) {
    chain_segment(first, t[j + 1], depth, l[j + 1])
    j += 2
    depth++
  }
}

# Each `use` item runs from `use` to the `;` at brace depth zero, read across lines. The tree is
# walked with a stack of the paths before each `{`; `cur` is the path of the member being read.
function scan_use_trees(t, l, n,    k, m, sp, cur, atstart, skip, w, parent, p, first) {
  for (k = 1; k <= n; k++) {
    if (t[k] != "use") continue
    sp = 0; base[0] = ""; cur = ""; atstart = 1; skip = 0
    for (m = k + 1; m <= n; m++) {
      w = t[m]
      if (w == ";" && sp == 0) break
      if (w == "::") continue
      if (w == "{") { sp++; base[sp] = cur; atstart = 1; continue }
      if (w == "}") { if (sp > 0) { cur = base[sp]; sp-- }; atstart = 0; continue }
      if (w == ",") { cur = base[sp]; atstart = 1; continue }
      if (w == "as") { skip = 1; continue }
      if (!is_word_token(w)) continue
      if (skip) { skip = 0; continue }
      parent = cur
      cur = (cur == "") ? w : cur "::" w
      p = index(cur, "::")
      first = (p > 0) ? substr(cur, 1, p - 1) : cur
      use_segment(parent, first, w, atstart, l[m])
      atstart = 0
    }
  }
}

function scan_stream(t, l, n,    k) {
  for (k = 1; k <= n; k++) {
    if (t[k] == "unsafe") add_unsafe(l[k])
    if (t[k] == "kind" && t[k + 1] == "=" && t[k + 2] == "\"" && t[k + 3] == "framework" && t[k + 4] == "\"") add_apple(l[k], "kind = \"framework\"")
    if (t[k] == "extern" && t[k + 1] == "crate" && is_apple(t[k + 2])) add_apple(l[k + 2], t[k + 2])
    if (is_word_token(t[k]) && t[k + 1] == "::" && is_root(t, k)) {
      if (is_apple(t[k])) add_apple(l[k], t[k])
      scan_chain(t, l, k)
    }
  }
}

BEGIN {
  LIBC = " open openat creat fopen fdopen freopen opendir fdopendir readdir stat lstat fstat fstatat access faccessat mkdir mkdirat rmdir unlink unlinkat rename renameat truncate ftruncate readlink readlinkat symlink link chmod fchmod chown realpath "
  APPLE = " objc objc2 objc_foundation objc_id block block2 dispatch dispatch2 cocoa cocoa_foundation core_foundation core_foundation_sys core_graphics core_graphics_types core_text core_services security_framework security_framework_sys system_configuration system_configuration_sys fsevent fsevent_sys io_kit_sys metal "
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
  scan_use_trees(tk, tl, nt)
  scan_use_trees(ct, cl, nc)
  split("QC-9 QC-15 QC-36", order, " ")
  split("apple unsafe process filesystem", clauses, " ")
  for (ln = 1; ln <= maxline; ln++)
    for (q = 1; q <= 3; q++) {
      for (clause = 1; clause <= 4; clause++) {
        key = ln SUBSEP order[q] SUBSEP clauses[clause]
        if (key in found) print rel ":" ln ": " order[q] ": " found[key]
      }
    }
}
AWK

# --- the files in scope ---
# Exclusions are judged on the path relative to its crate, by components, never with a find
# pattern: find's `*` crosses `/` and -name matches at any depth, so either would drop src/tests/
# and src/build.rs.

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
    is_core=0
    is_bridge=0
    exempt=0
    [ "$crate_name" = "nozoki-core" ] && is_core=1
    [ "$crate_name" = "nozoki-bridge" ] && is_bridge=1
    case "$relative" in
      crates/nozoki-core/src/fs_reader.rs | crates/nozoki-bridge/src/log_writer.rs) exempt=1 ;;
    esac
    if [ ! -r "$product_root/$relative" ]; then
      echo "cannot read $relative" >> "$work/causes"
      continue
    fi
    LC_ALL=C awk -v rel="$relative" -v is_core="$is_core" -v is_bridge="$is_bridge" -v exempt="$exempt" \
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

#!/usr/bin/env bash
# Version: 1.0.0 — first version: the Rust source scan over crates/ — QC-9's unsafe, Apple-framework and process clauses, QC-36's Rust half, QC-15's two filesystem owners
#
# checks/structure.sh — proves the Rust source holds the unit and import rules.
#
# WHY THIS EXISTS
#   The units may import only what docs/nfdr.md § 1.2 lets them, and a reviewer cannot keep
#   watching a tree for a name that does not belong in a file. This script reads it off the
#   source, on every run of CI. It reads text, never the compiler's view of it, so it needs no
#   toolchain and no build. The scan table states each rule's text scope. Closed-name source
#   rules include comments and strings: a forbidden name in a comment is cheap to remove. The
#   bridge crate set reads code only, and manifest rules read TOML keys and values.
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
#   Three more files are REQUIRED inputs: checks/deps.allow, crates/nozoki-core/Cargo.toml and
#   crates/nozoki-bridge/Cargo.toml. One that is absent or cannot be read exits 1 with
#   `structure.sh: cannot read <path>` on stderr, and every other file is still read before the
#   verdict. They are not counted in the pass line, which counts Rust files and crates only.
#   The script reads text and calls no toolchain: no cargo, no compiler.
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
#     QC-10  unit edge    In nozoki-core, a file of the unit `folder_model` (crates/nozoki-core/
#     QC-11  (CP-417,     src/folder_model.rs, or any file under src/folder_model/) that imports
#            CP-418)      `own_state`, or names the libgit2 binding, is a QC-10 finding. A file of
#                         `fs_reader` or of `highlighter` (the same shapes) that imports a
#                         forbidden unit, or names the libgit2 binding, is a QC-11 finding. A
#                         unit is its module and the units are folder_model, fs_reader,
#                         highlighter, own_state, git_reader, watcher and markdown_renderer;
#                         every other file of the core (lib.rs, language.rs, error.rs) belongs
#                         to no unit, is never a subject, and importing it is never an edge.
#                         Forbidden for fs_reader: own_state, git_reader, watcher,
#                         markdown_renderer, highlighter. Forbidden for highlighter: folder_model,
#                         own_state, git_reader, watcher, markdown_renderer, fs_reader. A file
#                         imports a unit when its text holds, read across lines with whitespace
#                         around `::` changing nothing: a path whose segment after a leading
#                         `crate`, or a leading run of `super`, is the unit; a `use` tree that
#                         reaches it in that position; or either form naming an item that
#                         crates/nozoki-core/src/lib.rs re-exports from the unit's module
#                         (`crate::Entry`), read from lib.rs on every run. `self::<unit>` and
#                         `nozoki_core::<unit>` are not imports, and a unit is never its own
#                         target. A comment or a string counts. The libgit2 binding is `git2` or
#                         `libgit2_sys`, a floor: this script may refuse more names, never fewer,
#                         read in the forms the Apple floor is read in. One finding per distinct
#                         (file, line, rule, target). Source: QC-10's and QC-11's must-not lists.
#     QC-13  crate set    In every file under crates/nozoki-bridge/, a crate named in code that
#            (CP-421,     is not `std`, `core` or `alloc`, and not a name under the `cargo:`
#            CP-422)      section of checks/deps.allow (read on every run, a `-` in a listed name
#                         read as `_`). A crate is named in code by the first segment of a `use`
#                         path or of a root-group member, the crate of an `extern crate` (never
#                         its alias), or the first segment of a path written in code. Never a
#                         crate: crate, self, super, Self, a name beginning with an uppercase
#                         letter, a primitive type, clippy, rustdoc, rustfmt, a module a file of
#                         the bridge declares with `mod`, and — as a path root only — a name a
#                         `use` item of the same file brings into scope. UNLIKE every other rule
#                         here this one reads code only: a comment or a string is not read,
#                         because the domain is open and every `word::` in prose or test data
#                         would be a candidate. Source: QC-13's import set.
#     QC-13  Apple        In every file under crates/nozoki-bridge/, QC-9's Apple floor, the same
#            (CP-423)     names and forms read over raw text, reported as QC-13 and naming the
#                         framework or form. QC-9's own Apple finding stays nozoki-core's.
#                         Source: QC-13's "must not import any Apple framework".
#     QC-14  manifest     In crates/nozoki-core/Cargo.toml and crates/nozoki-bridge/Cargo.toml, at
#            (CP-424,     the line of the offending key: a dependency in [dependencies] or
#            CP-425)      [target.<cfg>.dependencies] whose key is `checks`, whose `package` is
#                         `checks`, or whose `path` lies at or under the product's checks/
#                         directory; and a [lib] whose `path` does. A path lies under checks/ when,
#                         resolved from the manifest's own directory with `.` and `..` read as
#                         steps and an absolute path read as written, it is <root>/checks or
#                         below. Read in any form TOML allows: a table header, a dotted key, a
#                         quoted key, an inline table, nested. A comment, a string value and an
#                         array's content are never keys. Not read, whatever they name:
#                         [dev-dependencies], [build-dependencies] (and their target forms), the
#                         `build` key, and [[test]], [[bench]], [[example]] and [[bin]] targets.
#                         Source: QC-14's "as it ships" and its test-target exclusion.
#     QC-17  logger       In every file read whose path is not under crates/nozoki-bridge/src/
#     QC-61  (CP-426)     (the exact path component), a path whose first segment is `log` (or
#                         `::log`) and whose next segment is the whole word `set_logger` or
#                         `set_boxed_logger`, or a `use` tree rooted at `log` naming either,
#                         aliased or not. Two findings on that line, one QC-17 and one QC-61. A
#                         comment or a string counts. Source: QC-17's and QC-61's verified-by.
#
# WHAT IS NOT HELD
#   This version holds only the rules in the table above. Every other rule docs/nfdr.md names
#   for checks/structure.sh is NOT held here, and the NFDR's header sentence that each script's
#   rules become executable with the script is read as: a rule is executable from the change
#   that adds it here. Until then its gate is the design review. Not held: QC-2's write rule;
#   QC-7; QC-12; QC-15's other owners and its socket clause; QC-20; QC-30's and QC-58's first
#   half; § 9's layer-5 placement rule. And these parts of rules the table above holds in part:
#     - QC-11's `fs-reader` must not import `folder-model`. Not held: a file of fs_reader
#       importing folder_model raises no finding, because
#       crates/nozoki-core/src/fs_reader.rs:L14 (`use crate::folder_model::OpenFailure;`) is
#       that edge today and holding the clause would fail the real tree. The clause rides the
#       change that removes the edge. highlighter importing folder_model IS held.
#     - QC-10's `git-reader`-adapter clause.
#     - QC-11's clauses whose subject is `git-reader`, `watcher` or `markdown-renderer`, and its
#       "only `git-reader` imports the libgit2 binding" outside the three units' files.
#     - QC-17's adapter-constructor clause.
#
# GAPS THE RULES ABOVE DO NOT CLOSE
#   Named so that none is read as coverage. The scan reads source text of the files in scope,
#   so it does not see: `std` reached through an alias (`use std as s;`,
#   `extern crate std as s;`); a `Path` method that touches the filesystem (exists, metadata,
#   read_dir, canonicalize), which names no filesystem module; a crate-level build.rs that
#   emits `cargo:rustc-link-lib=framework=…`, because build.rs is outside every rule; source
#   that is generated or pulled in by `include!`, or a `#[cfg(test)]` module whose body sits in
#   the excluded tests/ directory. And, for the unit-graph rules: an edge reached through a glob
#   import (`use crate::*;`, `use log::*;`); an edge through `#[path]`, `include!` or
#   macro-generated source; a crate reached through a dependency renamed in a manifest
#   (`foo = { package = "x" }`), where QC-13 reads only the in-code name; a crate whose name
#   begins with an uppercase letter; a dependency inherited from the workspace manifest
#   (`x.workspace = true`) whose workspace entry points into checks/; a git dependency into this
#   repository; a symlink into checks/; code a build script generates and the library
#   `include!`s from OUT_DIR. A review catches these.

set -euo pipefail

product_root="$(cd "$(dirname "$0")/.." && pwd -P)"
crates_dir="$product_root/crates"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
: > "$work/findings"
: > "$work/causes"

tab="$(printf '\t')"
unit_names=" folder_model fs_reader highlighter own_state git_reader watcher markdown_renderer "
required_inputs="checks/deps.allow crates/nozoki-core/Cargo.toml crates/nozoki-bridge/Cargo.toml"

# --- the scan program: one awk pass per file ---

cat > "$work/scan.awk" <<'AWK'
# One pass per file. The file is cut into tokens — identifiers as whole words, `::`, and every
# other non-blank character one by one — each with its line and a kind: k (code), c (comment) or
# s (string). Comments and strings are tokens like the rest, so the rules read raw text; the kind
# is kept so the structure of the code can be read without a comment's punctuation in it.
#
# A finding is recorded under (line, QC, clause rank, target) and printed as a tab-separated
# record, path first, so the shell can sort every finding of every file in one pass.

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

function note(ln, qc, crank, target, what,    key) {
  key = ln SUBSEP qc SUBSEP crank SUBSEP target
  if (!(key in found)) found[key] = what
}

function add_unsafe(ln) {
  if (!is_bridge) note(ln, "QC-9", 2, "", "`unsafe` outside nozoki-bridge")
}

function add_apple(ln, form) {
  if (is_core) note(ln, "QC-9", 1, "", "Apple framework or binding `" form "` in nozoki-core")
  if (is_bridge) note(ln, "QC-13", 2, form, "Apple framework or binding `" form "` in nozoki-bridge")
}

function add_process(ln) {
  note(ln, "QC-36", 1, "", "std::process named — no shipped crate spawns a process")
  if (is_core) note(ln, "QC-9", 3, "", "std::process named in nozoki-core")
}

function add_fs(ln, form) {
  if (!exempt) note(ln, "QC-15", 1, "", "filesystem primitive `" form "` outside its owner file")
}

function is_libc_file_call(w) {
  return index(LIBC, " " w " ") > 0
}

function is_apple(w) {
  if (w ~ /^objc2_/) return 1
  return index(APPLE, " " w " ") > 0
}

function is_git2(w) {
  return w == "git2" || w == "libgit2_sys"
}

function is_logger(w) {
  return w == "set_logger" || w == "set_boxed_logger"
}

function is_word_token(w) {
  return w ~ /^[A-Za-z0-9_]/
}

# The unit a word names: a unit's own name, or an item lib.rs re-exports from a unit's module.
function unit_of(w,    p, rest, q) {
  if (index(UNITS, " " w " ") > 0) return w
  p = index(REEXPORT, " " w ":")
  if (p == 0) return ""
  rest = substr(REEXPORT, p + length(w) + 2)
  q = index(rest, " ")
  return substr(rest, 1, q - 1)
}

function forbidden_edge(u) {
  if (subj == "folder_model") return u == "own_state"
  if (subj == "fs_reader") return index(" own_state git_reader watcher markdown_renderer highlighter ", " " u " ") > 0
  if (subj == "highlighter") return index(" folder_model own_state git_reader watcher markdown_renderer fs_reader ", " " u " ") > 0
  return 0
}

function subject_qc() {
  return (subj == "folder_model") ? "QC-10" : "QC-11"
}

function add_unit(ln, w,    u) {
  if (subj == "") return
  u = unit_of(w)
  if (u == "" || u == subj) return
  if (forbidden_edge(u)) note(ln, subject_qc(), 1, u, subj " imports " u)
}

function add_git2(ln, w) {
  if (subj == "") return
  note(ln, subject_qc(), 2, w, subj " names the libgit2 binding `" w "`")
}

function add_logger(ln, w) {
  if (in_src) return
  note(ln, "QC-17", 1, w, "`log::" w "` outside crates/nozoki-bridge/src/")
  note(ln, "QC-61", 1, w, "`log::" w "` outside crates/nozoki-bridge/src/")
}

# A crate named in code in a bridge file. A path root may also be a name a `use` of the file bound.
function crate_position(w, ln, as_path_root) {
  if (!check_crates) return
  if (w ~ /^[A-Z]/) return
  if (w == "crate" || w == "self" || w == "super") return
  if (index(PRIMITIVES, " " w " ") > 0) return
  if (index(TOOLS, " " w " ") > 0) return
  if (index(BMODS, " " w " ") > 0) return
  if (index(ALLOWED, " " w " ") > 0) return
  if (as_path_root && (w in bound)) return
  note(ln, "QC-13", 1, w, "crate `" w "` is neither the standard library nor named on checks/deps.allow")
}

function is_crate_or_super(parent) {
  return parent == "crate" || parent ~ /^super(::super)*$/
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
  if (atstart && is_git2(w)) add_git2(ln, w)
  if (first == "std" && w == "process" && parent != "") add_process(ln)
  if ((first == "std" || first == "rustix") && w == "fs" && parent != "") add_fs(ln, first "::..::fs")
  if (first == "libc" && parent == "libc" && is_libc_file_call(w)) add_fs(ln, "libc::" w)
  if (first == "log" && parent != "" && is_logger(w)) add_logger(ln, w)
  if (is_crate_or_super(parent)) add_unit(ln, w)
  if (stream_code && parent == "" && atstart) crate_position(w, ln, 0)
}

# What a segment after the first of a path means, wherever the path is written: $1 is the path's
# first segment, $2 the segment, $3 how many segments follow the first up to it, $4 its line.
function chain_segment(first, seg, depth, ln) {
  if (first == "std" && seg == "process") add_process(ln)
  if ((first == "std" || first == "rustix") && seg == "fs") add_fs(ln, first "::..::fs")
  if (first == "libc" && depth == 1 && is_libc_file_call(seg)) add_fs(ln, "libc::" seg)
  if (first == "log" && depth == 1 && is_logger(seg)) add_logger(ln, seg)
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

# The target of a `crate::<x>` path or of a run of `super::` segments.
function scan_unit_path(t, l, k,    j) {
  j = k
  if (t[k] == "super") { while (t[j] == "super" && t[j + 1] == "::") j += 2 }
  else j = k + 2
  if (is_word_token(t[j])) add_unit(l[j], t[j])
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

# The tokens of every `use` item are marked, so a path root is not read twice, and a `use` path's
# first segment is never excused by a name a `use` binds.
function mark_use_items(t, n,    k, m, sp) {
  for (k = 1; k <= n; k++) {
    if (t[k] != "use") continue
    sp = 0
    for (m = k; m <= n; m++) {
      inuse[m] = 1
      if (t[m] == "{") sp++
      else if (t[m] == "}") { if (sp > 0) sp-- }
      else if (t[m] == ";" && sp == 0) break
    }
  }
}

# The names the `use` items of this file bring into scope: the last segment of a path, the segment
# before a `self` member, the name after `as`.
function bind_member(    name) {
  if (pending) {
    if (alias != "") name = alias
    else if (last == "self") name = prev
    else name = last
    if (name != "" && name != "_") bound[name] = 1
  }
  pending = 0
  alias = ""
}

function collect_bindings(t, n,    k, m, sp, w, want_alias) {
  for (k = 1; k <= n; k++) {
    if (t[k] != "use") continue
    sp = 0; last = ""; prev = ""; pending = 0; alias = ""; want_alias = 0
    for (m = k + 1; m <= n; m++) {
      w = t[m]
      if (w == ";" && sp == 0) { bind_member(); break }
      if (w == "::") continue
      if (w == "{") { sp++; saved[sp] = last; pending = 0; alias = ""; continue }
      if (w == "}") { bind_member(); if (sp > 0) { last = saved[sp]; sp-- }; prev = ""; continue }
      if (w == ",") { bind_member(); last = (sp > 0) ? saved[sp] : ""; prev = ""; continue }
      if (w == "as") { want_alias = 1; continue }
      if (!is_word_token(w)) continue
      if (want_alias) { alias = w; want_alias = 0; continue }
      prev = last; last = w; pending = 1
    }
  }
}

function scan_stream(t, l, n,    k) {
  for (k = 1; k <= n; k++) {
    if (t[k] == "unsafe") add_unsafe(l[k])
    if (t[k] == "kind" && t[k + 1] == "=" && t[k + 2] == "\"" && t[k + 3] == "framework" && t[k + 4] == "\"") add_apple(l[k], "kind = \"framework\"")
    if (t[k] == "extern" && t[k + 1] == "crate") {
      if (is_apple(t[k + 2])) add_apple(l[k + 2], t[k + 2])
      if (is_git2(t[k + 2])) add_git2(l[k + 2], t[k + 2])
      if (stream_code) crate_position(t[k + 2], l[k + 2], 0)
    }
    if ((t[k] == "crate" || t[k] == "super") && t[k + 1] == "::" && is_root(t, k)) scan_unit_path(t, l, k)
    if (is_word_token(t[k]) && t[k + 1] == "::" && is_root(t, k)) {
      if (is_apple(t[k])) add_apple(l[k], t[k])
      if (is_git2(t[k])) add_git2(l[k], t[k])
      if (stream_code && is_word_token(t[k + 2]) && !(k in inuse)) crate_position(t[k], l[k], 1)
      scan_chain(t, l, k)
    }
  }
}

BEGIN {
  LIBC = " open openat creat fopen fdopen freopen opendir fdopendir readdir stat lstat fstat fstatat access faccessat mkdir mkdirat rmdir unlink unlinkat rename renameat truncate ftruncate readlink readlinkat symlink link chmod fchmod chown realpath "
  APPLE = " objc objc2 objc_foundation objc_id block block2 dispatch dispatch2 cocoa cocoa_foundation core_foundation core_foundation_sys core_graphics core_graphics_types core_text core_services security_framework security_framework_sys system_configuration system_configuration_sys fsevent fsevent_sys io_kit_sys metal "
  PRIMITIVES = " bool char str i8 i16 i32 i64 i128 isize u8 u16 u32 u64 u128 usize f32 f64 "
  TOOLS = " clippy rustdoc rustfmt "
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
  if (phase == "mods") {
    for (k = 1; k <= nc; k++)
      if (ct[k] == "mod" && is_word_token(ct[k + 1]) && (ct[k + 2] == "{" || ct[k + 2] == ";")) print ct[k + 1]
    exit
  }
  check_crates = (is_bridge && have_allow)
  stream_code = 0
  scan_stream(tk, tl, nt)
  scan_use_trees(tk, tl, nt)
  stream_code = 1
  if (check_crates) { mark_use_items(ct, nc); collect_bindings(ct, nc) }
  scan_stream(ct, cl, nc)
  scan_use_trees(ct, cl, nc)
  for (key in found) {
    split(key, kp, SUBSEP)
    printf "%s\t%d\t%d\t%d\t%s\t%s:%d: %s: %s\n", rel, kp[1], substr(kp[2], 4) + 0, kp[3], kp[4], rel, kp[1], kp[2], found[key]
  }
}
AWK

# --- the re-export program: which items nozoki-core's lib.rs re-exports from which unit ---

cat > "$work/reexport.awk" <<'AWK'
# CP-416 requires the originating unit even when one root re-export groups several units.
{ text = $0; sub(/\/\/.*/, "", text); all = all " " text }

function export_member(path, alias,    n, parts, first, exported) {
  n = split(path, parts, "::")
  first = 1
  while (parts[first] == "crate" || parts[first] == "self") first++
  if (first > n || index(UNITS, " " parts[first] " ") == 0) return
  exported = (alias != "") ? alias : parts[n]
  if (exported == "self") exported = parts[n - 1]
  if (exported ~ /^[A-Za-z_][A-Za-z0-9_]*$/) printf " %s:%s", exported, parts[first]
}

function statement(stmt,    n, w, i, x, depth, parents, path, alias) {
  gsub(/[{},]/, " & ", stmt)
  gsub(/::/, " :: ", stmt)
  n = split(stmt, w, " ")
  depth = 0; parents[0] = ""; path = ""; alias = ""
  for (i = 1; i <= n + 1; i++) {
    x = w[i]
    if (x == "::") continue
    if (x == "{") { parents[++depth] = path; path = ""; continue }
    if (x == "," || x == "}" || i > n) {
      if (path != "") export_member(path, alias)
      path = ""; alias = ""
      if (x == "}" && depth > 0) depth--
      continue
    }
    if (x == "as") { alias = w[++i]; continue }
    if (path == "") path = parents[depth]
    path = (path == "") ? x : path "::" x
  }
}

END {
  while (match(all, /pub(\([a-z]+\))?[ \t]+use[ \t]+/)) {
    all = substr(all, RSTART + RLENGTH)
    e = index(all, ";")
    if (e == 0) break
    statement(substr(all, 1, e - 1))
    all = substr(all, e + 1)
  }
}
AWK

# --- the manifest program: QC-14 over one Cargo.toml ---

cat > "$work/toml.awk" <<'AWK'
# Reads one manifest lexically, with no TOML library. Every key becomes a path of its table, its
# dotted parts and the keys of the inline tables it holds; a string, an array and a multi-line
# string are consumed as values, so nothing inside one is ever read as a key. A comment ends at the
# `#` outside a string. A finding sits on the line where the offending key is written.

function ch(    s) {
  if (cl > N) return ""
  s = substr(L[cl], cc, 1)
  if (s == "") return "\n"
  return s
}

function adv() {
  if (cl > N) return
  if (cc > length(L[cl])) { cl++; cc = 1 } else cc++
}

function skip_ws(    c) {
  while ((c = ch()) == " " || c == "\t" || c == "\r") adv()
}

function skip_comment() {
  while (ch() != "\n" && ch() != "") adv()
}

function skip_line() {
  skip_comment()
  if (ch() == "\n") adv()
}

function unicode_escape(digits,    value, i, digit) {
  value = 0
  for (i = 0; i < digits; i++) {
    digit = index("0123456789abcdef", tolower(ch())) - 1
    if (digit < 0) return ""
    value = value * 16 + digit
    adv()
  }
  if (value < 128) return sprintf("%c", value)
  if (value < 2048) return sprintf("%c%c", 192 + int(value / 64), 128 + value % 64)
  if (value < 65536) return sprintf("%c%c%c", 224 + int(value / 4096), 128 + int(value / 64) % 64, 128 + value % 64)
  return sprintf("%c%c%c%c", 240 + int(value / 262144), 128 + int(value / 4096) % 64, 128 + int(value / 64) % 64, 128 + value % 64)
}

# CP-424 uses TOML values, not their spelling: https://toml.io/en/v1.0.0#string.
function parse_string(    q, c, s, triple, quotes, digits) {
  q = ch()
  triple = (substr(L[cl], cc, 3) == q q q)
  adv()
  if (triple) { adv(); adv() }
  if (triple && ch() == "\n") adv()
  s = ""
  while (1) {
    c = ch()
    if (c == "") break
    if (triple) {
      if (substr(L[cl], cc, 3) == q q q) {
        quotes = 0
        while (ch() == q) { quotes++; adv() }
        while (quotes > 3) { s = s q; quotes-- }
        break
      }
      if (c == "\n") { s = s "\n"; adv(); continue }
    } else {
      if (c == "\n") break
      if (c == q) { adv(); break }
    }
    if (q == "\"" && c == "\\") {
      adv()
      c = ch()
      if (triple && c ~ /^[ \t\r\n]$/) {
        while (ch() ~ /^[ \t\r\n]$/) adv()
        continue
      }
      if (c == "u" || c == "U") {
        digits = (c == "u") ? 4 : 8
        adv()
        s = s unicode_escape(digits)
        continue
      }
      if (c == "b") c = sprintf("%c", 8)
      else if (c == "t") c = "\t"
      else if (c == "n") c = "\n"
      else if (c == "f") c = sprintf("%c", 12)
      else if (c == "r") c = "\r"
    }
    s = s c
    adv()
  }
  SV = s
}

# Reads a possibly dotted key into KEYSTR (parts joined by SEP), KN parts, KLINE its line.
# Returns 0 when what stands here is not a key.
function parse_key(    c, part, quoted) {
  KEYSTR = ""; KN = 0; KLINE = cl
  while (1) {
    skip_ws()
    c = ch()
    quoted = 0
    part = ""
    if (c == "\"" || c == "'") { parse_string(); part = SV; quoted = 1 }
    else { while ((c = ch()) ~ /[A-Za-z0-9_-]/) { part = part c; adv() } }
    if (part == "" && !quoted) return 0
    KN++
    KEYSTR = (KN == 1) ? part : KEYSTR SEP part
    skip_ws()
    if (ch() == ".") { adv(); continue }
    return 1
  }
}

function note(ln, crank, target, what,    key) {
  key = ln SUBSEP crank SUBSEP target
  if (!(key in found)) found[key] = what
}

# The dependency key itself, named `checks`, is written here.
function touch_path(path, ln,    n, pp) {
  n = split(path, pp, SEP)
  if ((n == 2 && pp[1] == "dependencies" && pp[2] == "checks") || (n == 4 && pp[1] == "target" && pp[3] == "dependencies" && pp[4] == "checks"))
    note(ln, 1, "checks", crate ": a dependency named `checks` — no shipped unit depends on checks/")
}

# Each prefix of the key written on this line, below the path the key sits under.
function touch_key(base, kstr, kn, ln,    parts, i, acc) {
  split(kstr, parts, SEP)
  acc = base
  for (i = 1; i <= kn; i++) {
    acc = (acc == "") ? parts[i] : acc SEP parts[i]
    touch_path(acc, ln)
  }
}

function under_checks(p,    full, n, parts, i, stack, sp, out, target) {
  if (substr(p, 1, 1) == "/") full = p
  else full = mdir "/" p
  n = split(full, parts, "/")
  sp = 0
  for (i = 1; i <= n; i++) {
    if (parts[i] == "" || parts[i] == ".") continue
    if (parts[i] == "..") { if (sp > 0) sp--; continue }
    stack[++sp] = parts[i]
  }
  out = ""
  for (i = 1; i <= sp; i++) out = out "/" stack[i]
  target = root "/checks"
  return (out == target) || (index(out, target "/") == 1)
}

# A string value reached at `path`, on line `ln`.
function leaf(path, val, ln,    n, pp, dep) {
  n = split(path, pp, SEP)
  dep = (n == 3 && pp[1] == "dependencies") || (n == 5 && pp[1] == "target" && pp[3] == "dependencies")
  if (dep && pp[n] == "package" && val == "checks")
    note(ln, 2, pp[n - 1], crate ": dependency `" pp[n - 1] "` is the package `checks` — no shipped unit depends on checks/")
  if (dep && pp[n] == "path" && under_checks(val))
    note(ln, 3, pp[n - 1], crate ": dependency `" pp[n - 1] "` has a path under checks/ (`" val "`)")
  if (n == 2 && pp[1] == "lib" && pp[2] == "path" && under_checks(val))
    note(ln, 4, "lib", crate ": [lib] path is under checks/ (`" val "`)")
}

function skip_array(    depth, c) {
  depth = 0
  while (1) {
    c = ch()
    if (c == "") return
    if (c == "[") { depth++; adv() }
    else if (c == "]") { depth--; adv(); if (depth == 0) return }
    else if (c == "\"" || c == "'") parse_string()
    else if (c == "#") skip_comment()
    else adv()
  }
}

function skip_bare(    c) {
  while ((c = ch()) != "" && c != "\n" && c != "," && c != "}" && c != "]" && c != "#") adv()
}

function parse_value(path, ln,    c, kstr, kn, kline, full) {
  c = ch()
  if (c == "\"" || c == "'") { parse_string(); leaf(path, SV, ln); return }
  if (c == "[") { skip_array(); return }
  if (c == "{") {
    adv()
    while (1) {
      skip_ws()
      if (ch() == "}") { adv(); return }
      if (!parse_key()) return
      kstr = KEYSTR; kn = KN; kline = KLINE
      touch_key(path, kstr, kn, kline)
      full = path SEP kstr
      skip_ws()
      if (ch() != "=") return
      adv()
      skip_ws()
      parse_value(full, kline)
      skip_ws()
      if (ch() == ",") { adv(); continue }
      if (ch() == "}") { adv(); return }
      return
    }
  }
  skip_bare()
}

function parse_header(    array, line0) {
  line0 = cl
  adv()
  array = 0
  if (ch() == "[") { array = 1; adv() }
  if (!parse_key()) { skip_line(); return }
  skip_ws()
  if (ch() == "]") adv()
  if (array && ch() == "]") adv()
  if (array) table = "@@array"
  else { table = KEYSTR; touch_key("", KEYSTR, KN, line0) }
  skip_line()
}

function parse_statement(    c, kstr, kn, kline) {
  skip_ws()
  c = ch()
  if (c == "\n") { adv(); return }
  if (c == "") return
  if (c == "#") { skip_line(); return }
  if (c == "[") { parse_header(); return }
  if (!parse_key()) { skip_line(); return }
  kstr = KEYSTR; kn = KN; kline = KLINE
  skip_ws()
  if (ch() != "=") { skip_line(); return }
  adv()
  touch_key(table, kstr, kn, kline)
  skip_ws()
  parse_value((table == "") ? kstr : table SEP kstr, kline)
  skip_line()
}

BEGIN { SEP = "\034" }

{ sub(/\r$/, ""); N++; L[N] = $0 }

END {
  cl = 1; cc = 1; table = ""
  while (cl <= N) {
    before = cl SUBSEP cc
    parse_statement()
    if (cl SUBSEP cc == before) adv()
  }
  for (key in found) {
    split(key, kp, SUBSEP)
    printf "%s\t%d\t14\t%d\t%s\t%s:%d: QC-14: %s\n", rel, kp[1], kp[2], kp[3], rel, kp[1], found[key]
  }
}
AWK

# --- the required inputs ---

for input in $required_inputs; do
  [ -r "$product_root/$input" ] || echo "cannot read $input" >> "$work/causes"
done

# The crates checks/deps.allow names under `cargo:`, a `-` read as `_`, read on every run.
have_allow=0
allowed=" std core alloc "
if [ -r "$product_root/checks/deps.allow" ]; then
  have_allow=1
  allowed="$allowed$(LC_ALL=C awk '
    /^[A-Za-z0-9_-]+:[ \t]*$/ { section = $0; sub(/:.*/, "", section); next }
    section == "cargo" {
      entry = $0
      sub(/#.*/, "", entry)
      gsub(/[ \t\r]/, "", entry)
      if (entry != "") { gsub(/-/, "_", entry); printf "%s ", entry }
    }' "$product_root/checks/deps.allow" || true)"
fi

# The items lib.rs re-exports from a unit's module, read afresh from the tree on every run.
reexports=" "
if [ -r "$crates_dir/nozoki-core/src/lib.rs" ]; then
  reexports=" $(LC_ALL=C awk -v UNITS="$unit_names" -f "$work/reexport.awk" "$crates_dir/nozoki-core/src/lib.rs" || true) "
fi

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

# The modules any file of the bridge declares with `mod`, collected across the run before any file
# is judged: a path rooted at one is a local module, not a crate.
bridge_mods=" "
if [ -s "$work/files" ]; then
  while IFS= read -r relative; do
    case "$relative" in
      crates/nozoki-bridge/*) ;;
      *) continue ;;
    esac
    [ -r "$product_root/$relative" ] || continue
    bridge_mods="$bridge_mods$(LC_ALL=C awk -v phase=mods -v is_bridge=1 -f "$work/scan.awk" "$product_root/$relative" 2> /dev/null | tr '\n' ' ' || true) "
  done < "$work/files"
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
    in_bridge_src=0
    subject_unit=""
    [ "$crate_name" = "nozoki-core" ] && is_core=1
    [ "$crate_name" = "nozoki-bridge" ] && is_bridge=1
    case "$relative" in
      crates/nozoki-core/src/fs_reader.rs | crates/nozoki-bridge/src/log_writer.rs) exempt=1 ;;
    esac
    case "$relative" in
      crates/nozoki-bridge/src/*) in_bridge_src=1 ;;
    esac
    # The subject unit is the module by exact file or directory component, never a prefix.
    case "$relative" in
      crates/nozoki-core/src/*)
        within_src="${relative#crates/nozoki-core/src/}"
        case "$within_src" in
          */*) module_name="${within_src%%/*}" ;;
          *.rs) module_name="${within_src%.rs}" ;;
          *) module_name="" ;;
        esac
        case "$module_name" in
          folder_model | fs_reader | highlighter) subject_unit="$module_name" ;;
        esac
        ;;
    esac
    if [ ! -r "$product_root/$relative" ]; then
      echo "cannot read $relative" >> "$work/causes"
      continue
    fi
    LC_ALL=C awk -v rel="$relative" -v is_core="$is_core" -v is_bridge="$is_bridge" -v exempt="$exempt" \
      -v subj="$subject_unit" -v in_src="$in_bridge_src" -v have_allow="$have_allow" \
      -v ALLOWED="$allowed" -v BMODS="$bridge_mods" -v REEXPORT="$reexports" -v UNITS="$unit_names" \
      -f "$work/scan.awk" "$product_root/$relative" >> "$work/findings" \
      || echo "the scan could not read $relative" >> "$work/causes"
  done < "$work/files"
fi

# --- the shipped manifests: QC-14 ---

for manifest_crate in nozoki-core nozoki-bridge; do
  manifest="crates/$manifest_crate/Cargo.toml"
  [ -r "$product_root/$manifest" ] || continue
  LC_ALL=C awk -v rel="$manifest" -v crate="$manifest_crate" -v mdir="$product_root/crates/$manifest_crate" \
    -v root="$product_root" -f "$work/toml.awk" "$product_root/$manifest" >> "$work/findings" \
    || echo "the scan could not read $manifest" >> "$work/causes"
done

crate_count=0
if [ -s "$work/files" ]; then
  crate_count="$(cut -d/ -f2 "$work/files" | LC_ALL=C sort -u | wc -l | tr -d ' ')"
fi

# --- the verdict ---
# One sorted report over every file read, manifests included: path, then numeric line, then QC
# number, then the clause. The order is the sort's, never the order the files were visited in.

if [ -s "$work/findings" ] || [ -s "$work/causes" ]; then
  LC_ALL=C sort -t "$tab" -k1,1 -k2,2n -k3,3n -k4,4n -k5,5 "$work/findings" | cut -f6- >&2
  while IFS= read -r cause; do
    echo "structure.sh: $cause" >&2
  done < "$work/causes"
  exit 1
fi

echo "structure.sh: $file_count Rust files in $crate_count crates read — nothing found"

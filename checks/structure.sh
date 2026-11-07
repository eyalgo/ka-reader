#!/usr/bin/env bash
# Version: 1.7.1 — the unit-edge header comment says watcher and markdown_renderer have files
# Version: 1.7.0 — the bridge's watcher is a unit: its files alone stand outside QC-13's Apple row;
#   the Apple floor reads native vocabulary; the watcher, model-to-watcher and core-to-bridge edges
# Version: 1.6.0 — structure.sh holds QC-10's adapter, QC-11's git_reader, watcher and
#   markdown_renderer subjects, and QC-17's adapter construction
# Version: 1.5.0 — probe answers root for a git file; third QC-15 filesystem owner
# Version: 1.4.0 — structure.sh holds the value modules — QC-63 scan and its proof
# Version: 1.3.0 — structure.sh holds the boundary reads; fs_reader test body moves to tests/unit
# Version: 1.2.0 — fs_reader owns OpenFailure; structure.sh holds QC-11's fs-reader clause
# Version: 1.1.0 — ka-reader structure.sh holds the unit graph — QC-10/11/13/14/17/61
#   scanner and planted-break cases
# Version: 1.0.0 — first version: the Rust source scan over crates/ — QC-9's unsafe, Apple-framework
#   and process clauses, QC-36's Rust half, QC-15's two filesystem owners
#
# checks/structure.sh — proves the Rust source holds the unit and import rules.
#
# WHY THIS EXISTS
#   The units may import only what docs/nfdr.md § 1.2 lets them, and a reviewer cannot keep
#   watching a tree for a name that does not belong in a file. This script reads it off the
#   source, on every run of CI. It reads text, never the compiler's view of it, so it needs no
#   toolchain and no build. The scan table states each rule's text scope. Closed-name source
#   rules include comments and strings: a forbidden name in a comment is cheap to remove. The
#   bridge crate set and the adapter-construction rule read code only, and manifest rules read TOML
#   keys and values.
#
# USAGE
#   checks/structure.sh
#   No argument, and no environment variable: the product root is the parent of this script's
#   own directory, as checks/view.sh derives it, so a copy placed at <root>/checks/structure.sh
#   reads <root>.
#   A finding is one line on stderr — `<path relative to the root>:<line>: <QC-n>: <what>` — one
#   per distinct (clause, file, line), in path order and then line order. The layer-5 rule has no
#   QC number, and its finding is `<path>:<line>: layer-5: <what>`. A pass is exit 0, empty stderr
#   and one stdout line: the count of files and crates read, and that nothing was found. Both
#   counts are of the shipped scope below, so a file read only by layer-5 is in neither. Every
#   other ending is exit 1, and the script reads every file before it gives a verdict, so one run
#   reports every finding. It never passes having read nothing: no file in scope exits 1 with
#   `no Rust source was read` on stderr, and a file in scope that cannot be read exits 1 naming
#   the file.
#
# WHAT IS READ
#   Every regular *.rs file at any depth under crates/<c>/, where <c> is any directory directly
#   under crates/, with or without a manifest: a crate added later is read with no edit here.
#   <c> is the crate name in every rule below. Two exclusions, both judged on the path relative
#   to crates/<c>/: a file whose first component is `tests`, and the file `build.rs` at that
#   level. src/tests/x.rs and src/build.rs are read. What is left is the shipped scope, which
#   every rule below reads except layer-5.
#   The files under crates/<c>/tests/ (every regular *.rs at any depth) are read by the layer-5
#   rule alone and by no other. They are counted in neither the files nor the crates of the pass
#   line, and they never satisfy the guard against reading nothing: a run whose shipped scope is
#   empty exits 1 with `no Rust source was read` even when tests/ files exist. One that cannot be
#   read exits 1 with `structure.sh: cannot read <path>` after every other file was read.
#   Three more files are REQUIRED inputs: checks/deps.allow, crates/ka-reader-core/Cargo.toml and
#   crates/ka-reader-bridge/Cargo.toml. One that is absent or cannot be read exits 1 with
#   `structure.sh: cannot read <path>` on stderr, and every other file is still read before the
#   verdict. They are not counted in the pass line, which counts Rust files and crates only.
#   The script reads text and calls no toolchain: no cargo, no compiler.
#
# THE SCAN TABLE
#   A token is an identifier matched whole: a word character ([A-Za-z0-9_]) on either side means
#   no match, so `unsafe_code` is not `unsafe`. "QC-n" is docs/nfdr.md.
#     QC-9   Apple        In ka-reader-core only. The list of forms is a floor: this script may
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
#                         ka-reader-core the same occurrence is also a QC-9 finding, on the same
#                         line. Source: QC-36's Rust half, QC-9's process clause.
#     QC-15  filesystem   In every crate except in the three owner files,
#                         crates/ka-reader-core/src/fs_reader.rs,
#                         crates/ka-reader-bridge/src/log_writer.rs and
#                         crates/ka-reader-core/src/git_reader/libgit2.rs, the git-reader
#                         adapter, which reads a `.git` regular file's own bytes (matched by
#                         the exact path, so the same basename anywhere else, and the rest of
#                         git-reader, is not exempt, and the exemption is for this clause
#                         only). The module `fs` in a path rooted at `std`
#                         or `rustix`, so `std::fs`, `std::os::<platform>::fs` and
#                         `rustix::fs`, whitespace or newlines around `::` changing nothing;
#                         and a segment or member `fs` in a `use` tree rooted at `std`,
#                         `::std` or `rustix`, read across lines and nested, the finding at
#                         the member's own line. A crate other than those three owns no
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
#                         #[unsafe(…)]), in every crate except ka-reader-bridge. Source: QC-9's
#                         "unsafe appearing in no crate but ka-reader-bridge".
#     QC-10  unit edge    In ka-reader-core, a file of a unit is src/<unit>.rs or any file under
#     QC-11  (CP-417,     src/<unit>/, the module name matched as an exact file or directory name
#            CP-418,      and never as a prefix, so src/watcher_ext.rs is a file of no unit. The
#            CP-435)      units are folder_model, fs_reader, highlighter, own_state, git_reader,
#                         watcher and markdown_renderer. Every other file of the core (lib.rs,
#                         language.rs, error.rs) belongs to no unit, is never a subject of QC-10 or
#                         QC-11 (QC-63 below reads the files of no unit), and importing it is never
#                         an edge. A file of `folder_model` that imports `own_state`, or names the
#                         libgit2 binding, is a QC-10 finding. A file of `fs_reader`, `highlighter`,
#                         `git_reader`, `watcher` or `markdown_renderer` that imports a unit its set
#                         below forbids is a QC-11 finding, `<subject> imports <unit>`. A file of
#                         `fs_reader` or `highlighter` that names the libgit2 binding is a QC-11
#                         finding too; the binding in the other three is the libgit2-binding row's.
#                         watcher and markdown_renderer have files, and each is judged on them, with
#                         no edit here for a file added later. The sets
#                         are QC-11's "must not import `folder-model`, `own-state`, or one another",
#                         less its two stated edges.
#                         Forbidden for fs_reader: folder_model, own_state, git_reader, watcher,
#                         markdown_renderer, highlighter.
#                         Forbidden for highlighter: folder_model, own_state, git_reader, watcher,
#                         markdown_renderer, fs_reader.
#                         Forbidden for git_reader: folder_model, own_state, fs_reader, watcher,
#                         highlighter, markdown_renderer.
#                         Forbidden for watcher: folder_model, own_state, fs_reader, git_reader,
#                         highlighter, markdown_renderer.
#                         Forbidden for markdown_renderer: folder_model, own_state, git_reader,
#                         watcher. Its imports of fs_reader and highlighter are QC-11's two stated
#                         edges and draw nothing. That the fs_reader edge reaches the containment
#                         check alone is not held here (WHAT IS NOT HELD).
#                         A file imports a unit when its text holds, read across lines with
#                         whitespace around `::` changing nothing: a path whose segment after a
#                         leading `crate`, or a leading run of `super`, is the unit; a `use` tree
#                         that reaches it in that position; or either form naming an item that
#                         crates/ka-reader-core/src/lib.rs re-exports from the unit's module
#                         (`crate::Entry`), read from lib.rs on every run. `self::<unit>` and
#                         `ka_reader_core::<unit>` are not imports, and a unit is never its own
#                         target. A comment or a string counts. The libgit2 binding is `git2` or
#                         `libgit2_sys`, a floor: this script may refuse more names, never fewer,
#                         read in the forms the Apple floor is read in. One finding per distinct
#                         (file, line, rule, target). Source: QC-10's and QC-11's must-not lists.
#     QC-10  git-reader's In ka-reader-core, every file of the unit `folder_model`, in the unit-edge
#            adapter      row's shapes: each line that names git-reader's adapter. Two forms, a
#                         floor: this script may refuse more forms, never fewer. `Libgit2`, the
#                         adapter's type, as a token, anywhere: in a path, as a member of a `use`
#                         tree, as a bare name, in a comment or in a string. And
#                         `git_reader::libgit2`, the adapter's module, where `libgit2` is the
#                         segment directly after `git_reader` in a path or `use` tree that starts
#                         with `crate` or a run of `super`, read across lines, whitespace around
#                         `::` changing nothing, the finding at the line of `libgit2`. The finding
#                         names the form, `Libgit2` or `git_reader::libgit2`, spelled as written
#                         here, one per distinct (file, line, form). Not a finding: the Git port
#                         trait and the plain-data types beside it, reached through
#                         `crate::git_reader::…` or through an item lib.rs re-exports, and the
#                         lowercase word `libgit2` anywhere but directly after `git_reader::`. The
#                         unit-edge row's QC-10 findings stand beside this one on the same line.
#                         Source: QC-10's "must not import the libgit2 binding, `git-reader`'s
#                         adapter, or `own-state`".
#     QC-11  libgit2      In every file of the shipped scope in any crate (CP-647 - CP-651): the
#            binding      libgit2 binding, read in the forms the Apple floor is read in, is a QC-11
#            (CP-647 -    finding at its line, `<what>` naming the binding. Only `git-reader`
#            CP-651)      imports the binding, with one exception, so two exemptions: every file of
#                         the `git_reader` unit (crates/ka-reader-core/src/git_reader.rs and every
#                         file under src/git_reader/), and
#                         crates/ka-reader-bridge/src/machine_config.rs, the composition root's
#                         search-path switch. The switch's test lies under tests/, outside the
#                         shipped scope. A line that draws the unit-edge row's binding finding draws
#                         no second one: a folder_model file stays QC-10 alone, and an fs_reader or
#                         highlighter file draws its one QC-11 line. A file of git_reader stays
#                         exempt here although it is a unit-edge subject, and a file of watcher or
#                         markdown_renderer draws this row's one line, never a second QC-11 line for
#                         the same name. This clause adds no other rule. Source: QC-11's "only
#                         git-reader imports the libgit2 binding".
#     QC-63  value        In ka-reader-core, a file of no unit (CP-470): a file of the shipped scope
#            module       under crates/ka-reader-core/src/ whose first component under src/, matched
#            (CP-470 -    as an exact file or directory name and never as a prefix, is none of the
#            CP-474)      seven units. The domain is stated by class and not by a list, so a file
#                         added later is in it with no edit here: src/paths.rs, src/language/x.rs,
#                         src/highlighter_ext.rs, src/tests/x.rs, and a lib.rs anywhere but
#                         src/lib.rs. lib.rs aside: crates/ka-reader-core/src/lib.rs is the one
#                         exemption, matched by its exact path, so src/x/lib.rs and src/lib/x.rs
#                         are in the domain. Not in it: any file of a unit (a unit with no file
#                         today included), crates/ka-reader-core/tests/, build.rs, a ka-reader-core
#                         file outside src/, and every file of ka-reader-bridge. Such a file that
#                         imports a unit is a QC-63 finding, `value module imports <unit>`. The
#                         target set is the seven units and the import forms are QC-10's and
#                         QC-11's, above: a path whose segment after a leading `crate` or run of
#                         `super` is a unit, a `use` tree reaching one, either form naming an item
#                         lib.rs re-exports from a unit's module, read from lib.rs on every run,
#                         across lines, with whitespace around `::` changing nothing. A comment or a
#                         string counts; `self::<unit>`, `ka_reader_core::<unit>`, a bare name, and
#                         a path to a file of no unit are not imports. One finding per distinct
#                         (file, line, unit): a line naming two units gives two, a line naming one
#                         unit twice gives one, at the line holding the unit's name. A file of a
#                         unit is judged by QC-10 and QC-11 alone and never draws this finding; a
#                         file of no unit never draws a QC-10 or QC-11 one. libgit2 names are not
#                         a QC-63 target. Source: QC-63's verified by.
#     QC-13  crate set    In every file under crates/ka-reader-bridge/, a crate named in code that
#            (CP-421,     is not `std`, `core` or `alloc`, and not a name under the `cargo:` section
#            CP-422)      of checks/deps.allow (read on every run, a `-` in a listed name read as
#                         `_`). A crate is named in code by the first segment of a `use` path or of
#                         a root-group member, the crate of an `extern crate` (never its alias), or
#                         the first segment of a path written in code. Never a crate: crate, self,
#                         super, Self, a name beginning with an uppercase letter, a primitive type,
#                         clippy, rustdoc, rustfmt, a module a file of the bridge declares with
#                         `mod`, and — as a path root only — a name a `use` item of the same file
#                         brings into scope. UNLIKE every other rule here but QC-17's adapter
#                         construction, this one reads code only: a comment or a string is not read,
#                         because the domain is open and every `word::` in prose or test data would
#                         be a candidate. Source: QC-13's import set.
#     QC-13  Apple        In every file under crates/ka-reader-bridge/, QC-9's Apple floor, the same
#            (CP-423)     names and forms read over raw text, reported as QC-13 and naming the
#                         framework or form. QC-9's own Apple finding stays ka-reader-core's.
#                         Source: QC-13's "must not import any Apple framework".
#     QC-13  watcher      In crates/ka-reader-bridge/, the files crates/ka-reader-bridge/src/watcher.rs
#     QC-11  (the bridge  and every file under crates/ka-reader-bridge/src/watcher/, matched as an
#     QC-10  unit)        exact name and never as a prefix (src/watcher_ext.rs is in no unit), are
#                         the only bridge files the Apple row above does not read: the native binding
#                         is written there and nowhere else, and QC-9's core row exempts nothing.
#                         The Apple floor, in both crates, also refuses native vocabulary written
#                         without the framework attribute: a token (comments and strings counting)
#                         beginning `FSEvent`, `CF` followed by a capital letter, or `dispatch_`.
#                         A watcher file that names `ka_reader_core`, or reaches another bridge
#                         module by `crate::<module>` (any but `watcher`), by `super::super::`, or,
#                         in src/watcher.rs, by `super::<module>` the bridge declares, is a QC-11
#                         finding. A folder_model file that imports `watcher` (`crate::watcher`, a
#                         `use` tree reaching it, or `watcher::` as a path root), and any
#                         ka-reader-core source file or the core manifest that names
#                         `ka_reader_bridge` or `ka-reader-bridge`, are QC-10 findings. Source:
#                         QC-10, QC-13 and QC-15's watcher placement.
#     QC-14  manifest     In crates/ka-reader-core/Cargo.toml and
#     crates/ka-reader-bridge/Cargo.toml, at
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
#     QC-17  logger       In every file read whose path is not under crates/ka-reader-bridge/src/
#     QC-61  (CP-426)     (the exact path component), a path whose first segment is `log` (or
#                         `::log`) and whose next segment is the whole word `set_logger` or
#                         `set_boxed_logger`, or a `use` tree rooted at `log` naming either,
#                         aliased or not. Two findings on that line, one QC-17 and one QC-61. A
#                         comment or a string counts. Source: QC-17's and QC-61's verified-by.
#     QC-17  adapter      In every file read whose path is not under crates/ka-reader-bridge/src/
#            construc-    (the exact path component, as the logger row reads it): each line of code
#            tion         that makes a value of git-reader's adapter from its name, `Libgit2`. The
#                         forms are a floor, each read across lines with whitespace changing
#                         nothing: the unit value as an expression (`Arc::new(Libgit2)`,
#                         `Box::new(Libgit2)`, `f(Libgit2)`, `f(&Libgit2)`, `let p = Libgit2;`,
#                         `return Libgit2`); a struct literal, `Libgit2 { … }`; and an associated
#                         function called on the type, such as `Libgit2::new(…)` or
#                         `Libgit2::default()`. Never a finding, because the name stands where a
#                         type stands: a `use` item or re-export, `pub use` included; the `struct
#                         Libgit2` definition; an `impl` header; a generic argument
#                         (`assert_port::<Libgit2>()`); the self type of a qualified path (`<Libgit2
#                         as GitPort>::probe`); a type annotation or bound (`p: Libgit2` as a
#                         parameter or field type, `-> Libgit2`, `&Libgit2` or `Arc<Libgit2>` in a
#                         type, `T: Into<Libgit2>`). Like the QC-13 crate set and unlike the logger
#                         row, this rule reads code only: a comment or a string holds no expression,
#                         so construction text inside one is not read, and a string between two code
#                         tokens still keeps them apart. The finding names the adapter, `Libgit2`,
#                         and the bridge's source path, at the line holding `Libgit2`, one per line.
#                         A folder_model line that constructs the adapter draws this finding and the
#                         QC-10 adapter finding. Source: QC-17's "the adapter's constructor …
#                         appear[s] only under crates/ka-reader-bridge/src/".
#     QC-2   write API    In ka-reader-core only, every file of the shipped scope, no file exempt:
#            (CP-445,     crates/ka-reader-core/src/fs_reader.rs is read too, because its owner
#            CP-446,      exemption is QC-15's filesystem clause alone, and a file added later for
#            CP-447)      own-state is not exempt before it exists. Comments and strings count.
#                         The floor is `std::fs::write`; the members are a floor this script may
#                         refuse more than, never fewer. A member is read in a path or as a member
#                         of a `use` tree, across lines and nested, the finding at the member's own
#                         line, and the segment before `fs` or `File` is whatever precedes it.
#                         (W1) directly after `fs`: write, copy, rename, create_dir,
#                         create_dir_all, remove_file, remove_dir, remove_dir_all, hard_link,
#                         soft_link, symlink, symlink_file, symlink_dir, mkfifo, mkdir, mkdirat,
#                         unlink, unlinkat, renameat, renameat_with, symlinkat, link, linkat,
#                         mknodat, ftruncate. (W2) `create` or `create_new` directly after `File`.
#                         (W3) the word `DirBuilder`. (W4) a builder flag literally set to true:
#                         `.` then write, append, create, create_new or truncate, then `(true)`,
#                         any whitespace. (W5) WRONLY, RDWR, CREATE, TRUNC or APPEND after
#                         `OFlags`, and O_WRONLY, O_RDWR, O_CREAT, O_TRUNC or O_APPEND as a
#                         `libc` path or `use libc` member. (W6) as a `libc` path or `use libc`
#                         member: creat, mkdir, mkdirat, mkfifo, mkfifoat, mknod, mknodat, rmdir,
#                         unlink, unlinkat, remove, rename, renameat, renamex_np, renameatx_np,
#                         symlink, symlinkat, link, linkat, truncate, ftruncate. Outside it:
#                         `File::open`, `.read(true)`, `OFlags::NOFOLLOW` and `NONBLOCK`,
#                         `libc::open` and `openat`, `libc::write`, `std::io::Write`, `write!`,
#                         `writeln!`, `.write_all`. One QC-2 finding per line. Source: QC-2.
#     QC-30  argument,    In every crate, every file of the shipped scope, no file exempt, comments
#     QC-58  environment  and strings counting. Two findings on the line, one QC-30 and one QC-58,
#            and          each one clause however many members the line holds. (E1) `args`,
#            configura-   `args_os`, `var`, `var_os`, `vars` or `vars_os` directly after `env`, in
#            tion         a path or a `use` tree member, whatever precedes `env`. (E2) `getenv`,
#            (CP-448 -    `environ`, `_NSGetEnviron`, `_NSGetArgv` or `_NSGetArgc` as a `libc`
#            CP-451)      path or `use libc` member. A configuration location is read in the
#                         line's raw text, so a string's punctuation counts as written: (C1)
#                         `.config/` or `.config"`; (C2) `Library/Preferences`; (C3) `/etc/`;
#                         (C4) the words config_dir, config_local_dir and preference_dir; (C5) the
#                         path or `use` roots dotenv, dotenvy, confy and figment. Outside it:
#                         current_exe, current_dir, temp_dir, home_dir, `env!`, `option_env!`, a
#                         local named `config`, `libc::getpwuid_r`. Source: QC-30's and QC-58's
#                         argument, environment and configuration clauses.
#     QC-15  socket       In every crate, every file of the shipped scope, and both filesystem
#     QC-30  (CP-452)     owner files, because the owner exemption above is the filesystem clause's
#                         alone. A QC-15 finding of this clause and the line's one QC-30 finding,
#                         never a QC-58 one. A line holding a non-owner filesystem module and a
#                         socket gets two QC-15 findings, one per clause. (S1) the module `net` in
#                         a path or `use` tree rooted at `std`, `::std` or `rustix`, whitespace or
#                         newlines around `::` changing nothing, the finding at the `net` line; it
#                         refuses `std::net::IpAddr` too, and a local `net`, `crate::net` and
#                         `mod net` are not rooted there. (S2) socket, socketpair, connect, bind,
#                         listen, accept or accept4 as a `libc` path or `use libc` member. Comments
#                         and strings count. Source: QC-15's socket clause.
#     layer-5 CARGO_BIN_EXE_  (CP-453 - CP-455) In every regular *.rs file at any depth under
#            placement    crates/<c>/tests/, for every crate and no other file: each line whose
#                         raw text holds `CARGO_BIN_EXE_` anywhere, in code, a comment or a string,
#                         is one `layer-5` finding. The same text in src/, in src/tests/ or in
#                         build.rs is not one. No other rule reads these files. Source: § 9's
#                         layer-5 placement rule.
#
# WHAT IS NOT HELD
#   This version holds only the rules in the table above. Every other rule docs/nfdr.md names
#   for checks/structure.sh is NOT held here, and the NFDR's header sentence that each script's
#   rules become executable with the script is read as: a rule is executable from the change
#   that adds it here. Until then its gate is the design review. Not held: QC-7; QC-12;
#   QC-20. And these parts of rules the table above holds in part:
#     - The watcher's native binding is not judged for what it does: that the adapter never stats,
#       canonicalizes or checks the existence of a reported path (QC-15) names `Path` methods the
#       scan cannot see, and review of the diff holds it. A native name outside the vocabulary
#       above (a framework call spelled without FSEvent, CF or dispatch_) is not found.
#     - QC-15's filesystem owners, in two parts: which read the adapter makes inside its owner
#       file (every filesystem form there is admitted), and `git-reader`'s `Path`-method reads
#       (`Path::metadata`, `symlink_metadata`, which name no `fs` module). Review at
#       development-design holds both.
#     - QC-11's bound on the edge from `markdown-renderer` to `fs-reader`: that the edge reaches
#       `fs-reader`'s containment check alone. The scan judges an import a whole unit at a time, so
#       every import of fs_reader by a markdown_renderer file draws nothing. Review at
#       development-design holds it.
#     - QC-63's types-and-values half: whether a value module holds anything a part's Owns cell
#       names. No script rule approximates it; its gate is review at development-design.
#
# GAPS THE RULES ABOVE DO NOT CLOSE
#   Named so that none is read as coverage. The scan reads source text of the files in scope,
#   so it does not see: `std` reached through an alias (`use std as s;`,
#   `extern crate std as s;`); a `Path` method that touches the filesystem (exists, metadata,
#   read_dir, canonicalize), which names no filesystem module; a crate-level build.rs that
#   emits `cargo:rustc-link-lib=framework=…`, because build.rs is outside every rule; source
#   that is generated or pulled in by `include!`, or a `#[cfg(test)]` module whose body sits in
#   the excluded tests/ directory. And, for the unit-graph rules, QC-63 among them: an edge reached
#   through a glob import (`use crate::*;`, `use log::*;`); an edge through `#[path]`, `include!` or
#   macro-generated source; a crate reached through a dependency renamed in a manifest
#   (`foo = { package = "x" }`), where QC-13 reads only the in-code name; a crate whose name
#   begins with an uppercase letter; a dependency inherited from the workspace manifest
#   (`x.workspace = true`) whose workspace entry points into checks/; a git dependency into this
#   repository; a symlink into checks/; code a build script generates and the library
#   `include!`s from OUT_DIR. A review catches these.
#   And, for the boundary-read rules: `std::env::temp_dir` (it returns TMPDIR) and
#   `std::env::home_dir` (it returns HOME), which are environment reads this script does not
#   refuse; an environment read through a glob import (`use std::env::*;` and then a bare
#   `var(…)`); a write, a socket or an environment read through a crate other than `std`, `rustix`
#   and `libc` — in the bridge QC-13 names an unlisted crate, and in ka-reader-core only QC-3's
#   allowlist stands; an open whose write access sits in a variable or a numeric constant
#   (`.write(w)`, `custom_flags(1)`, `libc::open(p, flags)`), and the fd-generic `libc::write`; a
#   configuration location no member names, or one assembled at run time from parts; a
#   `CARGO_BIN_EXE_` name assembled by a macro (`concat!`); and a `#[path]` that loads a tests/
#   file into shipped source, which only the `#[cfg(test)]` on its declaration keeps out of the
#   binary.
#   And, for the adapter rules: an adapter reached under another name, as in `use
#   crate::git_reader::Libgit2 as L;` or `type G = Libgit2;`, and then constructed as `L` or
#   `G::default()`; the adapter's module reached through an alias of git_reader (`use
#   crate::git_reader as g;` and then `g::libgit2`), on a line that does not also name `Libgit2`; a
#   value made inside an impl of the adapter as `Self`; a value made by a trait call whose type is
#   inferred, as in `let p: Libgit2 = Default::default();`, where the name stands only as a type; a
#   field value written `port: Libgit2` inside a struct literal, which reads as a field type; a
#   construction later in an expression where `<` compares a value whose name is capitalised but not
#   a constant, as in `Level::Debug < level && take(Libgit2)`, because that `<`
#   reads as the opening of a generic argument list; and a construction in macro-generated or
#   `include!`d source. A review catches these.

set -euo pipefail

product_root="$(cd "$(dirname "$0")/.." && pwd -P)"
crates_dir="$product_root/crates"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
: > "$work/findings"
: > "$work/causes"

tab="$(printf '\t')"
unit_names=" folder_model fs_reader highlighter own_state git_reader watcher markdown_renderer "
required_inputs="checks/deps.allow crates/ka-reader-core/Cargo.toml crates/ka-reader-bridge/Cargo.toml"

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
  if (!is_bridge) note(ln, "QC-9", 2, "", "`unsafe` outside ka-reader-bridge")
}

function add_apple(ln, form) {
  if (is_core) note(ln, "QC-9", 1, "", "Apple framework or binding `" form "` in ka-reader-core")
  if (is_bridge && !bwatch) note(ln, "QC-13", 2, form, "Apple framework or binding `" form "` in ka-reader-bridge")
}

# The native vocabulary a binding can be written in without the framework attribute: a token that
# begins FSEvent, CF and a capital letter, or dispatch_. A floor in both crates; the bridge's
# watcher files are the one place the QC-13 clause lets it stand.
function is_native_vocab(w) {
  return w ~ /^FSEvent/ || w ~ /^CF[A-Z]/ || w ~ /^dispatch_/
}

# A path that starts at `crate` or at a run of `super`, written in a bridge watcher file, reaches
# another bridge module unless it reaches the watcher itself. In src/watcher.rs a single `super` is
# the crate root, so it reaches a module only by naming one the bridge declares; in a file under
# src/watcher/ a single `super` is the watcher module, and a second one is the crate root.
function watcher_reach(ln, parent, w,    n) {
  if (!bwatch || !is_word_token(w) || w == "watcher") return
  if (parent == "crate") { note(ln, "QC-11", 3, w, "watcher reaches the bridge module `" w "`"); return }
  n = gsub(/super/, "super", parent)
  if (n >= 2 || (n == 1 && !bwatch_nested && index(BMODS, " " w " ") > 0))
    note(ln, "QC-11", 3, w, "watcher reaches the bridge module `" w "`")
}

function add_process(ln) {
  note(ln, "QC-36", 1, "", "std::process named — no shipped crate spawns a process")
  if (is_core) note(ln, "QC-9", 3, "", "std::process named in ka-reader-core")
}

function add_fs(ln, form) {
  if (!exempt) note(ln, "QC-15", 1, "", "filesystem primitive `" form "` outside its owner file")
}

function in_set(set, w) {
  return index(set, " " w " ") > 0
}

# The last segment of a `::`-joined path: the segment directly before a member of a `use` tree.
function last_seg(path,    p, q) {
  p = path
  while ((q = index(p, "::")) > 0) p = substr(p, q + 2)
  return p
}

function add_write(ln, form) {
  if (is_core) note(ln, "QC-2", 1, "", "write API `" form "` in ka-reader-core")
}

# An argument, environment or configuration-file read: one QC-30 and one QC-58 finding on the line,
# each a single clause however many members the line holds.
function add_config_read(ln, what) {
  note(ln, "QC-30", 1, "", what " — no shipped crate reads its arguments, its environment or a configuration file")
  note(ln, "QC-58", 1, "", what " — the product has no configuration surface")
}

# Opening a socket: a QC-15 finding of its own clause (the filesystem owners are exempt from the
# filesystem clause only) and the line's one QC-30 finding, never a QC-58 one.
function add_socket(ln, form) {
  note(ln, "QC-15", 2, "", "socket `" form "` — no unit owns a socket")
  note(ln, "QC-30", 1, "", "socket `" form "` — no shipped crate reads its arguments, its environment or a configuration file")
}

function is_config_root(w) {
  return w == "dotenv" || w == "dotenvy" || w == "confy" || w == "figment"
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

# The forbidden sets are QC-11's "must not import `folder-model`, `own-state`, or one another", less
# its two stated edges: markdown_renderer may import fs_reader and highlighter. folder_model is
# QC-10's subject and is forbidden own_state alone. A file of watcher or markdown_renderer is judged
# from the run in which it first appears.
function forbidden_edge(u) {
  if (subj == "folder_model") return u == "own_state" || u == "watcher"
  if (subj == "fs_reader") return index(" folder_model own_state git_reader watcher markdown_renderer highlighter ", " " u " ") > 0
  if (subj == "highlighter") return index(" folder_model own_state git_reader watcher markdown_renderer fs_reader ", " " u " ") > 0
  if (subj == "git_reader") return index(" folder_model own_state fs_reader watcher highlighter markdown_renderer ", " " u " ") > 0
  if (subj == "watcher") return index(" folder_model own_state fs_reader git_reader highlighter markdown_renderer ", " " u " ") > 0
  if (subj == "markdown_renderer") return index(" folder_model own_state git_reader watcher ", " " u " ") > 0
  return 0
}

function subject_qc() {
  return (subj == "folder_model") ? "QC-10" : "QC-11"
}

function add_unit(ln, w,    u) {
  u = unit_of(w)
  if (value_module) {
    if (u != "") note(ln, "QC-63", 1, u, "value module imports " u)
    return
  }
  if (subj == "") return
  if (u == "" || u == subj) return
  if (forbidden_edge(u)) note(ln, subject_qc(), 1, u, subj " imports " u)
}

# The binding's wording does not follow the subject set. A folder_model, fs_reader or highlighter
# file draws the subject-worded line. A git_reader file draws nothing, because git-reader owns the
# binding. A watcher or markdown_renderer file draws the general line, the one it drew before either
# unit was a subject.
function add_git2(ln, w) {
  if (subj == "folder_model" || subj == "fs_reader" || subj == "highlighter") {
    note(ln, subject_qc(), 2, w, subj " names the libgit2 binding `" w "`")
    return
  }
  if (git_exempt) return
  note(ln, "QC-11", 2, w, "the libgit2 binding `" w "` named outside git-reader")
}

# Each new clause has its own rank, after the clauses its QC already had, so a line that draws two
# clauses keeps both and the report's order does not move.
#
# QC-10's adapter clause. `Libgit2` counts as a whole word in the raw text, comments and strings
# included. `libgit2` counts only as the segment directly after `git_reader` in a path or `use` tree
# that starts with `crate` or a run of `super`, so the lowercase word in prose draws nothing. One
# finding per line and form.
function add_adapter(ln, form) {
  note(ln, "QC-10", 3, form, "folder_model names git-reader's adapter `" form "`")
}

# Whether the word w stands in text, a word character on either side meaning no match.
function has_word(text, w,    off, rest, p, before, after) {
  off = 0
  rest = text
  while ((p = index(rest, w)) > 0) {
    before = (off + p > 1) ? substr(text, off + p - 1, 1) : ""
    after = substr(text, off + p + length(w), 1)
    if (before !~ /[A-Za-z0-9_]/ && after !~ /[A-Za-z0-9_]/) return 1
    off += p
    rest = substr(text, off + 1)
  }
  return 0
}

function is_git_reader_path(parent) {
  return parent ~ /^(crate|super(::super)*)::git_reader$/
}

function add_logger(ln, w) {
  if (in_src) return
  note(ln, "QC-17", 1, w, "`log::" w "` outside crates/ka-reader-bridge/src/")
  note(ln, "QC-61", 1, w, "`log::" w "` outside crates/ka-reader-bridge/src/")
}

# QC-17's adapter construction. The name `Libgit2` in code is a construction unless it stands where
# a type stands: a `use` item, the `struct` definition, an `impl` header, a generic argument, the
# self type of a qualified path, an annotation or a bound. Those positions are closed off before the
# name is judged, across lines and with brackets balanced. Comments and strings are not read, and a
# string still separates the code tokens on either side of it. The finding is at the line holding
# the name, once per line.

# Marks a `use` or `type` item as a type position, to the `;` outside braces.
function mark_to_semi(t, n, k,    m, d) {
  d = 0
  for (m = k; m <= n; m++) {
    ty17[m] = 1
    if (t[m] == "{") d++
    else if (t[m] == "}") { if (d > 0) d-- }
    else if (t[m] == ";" && d == 0) return
  }
}

# Marks an item header, to its `{` or `;` outside brackets; with whole set, a `{` body too.
function mark_item(t, n, k, whole,    m, d, b) {
  d = 0
  for (m = k; m <= n; m++) {
    ty17[m] = 1
    if (t[m] == "(" || t[m] == "[") d++
    else if (t[m] == ")" || t[m] == "]") { if (d > 0) d-- }
    else if (d == 0 && t[m] == ";") return
    else if (d == 0 && t[m] == "{") {
      if (!whole) return
      b = 1
      while (++m <= n && b > 0) {
        ty17[m] = 1
        if (t[m] == "{") b++
        else if (t[m] == "}") b--
      }
      return
    }
  }
}

# Marks the annotation of a `let`, `const` or `static` as a type position: from the `:` that follows
# its pattern or name at depth zero to the `=` or `;` that ends it, brackets and generic lists
# balanced, so a tuple, an array or a slice in it is a type too. The value after the `=` is not
# marked. A `const fn` or a `*const T` has no such `:` before its `{`, `=` or `;`, and is left
# alone.
function mark_annotation(t, n, k,    m, d, a) {
  d = 0
  for (m = k + 1; m <= n; m++) {
    if (t[m] == "(" || t[m] == "[") d++
    else if (t[m] == ")" || t[m] == "]") { if (d == 0) return; d-- }
    else if (d == 0 && (t[m] == "=" || t[m] == ";" || t[m] == "{" || t[m] == "}")) return
    else if (d == 0 && t[m] == ":") break
  }
  d = 0
  a = 0
  for (m++; m <= n; m++) {
    if (t[m] == "(" || t[m] == "[") d++
    else if (t[m] == ")" || t[m] == "]") { if (d == 0) return; d-- }
    else if (t[m] == "<") a++
    else if (t[m] == ">" && t[m - 1] != "-") { if (a == 0) return; a-- }
    else if (d == 0 && a == 0 && (t[m] == "=" || t[m] == ";" || t[m] == "{" || t[m] == "}")) return
    ty17[m] = 1
  }
}

# Marks the parameter types of a closure whose opening `|` is at k: each `:` at depth zero, to the
# `,` or `|` that ends that parameter. A `|` opens a closure where an operand cannot end, so `a | b`
# and `a || b` are left alone.
function mark_closure_params(t, n, k,    p, m, d, a, on) {
  p = (k > 1) ? t[k - 1] : ""
  if (!(k == 1 || p == "(" || p == "," || p == "=" || p == "{" || p == ";" || p == "[" || p == ":" || p == "move" || p == "return" || (p == ">" && t[k - 2] == "="))) return
  d = 0
  a = 0
  on = 0
  for (m = k + 1; m <= n; m++) {
    if (t[m] == "(" || t[m] == "[") d++
    else if (t[m] == ")" || t[m] == "]") { if (d == 0) return; d-- }
    else if (t[m] == "<") a++
    else if (t[m] == ">" && t[m - 1] != "-") { if (a > 0) a-- }
    else if (d == 0 && a == 0 && t[m] == "|") return
    else if (d == 0 && a == 0 && t[m] == ",") { on = 0; continue }
    else if (d == 0 && a == 0 && t[m] == ":") { on = 1; continue }
    else if (t[m] == "{" || t[m] == "}" || t[m] == ";") return
    if (on) ty17[m] = 1
  }
}

# A `<` opens a generic argument list or a qualified path, and is not a comparison, after `::`,
# after a name that begins with an uppercase letter, `impl`, `dyn` or a function's name, and after
# any punctuation that cannot end an operand. A constant's name, all capitals, ends an operand, and
# so do a string, a character and a `?`: after any of them the `<` compares.
function opens_angle(t, k,    p) {
  p = (k > 1) ? t[k - 1] : ""
  if (p == "::") return 1
  if (p == "<" || p == ")" || p == "]" || p == "}" || p == "?" || p == "\"str\"" || p == "'chr'") return 0
  if (is_word_token(p)) {
    if (p ~ /^[A-Z][A-Z0-9_]+$/) return 0
    if (p ~ /^[A-Z]/ || p == "impl" || p == "dyn") return 1
    return (k > 2 && t[k - 2] == "fn")
  }
  return 1
}

# The name follows a type marker: an annotation `:`, a return `->` or a cast `as`, past any path
# prefix, reference, `mut`, lifetime or `dyn`.
function after_type_marker(t, k,    j) {
  j = k - 1
  while (j >= 1 && t[j] == "::") {
    j--
    if (j >= 1 && is_word_token(t[j])) j--
  }
  while (j >= 1) {
    if (t[j] == "&" || t[j] == "*" || t[j] == "mut" || t[j] == "const" || t[j] == "dyn") j--
    else if (j >= 2 && is_word_token(t[j]) && t[j - 1] == "'") j -= 2
    else break
  }
  if (j < 1) return 0
  if (t[j] == ":" || t[j] == "as") return 1
  return (t[j] == ">" && j > 1 && t[j - 1] == "-")
}

function scan_construction(t, l, n,    k, w, sp) {
  for (k = 1; k <= n; k++) {
    w = t[k]
    if (w == "use" || w == "type") mark_to_semi(t, n, k)
    else if (w == "struct" || w == "enum") mark_item(t, n, k, 1)
    else if (w == "impl" || w == "fn" || w == "trait") mark_item(t, n, k, 0)
    else if (w == "let" || w == "const" || w == "static") mark_annotation(t, n, k)
    else if (w == "|") mark_closure_params(t, n, k)
  }
  sp = 0
  for (k = 1; k <= n; k++) {
    w = t[k]
    if (w == "{" || w == "}" || w == ";") sp = 0
    else if (w == "<") { if (opens_angle(t, k)) sp++ }
    else if (w == ">") { if (sp > 0 && t[k - 1] != "-" && t[k - 1] != "=") sp-- }
    else if (sp > 0) ty17[k] = 1
  }
  for (k = 1; k <= n; k++) {
    if (t[k] != "Libgit2" || (k in ty17) || after_type_marker(t, k)) continue
    note(l[k], "QC-17", 2, "", "git-reader's adapter `Libgit2` constructed outside crates/ka-reader-bridge/src/")
  }
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

# The boundary-read rules keyed on the segment directly before the member, in a path or in a `use`
# tree: `fs`, `File` and `OFlags` for QC-2.
function use_member_rules(before, w, ln) {
  if (before == "fs" && in_set(W1, w)) add_write(ln, "fs::" w)
  if (before == "File" && (w == "create" || w == "create_new")) add_write(ln, "File::" w)
  if (before == "OFlags" && in_set(W5_OFLAGS, w)) add_write(ln, "OFlags::" w)
  if (before == "env" && in_set(E1, w)) add_config_read(ln, "environment read `env::" w "`")
}

# The module `net` under a root of `std` or `rustix`, as a path segment or a `use` member.
function net_module(first, w, ln) {
  if ((first == "std" || first == "rustix") && w == "net") add_socket(ln, first "::..::net")
}

# The `libc::` members, as a path (`libc::X`) or a member of a `use libc` tree.
function libc_member_rules(w, ln) {
  if (in_set(W5_LIBC, w) || in_set(W6, w)) add_write(ln, "libc::" w)
  if (in_set(E2, w)) add_config_read(ln, "environment read `libc::" w "`")
  if (in_set(S2, w)) add_socket(ln, "libc::" w)
}

# What a segment of a `use` tree means: $1 is the path before it, $2 the first segment of its
# path, $3 the segment, $4 whether it starts a path or a member of the tree, $5 its line.
function use_segment(parent, first, w, atstart, ln) {
  if (atstart && is_apple(w)) add_apple(ln, w)
  if (atstart && is_git2(w)) add_git2(ln, w)
  if (first == "std" && w == "process" && parent != "") add_process(ln)
  if ((first == "std" || first == "rustix") && w == "fs" && parent != "") add_fs(ln, first "::..::fs")
  if (first == "libc" && parent == "libc" && is_libc_file_call(w)) add_fs(ln, "libc::" w)
  if (parent != "") { use_member_rules(last_seg(parent), w, ln); net_module(first, w, ln) }
  if (first == "libc" && parent == "libc") libc_member_rules(w, ln)
  if (first == "log" && parent != "" && is_logger(w)) add_logger(ln, w)
  if (is_crate_or_super(parent)) { add_unit(ln, w); watcher_reach(ln, parent, w) }
  if (subj == "folder_model" && w == "libgit2" && is_git_reader_path(parent)) add_adapter(ln, "git_reader::libgit2")
  if (atstart && parent == "" && is_config_root(w)) add_config_read(ln, "configuration loader `" w "`")
  if (stream_code && parent == "" && atstart) crate_position(w, ln, 0)
}

# What a segment after the first of a path means, wherever the path is written: $1 is the path's
# first segment, $2 the segment, $3 how many segments follow the first up to it, $4 its line.
function chain_segment(first, seg, depth, ln, prev) {
  if (first == "std" && seg == "process") add_process(ln)
  if ((first == "std" || first == "rustix") && seg == "fs") add_fs(ln, first "::..::fs")
  if (first == "libc" && depth == 1 && is_libc_file_call(seg)) add_fs(ln, "libc::" seg)
  if (first == "log" && depth == 1 && is_logger(seg)) add_logger(ln, seg)
  use_member_rules(prev, seg, ln)
  net_module(first, seg, ln)
  if (first == "libc" && depth == 1) libc_member_rules(seg, ln)
}

function scan_chain(t, l, k,    first, j, depth, prev) {
  first = t[k]
  prev = first
  j = k + 1
  depth = 1
  while (t[j] == "::" && is_word_token(t[j + 1])) {
    chain_segment(first, t[j + 1], depth, l[j + 1], prev)
    prev = t[j + 1]
    j += 2
    depth++
  }
}

# The target of a `crate::<x>` path or of a run of `super::` segments.
function scan_unit_path(t, l, k,    j, m, prefix) {
  j = k
  if (t[k] == "super") { while (t[j] == "super" && t[j + 1] == "::") j += 2 }
  else j = k + 2
  if (is_word_token(t[j])) {
    add_unit(l[j], t[j])
    prefix = "crate"
    if (t[k] == "super") { prefix = "super"; for (m = k + 2; m < j; m += 2) prefix = prefix "::super" }
    watcher_reach(l[j], prefix, t[j])
  }
  if (subj == "folder_model" && t[j] == "git_reader" && t[j + 1] == "::" && t[j + 2] == "libgit2") add_adapter(l[j + 2], "git_reader::libgit2")
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

# The rules read off the physical line, before the tokenizer splits a string's `/` and `.` apart: a
# configuration location is its text as written, comments and strings included.
function raw_line_rules(text, ln) {
  if (is_core && index(text, "ka-reader-bridge") > 0) note(ln, "QC-10", 4, "ka_reader_bridge", "ka-reader-core names ka_reader_bridge — the core never imports the bridge")
  if (subj == "folder_model" && has_word(text, "Libgit2")) add_adapter(ln, "Libgit2")
  if (index(text, ".config/") > 0 || index(text, ".config\"") > 0) add_config_read(ln, "configuration path `.config`")
  if (index(text, "Library/Preferences") > 0) add_config_read(ln, "configuration path `Library/Preferences`")
  if (index(text, "/etc/") > 0) add_config_read(ln, "configuration path `/etc/`")
}

function scan_stream(t, l, n,    k) {
  for (k = 1; k <= n; k++) {
    if (t[k] == "unsafe") add_unsafe(l[k])
    if (is_word_token(t[k]) && is_native_vocab(t[k])) add_apple(l[k], t[k])
    if (bwatch && t[k] == "ka_reader_core") note(l[k], "QC-11", 4, "ka_reader_core", "watcher names ka_reader_core — it imports no core item")
    if (is_core && t[k] == "ka_reader_bridge") note(l[k], "QC-10", 4, "ka_reader_bridge", "ka-reader-core names ka_reader_bridge — the core never imports the bridge")
    if (subj == "folder_model" && t[k] == "watcher" && t[k + 1] == "::" && is_root(t, k)) note(l[k], "QC-10", 1, "watcher", "folder_model imports watcher")
    if (t[k] == "DirBuilder") add_write(l[k], "DirBuilder")
    if (t[k] == "config_dir" || t[k] == "config_local_dir" || t[k] == "preference_dir") add_config_read(l[k], "configuration locator `" t[k] "`")
    if (t[k] == "." && in_set(W4, t[k + 1]) && t[k + 2] == "(" && t[k + 3] == "true" && t[k + 4] == ")") add_write(l[k + 1], "." t[k + 1] "(true)")
    if (t[k] == "kind" && t[k + 1] == "=" && t[k + 2] == "\"" && t[k + 3] == "framework" && t[k + 4] == "\"") add_apple(l[k], "kind = \"framework\"")
    if (t[k] == "extern" && t[k + 1] == "crate") {
      if (is_config_root(t[k + 2])) add_config_read(l[k + 2], "configuration loader `" t[k + 2] "`")
      if (is_apple(t[k + 2])) add_apple(l[k + 2], t[k + 2])
      if (is_git2(t[k + 2])) add_git2(l[k + 2], t[k + 2])
      if (stream_code) crate_position(t[k + 2], l[k + 2], 0)
    }
    if ((t[k] == "crate" || t[k] == "super") && t[k + 1] == "::" && is_root(t, k)) scan_unit_path(t, l, k)
    if (is_word_token(t[k]) && t[k + 1] == "::" && is_root(t, k)) {
      if (is_apple(t[k])) add_apple(l[k], t[k])
      if (is_git2(t[k])) add_git2(l[k], t[k])
      if (is_config_root(t[k])) add_config_read(l[k], "configuration loader `" t[k] "`")
      if (stream_code && is_word_token(t[k + 2]) && !(k in inuse)) crate_position(t[k], l[k], 1)
      scan_chain(t, l, k)
    }
  }
}

BEGIN {
  LIBC = " open openat creat fopen fdopen freopen opendir fdopendir readdir stat lstat fstat fstatat access faccessat mkdir mkdirat rmdir unlink unlinkat rename renameat truncate ftruncate readlink readlinkat symlink link chmod fchmod chown realpath "
  APPLE = " objc objc2 objc_foundation objc_id block block2 dispatch dispatch2 cocoa cocoa_foundation core_foundation core_foundation_sys core_graphics core_graphics_types core_text core_services security_framework security_framework_sys system_configuration system_configuration_sys fsevent fsevent_sys io_kit_sys metal "
  W1 = " write copy rename create_dir create_dir_all remove_file remove_dir remove_dir_all hard_link soft_link symlink symlink_file symlink_dir mkfifo mkdir mkdirat unlink unlinkat renameat renameat_with symlinkat link linkat mknodat ftruncate "
  W4 = " write append create create_new truncate "
  W5_OFLAGS = " WRONLY RDWR CREATE TRUNC APPEND "
  W5_LIBC = " O_WRONLY O_RDWR O_CREAT O_TRUNC O_APPEND "
  W6 = " creat mkdir mkdirat mkfifo mkfifoat mknod mknodat rmdir unlink unlinkat remove rename renameat renamex_np renameatx_np symlink symlinkat link linkat truncate ftruncate "
  E1 = " args args_os var var_os vars vars_os "
  S2 = " socket socketpair connect bind listen accept accept4 "
  E2 = " getenv environ _NSGetEnviron _NSGetArgv _NSGetArgc "
  PRIMITIVES = " bool char str i8 i16 i32 i64 i128 isize u8 u16 u32 u64 u128 usize f32 f64 "
  TOOLS = " clippy rustdoc rustfmt "
}

layer5 {
  # A file under crates/<c>/tests/ is read for this one rule, as raw text, line by line.
  if (index($0, "CARGO_BIN_EXE_") > 0) bin_exe[NR] = 1
  next
}

{
  ln = NR
  line = $0
  len = length(line)
  raw_line_rules(line, ln)
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
      else if (c == "\"") { flush_word(); push("\"", ln, "s"); strmark[nt] = 1; mode = "str"; i++ }
      else if ((c == "r" || c == "b") && (i == 1 || substr(line, i - 1, 1) !~ /[A-Za-z0-9_]/) && match(substr(line, i), /^b?r#*"/)) {
        flush_word()
        rawtext = substr(line, i, RLENGTH)
        tmp = rawtext
        rawhashes = gsub(/#/, "", tmp)
        rawclose = ""
        for (q = 1; q <= rawhashes; q++) rawclose = rawclose "#"
        push("\"", ln, "s")
        strmark[nt] = 1
        mode = "raw"
        i += RLENGTH
      }
      else if (c == "'") {
        flush_word()
        if (substr(line, i + 1, 1) == "\\") {
          j = i + 3
          while (j <= len && substr(line, j, 1) != "'") j++
          chrmark[nt] = 1
          i = j + 1
        }
        else if (substr(line, i + 2, 1) == "'" && substr(line, i + 1, 1) != "'") { chrmark[nt] = 1; i += 3 }
        else emit_at("k")
      }
      else emit_at("k")
    }
  }
  flush_word()
}

END {
  if (layer5) {
    # The sort reads the third field as a number, so layer-5 carries its own layer number, 5, which
    # no QC number is ever read as.
    for (key in bin_exe)
      printf "%s\t%d\t5\t1\t\t%s:%d: layer-5: `CARGO_BIN_EXE_` under crates/<c>/tests/ — a test reaches a binary by name only in the layer-5 harness\n", rel, key, rel, key
    exit
  }
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
  if (!in_src) {
    # The code stream with a placeholder where a string or a character stood, so a literal keeps its
    # neighbours apart and still ends an operand. chrmark[k] says a character follows token k.
    n17 = 0
    for (k = 0; k <= nt; k++) {
      if (k > 0 && tkind[k] == "k") { n17++; t17[n17] = tk[k]; l17[n17] = tl[k] }
      else if (k in strmark) { n17++; t17[n17] = "\"str\""; l17[n17] = tl[k] }
      if (k in chrmark) { n17++; t17[n17] = "'chr'"; l17[n17] = (k > 0) ? tl[k] : 1 }
    }
    scan_construction(t17, l17, n17)
  }
  for (key in found) {
    split(key, kp, SUBSEP)
    printf "%s\t%d\t%d\t%d\t%s\t%s:%d: %s: %s\n", rel, kp[1], substr(kp[2], 4) + 0, kp[3], kp[4], rel, kp[1], kp[2], found[key]
  }
}
AWK

# --- the re-export program: which items ka-reader-core's lib.rs re-exports from which unit ---

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
if [ -r "$crates_dir/ka-reader-core/src/lib.rs" ]; then
  reexports=" $(LC_ALL=C awk -v UNITS="$unit_names" -f "$work/reexport.awk" "$crates_dir/ka-reader-core/src/lib.rs" || true) "
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
        tests/*) printf '%s\n' "crates/$crate_name/$within_crate" >> "$work/test_files"; continue ;;
        build.rs) continue ;;
      esac
      printf '%s\n' "crates/$crate_name/$within_crate"
    done
  done | LC_ALL=C sort > "$work/files"
else
  : > "$work/files"
fi
# The second list: every regular Rust file under a crate-level tests/, which only layer-5 reads.
: >> "$work/test_files"
LC_ALL=C sort -o "$work/test_files" "$work/test_files"

# The modules any file of the bridge declares with `mod`, collected across the run before any file
# is judged: a path rooted at one is a local module, not a crate.
bridge_mods=" "
if [ -s "$work/files" ]; then
  while IFS= read -r relative; do
    case "$relative" in
      crates/ka-reader-bridge/*) ;;
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
    git_exempt=0
    in_bridge_src=0
    bridge_watcher=0
    bridge_watcher_nested=0
    subject_unit=""
    value_module=0
    [ "$crate_name" = "ka-reader-core" ] && is_core=1
    [ "$crate_name" = "ka-reader-bridge" ] && is_bridge=1
    case "$relative" in
      crates/ka-reader-core/src/fs_reader.rs | crates/ka-reader-bridge/src/log_writer.rs | crates/ka-reader-core/src/git_reader/libgit2.rs) exempt=1 ;;
    esac
    case "$relative" in
      crates/ka-reader-bridge/src/*) in_bridge_src=1 ;;
    esac
    # The bridge's watcher unit, matched as an exact name: src/watcher.rs and every file under
    # src/watcher/, never src/watcher_ext.rs.
    case "$relative" in
      crates/ka-reader-bridge/src/watcher.rs) bridge_watcher=1 ;;
      crates/ka-reader-bridge/src/watcher/*) bridge_watcher=1; bridge_watcher_nested=1 ;;
    esac
    # The two files that may name the libgit2 binding: every file of the git_reader unit, and the
    # composition root's search-path switch.
    case "$relative" in
      crates/ka-reader-core/src/git_reader.rs | crates/ka-reader-core/src/git_reader/* | crates/ka-reader-bridge/src/machine_config.rs) git_exempt=1 ;;
    esac
    # The subject unit is the module by exact file or directory component, never a prefix.
    case "$relative" in
      crates/ka-reader-core/src/*)
        within_src="${relative#crates/ka-reader-core/src/}"
        case "$within_src" in
          */*) module_name="${within_src%%/*}" ;;
          *.rs) module_name="${within_src%.rs}" ;;
          *) module_name="" ;;
        esac
        case "$module_name" in
          folder_model | fs_reader | highlighter | git_reader | watcher | markdown_renderer) subject_unit="$module_name" ;;
        esac
        # A file of no unit: its module is none of the units the awk pass is given (the same
        # full set, so a unit with no subject rule today stays out), however it is spelled.
        case "$unit_names" in
          *" $module_name "*) ;;
          *) value_module=1 ;;
        esac
        # The one exemption is the exact path of the crate root, never the module name `lib`, so
        # src/lib/x.rs and src/x/lib.rs stay in the domain.
        if [ "$relative" = "crates/ka-reader-core/src/lib.rs" ]; then
          value_module=0
        fi
        ;;
    esac
    if [ ! -r "$product_root/$relative" ]; then
      echo "cannot read $relative" >> "$work/causes"
      continue
    fi
    LC_ALL=C awk -v rel="$relative" -v is_core="$is_core" -v is_bridge="$is_bridge" -v exempt="$exempt" -v git_exempt="$git_exempt" \
      -v subj="$subject_unit" -v value_module="$value_module" \
      -v in_src="$in_bridge_src" -v have_allow="$have_allow" \
      -v bwatch="$bridge_watcher" -v bwatch_nested="$bridge_watcher_nested" \
      -v ALLOWED="$allowed" -v BMODS="$bridge_mods" -v REEXPORT="$reexports" -v UNITS="$unit_names" \
      -f "$work/scan.awk" "$product_root/$relative" >> "$work/findings" \
      || echo "the scan could not read $relative" >> "$work/causes"
  done < "$work/files"
fi

# --- the test files: layer-5 ---
# Read by the layer-5 rule alone, counted in neither the files nor the crates of the pass line, and
# never a reason the run has read something: the guard above is on the shipped scope. One that
# cannot be read is named, after every other file was read.

while IFS= read -r relative; do
  [ -n "$relative" ] || continue
  if [ ! -r "$product_root/$relative" ]; then
    echo "cannot read $relative" >> "$work/causes"
    continue
  fi
  LC_ALL=C awk -v rel="$relative" -v layer5=1 -f "$work/scan.awk" "$product_root/$relative" >> "$work/findings" \
    || echo "the scan could not read $relative" >> "$work/causes"
done < "$work/test_files"

# --- the shipped manifests: QC-14 ---

for manifest_crate in ka-reader-core ka-reader-bridge; do
  manifest="crates/$manifest_crate/Cargo.toml"
  [ -r "$product_root/$manifest" ] || continue
  LC_ALL=C awk -v rel="$manifest" -v crate="$manifest_crate" -v mdir="$product_root/crates/$manifest_crate" \
    -v root="$product_root" -f "$work/toml.awk" "$product_root/$manifest" >> "$work/findings" \
    || echo "the scan could not read $manifest" >> "$work/causes"
done

# QC-10: the core's manifest never names the bridge, whatever the key, the package or the path.
if [ -r "$product_root/crates/ka-reader-core/Cargo.toml" ]; then
  LC_ALL=C awk '
    { text = $0; sub(/#.*/, "", text) }
    index(text, "ka-reader-bridge") > 0 || index(text, "ka_reader_bridge") > 0 {
      printf "crates/ka-reader-core/Cargo.toml\t%d\t10\t4\tka_reader_bridge\tcrates/ka-reader-core/Cargo.toml:%d: QC-10: ka-reader-core names ka_reader_bridge — the core never depends on the bridge\n", NR, NR
    }' "$product_root/crates/ka-reader-core/Cargo.toml" >> "$work/findings" \
    || echo "the scan could not read crates/ka-reader-core/Cargo.toml" >> "$work/causes"
fi

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

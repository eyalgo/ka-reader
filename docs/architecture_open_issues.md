# Architecture open issues — Nozoki

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the SRS, the SDD
> and the FDR.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-architecture`. It folds your answers into the records and drops the resolved items.
> When nothing is left open, `product-architecture` **deletes this file**: no file = the records are
> done.
>
> Your answers are never thrown away. Each time the Principal Architect folds them in, it first copies
> this file whole to `docs/trail/architecture/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 is raised, not asked.** These records bind every later change, so the seats that live under
> them find gaps the authoring run could not. § 3 is where such a seat says so, against both records
> — an ADR's binding and an NFDR obligation reach the same file.

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-07 from the
> architecture companion template. The `.gitmodules` section-path refusals and the refusal on the
> submodule map are now built (`nozoki@772c63b`), and an unreadable `.gitmodules` answers a
> condition of its own. The NFDR still names the refusals as not built, and ADR-0022's *Decision*
> says every file the check cannot read answers the unreadable-Git-directory condition. Both records
> are Settled or Accepted, and with no companion on disk a `product-architecture` re-run has nothing
> to act on. Its two items are in § 3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-6 and QC-35 name the `.gitmodules` section-path and submodule-map refusals as stated and not built, and both are built
- **Raised by:** PM — 2026-10-07
- **Which record:** `nfdr.md` QC-6 and QC-35
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. QC-6's *Still uncovered* and QC-35's *Not covered* (1)
  tell a reader that a section naming a location outside the folder is bounded only by the sandbox,
  and one naming another location inside it by nothing. At `nozoki@772c63b` the adapter refuses
  both, in-process, on the repository's `.gitmodules` and on each verified submodule's.
- **Where it shows:** QC-6, **Still uncovered, and named** (`docs/nfdr.md:L278-L286`): "a
  `.gitmodules` section's path and the submodule map — their refusals are stated and not built".
  QC-35, **Not covered** (1) (`:L1040-L1048`): "a `.gitmodules` section's path, whose refusal is
  stated and not built", closing on SDD *Open Questions*' config-named-path item "open on its
  `.gitmodules` case alone". At `nozoki@772c63b` a section path beginning `/` answers
  `ConfigNotLocated`, one spelled outside the folder `ConfigNamesOutside`, and a looked-up name
  whose path spells to another location `SubmoduleElsewhere`, all on `status()` alone
  (`crates/nozoki-core/src/git_reader/libgit2.rs:L330-L353`). R-16's fourth case is in the tree,
  `checks/fixtures/gitmodules-names-outside` with
  `test_section_leading_through_a_link_to_an_outside_x_opens_nothing_outside`
  (`crates/nozoki-core/tests/git_state.rs:L2680`), and fails against the crates at
  `nozoki@799c3d6` with "a call opened the outside x". Every read the check adds is in
  `git_reader/libgit2.rs`, and `grep -rn "std::process" crates/*/src` prints nothing. The rewrite
  between check and read stays uncovered, as both entries already say. The measured looked-up set
  is the index's gitlinks alone (SDD companion item 5.3), so QC-15's list owes no read for a `.git`
  entry with no gitlink. The SDD's own passages are raised on `SDD_open_issues.md` § 5.1.
- **If a document has to be written:** none. A change in `nfdr.md` QC-6 and QC-35, written by
  `product-architecture`.
- **Answer:** <the owner fills this in>

### 3.2 ADR-0022's *Decision* says a file the check cannot read answers the unreadable-Git-directory condition, and an unreadable `.gitmodules` answers a condition of its own
- **Raised by:** PM — 2026-10-07
- **Which record:** `adr/0022-git-reader-refuses-a-repository-whose-config-names-a-location-outside-the-folder.md`
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. The built behaviour departs from an accepted decision's
  binding line, and the record does not say so.
- **Where it shows:** *Decision*, "Each refusal is a condition of its own": "a file the check
  cannot read answers the condition for an unreadable Git directory"
  (`docs/adr/0022-git-reader-refuses-a-repository-whose-config-names-a-location-outside-the-folder.md:L58-L60`).
  At `nozoki@772c63b` a `.gitmodules` that cannot be read for any reason but its absence answers
  `GitReadCondition::GitmodulesUnreadable` on `status()` alone
  (`crates/nozoki-core/src/git_reader/libgit2.rs:L285`; `git_reader.rs:L241`), held by
  `test_unreadable_gitmodules_answers_gitmodules_unreadable`
  (`crates/nozoki-core/tests/git_state.rs:L2950`). A file a `.gitmodules` includes still answers the
  unreadable-Git-directory condition. The reason is SDD § 4 C-E4, "never a cause the tool did not
  observe": `.gitmodules` lies in the working tree, not the Git directory, and the shipped sentence
  for that condition says the Git directory could not be read (SDD § 11 R-16, *Not covered*). The
  Git view's sentence for the new condition does not say so
  (`nozoki-mac/Sources/Surfaces/GitSentences.swift:L30-L33`). *Built and not built, at
  `nozoki@076eac2`* is pinned to that commit and stays true there, as the cycle-38 answer ruled
  (`docs/trail/architecture/cycle-38.md` § 3.2). Whether the *Decision* line is amended in place,
  carried by a later record, or left with the SDD stating the exception is this seat's call.
- **If a document has to be written:** possibly a record that amends or supersedes ADR-0022's one
  line, written by `product-architecture`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.

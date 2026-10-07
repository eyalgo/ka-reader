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
- **Answer:** Confirmed, with additions. Both entries are now false, and folding the correction is this document's own work. The fresh authorization is `docs/SDD.md` v46 (Settled, RN-106). Outside `docs/`, the tree at HEAD `63e48c1` is `nozoki@772c63b`'s (`git diff --stat 772c63b 63e48c1 -- . ':!docs'` prints nothing). At that tree, the three refusals answer `ConfigNotLocated`, `ConfigNamesOutside` and `SubmoduleElsewhere` on `status()` alone (`crates/nozoki-core/src/git_reader/libgit2.rs:L330-L353`). Six changes follow. (1) **QC-6**, *Still uncovered*: the `.gitmodules` section path and the submodule map leave. Nothing else remains in that clause, so the clause moves to a dated note, together with its two sentences about the sandbox being the only bound and nothing bounding either case. (2) **The closing pointer, in QC-6 and QC-35 (1).** This change is not in the item, which was raised before the SDD's cycle-41 fold. SDD v46 closed and removed the *Open Questions* config-named-path item (RN-106 (7)). Two sentences therefore name an item that no longer exists and a bound that is already discharged. The first is the clause in both entries that runs "closes on SDD *Open Questions*' config-named-path item, open on its `.gitmodules` case alone, settled before `see-git-status` is reached". The second is QC-6's "The bound is held by review of the change after which … the slice is not reached". The fourth case and its fixture are in the tree (`crates/nozoki-core/tests/git_state.rs:L2680`; `checks/fixtures/gitmodules-names-outside`). Move both sentences to dated notes, and trace both entries to SDD v46 § 11 R-16, *Built, and the cases that hold it*. QC-35 (1) keeps the file rewritten between the check and libgit2's read, and the link inside the Git directory that leads out. Both keep "no closing named", with the sandbox as their only bound. Its lead, "what that check does not yet refuse, and what it cannot", keeps only "what it cannot". (3) **QC-35**, *verified by*: also not in the item. The fourth case, `test_section_leading_through_a_link_to_an_outside_x_opens_nothing_outside`, watches a FIFO at the outside `x`'s `.git/config` through `opener_seen_during_the_three_calls`. That makes it a sixth FIFO case beside the five. Name it, and say that it runs in-process like them. Re-pin the five locators and the pass count with a fresh `cargo test --locked -p nozoki-core --test git_state` on a disposable copy. The locators pinned at `nozoki@66f428d` stay true there, but `git_state.rs` has moved by about nine hundred lines since (SDD RN-106 (d)). (4) **QC-30**: read its sentence "what that check does not yet hold QC-35 names as uncovered" (`docs/nfdr.md:L903-L906`) in the same fold. It stays true only without "yet", because what QC-35 will then name is what the check cannot hold. (5) **QC-6**, the domain's pin: not in the item, and surfaced to this seat by SDD RN-106. The submodule-map refusal is decided against the set of paths the status read looks up (`SectionScope`, `libgit2.rs:L223-L230`). That set is measured as the index's gitlinks (SDD § 11 R-16, *Which paths the status read looks up*), and it is pinned to the `libgit2-sys` version, as the six members are. QC-6 names the six members at `libgit2-sys 0.18.8+1.9.7`. Name the looked-up set beside them, re-measured at the same lockfile review (QC-26; ADR-0022, *Decision*, last bullet). A libgit2 that looked up more paths than the gitlinks would leave a section naming an extra path unchecked, and no case would notice. (6) **QC-15** needs no change. The walk along a section's name, made for a looked-up name or a section with no `path`, is a walk along a value the `.gitmodules` check locates, which its list already names (`docs/nfdr.md:L517-L518`). Each entry's ADR-0022 trace moves to the record that § 3.2's answer writes. Decided together with § 3.2. Reasoning: `docs/trail/architecture/self_answer-44.md`.

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
- **Answer:** A new record, ADR-0023, supersedes ADR-0022. ADR-0022's Status line is the only line in it that changes, to `Superseded by ADR-0023` (`<CORE>/templates/product-templates/adr_record_template.md:L22-L23`), and its index row follows. Neither of the other two forms holds. Amending the line in place rewrites an Accepted record, which this log never does (`docs/adr/README.md:L4-L5`). Leaving the line, with the SDD stating the exception, keeps a present-tense rule in an Accepted *Decision* that is false of the product. The delivery tier reads that record as fixed, so a later change could take the line as grounds to move the condition back. That is not the cycle-38 § 3.2 case. The paragraph there was pinned to `nozoki@076eac2` and true at that commit, and nothing had been decided anew. Here something was: in SDD v46 the CTO gave an unreadable `.gitmodules` a condition of its own (RN-106 (1); § 11 R-16, *Not covered*) and surfaced it for this seat to record. **What ADR-0023 carries.** It carries ADR-0022's decision whole, with one line changed: a file the check cannot read answers the unreadable-Git-directory condition, except a `.gitmodules` at depth 0 of a level's walk, the repository's or a verified submodule's. When that file cannot be read for any reason but its absence — the read is not permitted, it is a link, it is not a regular file, or it is over the size bound — it answers `GitReadCondition::GitmodulesUnreadable`, on `status()` alone, and the Git item is `failed` with it (`crates/nozoki-core/src/git_reader/libgit2.rs:L279-L290`; `git_reader.rs:L238-L241`). A file that the `.gitmodules` includes keeps the unreadable-Git-directory condition. Two cases are as before: an absent file at any depth is skipped (`libgit2.rs:L244`), and one the check cannot parse to the end answers the read-failed condition (`:L250-L251`). The ground is SDD § 4 C-E4, "Never a cause the tool did not observe": `.gitmodules` lies in the working tree, not in the Git directory, and the shipped sentence names no Git directory (`nozoki-mac/Sources/Surfaces/GitSentences.swift:L30-L33`). *Alternatives ruled out* gains two entries: keeping the unreadable-Git-directory condition, which states a cause the tool did not observe, and amending ADR-0022 in place. *Built and not built* is re-pinned to the current tree, where every check ADR-0022 decided is built: the alternates check at `nozoki@66f428d`, and the section-path and submodule-map refusals at `nozoki@772c63b`. The two-reads race and the linked `HEAD`, `index` or `refs` case stay named as uncovered. *Binds* stays QC-6, QC-15, QC-30 and QC-35. The NFDR's traces to ADR-0022 move to ADR-0023 in the same fold as § 3.1. Decided together with § 3.1. Reasoning: `docs/trail/architecture/self_answer-44.md`.

**How it closes.** `product-architecture` folds it on its next run like any other item here.

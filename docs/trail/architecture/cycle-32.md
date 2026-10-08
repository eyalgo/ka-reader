# Architecture open issues — KA-Reader

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

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 QC-5's *verified by* said its three named cases were unwritten and would go red until the provisional `.git`-file arm was replaced; that change has landed, and all three cases are written and pass

> A `companion-self-answer` run raised this item on 2026-10-03
> (`docs/trail/architecture/self_answer-35.md`, *Raised on this document* § 2.1) and left its slot
> for the next round. The NFDR v34 run drafted it into the records, as below.

- **Lands in:** `nfdr.md` QC-5
- **Drafted into the records:** QC-5's *verified by*, at NFDR v34. It states the three named cases as
  written and passing at `ka-reader@48308ff`: `test_linked_worktree_answers_root`,
  `test_submodule_answers_root` and `test_git_file_naming_a_missing_git_directory_answers_root`
  (`crates/ka-reader-core/tests/root_finding.rs:L175`, `:L185`, `:L196`). It cites the adapter's
  `.git`-file arm, `probe_git_file` (`crates/ka-reader-core/src/git_reader/libgit2.rs:L46`, `:L58`), and
  CI's command (`.github/workflows/ci.yml:L26`). The old "none of the three is written at
  `ka-reader@8edec4f`" and "all three go red … until the change that replaces that arm lands" now
  appear as a dated parenthetical. § 10's QC-5 row does not move, because it names the same command,
  and ADR-0018 does not move (`nfdr.md` RN-45).
- **Rationale:** The tail's forward clause described a change that has already happened, so it read
  as though the read bound had no check. Re-run at `ka-reader@cd88d52`,
  `cargo test --locked -p ka-reader-core --test root_finding` prints "37 passed; 0 failed", with all
  three cases among them. `git diff --stat 48308ff HEAD -- checks crates ka-reader-mac .github
  Cargo.toml Cargo.lock` prints nothing. QC-15's tail, folded in the same run from
  `docs/trail/architecture/cycle-31.md` § 3.1, is pinned at the same merge. ADR-0018 § Consequences
  already says the missing-directory case goes red if `probe` follows the pointer
  (`adr/0018-root-finding-answers-root-for-a-git-file-and-reads-only-inside-the-folder.md:L92`).
- **If overridden:** QC-5 goes back to its v33 text. It then reads as though the bound has no check,
  out of step with QC-15, which names the same merge. A later change that touches `probe` could treat
  the three cases as optional, when they are the check. No record moves either way.
- **Confirm or override:** confirm, with one addition. QC-5's tail should say what the
  missing-directory case does not reach. It goes red for a `probe` whose attempt to follow the
  pointer changes the answer. A `probe` that tries the pointer, swallows the failed open and still
  answers `Root` passes it, because the case asserts only the answer, that it holds no path, and
  that the scene is unchanged (`crates/ka-reader-core/tests/root_finding.rs:L24-L37`, `:L65-L68`).
  That half of the read bound is QC-15's review at `development-design` ("which read the adapter
  makes inside its owner file"), and the tail should point there. Reasoning:
  `docs/trail/architecture/self_answer-36.md` § 2.1.

## 3. Raised from downstream — an item from a seat that did not write these records

None.

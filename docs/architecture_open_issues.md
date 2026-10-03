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
  written and passing at `nozoki@48308ff`: `test_linked_worktree_answers_root`,
  `test_submodule_answers_root` and `test_git_file_naming_a_missing_git_directory_answers_root`
  (`crates/nozoki-core/tests/root_finding.rs:L175`, `:L185`, `:L196`). It cites the adapter's
  `.git`-file arm, `probe_git_file` (`crates/nozoki-core/src/git_reader/libgit2.rs:L46`, `:L58`), and
  CI's command (`.github/workflows/ci.yml:L26`). The old "none of the three is written at
  `nozoki@8edec4f`" and "all three go red … until the change that replaces that arm lands" now
  appear as a dated parenthetical. § 10's QC-5 row does not move, because it names the same command,
  and ADR-0018 does not move (`nfdr.md` RN-45).
- **Rationale:** The tail's forward clause described a change that has already happened, so it read
  as though the read bound had no check. Re-run at `nozoki@cd88d52`,
  `cargo test --locked -p nozoki-core --test root_finding` prints "37 passed; 0 failed", with all
  three cases among them. `git diff --stat 48308ff HEAD -- checks crates nozoki-mac .github
  Cargo.toml Cargo.lock` prints nothing. QC-15's tail, folded in the same run from
  `docs/trail/architecture/cycle-31.md` § 3.1, is pinned at the same merge. ADR-0018 § Consequences
  already says the missing-directory case goes red if `probe` follows the pointer
  (`adr/0018-root-finding-answers-root-for-a-git-file-and-reads-only-inside-the-folder.md:L92`).
- **If overridden:** QC-5 goes back to its v33 text. It then reads as though the bound has no check,
  out of step with QC-15, which names the same merge. A later change that touches `probe` could treat
  the three cases as optional, when they are the check. No record moves either way.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

None.

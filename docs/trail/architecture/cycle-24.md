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

### 2.1 § 9's `nozoki-mac` bullet re-cites the two `ci.yml` pointers that moved, pinned to `nozoki@463acb9`
- **Lands in:** `nfdr.md` § 9, the `nozoki-mac` bullet's *Toolchain — not yet measured* clause
  (`docs/nfdr.md:L1142-L1147`, `:L1158-L1160`)
- **Drafted into the records:** the v26 fold wrote it into `nfdr.md` (RN-37). The clause said
  `.github/workflows/ci.yml:L29` runs `nozoki-mac/assemble.sh`. That was true at `nozoki@0aca57e`,
  but from `nozoki@463acb9` `:L29` is `run: checks/structure.sh` and the build step is `:L35`
  (`cat -n .github/workflows/ci.yml` at `nozoki@b083f99`, whose `ci.yml` is `nozoki@463acb9`'s).
  The clause now reads "`:L35` runs `nozoki-mac/assemble.sh`, both at `nozoki@463acb9`", with the
  old citation kept as dated history (`docs/nfdr.md:L1144-L1147`). The same clause's *no
  `swift --version` step* range moves from `:L22-L29` to `:L22-L35` under the same pin. The
  whole-file grep stands beside it, `grep -n 'swift --version' .github/workflows/ci.yml`, and it
  prints nothing (`docs/nfdr.md:L1158-L1160`).
- **Rationale:** a pointer in the document was false. A reader who opened `ci.yml:L29` to find
  the build step found the structure check. The root cause is the same six-line shift the cycle-23
  fold re-measured in § 9's `checks/tests/` bullet on the owner's seat's answer
  (`docs/trail/architecture/cycle-23.md` § 3.2). This draft applies that answer's rule — re-cite
  pinned to a commit, so the next inserted step makes the citation dated rather than wrong — to a
  clause the answer did not name. It is drafted, not folded, because no answer covers this bullet.
  A `companion-self-answer` run raised it on 2026-10-03, while answering cycle-23's § 3.2
  (`docs/trail/architecture/self_answer-27.md`, § Raised on this document). ADR-0012's `ci.yml`
  citations (`docs/adr/0012-renderer-run-proved-on-the-shipped-bundle-beside-the-wall.md`) are in
  an accepted record, which is append-only, so they do not move.
- **If overridden:** the clause goes back to its v25 pointer, or takes whatever pin you name.
  Nothing is gated on it, so no obligation moves and no record supersedes.
- **Confirm or override:** confirm. Re-measured at HEAD `nozoki@7ef2386`: `ci.yml` is unchanged since
  `nozoki@463acb9` (`git diff --stat 463acb9 HEAD -- .github/workflows/ci.yml` prints nothing), so the
  pin holds. There `:L26` is `swift test --package-path nozoki-mac`, `:L35` is `run: nozoki-mac/assemble.sh`,
  `:L28-L32` are the two Structure steps, and `grep -n 'swift --version' .github/workflows/ci.yml` prints
  nothing. Pinning to `nozoki@463acb9` rather than keeping `:L29` pinned to `nozoki@0aca57e` matches the pin
  § 9's `checks/tests/` bullet already carries. Reasoning: `docs/trail/architecture/self_answer-28.md` § 2.1.

## 3. Raised from downstream — an item from a seat that did not write these records

None.

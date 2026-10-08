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

> **No `product-architecture` run opened this companion. The PM opened it on 2026-09-24** with
> five items, §§ 3.1 – 3.5, each measured on `main` at `ka-reader@153f5a1` against these records after
> `checks/view.sh`, `checks/renderer.sh` and `checks/fixtures/idle-shell` landed. All five were
> answered in the owner's seat by a `companion-self-answer` run and folded at NFDR v15
> (`docs/trail/architecture/cycle-12.md` holds them as answered; `nfdr.md` RN-26). What remains is
> § 2.1, the one item that run raised on this document, with its slot at its placeholder.

---

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

> **No `product-architecture` run wrote this section or its item.** A `companion-self-answer` run
> added it on 2026-09-24 while answering §§ 3.1 – 3.5 (`docs/trail/architecture/self_answer-15.md`,
> § Raised on this document). It was found by reading `nfdr.md` § 9 whole against the CI runs on
> `main`, not raised by any item. It sits in this bucket because the run holds a lean, and its slot
> is the next round's.

### 2.1 § 9 says no CI run on `main` has built `ka-reader-mac`. Run 35968105480 on `main` did, and its log names no Swift toolchain
- **Lands in:** `nfdr.md` § 9, the `ka-reader-mac` bullet's *Toolchain — not yet measured* clause, and
  that bullet's *verified by* tail
- **Drafted into the records:** `nfdr.md` § 9, the `ka-reader-mac` bullet's *Toolchain — not yet
  measured* clause, at v15, by the `product-architecture` run of 2026-09-24 (RN-26): the clause
  records GitHub Actions run 35968105480 on `ka-reader@c461b29` (`success`; image `macos-14-arm64`
  20260831.0302.1, macOS 14.8.9) as the first `main` run to run `swift test --package-path
  ka-reader-mac`, and that its log names no Swift version, so by its own rule the line stays *not yet
  measured* and waits for a log on `main` that names the toolchain; "no CI run on `main` has built
  it (`origin/main` at `a4ab8e6`)" is dated history in a parenthesis. The bullet's review gate and
  its four departures do not move. The run re-read the log before writing (`gh run view
  35968105480 --log`, 2026-09-24) and found what the item states. *As raised, this field read
  "Nothing": the raising run wrote no record.* The change the item proposed, kept as it was
  raised: the clause records GitHub Actions run 35968105480 on
  `ka-reader@c461b29`. That is the first run on `main` whose `Test gate` ran `swift test --package-path
  ka-reader-mac` (`c461b29:.github/workflows/ci.yml:L25-L26`), and it succeeded. Its image was
  `macos-14-arm64` 20260831.0302.1, on macOS 14.8.9, and its log prints no Swift version: the one
  `swift-version` line is a build file name, `Write swift-version-76B232A4806BA581.txt`. So, by the
  bullet's own rule ("if the first log names none, this line stays *not yet measured* and says it
  waits for a log that does"), the line stays not yet measured and says it waits for a log that
  names the toolchain. "No CI run on `main` has built it (`origin/main` at `a4ab8e6`, 2026-09-24)"
  becomes dated history.
- **Rationale:** A fact in the record has moved past the trigger the record itself names. The bullet
  says the first CI log on `main` that runs those steps supplies the value and "this line takes it".
  That log exists (`gh run view 35968105480` → `success`, `headSha` `c461b29`), and the line has not
  taken it. The line is what the review of any `ci.yml` or `Package.swift` change is checked against,
  so a stale reading there misleads the one gate that reads it. Nothing else in the bullet moves. The
  review gate still stands until a log names the toolchain, and the four departures still flip
  together. Whether to add a `swift --version` step to `ci.yml` is the delivery tier's; the bullet
  already notes there is none (`:L22-L29`).
- **If overridden:** The clause keeps reading as if no `main` run had built `ka-reader-mac`. A reviewer
  checking a CI change against it would wait for a first run that has already happened, and would
  not know its log was silent on the toolchain.
- **Confirm or override:** confirm, with one addition. Every fact in the drafted clause was re-read and
  holds: run 35968105480 is `success` on `main` at `c461b29`, image `macos-14-arm64` 20260831.0302.1
  on macOS 14.8.9, and its log's only `swift-version` lines are the build file's name. No earlier run
  on `main` had `swift test` in `ci.yml`, and no later run on `main` exists yet. The addition: the
  clause's closing parenthesis points at this companion's § 2.1, and the fold deletes this file. The
  fold re-points it to the trail cycle that keeps this answer, as the entries do for every earlier
  cycle. Reasoning: `docs/trail/architecture/self_answer-16.md`.

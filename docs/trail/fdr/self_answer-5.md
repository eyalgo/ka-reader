# Self-answer report — `fdr.md`

## Header

- **Companion:** `docs/fdr_open_issues.md`
- **Document:** `docs/fdr.md` (v7, Draft)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-23
- **Sources re-read:** None. No answer relies on a source outside this repository. Both answers
  rest on `docs/SDD.md` v13, `docs/SDD_open_issues.md`, `docs/nfdr.md`,
  `docs/architecture_open_issues.md` and the doctrine they cite, and each was read on disk
  this run.

## Items worked

### 2.1 — PD-29 said the renderer technology is not replaceable inside the terminus; the owner ruled that it leaves WKWebView, and the SDD now carries the replacement

- **Bucket:** 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The new PD-29 is right, for the reasons the draft gives.
  - **Seat.** This is an owner's seat question about this document. The edit lands in PD-29,
    and the decision behind it is the owner's own answer of 2026-09-23, "(a) — the renderer
    leaves WKWebView" (`docs/trail/sdd/cycle-9.md:219`). No second owner call is hidden in it.
  - **The draft is sound.** Every clause is in the SDD as it reads now. `docs/SDD.md:224-230`
    (§ 2 force 4) says "not the view technology *again* — it moved once, before any release".
    `:298-300` (*Undoing it*) says "paid once, before any release (§ 10 RC-3) — and not
    foreseen again inside the terminus". `:2067-2074` (§ 9 TO-4) says "paid once already,
    from the WKWebView".
  - **"Before any public release" is true.** `git tag` in the product repo prints nothing, and
    `gh release list -R kensaiapp/nozoki` prints nothing (2026-09-23).
  - **The altitude call is right.** PD-29 leaves the technology unnamed. The SDD names it
    (`docs/SDD.md` § 3, `mac-shell` and `surfaces` rows, `nozoki-mac`). Naming AppKit in PD-29
    would turn a later view change under the same behaviour into a behaviour change.
  - **No contradiction elsewhere in the FDR.** It has no other mention of WKWebView, Tauri,
    an ADR or the "renderer technology" apart from PD-29, RN-31 and the header (`grep`,
    2026-09-23). PD-29's trace to TO-2 still resolves (`docs/SDD.md:2055`).
  - **The addition.** When this confirm folds, `docs/nfdr.md` QC-21 is out of date. It still
    says "neither is replaceable inside the terminus" (`docs/nfdr.md:181-185`). It traces to
    PD-29 and waits for PD-29 to move (NFDR RN-21, `:1601-1608`). The draft names that
    reader, but it does not say where the fix goes. It already has a home:
    `docs/architecture_open_issues.md` § 2.3 lists QC-21 among the NFDR entries owed a
    re-derivation, and its slot is still open. So nothing new is opened here. If a second
    companion item asked for the same thing, the owner would answer the same question twice.
  - **Failure paths.** *Stale:* the SDD's open question on how TextKit lays out UX-I12's two
    hard cells (FDR RN-17) is the one foreseeable thing that could ask for the view to change
    again. If it does, PD-29 makes that change something to escalate to the owner, as cycle-9
    was, and that is the job of a product decision. *Concurrent:* the NFDR's re-derivation
    under architecture § 2.3 and this fold both touch PD-29 and QC-21. The NFDR reads PD-29
    either way, and after this fold PD-29 says what the SDD says.
  - **What would have tipped it to an override:** PD-29 naming the engine, or the SDD still
    reading "not replaceable". Neither is so.

### 2.2 — The SDD moved from v5 to v13 beneath this document and stands Draft; this run folded what the move reached and derived from the Draft rather than waiting for it to settle

- **Bucket:** 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The drafted changes hold. One of the two reasons for not waiting does not hold. I
  confirm the decision, give the correct reason, and add one failure case.
  - **The locators.** `docs/SDD.md` § 3's `mac-shell` row names "the one window" in what it
    owns and "A second window" in what it must not own. `ipc-surface` survives only in the
    review notes that record it leaving (`docs/SDD.md:2278`, `:3458`). The re-pointing of
    PD-31 and OOS-23 is right.
  - **The header line.** `<CORE>/doctrine/governance/unsettled_inputs.md` § *The rule* asks for
    "**Every input the revision read, not only the unsettled ones**" in the header, once.
    `fdr_template.md:77` fixes its form, and `docs/fdr.md:6` matches it.
  - **Deriving from the Draft, the reason that holds.** `docs/SDD_open_issues.md` § 2.3 moves
    C-I3's check wording and the record lines of C-R2 and C-I3, and nothing else. Its owner-seat
    answer only takes the word *Proposed* off those record lines. In `docs/fdr.md`, C-R2 and
    C-I3 appear only in RN-13, RN-18 and RN-31 (`grep -n`, lines 403, 408 and 421). No rule,
    product decision or exclusion cites them. So nothing in this document depends on the Draft,
    and `unsettled_inputs.md` § *The rule* says the run must not stop because of it.
  - **The reason that does not hold.** The draft says a derivation that waited on a settled SDD
    "could wait on nothing scheduled", and cites the owner's "the SDD may never have a next
    fold" (`docs/SDD_open_issues.md` § 2.3). That sentence is about the fold *after* § 2.3's:
    "After this fold the companion is removed, so the SDD may never have a next fold." § 2.3's
    own fold is owed and scheduled. It is the `product-sdd` run that takes the SDD to Settled.
    Waiting would therefore mean waiting on a known run. The reason not to wait is the one
    above: nothing here depends on it. Anyone relying on the draft's reason would be relying on
    a misreading. The prompt calls this "conclusion right, argument not" and requires the real
    reason to be stated.
  - **The addition, the stale case.** The two folds may land in either order. If `product-sdd`
    folds § 2.3 before this companion is folded, the SDD reads Settled at v14. `Inputs read:
    SDD Draft` would then describe a document that has moved on, and a Settled FDR v8 would
    carry it. So on this fold, `product-fdr` reads the SDD's `Status:` again:
    - Settled: the line reads `SDD Settled`, and RN-18 records that § 2.3's fold reached no
      entry here.
    - Still Draft: the line stays as it is, which is true.

    Either way the fold does not wait.
  - **What would have tipped it to an override:** an FDR entry citing C-I3's check or the
    C-R2/C-I3 record lines. There is none.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`fdr.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/skill/launcher.sh product-fdr nozoki`

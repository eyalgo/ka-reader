# Self-answer report — SDD.md

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-03

## Items worked

### 5.2 — The re-author broke 38 citations in the decision log and the NFDR, and this document records the UXD's equivalent defect but not this one

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item is this document's own — the edit it calls for lands in `SDD.md`, and the
  *repair* it does not call for is already routed elsewhere — so no seat has to be found for it. Its
  measurement was re-checked rather than taken on trust, against `ka-reader@59287c9`, 2026-09-03: 14
  citations of `docs/trail/sdd/cycle-1.md` across ADR-0002, ADR-0003, ADR-0006, ADR-0007 and
  ADR-0008, all dead since `ka-reader@9c91359`; `docs/nfdr.md:385`'s `SDD § 6 S-4`, which now names
  `see-git-status`; and ADR citations of this document's review notes by number, including RN-24 and
  RN-25, which this document does not have — its notes run RN-1 – RN-19 and RN-30 – RN-33. So the
  ground is the strongest of the three the prompt names, *a fact in it is now false*, and it needs no
  argument past the measurement. Two additions, and both come out of check 2 rather than taste.
  **The first: the item asks a smaller question than its own evidence.** Its *Where it shows* names
  two places — § 12's downstream boundary and the Review Notes — and then asks for one Review Note.
  RN-32, the model it names, is not a note alone: it is a note *plus* one sentence in § 12's matching
  boundary clause. Written as scoped, § 12 would still rest on the log, still say the record is cited
  rather than re-surfaced (RN-1), and still say nothing about the log's pointers back into it
  misdirecting — which is the half of the defect the item measured first. So the note carries a
  paired sentence in the downstream-boundary paragraph, and both are the **CTO's**: the standing
  split gives that seat "§ 12 — the SRS boundary, and the downstream boundary" (`SDD.md` § *Who holds
  what*), exactly as RN-32 and its sentence are the CDO's on the UXD side.
  **The second is a failure path the item does not reach — the *stale* case.** The empty 20 – 29 band
  in this document's numbering is precisely where the dead citations point: ADR-0007 and ADR-0008
  cite `SDD Review Notes RN-25` in three places between them, ADR-0005 cites RN-24 in two. A new note
  dropped into that gap converts a citation that visibly fails into one that silently resolves to the
  wrong subject, which is worse than the defect being unrecorded — a broken pointer at least
  announces itself. The note is therefore RN-34, and the gap stays empty until the records are
  repaired. The two rounds stay independent in either order, which is why this needs no second item
  on the architecture companion: repaired first, the hazard is gone; repaired second, the empty gap
  is what holds it off in the meantime.
  **Close to a different verdict:** *answered*, since this is a bucket-5 item and § 5.1 — the other
  item in that bucket — was answered from scratch. What tipped it is that this item does carry a
  lean, and a precise one ("one Review Note in RN-32's own shape … recording what was found, that it
  was reported rather than repaired, and where it went"), so it is weighed as a draft, per the
  prompt's rule that the bucket is the author's judgment and not a fact.

## Left for the owner

### 2.2 — What the 1.0.0 promise covers — the contract the version number starts

- **Bucket:** 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override
- **Verdict:** left for the owner
- **Why:** Re-examined this run rather than inherited, and it lands in the same place. This is the
  content of a public promise to strangers, and the owner's own standing routing rule — bound by
  § 1.1 of this companion — reserves exactly that class in their words: *park an item for the owner
  when the answer changes what the product promises, not when it changes how the work is divided*
  (`docs/trail/sdd/cycle-1.md` § 3.1). The ground the run cannot see is nameable rather than
  gestured at: what the owner is willing to be held to after 1.0.0 and to keep paying for. A
  compatibility contract is the instrument that makes some future change cost a major version, and
  the PRD already names maintenance a standing liability — that liability is theirs alone. Leaving it
  still costs the chain nothing: S-11 is the last slice, and § 2.1's answer refers to the contract as
  *drafted* rather than as settled. **What would tip it:** the owner saying the declaration is the
  seats' to make, which RN-19 argues is where the CPO's posture already puts it.
- **The answer I would have given:** **Confirm the four covered items and the exclusions, with one
  correction and two additions** — the same answer this file's previous run reached, restated here
  because the owner reads one item without reading another file, and with its three citations
  re-checked this run.
  *The correction.* Item (b), the read-only and no-network promises, does not belong in a list of
  things a major version could buy the right to break. `docs/SRS.md` C-2 reads *"Viewer-only,
  permanently: no write path to the viewed folder exists in any version; adding one would be a
  different product"*, C-1 makes the product local-only, and NFR-7 and NFR-8 exclude transmission and
  network calls outright (all re-read 2026-09-03). Breaking those is not a priced major-version
  event; it is a different product. The drafted *breaking* list is already right to omit them — the
  *Delivers* list should say so, i.e. that (b) is unconditional and purchasable at no version. As
  drafted the two halves disagree.
  *First addition — say which way (c) points.* "Own state — a later version reads what an earlier one
  wrote, or discards it whole" promises **safety**, not **continuity**: a version that changed the
  bundle identifier would start from an empty container and satisfy the letter of (c), and what a
  reader loses is their theme and, beyond v1, their ten remembered folders. If continuity is meant,
  the bundle identifier belongs in the covered list; if only safety is meant, say that losing own
  state is permitted, so nobody reads the promise as more than it is.
  *Second addition — decide the floor language set.* An adopter relies on their `.py` file being
  highlighted, and `docs/SRS.md` FR-8 names the floor — Python, shell, JavaScript, JSON, YAML, TOML
  — and grows it only by a PRD revision. Dropping a floor language is not obviously "removing a
  surface" under the drafted wording, so it is uncovered by accident. Name it in the breaking list:
  removing a floor language costs a major version; the extension set within a language (C-I5) does
  not, because it grows and never shrinks.
  Everything else in the draft holds. The four items are what an adopter demonstrably relies on
  between versions — the way in, the promises the product is for, their own remembered state, and the
  surface they came for — and the exclusions correctly keep the promise off wording and tokens, which
  would otherwise make every `docs/CONTENT.md` and `docs/DESIGN.md` revision a major-version event.

## Skipped

- **1.1 — Do the owner's answers to the previous SDD bind this run?** — answered at
  `ka-reader@59287c9`; a re-run leaves a decided item alone.
- **2.1 — An SVG inside the folder is not rendered in place** — answered at `ka-reader@59287c9`.
- **3.1 — `first-public-release` lands after the v1 cut, below 1.0.0** — answered at `ka-reader@59287c9`.
- **5.1 — `sdd_template.md` § 3 gained a units table** — answered at `ka-reader@59287c9`.
- **§ 4 Disagreements** — reads "None yet."; no item to work.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-sdd/launcher.sh ka-reader`

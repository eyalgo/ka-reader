# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (Settled, v18)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-25
- **Sources re-read:** None. No answer here rests on a source outside this repository. The one
  platform behaviour the answer relies on, that this Mac's volume and `macos-14`'s resolve
  `../<NAME>` to the granted folder, is the item's own measurement on `nozoki@46bb275`. That
  measurement is recorded in
  `system/projects/nozoki/journey/tobiishi/trail/2026-09-24_the-root-in-order/code-integrity-report.md`
  § Observations for their owners. This run did not measure it again.

## Items worked

### 5.1 — The containment check is defined on the canonical path, and a path that leaves the grant and names it again in another letter case cannot be canonicalized without touching outside it

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** The check compares spellings while a path lies outside the grant, and it never reaches
  the canonical form there. It may recognise the granted folder in exactly one spelling besides
  its own. There was no draft, so this answer was worked out from nothing.

  **Check 1: the seat.** The change lands in `docs/SDD.md` § 3's `fs-reader` row, which is the
  CTO's lane (`docs/SDD.md:L90`). The answer commits no person, money or outside party. It also
  moves no promise: both readings kept on the table touch nothing outside the grant. The one
  reading that would trade the read-only promise for a truer label is the first rejection below,
  and settled records rule it out. So the item is mine to answer in the owner's seat, and it goes
  in the slot.

  **Check 2: the question.** The item asks for one of two things: compare spellings outside the
  grant, or reach the canonical form. The second is not available. Reaching the canonical form of
  `/…/parent/NAME` takes a filesystem call on the grant's parent: an `lstat`, a `realpath`, or a
  directory lookup. § 4 C-D1's *Violated by* names "any read outside the granted folder and the
  app's own container" (`docs/SDD.md:L778-L779`). `docs/nfdr.md` QC-35 enforces the same line
  (`docs/nfdr.md:L579-L580`). The reader already states it as its own rule: "without a filesystem
  call on any path outside the root" (`crates/nozoki-core/src/fs_reader.rs:L175`). So the first
  reading is the rule.

  The question also hides a second one, whether "compare spellings" means byte-equal. It does not
  have to. Answering that is what fixes the item's actual symptom without touching anything
  outside. Both questions have the same seat, so this is not a split: both are answered in the one
  slot.

  **Why not stop at exact spellings.** Exact spellings would keep today's behaviour. That answer
  contradicts two settled things for a link inside the folder:
  - FDR R-34 says a link whose target lies inside the viewed folder is read as its target
    (`docs/fdr.md:L84`), and R-151 says one to a folder inside it expands (`docs/fdr.md:L85`).
    `../<NAME>/docs` on a case-folding volume targets a folder inside, and exact spelling refuses
    it as `Outside`.
  - The row sentence for `Outside` is "This link leads outside the folder you opened, so Nozoki
    doesn't read it." (`docs/CONTENT.md:L332`). For `back → ../<NAME>` that states a destination
    the tool did not observe, which § 4 C-E4 forbids ("never a cause the tool did not observe").
    The item cites UX-I4 for the same point.

  **Why the one extra spelling is safe.** It is recognised only where both of two facts can be read
  from the granted folder itself. First, the folder is not the root of its volume, so its parent
  sits on the same volume. Second, that volume ignores letter case. The comparison may never treat
  two names as one where the volume keeps them apart. An ASCII-only fold meets that, and the
  implementation is left to choose it or anything no wider.

  The failure direction is what makes it safe. A false "equal" moves the position onto the
  canonical root, and every later read happens inside the grant. So even a wrong fold cannot touch
  anything outside. It could only mislabel, and it is bounded so that it cannot.

  **Check 3: against the settled record.**
  - C-D1 and QC-35 hold, because nothing outside is touched.
  - § 4 C-D3's "passes `fs-reader`'s containment check before any open" is unchanged.
  - The check keeps one implementation (SM-7; QC-6).
  - FDR R-152 is what `back → ../<NAME>` now meets (`Cycle`). R-34 and R-151 are what
    `../<NAME>/docs` now meets.
  - The same "canonical path, symlinks resolved" sentence stands in § 11 R-10's response
    (`docs/SDD.md:L2417-L2418`), and the fold moves it with § 3. § 9 TO-6's cost says the check
    "must be right about `..`, symlinks, percent-encoding and Unicode normalization"
    (`docs/SDD.md:L2125-L2127`). Under this answer, being right about normalization outside the
    grant means refusing the path as outside, never taking it for inside. The answer names both
    places so that the fold is not read as done after § 3 alone.
  - `docs/nfdr.md` QC-6 says "on the canonical path, symlinks resolved and after decoding"
    (`docs/nfdr.md:L132`). It is re-derived from § 3 once the fold lands, under § 4's opening
    rule. There is nothing to re-derive until then, so no architecture item is opened now.

  **Check 4: the failure paths.**
  - **Absent:** the folder is the root of its volume, for example a mounted disk. Its parent is
    then on another volume whose case rule cannot be read from inside, so the spelling is compared
    as written and the path is `Outside`. This case is named in the answer.
  - **Absent:** the path climbs more than one level and comes back in another case, for example
    `../../PROJECTS/nozoki`. The grandparent's volume cannot be read from inside either, so this
    case is named too.
  - **Absent:** a Unicode-normalization difference is compared as spelled. It is § 11 R-10's
    already-named class, and it is named too.
  - **Refused:** the three named cases stay `Outside`, and their row sentence stays wrong about
    where the link leads. C-D1 is what wins there, and the answer says so rather than claiming
    coverage. None of the three has a cited occurrence, so none is carried further, following
    § *A widening item waits until it occurs*.
  - **Case-sensitive volume:** `../<NAME>` names a different entry or nothing, so no fold applies
    and it is `Outside`. That is correct, because the target does lie outside.
  - **Concurrent and stale:** a volume's case rule does not change mid-session. A folder renamed
    mid-session already fails its own reads.

  **One hazard for delivery, not the SDD's to fix.** "Not the root of its volume" has to be read
  without asking about the parent. Where the implementation cannot establish it, for example on a
  path that crosses a firmlink, the rule's own fallback applies: compare as spelled. That fallback
  gives today's behaviour, never a wider one.

  **What was close.** Exact spelling plus a CONTENT rewording, a sentence that is true of the
  spelling rather than of the destination. That rewording would have left R-34 contradicted for
  `../<NAME>/docs`, which is a product rule the owner confirmed (`docs/fdr.md` RN-5). What would
  have tipped the answer that way is a fold that cannot be bounded to the volume's own
  comparison. The bound above is what rules that out.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run. The only other documents this answer reaches are two. `docs/nfdr.md` QC-6 re-derives
from the SDD's fold, and there is nothing to raise there before that fold exists. `docs/CONTENT.md`
L332 needs no change under this answer, because the extra spelling ends `Cycle` or reads as its
target and no longer reaches the `Outside` sentence.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh nozoki`

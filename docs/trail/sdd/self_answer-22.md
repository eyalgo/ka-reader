# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** docs/SDD_open_issues.md
- **Document:** docs/SDD.md
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-23
- **Sources re-read:** None. The only answer this run gave rests on this repository's own records:
  `docs/SDD.md` § 3, § 4 C-I1 and C-I3, § 11 R-13, RN-64; `docs/SRS.md` FR-8, FR-30, DR-6;
  `docs/nfdr.md` QC-10 and QC-11; `docs/architecture_open_issues.md` § 1.1.

## Items worked

### 2.4 — § 3 does not say which unit calls `markdown-renderer` and `highlighter` to fill a `FileView`, and `folder-model`'s "Must not own" still says "Rendering" and "The Tauri runtime"

- **Bucket:** 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** Reading (a) is right, and `core-bridge`'s row is what settles it. The bridge must not
  own "Read logic — every function delegates and formats", and must not own "Anything the harness
  could not exercise through SM-5" (`docs/SDD.md:328`). SM-5 is `folder-model`'s API, which the
  harness calls in-process with no window (`docs/SDD.md:414`; C-I3 at `docs/SDD.md:637`). If the
  bridge did the rendering, the harness could not reach it. It would also put a parse of untrusted
  content in the one unit that holds `unsafe`, where § 11 R-13's response is that "the bridge
  holds no logic" (`docs/SDD.md:2391-2395`). The other two edits hold as well. "Drawing" names the
  bar that is actually `surfaces`' (`docs/SDD.md:330`). "Any Apple framework" is the boundary
  `ka-reader-core` already states (`docs/SDD.md:333-334`). "The Tauri runtime" was retired by RC-3.
  The new edge sentence (`docs/SDD.md:346-348`) keeps QC-11's rule true: the readers import
  neither the model nor one another (`docs/nfdr.md` QC-11).

  *The addition.* One of the draft's reasons does not hold as worded. RN-64, and the item's own
  rationale, say the model's "I/O of any kind" still holds because "neither callee reads
  anything". But `markdown-renderer` calls `fs-reader`'s containment check for every image
  reference (`docs/SDD.md:345`; SM-7 at `:416`). That check works on "a canonical path, symlinks
  resolved" (`docs/SDD.md:321`), so filling a Markdown `FileView` does touch the filesystem. The
  bar holds for a different reason. The model already reaches the filesystem only through
  `fs-reader`, over SM-1 ("Down: a path to list or read", `docs/SDD.md:410`), and the renderer's
  containment call goes through that same unit. Read this way, "I/O of any kind" means I/O the
  model performs itself, and every filesystem touch belongs to `fs-reader`. No § 3 sentence has to
  change. RN-64's *because* should say this on the fold, so that a later reader who follows the
  stated reason does not find a hole in it.

  *Check 3.* The draft contradicts nothing settled. SRS FR-8, FR-30 and DR-6 place highlighting
  and rendering in the product without naming a unit (`docs/SRS.md:149`, `:164`, `:440`).
  QC-10 currently forbids `folder-model` from importing `markdown-renderer` (`docs/nfdr.md:149-152`),
  but it names this gap itself. The architecture companion's § 1.1 has already answered that QC-10
  follows the SDD on this fold (`docs/architecture_open_issues.md`, § 1.1 Answer), so no second
  companion item is needed.

  *Check 4.* A call that fails is held as the item's `failed(condition)` and never panics, which is
  C-I1's rule (`docs/SDD.md:617-623`). An empty file is text and renders as empty (`fs-reader` row).
  If the file changes, the reducer re-reads it and the fill runs again on the new bytes. A refused
  or missing image becomes a placeholder node inside an observed document, not a failed item
  (`markdown-renderer` row). An enormous file costs the same wherever the call is placed, so it
  does not change which reading is right.

  *What would have tipped it.* I was close to a plain *confirm*: the conclusion stands without the
  addition. I added it because the item's own "If overridden" field shows that two architects
  reading § 3 disagree, and RN-64 is what they will read to learn why.

## Left for the owner

None this run.

## Skipped

- **§ 1 — Open issues** — none open. The section's own text says § 1.1 was folded at cycle 9.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh ka-reader`

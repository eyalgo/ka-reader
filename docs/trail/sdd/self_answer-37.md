# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v29, Settled)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-04
- **Sources re-read:** None. The answer rests on `docs/SDD.md` and on the product's own tree at
  `ka-reader@cffb3ad`, and on no source outside this repository.

**What this run read, and what it did not.** `docs/SDD.md` was read in full for §§ 1–4, § 6 S-4,
S-5 and S-11, §§ 7–9, the head of § 10, § 11 R-13 and *Open Questions*. § 5, the other eight
slices, §§ 10–12 and the *SDD Review Notes* were not read whole: they were searched for
`model_changed`, `callback`, `registration` and `nine`, and RN-66 and RN-82 were read where the
search landed. `docs/PRD.md`, `docs/SRS.md` and `docs/UXD.md` were not re-read; the answer moves
no requirement and no experience entry, and it rests on none beyond what the SDD quotes. A
contradiction with a part not read is therefore not excluded.

## Items worked

### 5.1 — SM-4 and C-R7 admit no call that can bring the Git item to the shell; S-4 needs one now

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** The SDD admits a Git-named call on SM-4's list, `read_git`, exported as
  `ka_reader_read_git`. It does not admit the `model_changed` registration call now.

  **Whose it is.** The item's `Seat:` is `cto`, and the edit lands in § 3 SM-4, § 4 C-R7, § 6
  S-4's *Rests on*, § 10 and *Open Questions*, all the CTO's by the SDD's own table
  (`docs/SDD.md:L95-L118`). It commits nothing to a person or an outside party: the bridge is a
  static library linked into the one executable (`docs/SDD.md:L430-L432`), and the owner has
  already chosen the route, which is to amend the SDD first (`docs/SDD_open_issues.md:L96-L98`).

  **It is not a widening without an occurrence.** The item cites sites in the product and a
  failure. This run re-checked each. The export test admits four names
  (`crates/ka-reader-bridge/tests/exports.rs:L17-L22`). The shell's decoder rejects an `opened`
  answer with any member besides `state` (`ka-reader-mac/Sources/Shell/BridgePayload.swift:L49-L53`).
  `grep -rn model_changed crates ka-reader-mac/Sources` printed nothing at `ka-reader@cffb3ad`. C-R7
  itself says a further export "is raised, on this condition and SM-4, by the slice that needs it"
  (`docs/SDD.md:L668-L669`), and this item is that raising.

  **The question as framed.** The item offers two calls and gives no lean, so it was answered
  from scratch. It holds one question, not two: which call, its name and its place are one
  decision.

  **Why the pull call.** Four grounds, each from the SDD.
  1. `see-git-status` has nothing to push. Its fence says "in this slice the Git view shows the
     state read when the folder opened" (`docs/SDD.md:L1761-L1762`). A callback exists to deliver
     what arrives unasked, and that is `follow-the-folder`'s (`docs/SDD.md:L1814-L1815`).
  2. The seam is synchronous today: "a call's answer is its return (SM-4)"
     (`docs/SDD.md:L335`). A call that returns an owned buffer is the shape the three landed
     calls already have (`crates/ka-reader-bridge/src/exports.rs:L55`, `:L73`, `:L90`). A
     registration call adds a function pointer, a context whose lifetime the shell owns, and a
     thread that calls into Swift, in the one unit that holds `unsafe` (`docs/SDD.md:L2661-L2668`).
  3. A call on the list is a command, so `checks/read-only.sh` exercises it in the build that
     exports it (`docs/SDD.md:L715-L720`). A registration call is no command and the harness
     would not walk it.
  4. C-R7's rule is "by the slice that needs it, and not before" (`docs/SDD.md:L669`). Admitting
     the registration call for S-4 would build S-5's delivery ahead of S-5.

  **Why on the list.** `ka_reader_free` stands beside the list because "it never reaches the model
  over SM-5" (`docs/SDD.md:L666`). `read_git` does reach the model, so it belongs on the list.

  **What it costs.** The list goes from nine to ten, and the SDD counts it in SM-4's row
  (`docs/SDD.md:L424`), S-11's pin (`docs/SDD.md:L2149`) and the collapse-and-scroll item
  (`docs/SDD.md:L5428`, `:L5438-L5439`). That same item says a call the list does not name is "a
  re-cut, recorded in § 10 before it is built" (`docs/SDD.md:L5437-L5439`), so the answer asks for
  a § 10 entry. S-4's *Rests on* names "`model_changed` carrying Git state" (`docs/SDD.md:L1747`)
  and is re-pointed to `read_git`. From `v1.0.0` the call is in the pinned set
  (`docs/SDD.md:L866-L871`); the pin does not exist yet, so nothing priced moves.

  **Against the settled record.** The answer changes no existing call's answer, which is what
  the item asks and what the two strict decoders require
  (`crates/ka-reader-bridge/src/boundary.rs:L51`). It keeps C-R7's sentence on the registration
  call. It contradicts S-4's *Rests on* as written, and that field is one the fold changes.

  **On the failure paths.**
  - *Empty:* no folder open answers `pending`, as `list_tree` does
    (`crates/ka-reader-bridge/src/session.rs:L308-L315`). RN-82 records that the shell's decoder reads
    a wire `pending` as carrying no verdict (`docs/SDD.md:L4910-L4914`); that reading is the
    shell's and this answer does not move it.
  - *Absent:* a folder that is not a repository's root answers `plain`. A failed search-path
    switch answers `failed`, as the `core-bridge` row already says (`docs/SDD.md:L333`).
  - *Stale:* nothing re-reads an `observed` Git item before `follow-the-folder`. Whether an ask
    on a `failed` item reads again is named as not covered.
  - *Concurrent:* which side orders two asks in flight is already left open on the `surfaces`
    row (`docs/SDD.md:L335`) and stays there.
  - *Refused:* a read the sandbox or a lock refuses is `failed` with its condition, under C-I1
    (`docs/SDD.md:L686-L689`).

  **What the export triggers.** `ka_reader_read_git` is the first export that reaches `git-reader`.
  C-I3 ties the `nm` transport read to "the build that first exports a function reaching
  `git-reader`" (`docs/SDD.md:L736-L738`) and the search-path switch to the change that wires the
  adapter (`docs/SDD.md:L744-L746`). The R-16 item in *Open Questions* is settled no later than
  that same build (`docs/SDD.md:L5450-L5451`). The answer names all three so the change that
  builds the call is not sized as one export alone.

  **What would have tipped it.** If S-4's observable half required Git state to change while the
  folder stays open, the registration call would be needed now. It does not: that is S-5's
  *Delivers* (`docs/SDD.md:L1772-L1777`).

  **One thing in the item's text.** The item says the fold touches "S-4's *Rests on* if the call
  chosen is not the `model_changed` registration" (`docs/SDD_open_issues.md:L99-L100`). It does
  not name the counts or § 10. The answer names them; the item's text is left as the PM wrote it.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`

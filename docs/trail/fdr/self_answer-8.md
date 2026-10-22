# Self-answer report — `docs/fdr.md`

## Header

- **Companion:** `docs/fdr_open_issues.md`
- **Document:** `docs/fdr.md` (v12, Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-22
- **Sources re-read:**
  - `gh repo view eyalgo/ka-reader --json name,visibility,owner` printed owner `eyalgo`, name `ka-reader`,
    visibility `PRIVATE` (2026-10-22). The repository lives at the address the moved sources name.
  - `git -C <product> remote -v` printed `git@github.com:eyalgo/ka-reader.git` for fetch and push.
  - `gh release list -R eyalgo/ka-reader` printed nothing, and `git -C <product> tag` printed nothing
    (2026-10-22). No release has been offered from either address yet.

## Items worked

### 3.1 — The FDR still publishes from `kensaiapp/ka-reader`, where every document above it moved to `eyalgo/ka-reader`

- **Bucket:** 3. Raised from downstream — an item raised against the FDR after it settled
- **Verdict:** answered
- **Why:** Re-derive both. R-128 names `github.com/eyalgo/ka-reader`, and PD-21 says the product is published
  from there under the personal handle `eyalgo`, which is its public face.
  - **Seat.** The edit lands in this document, and it commits nobody to anything new. The owner already made
    the call: they moved the repository on 2026-10-16 knowing it reversed their cycle-7 confirmation
    (`docs/trail/prd/cycle-14.md` § 3.1, *Why*). So the question is only whether this document follows a value
    the owner set. That binds this document's consistency alone, and it is mine to answer in their seat.
  - **Not a widening.** The item asks for no case or rule the FDR lacks. It says two statements are now
    false, and that is a correction. § *A widening item waits until it occurs* does not apply.
  - **Check 2: the item's claims.** Each was read at its source and holds:
    - PRD v16, Settled, § Assumptions *Public identity* (`docs/PRD.md:L396-L402`): "KA-Reader lives at
      `github.com/eyalgo/ka-reader`, under the maintainer's personal GitHub handle `eyalgo` … the personal
      handle is the public face."
    - SRS v13, Settled, § 7 C-12 (`docs/SRS.md:L497-L499`): published from `github.com/eyalgo/ka-reader`,
      "and that repository is where C-7's channel is enabled and where releases are offered."
    - SDD v57, Settled, § 4 C-R4 (`docs/SDD.md:L632-L633`): the GitHub Release is on
      `github.com/eyalgo/ka-reader`, with "`github.com/kensaiapp/ka-reader` until v51".
    - ADR-0024's title and decision name `github.com/eyalgo/ka-reader`, and NFDR QC-28's command reads
      `--repo eyalgo/ka-reader` (`docs/nfdr.md:L2297`).
    - The FDR reads the old identity in two places only: R-128 (`docs/fdr.md:L252`) and PD-21 (`:L295`).
      `grep -n kensaiapp docs/fdr.md` prints those two lines and RN-32.
  - **The item's scope is right, with one site it did not name.** R-143 says private vulnerability reporting
    is enabled "on the repository R-128 names". It names the repository through R-128, so it follows that
    rule and needs no edit of its own. PD-15 says GitHub is the only channel and names no repository, so it
    does not move. RN-32 quotes `gh release list -R kensaiapp/ka-reader` as a measurement made on
    2026-09-23 at the old address. It is a dated record and stays as written. That is the same treatment
    the PRD's own item gives the SDD's old CI evidence lines (`docs/trail/prd/cycle-14.md` § 3.1, *What it
    reaches downstream*).
  - **Check 3: nothing settled is contradicted.** Every document above the FDR, and the ADR and NFDR beside
    it, already reads `eyalgo/ka-reader`. The answer moves the FDR into line with them and asks no source to
    move. The repository is really at that address: `gh repo view` names owner `eyalgo`, and the product's
    `origin` remote points there. PD-34's non-commercial ground is unaffected, because the PRD keeps "a
    private individual" and "a side project" beside the handle.
  - **Check 4: the failure paths.**
    - *Empty.* No release exists at either address, and `git tag` prints nothing. So no release has yet
      broken R-128 as it reads. The fold only has to land before the first public release (`docs/SDD.md`
      § 6 S-7), and that is the block the item names.
    - *Stale.* GitHub redirects the old address (`docs/trail/prd/cycle-14.md` § 3.1). A stranger following an
      old link still arrives, but the contract names the live address only. If the identity moves again, it
      is the same upstream change, re-derived the same way.
    - *Absent / refused.* The repository is private now. Whether and when it goes public is the owner's, and
      the PRD's item set it aside (cycle-14 § 3.1, *Why*). This answer decides nothing about that. R-128
      says where a release is offered, not when one is.
  - **Other upstream moves under v12, read and not raised.** The SDD moved v48 → v57 after the FDR's last
    commit (`git log d6405e2..HEAD -- docs/SDD.md`). Apart from v52's identity change, each version moves the
    harness, C-I3's evidence or the model's API (v53, RN-113). v53 keeps a deleted node's expansion and
    selection held and re-applies them when the entry comes back. R-78 and R-83 already state that, so no
    rule here is false. CONTENT v13 limits its rules to the words KA-Reader writes, and that reaches no rule
    here. Nothing else in the FDR is false, and `product-fdr`'s re-run measures what moved under it by its own
    rule. So no second item is raised.
  - **What would have tipped it.** If the owner's cycle-14 answer had left the public face open, the item
    would have gone back to the owner. It did not: it states "the personal handle `eyalgo` is now the face
    the repository is published under."

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/fdr.md** — `/Users/eyalgolan/.kensaiapp/pins/20261022T014137Z-si90zq/core/launchers/skill/launcher.sh product-fdr ka-reader`

# Self-answer report — UXD.md

## Header

- **Companion:** `docs/UXD_open_issues.md`
- **Document:** `docs/UXD.md` (Settled, v6)
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

## Items worked

None this run.

## Left for the owner

None this run.

## Skipped

- **1.1 — Three more layout references landed; does the UXD change?** — its **Answer** slot was
  already filled when this run reached it, carrying the owner's standing directive of 2026-09-01
  (*the CDO decides; re-write the UXD if and only if it judges that it changes; if it does not,
  record that and drop the item*). A filled slot is an answer already given and is never
  rewritten. The deciding it asks for — reading the three images and the folder's README and
  judging whether the UXD's statement of the Git view moves — is the `product-uxd` fold's own
  work, in the CDO posture that run carries; this run fills slots and writes no document, so it
  did not pre-empt it. The facts the item rests on still hold on disk: `docs/ux_reference/` holds
  seven images, the README still opens "Four screenshots of VS Code", and the UXD still says
  "four" at `docs/UXD.md:68` and in RN-13. The prior report's observation stands unchanged —
  UX-F4, UX-S6 and RN-14 are the entries the two Git-graph references bear on
  (`docs/trail/uxd/self_answer-1.md` § Skipped).

- **2.1 — Every trail pointer in the UXD is dead — the folder moved and the citations did not** —
  its **Confirm-or-override** slot was already filled, by the previous self-answer run
  (`confirm — with two additions`, reasoning in `docs/trail/uxd/self_answer-1.md`). A prior
  verdict binds this run exactly as the owner's would; it was not revisited. Re-measured for
  drift only: `docs/UXD.md` is unchanged since v6 (`ka-reader@dd08f2d`) and still carries 71
  `docs/<x>_trail/` citations (43 `uxd_trail`, 14 `srs_trail`, 11 `prd_trail`, 3
  `content_trail`), of which 4 are commit-pinned and must not move — the numbers the answer
  states.

**Read whole, and owed nothing the items do not already carry.** Since the previous report two
of this document's inputs moved — `docs/PRD.md` to v12 (`ka-reader@2d8c99d`) and `docs/SRS.md` to
v9 (`ka-reader@82c199a`) — so the prompt's "something upstream moved" ground was walked and does
not fire. PRD v12's diff outside its trail citations is empty of content, and every place the
UXD names "PRD v11" is a statement of which version settled a thing ("widened at v6 with PRD
v11", `docs/UXD.md:30`; "narrowed at v6: PRD v11", `:459`; RN-25, `:751`), which v12 does not
make false. SRS v9 adds the diagnostic log's bound to NFR-11 and states that a failed log
write "surfaces nowhere" — which is what the UXD already asks of NFR-11 (RN-24,
`docs/UXD.md:749-750`) — and the UXD's RN-28 records that "`docs/SRS.md` v8 *was read*"
(`:817`), a historical statement, not a claim about the SRS's current state. SRS v9 also moved
the SRS to `**Status:** Draft` because its companion still carries one item, `docs/SRS_open_issues.md`
§ 2.1, and that item is an SRS-side sentence gone stale at UXD v6 — the SRS's to fix, with no
UXD consequence. The two facts in the UXD that *are* now false — the screenshot count and the
trail pointers — are exactly items 1.1 and 2.1, so raising either again would be the
near-duplicate the skill forbids.

## Companions opened

None this run.

## Launchers owed

- **`docs/UXD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-uxd/launcher.sh ka-reader`

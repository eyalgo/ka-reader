# Self-answer report — UXD.md

## Header

- **Companion:** `docs/UXD_open_issues.md`
- **Document:** `docs/UXD.md` (v13, Settled; the companion was reopened by the PM on 2026-11-24 at `ka-reader@90edb50`, with one item under raised from downstream)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.5.0
- **Date:** 2026-11-24
- **Sources re-read:** `kensaiapp-presence` `products/product-front/docs/PRD.md` (Settled, v6), § Core Features *The README's shared parts* and § Success Metrics M1. Re-read at the source: every product's README must open with the shared top block, in this order: the name, one sentence, a line naming KensaiApp as maker, a row of badges, a row of links. M1 says every public product meets this with no exception. The answer relies on this only to say who set the maker line, the badges and the link row. It does not cite it as a source of the UXD. Read in this repository at the lines named below: `docs/UXD.md` (v13) whole, `docs/PRD.md` (v20) § Goals, `docs/SRS.md` (v17) C-9, `docs/CONTENT.md` (v20) § Tone first-screen row and UX-A3's posture row, `docs/CONTENT_open_issues.md` § 3.3, `docs/trail/uxd/cycle-1.md` § 2.4, `README.md` at `ka-reader@90edb50`, and `system/experience/visual_restrictions.md` § `no-runtime-remote-asset`.

## Items worked

### 3.1 — UX-A3 keeps the first screen "to the four things"; the README's opening now carries more

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the UXD
- **Verdict:** answered
- **Why:** UX-A3 does not rule on the maker line, the badges or the link row, and never could. It fixes one thing: the posture sentence stays below the first screen. The fold rewords one clause so the entry stops reading as if it ruled on more.
  - **Check 1, seat: this document's.** The change lands in UX-A3's own words. Whether that other matter belongs on the README's first screen is not this document's to decide. UX-A3's last sentence says the README is the CPO's, and § 10 says the README's content is the CPO's and that this document only constrains pictures of the shell (UX-I11) and asks for one posture sentence (UX-A3). It is not an open question waiting on another seat either. The owner set the shared top block for every KensaiApp product (the product-front PRD, under *Sources re-read*), and the first-screen floor stays where it was: PRD § Goals "Pick-it-up adoption" and `docs/SRS.md` C-9. So the item is not split. The other half is a premise with an owner and an answer already, not a second open question (prompt § *What is not a split*, a premise of a call).
  - **Check 2, the question.** The item reads UX-A3 correctly. The entry governs where the posture sentence goes and is silent on the rest. The defect is in the reason clause, *"so the first screen keeps to the four things the PRD fixes for it"*. Read alone, it sounds like an exclusive list. The owner's bound was narrower: *"agreed, keep it below the first screen"* (`docs/trail/uxd/cycle-1.md` § 2.4). The PRD names the four things the first screen must carry and does not say "only". So the answer is to reword the clause so it says what it was always for: the posture sentence takes no place beside the four things. It is not a new rule about other matter.
  - **Check 3, the settled record.** Nothing settled moves. UX-I11 (the screenshot is true to the product) is untouched. UX-I15 and the instance fence `no-runtime-remote-asset` reach the README, and the badges are repository-local pictures (`README.md:L7-L12`), so they are inside the fence. The posture sentence stands at `README.md:L38`, under § Promises and limits and below the opening, so UX-A3 holds as written. `docs/CONTENT_open_issues.md` § 3.3 asks the same question of CONTENT's tone row. That item belongs to the Content Manager's round and is not answered here. This answer constrains no answer it might get.
  - **Check 4, the failure paths.** *Stale:* if the shared block grows and pushes one of the four things off the first screen, the breach is against PRD § Goals and SRS C-9. The README's owner holds that bound, not UX-A3, and the reworded entry neither hides nor excuses it. *Refused:* if the CPO or the owner later decides the shared block does not belong on the first screen, the reworded UX-A3 still holds unchanged, because it says nothing about other matter. *Empty:* a release with no release badge, or a product with no link row, changes nothing here. *Concurrent:* the parallel CONTENT item can resolve either way without the two documents disagreeing.
  - **What was close to tipping it:** leaving UX-A3 exactly as it stands. The clause is a reason, not a rule, and the CDO could defend it as harmless. What tipped it is that a downstream seat has already read it as a rule and raised it. A clause that reads as a bound it is not will be raised again on the next README change. *Raised upstream* to the PRD was considered too. It would have won if the PRD's first-screen sentence read as exclusive, but it does not.

## Left for the owner

None this run.

## Skipped

None this run. The companion carries one item and no filled slots, and §§ 1 and 2 read "None".

## Companions opened

None this run.

## Launchers owed

- **docs/UXD.md** — `<CORE>/launchers/skill/launcher.sh product-uxd ka-reader`

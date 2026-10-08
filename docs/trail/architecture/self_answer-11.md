# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `adr/` and `nfdr.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-23
- **Sources re-read:** Apple's entry for `com.apple.security.files.user-selected.read-only`. I
  re-read it through the documentation's own data endpoint
  (`https://developer.apple.com/tutorials/data/documentation/bundleresources/entitlements/com.apple.security.files.user-selected.read-only.json`,
  `abstract`, 2026-09-23), because the HTML page renders only its title without a browser. It says
  "A Boolean value that indicates whether the app may have read-only access to files the user has
  selected using an Open or Save dialog". That is the sentence ADR-0011 and QC-25 quote, and it
  still holds. The WebKit sources ADR-0011 transcribes were not re-read. No answer here rests on
  them: the owner refused the network entitlement and the mach-lookup exception
  (`docs/trail/sdd/cycle-8.md` § 5.1, answer 1; `docs/SDD_open_issues.md` § 1.1, *Answer*), so
  both refusals stand on the ruling whatever the WebKit mechanism turns out to be.

## Items worked

### 2.1 — QC-25 and ADR-0003 state C-R2's entitlements as *exactly* a list; the SDD binds a rule, and a renderer gate beside the wall probe

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** **The seat is this one.** The records are the Principal Architect's to write, and the
  owner already made the call they record. The rule is the owner's cycle-8 ruling, answers 1–2, and
  the gate is answer 4 (`docs/trail/sdd/cycle-8.md` § 5.1). The item asks only whether these
  records and entries carry that ruling faithfully, so no ground is hidden from this run.
  **The drafts hold.** ADR-0011's § Decision is answer 2 almost word for word. "Any other
  entitlement only with an ADR" becomes "a record in this log", which says the same thing. The
  record restates ADR-0003 whole, the same form ADR-0010 took over ADR-0008. It lands at Proposed so
  that ADR-0003 stays in force until the owner confirms, which is correct for an append-only log.
  ADR-0012 gets its own record, and the lifecycle argument for that holds: the rule stands if the
  gate's mechanism is replaced, and the gate stands if a fourth entitlement is ever recorded. QC-25's
  two halves are forced by the rule's own words, "only with a record". A key that has a record
  cannot be judged by set equality alone, and the network clause cannot be checked by any command.
  So a review half at `development-design` is the honest form, on QC-26's precedent.
  **Nothing settled is contradicted.** I checked the drafts against `docs/SDD.md` § 4 C-R2
  (`:L434-L460`) and the renderer-gate clause in C-I3 (`:L598-L620`) at v12, and against the
  owner's later § 1.1 answer that the renderer leaves WKWebView. The rule holds under that answer,
  and ADR-0011 records the answer as the cost the rule was chosen with. I re-read Apple's page for
  the read-only entitlement (Header), and it still says what both records quote.
  **Failure paths, and the addition.** The stale case is the one the draft half-states. QC-62 says
  its mechanism was written for WKWebView and gets re-derived later. It does not say what follows
  from C-R2 today: under the rule, WKWebView does not start (SDD § 10 RC-2). So no bundle this
  product may ship can reach `open_folder` until the renderer is replaced, and QC-62 is red on every
  build by construction. A delivery reader who meets a gate that never goes green will be tempted
  to "fix" it. The two fixes within reach are to re-sign with `network.client`, which the sample
  table proves makes the window draw, or to skip the script. Both undo the ruling. So QC-62's tail
  should say three things. The red is the gate working. It is never cleared by an entitlement or by
  skipping the script. `checks/renderer.sh` lands with the replacement renderer or after it. The
  other failure paths are already covered. The hosted-runner case is named as not covered (the
  absent case). ADR-0003's seven citing sites move only on acceptance, so a Proposed record is never
  cited as in force (the concurrent case).
  **A slip in the item, reported and not corrected.** *Drafted into the records*, part 1, says "the
  six entries that cite it" and then lists six entries plus § 2's trust-boundary paragraph, which
  makes seven sites. NFDR RN-21 counts seven. The records are right; only the item's count is off.
  **What would have tipped me.** I would have overridden if ADR-0011 had admitted anything the
  owner refused, or if QC-62 had read a marker. Neither does.
  **Downstream.** The SDD still says "C-R2's exact list" in C-I3, and its record lines name ADR-0003
  and no gate record. That is raised on the SDD's companion (§ 2.3, below), not here.

### 2.2 — ADR-0002 is not superseded, and QC-21 stands, on your SDD-companion answer alone — the record lands when the SDD carries the replacement renderer

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** **The seat is this one.** When a record lands is the Principal Architect's call.
  The owner's decision, that the renderer leaves WKWebView, is already made
  (`docs/SDD_open_issues.md` § 1.1, *Answer*), and neither choice here changes it.
  **The draft holds, and there is one more reason for it.** A superseding record restates the
  whole runtime decision with its alternatives weighed. The SDD has not weighed them, and its
  C-R1 at v12 still renders in WKWebView (`docs/SDD.md:L427-L433`). A record written now would
  leave a hole in its § Decision. The draft underplays how far the replacement reaches. The SDD
  companion prices exit (a) as also losing "the renderer wall — the process that holds no
  capability" and redrawing "C-D3's three walls" for a native renderer
  (`docs/SDD_open_issues.md:L55-L60`). So the eventual record may supersede ADR-0001's
  renderer half and ADR-0006, not only ADR-0002. Which records move is exactly what the SDD's § 2
  re-weighing decides. The record the override describes would name ADR-0002 alone, and it would
  likely be wrong about its own scope as well as incomplete. That turns "two records where one
  would do" into a record that is itself mistaken.
  **Nothing settled is contradicted.** QC-21, read literally, still binds a change to "what ADR-0002
  states". But no delivery change can reach it before the SDD moves: every slice waits on S-1, and
  S-1 waits on the renderer (ADR-0011 § Consequences). RN-21 sits beside QC-21 for any reader who
  arrives early.
  **Failure paths, and the addition.** Take the absent case. QC-21 is re-derived "when the FDR and
  the SDD carry the replacement" (NFDR RN-21), and QC-21 traces to PD-29. `docs/fdr.md` is Settled
  at v6 and had no companion. So after the SDD folds, `product-fdr` would have found nothing to act
  on, PD-29 would never move, and neither would QC-21. The draft's plan depended on a fold that
  nothing would trigger. This run opened `docs/fdr_open_issues.md` with one item for PD-29
  (`ka-reader@f5cddef`). The item proposes a sentence that is true now, without naming the
  replacement, so it can fold before the SDD settles.
  **What would have tipped me.** I would have overridden if a delivery change could reach QC-21
  before the SDD moves. The slice order rules that out.

## Left for the owner

None this run.

## Skipped

None this run. Both items carried a slot at its placeholder, and no item is addressed to another actor.

## Companions opened

- **`docs/SDD_open_issues.md`** — **appended** — companion to `SDD.md`, item 2.3 (C-I3 still
  checks against "C-R2's exact list", which C-R2 retired at `docs/SDD.md:L434-L448`; C-R2's and
  C-I3's record lines owe ADR-0011 and ADR-0012), landed in commit `51b0e01`
- **`docs/fdr_open_issues.md`** — **opened** — companion to `fdr.md`, item 2.1 (PD-29's "the
  renderer technology … not replaceable inside the terminus" is reversed by the owner's answer on
  the SDD companion's § 1.1, and NFDR QC-21 waits on it), landed in commit `f5cddef`

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh ka-reader`
- **`docs/fdr.md`** — `<CORE>/launchers/skill/launcher.sh product-fdr ka-reader`

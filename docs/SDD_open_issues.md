# SDD open issues — Nozoki

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time the seats fold them in, they first copy this file
> whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a disagreement is not something one seat asked, it
> is something two seats answered differently, and the answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the run entirely.** §§ 1–4 are all the SDD's own three seats;
> § 5 is a seat that never wrote the SDD, reading it long after it settled and finding something
> only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's, which stay fixed
> to the three authoring seats on purpose.

> **The cycle-9 items this file carried are folded and on the trail** (`docs/trail/sdd/cycle-9.md`):
> § 1.1, the owner's answer that the renderer leaves WKWebView — folded as `SDD.md` § 2, § 3, § 4
> C-R1, C-R7, C-D3, § 10 RC-3 and RN-60; § 2.1 and § 2.2, both confirmed — folded at `SDD.md` § 4
> C-I3 (RN-56) and § 10 RC-2 (RN-61). **One item remains, § 2.3 below**: the CTO drafted it into
> `SDD.md` at run 12, round 1 (RN-61), and its slot is the owner's.

---

## 1. Open issues — questions with no answer yet

*None open.* The one item this section carried — § 1.1, the renderer that could not start under
C-R2's rule — was answered by the owner on 2026-09-23 and is folded; the answer and the three
seats' positions are on the trail (`docs/trail/sdd/cycle-9.md` § 1.1), and the fold is `SDD.md`
§ 2, § 3, § 4 C-R1, C-R7, C-D3, § 10 RC-3 and RN-60.

## 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override

> **No `product-sdd` run wrote this item. A `companion-self-answer` run raised it on
> 2026-09-23** while it answered `docs/architecture_open_issues.md` §§ 2.1 and 2.2. That run read
> `SDD.md` § 4 C-R2 and C-I3 at v12 and found C-I3 still naming the list C-R2 retired. It also found
> the two conditions' record lines now point at records that the architecture companion carries
> forward. No item asked about either. **The CTO drafted both changes into `SDD.md` at run 12,
> round 1** (`SDD.md` RN-61), inside the fold of the owner's § 1.1 answer; the slot below is the
> owner's. (§ 2.1 and § 2.2, which this file carried beside it, were confirmed by the owner and are
> folded — `docs/trail/sdd/cycle-9.md` §§ 2.1, 2.2; `SDD.md` RN-56, RN-61.)

### 2.3 C-I3 still checks the bundle "against C-R2's exact list", and C-R2 and C-I3 name records that ADR-0011 and ADR-0012 now carry
- **Raised by:** the `companion-self-answer` run, 2026-09-23 — not one of the SDD's three seats
- **Drafted into the SDD:** Both changes, in § 4, at run 12, round 1 (RN-61).
  1. **C-I3's wording.** "`checks/bundle.sh` reads `codesign -d --entitlements :- Nozoki.app`
     against C-R2's exact list" now reads "against the set C-R2's rule admits, as the script's
     expected set records it — set equality, the expected set widened only by a change reviewed
     against the rule" (`SDD.md` § 4 C-I3, its third sentence). That is the form `docs/nfdr.md`
     QC-25 took at v10.
  2. **The record lines.** C-R2's record line reads "The record is ADR-0011 — Proposed, superseding
     ADR-0003 on acceptance (`docs/adr/README.md`, its row) — which restates the wall under this
     rule; until it is Accepted, ADR-0003 is the record in force and this condition departs from it
     on the one word *exactly* (RN-52)". C-I3's reads "The record is ADR-0010; the renderer gate's
     own record is ADR-0012 — Proposed — whose mechanism, control and observable's name are
     re-derived from this clause as it now reads". Each names the status the index shows on
     2026-09-23; when the `product-architecture` fold that takes
     `docs/architecture_open_issues.md` § 2.1's confirm lands, the two words *Proposed* are the
     CTO's to move to *Accepted* on the next fold here. One thing the draft adds that the item did
     not ask: under the owner's § 1.1 answer the renderer left WKWebView (`SDD.md` § 10 RC-3), so
     C-I3's line says ADR-0012's mechanism and control are re-derived from C-I3 — the record's own
     § Consequences already says so of itself.
- **Rationale:** C-R2 at v12 says the entitlement set is "bound by a **rule**, not held as a list"
  and that the rule "replaced 'exactly these entitlements'" (`docs/SDD.md:L434-L448`). Further down
  § 4, C-I3 still checks the bundle against "C-R2's exact list" (`:L554`). So the document
  contradicts itself. A delivery reader who takes C-I3 at its word fails a bundle carrying
  `com.apple.security.files.bookmarks.app-scope`, which C-R2 names as a member from the
  folder-selector slice. The record lines follow from the same ruling. ADR-0011 restates ADR-0003
  whole with the rule in place of the list and supersedes it on acceptance
  (`docs/adr/0011-app-sandbox-wall-under-a-rule-no-network-entitlement-ever.md`). ADR-0012 is the
  renderer gate's own record, which C-I3 claims none for (RN-56;
  `docs/adr/0012-renderer-run-proved-on-the-shipped-bundle-beside-the-wall.md`). NFDR RN-21
  reports the C-I3 record line as the CTO's at this fold but raised it nowhere, and this item is
  where it is raised. It costs no extra cycle, because it rides the fold § 1.1's answer already
  owes.
- **If overridden:** C-I3 keeps checking against a list C-R2 no longer holds, and the two
  conditions keep citing ADR-0003 after it is superseded and no record for the renderer gate.
  Nothing the SDD decides moves either way: the rule, the gate and the probe stand as written.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

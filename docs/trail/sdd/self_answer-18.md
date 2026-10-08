# Self-answer report — docs/SDD.md

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v10, Settled)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-23
- **Sources re-read:** None. This run gave no answer, so no answer rests on a source outside this
  repository.

## Items worked

None this run.

## Left for the owner

None this run.

## Skipped

- **5.1 — Under C-R2's exact entitlements the renderer never starts, so the window is empty** — the
  **Answer** slot is already filled, by the owner, 2026-09-23 (`docs/SDD_open_issues.md:L62-L76`,
  committed at `8b9ffa1`). A filled slot is an answer already given, and this run leaves it exactly as
  it stands. It is the only item in the file, and **Answer** is its only slot, so nothing was left to
  write.

## Companions opened

None this run.

No other document is owed a companion from this round yet. § 5.1's answer says the ADR and
`docs/nfdr.md` follow through the architecture chain once the SDD rewrites C-R2
(`docs/SDD_open_issues.md:L59-L61`). Its point 3 also makes the CTO find the mechanism before any
entitlement is chosen. Until `product-sdd` folds that, there is no settled change for
`architecture_open_issues.md` to carry.

One thing for the fold to check, not raised as an item because the C-R2 rewrite § 5.1 already asks
for covers it: C-R2 today names a third entitlement, `com.apple.security.files.bookmarks.app-scope`,
from the slice that adds the folder selector (`docs/SDD.md:L432-L435`). Under the owner's new rule,
any entitlement beyond the no-network condition and the read-only folder grant needs "an ADR that
names why it is needed" (`docs/SDD_open_issues.md:L67-L70`). So the rewritten C-R2 has to say whether
ADR-0003 already records that grant's reason or whether a new one does.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh ka-reader`

# Self-answer report — SDD

This report records the companion check for the owner and the next SDD producing run.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1; no new decision this run.
- **Date:** 2026-11-02
- **Sources re-read:** None; no answer this run rests on an external source.
- **Finding:** The companion is already answered: both items have filled Answer fields (`docs/SDD_open_issues.md:L44-L51`, `:L69-L91`). The header names sibling `SDD.md`, which exists, and names `product-sdd` as the producing skill (`docs/SDD_open_issues.md:L3-L5`).
- **Scope:** Step 3's nothing-left-to-write path: zero items decided, two filled answers skipped. No document review or new technical verdict was undertaken.
- **Report home:** `<CORE>/doctrine/setup/kensaiapp_structure.md` § 3, “A trail is not the document's sibling — it is filed under `trail/`”. The existing numbered reports ran through `self_answer-70.md`; this run uses the next number.

## Items worked

None this run.

## Left for the owner

None this run.

## Skipped

Two filled answers preserved under companion-self-answer Step 3.

- **5.1 — The `watcher` row places an FSEvents binding in the unit that imports no Apple framework** — Answer already filled (`docs/SDD_open_issues.md:L44-L51`). Left unchanged; the technical choice it delegates to the CTO belongs to the producing run.
- **5.2 — S-5 is one slice, but its checks are owed by two routes** — Answer already filled (`docs/SDD_open_issues.md:L69-L91`). Left unchanged.

## Companions opened

None this run.

## Launchers owed

- **docs/SDD.md** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`

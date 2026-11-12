# Self-answer report — DESIGN.md

## Header

- **Companion:** `docs/DESIGN_open_issues.md`
- **Document:** `docs/DESIGN.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-12
- **Sources re-read:** None. This run gave no answer, so no answer rests on an outside source.

## Items worked

None this run.

## Left for the owner

None this run.

## Skipped

- **3.1 — The application icon's drawing is signed off: an eye** — its **Answer** slot is already
  filled: "Signed off (owner, 2026-11-11)" (`docs/DESIGN_open_issues.md:L57-L60`). An answer that is
  already given is left as it stands. The companion holds no other item: § 1 and § 2 each read
  "None." So nothing in this file was this run's to write, and the companion is unchanged.

  Read, and nothing raised. The answer's facts match what is on disk.
  `docs/design/app_icon.svg` holds a rounded square filled `#FBFBFA`, an almond outline stroked
  `#1E1F22`, and a round pupil filled `#1E1F22`, with no other colour and no text. Those are the
  light values of `{colors.primary}` and `{colors.surface}` in the frontmatter
  (`docs/DESIGN.md:L7`, `:L10`). The drawing therefore keeps every rule in § Components "The
  application icon": two tokens, no hue, no lettering, and neither pure black nor pure white
  (`docs/DESIGN.md:L849-L870`). That paragraph still says the figure "is drawn separately and recorded
  in this paragraph once the owner has signed it off" (`:L857-L858`). That sentence is exactly what
  the answered item exists to fill, and `product-design` fills it on its fold. I found nothing else
  in the parts of `DESIGN.md` this item touches — the frontmatter, § Overview, the icon paragraph, and
  the Do's and Don'ts — that is false now, contradicts another document, or misses an upstream
  change.

## Companions opened

None this run.

## Launchers owed

- **docs/DESIGN.md** — `<CORE>/launchers/skill/launcher.sh product-design ka-reader`

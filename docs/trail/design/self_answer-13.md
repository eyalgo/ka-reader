# Self-answer report — docs/DESIGN.md

## Header

- **Companion:** docs/DESIGN_open_issues.md
- **Document:** docs/DESIGN.md
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-12
- **Sources re-read:** None. The one answer rests only on this repository: the tree at `ka-reader@b809ab9`, its history, and the bytes of the fixture.

## Items worked

### 3.1 — "The application icon" names the stand-in at a path the tree no longer holds

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the design language
- **Verdict:** confirmed with addition
- **Why:** The design document is wrong here and its own seat can fix it. The item asks for a correction, not a widening: a path the document names is gone, so § *A widening item waits until it occurs* does not apply. The item proposes a fix, so I read that as a draft and weighed it.

  *Check 1, the seat.* The fix is a sentence in `docs/DESIGN.md` § Components "The application icon", and it commits nothing to any person. It is this document's to fix, and the answer goes in the slot.

  *Check 2, is the draft sound.* Yes, and every fact it rests on holds when measured. `ls ka-reader-mac/icon.icns` prints "No such file or directory". `git log --diff-filter=D -- ka-reader-mac/icon.icns` names `338288d` ("the build script generates the icon"), and that commit is on main. The file as it stood just before that commit (`git show 338288d^:ka-reader-mac/icon.icns`) matches `checks/fixtures/stand-in-icon.icns` byte for byte (`cmp` reports no difference). `ka-reader-mac/assemble.sh` renders `docs/design/app_icon.svg` with `sips` and `iconutil` at every assembly (`:L65`, `:L95-L98`) and copies the result to `Contents/Resources/icon.icns` (`:L166`). `checks/bundle.sh` refuses a bundle in which any file has the stand-in's bytes (`:L26-L31`, `:L123-L147`). `Info.plist` still names `icon.icns` (`:L13-L14`), but that file is now the generated one. So the document's rule, "a release carries the drawn icon, or the bundle names no icon file", is still true, and only the clause about where the stand-in lives is false.

  *The additions.* (1) The new clause should say why the bytes are still in the repository: they are the icon check's control. A reader who finds a blue icon file under `checks/fixtures/` might otherwise take it for a second icon, or for the decided one. (2) The item names RN-33's mentions of the old path (`:L1541`, `:L1575`) as records of their day. RN-34 also has one: "The bundle as built still names the blue square (`ka-reader-mac/Info.plist:L11-L12`; `ka-reader-mac/assemble.sh:L37`, `:L61`)" (`:L1630`). It is a record too and does not move. The fold should say so, so nobody "fixes" a dated record. The paragraph's "the bundle's icon is generated from that file (RN-44)" is already true and stays as written.

  *Check 3, does it contradict anything settled.* No. The rule "No stand-in ships", the Don't against shipping a stand-in, and the first Do's exception for the icon as a fixed file (now `docs/design/app_icon.svg`, still redrawn when either token moves) all stand. The PM's own record of the station says the same thing the answer says. No token value or component changes.

  *Check 4, failure paths.* Stale: if the fixture moves or the check is renamed, the new clause goes stale the same way this one did. Tying it to the check's role (the control) rather than only to a path means a reader can follow it even then. Absent: if a build runs without the drawing, `assemble.sh` stops with no bundle (`:L70`, `:L76`), so no bundle ships without an icon and no stand-in is substituted. That is the code's guarantee and not this document's. Nothing is uncovered that this sentence has to cover.

  I was close to plain **confirmed**. Addition 2 tipped it, because without it the fold could rewrite RN-34.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/DESIGN.md** — `<CORE>/launchers/skill/launcher.sh product-design ka-reader`

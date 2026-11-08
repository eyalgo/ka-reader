# SDD open issues — KA-Reader

> Companion to `SDD.md`. The CTO wrote the SDD; this file holds what that run could not settle from
> its inputs (the PRD, the SRS, the UXD, and any context or constraints), and the calls that are the
> CPO's or the CDO's to make. An item whose call is the CPO's or the CDO's carries that seat's
> `Seat:`; an item whose call is the CTO's carries `cto` or no `Seat:` field.
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time `product-sdd` folds them in, it first copies this
> file whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item may name the seat that answers it.** Any item in any section carries an optional
> `- **Seat:** <seat>` field beside its other fields. Its value is the name of the agent whose posture
> answers the item — `cto`, `cpo` or `cdo`. An item with no usable value, whether the field is absent,
> empty or still the `<seat>` placeholder, is answered in the seat of the skill that produced this file.
> The field names the *answering* seat. It is not the seat that raised the item (`Raised by:` /
> `Held by:`), and it is not the document an answer belongs to.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a
> disagreement is not something one seat asked, it is two positions held by different seats, and the
> answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.** §§ 1–4 are all the SDD's own three
> lane seats; § 5 is a seat that never held a lane in it, reading it long after it settled and
> finding something only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's,
> which stay fixed to the three lane seats on purpose.

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-11-09, reading the settled SDD
> against the product at `ka-reader@2d7c4f9`. One item follows in § 5; the SDD is not edited.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 § 3's `read-only-harness` row is pinned at `3fa227e` and names none of the release workflow, its five scripts or their five suites
- **Raised by:** PM — 2026-11-09
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; the row's enumeration, counts and `gate.sh` locators read an older tree, and S-7's later work reads this row.
- **Where it shows:** `docs/SDD.md:L539`, measured at `ka-reader@3fa227e` (sixteen scripts, seventeen suites, 40 gate steps, `gate.sh` at 1.10.0, one workflow). At `ka-reader@2d7c4f9` the tree adds `checks/release-version.sh`, `checks/release-pack.sh`, `checks/release-sums.sh`, `checks/release-absent.sh` and `checks/release-shape.sh`, their suites `checks/tests/test_release_{version,pack,sums,absent,shape}.sh`, and a second workflow, `.github/workflows/release.yml`; `checks/gate.sh` is at 1.11.0 with 46 steps (`grep -cE "^run_step '" checks/gate.sh` → `46`).
- **If a document has to be written:** none — the row is re-measured and re-pinned at the current tree.
- **Answer:** Confirmed with addition. § 3's `read-only-harness` row is re-measured at `ka-reader@2d7c4f9` (the merge that landed the release workflow; the tip answered at, `09057d9`, holds its tree outside `docs/`) and re-pinned there, with the `3fa227e` reading kept as a dated note and its line map, and the item's enumeration is right: `.github/workflows/release.yml` (93 lines, mode 100644) joins `ci.yml` (unchanged, 41 lines), the five scripts and their five suites land, all ten at mode 100755, `gate.sh` is at 1.11.0 with 46 steps (`grep -c '^run_step'` prints 47), its list at `:L58-L162` and its dispatcher at `:L40-L47`. The addition is what the same re-measure carries beyond the counts. (1) The row's shape sentence changes, not only its numbers: "every check script but two" runs as a gate step is false now — `release-version.sh`, `release-pack.sh`, `release-sums.sh` and `release-absent.sh` run as steps of the release workflow (`release.yml:L68-L83`) and of no gate step, where their suites run; `release-shape.sh` is the one new script that is itself a gate step (*Release workflow shape*, `checks/gate.sh:L135`), reading `release.yml`'s text against CP-1170 – CP-1184 because a tag run cannot run while Actions is off — so the scripts no gate step runs are six: the two a person runs and the four the release workflow runs. (2) The six steps sit in one block at `:L135-L140` under a five-line comment at `:L130-L134`, between *Strings check step suite* (`:L129`) and *Own state suite* (`:L141`): shape check, its suite, then *Release version suite*, *Release image suite* (`test_release_pack.sh`), *Release checksum suite* (`test_release_sums.sh`) and *Release absent suite*; the comment says why — the block reads the bundle *Build KA-Reader.app* wrote, launches nothing, and the check precedes its suite as *Strings check* does. They are `first-public-release`'s (§ 6 S-7), and the row says they are in the list, not that the slice is delivered; S-7's command half already names `release.yml` and is not amended. (3) `release.yml` is described as it stands: on a `v*` tag push, `contents: write`, one concurrency group per ref with no cancel, bash `-eo pipefail`, one job on `macos-26`; checkout at depth 0 with `persist-credentials: false`; *Test gate*; *Install cargo-audit* 0.22.2 and *Cargo audit*; the four scripts; `shasum -a 256 -c SHA256SUMS`; and `gh release create --draft … --verify-tag` holding the image and the sums, notes written by hand by whoever publishes (`:L16`). (4) The network sentence: the six gate steps reach no network — the absent suite's `gh` is a stand-in — while at release the workflow's two audit steps and `release-absent.sh`'s `gh api --paginate` (`:L54`) do, outside the gate; the gate holds no audit step, and whether QC-64's wording bears that is the Principal Architect's (`docs/architecture_open_issues.md` § 3.1). (5) `test_vm_refusal.sh` is unchanged, but its runner case greps every `.yml` under `.github/workflows/` (`:L273`), so it now reads both workflows' `runs-on`; its gate-step and fatal-step cases still read `ci.yml` alone (`:L39`). (6) The pack suite mounts an image and needs a session that allows `hdiutil attach`; the version and pack suites read the gate-built bundle. None of the five sources `tests/support/vm_refusal.sh` — still seven. The CP ids appear in no document under `docs/`; the row names the scripts and not their rule. (7) The line map: `gate.sh` gained two lines at `:L2-L3` and eleven at `:L130-L140`, so every locator from old `:L2` to old `:L127` reads two higher and every one from old `:L128` thirteen higher; § 4 C-I3's `:L38-L45`, `:L78` and `:L94` read `:L40-L47`, `:L80` and `:L96`; every `ci.yml` and `test_read_only.sh` locator stands. (8) GitHub Actions is still disabled (`gh api …/actions/permissions` prints `enabled: false`, re-read 2026-11-09) and the repository is private, so `release.yml` has never run and the row says what is on disk, not that a step is green. The counts read twenty-one scripts — nineteen paired, `gate.sh` and `tree-walk.sh` not — and twenty-two suites, nineteen paired and the three beside them. `docs/nfdr.md`'s own counts and QC-64 and QC-70 stay the Principal Architect's (`docs/architecture_open_issues.md` §§ 3.1–3.3), not pre-empted here. Reasoning: `docs/trail/sdd/self_answer-90.md`.

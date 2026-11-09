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
> against the product at `ka-reader@06e4a34`. One item follows in § 5; the SDD is not edited.

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

### 5.1 § 3's `read-only-harness` row is pinned at `2d7c4f9` and names neither `checks/notices.sh` nor its suite
- **Raised by:** PM — 2026-11-09
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; the row's enumeration, counts and `gate.sh` locators read an older tree, and S-7's later work reads this row.
- **Where it shows:** `docs/SDD.md:L540`, measured at `ka-reader@2d7c4f9` (twenty-one scripts, twenty-two suites, 46 gate steps, `gate.sh` at 1.11.0). At `ka-reader@06e4a34` the tree adds `checks/notices.sh` and its suite `checks/tests/test_notices.sh`, the whole commands of the gate steps *Notices check* (`checks/gate.sh:L129`) and *Notices check suite* (`:L130`), directly after *No-network suite*, with their comment at `:L123-L128`; `ls checks/*.sh | wc -l` → `22`, `ls checks/tests/*.sh | wc -l` → `23`, `grep -cE "^run_step '" checks/gate.sh` → `48`, and `checks/gate.sh:L2` reads `# Version: 1.12.0`. *No-network suite*, which the row places at `:L120`, is at `:L122`, so the row's `gate.sh` locators are read again at the new pin.
- **If a document has to be written:** none — the row is re-measured and re-pinned at the current tree.
- **Answer:** Confirmed with addition. § 3's `read-only-harness` row is re-measured at `ka-reader@06e4a34` (the merge that landed the licence and notices stand; the tip answered at, `caa0f42`, holds its tree outside `docs/` — `git diff --stat 06e4a34 caa0f42 -- . ':!docs'` prints nothing) and re-pinned there, with the `2d7c4f9` reading kept as a dated note and its line map, and the item's enumeration is right to the digit: `git diff --name-status 2d7c4f9 06e4a34 -- checks .github` lists exactly `checks/gate.sh` changed and `checks/notices.sh` and `checks/tests/test_notices.sh` added, both at mode 100755 (91 and 393 lines); `gate.sh` is at 1.12.0 (`:L2-L3`, a two-line entry) with 48 steps (`grep -c '^run_step'` prints 49), its list at `:L60-L172` and its dispatcher at `:L42-L49`; *Notices check* (`:L129`) is the whole command of `checks/notices.sh` and *Notices check suite* (`:L130`) of `checks/tests/test_notices.sh`, directly after *No-network suite* (`:L122`) and before *Offline page, repository* (`:L131`), under a six-line comment at `:L123-L128`. The addition is what the same re-measure carries beyond the counts. (1) The comment's reason is the row's to hold, as it holds every other placed step's: the block sits after *Build the workspace* (`:L72`) because `notices.sh` runs `cargo tree --offline`, which reads the crate sources that step's build fetched and a fresh checkout does not have before it; the check precedes its suite so a miss on the tree is named by the check's own step, as with *Strings check*; both precede *Launch the built bundle* (`:L169`) with *Own state* (`:L172`) last; and the place after *No-network suite* is a stated preference — a new dependency is named by the allowlist step before its notice is asked for. (2) The shape sentence does not change this time: `notices.sh` is a gate step paired with a suite, so the scripts no gate step runs stay six — the two a person runs and the four the release workflow runs — and the counts read twenty-two scripts, twenty paired with a `test_<name>.sh` and `gate.sh` and `tree-walk.sh` not, and twenty-three suites, the twenty paired and the three beside them; `tests/support/vm_refusal.sh` is still sourced by seven (`test_notices.sh` does not source it); sixteen fixture folders, none added. (3) What the check reads is new in kind for this unit: its one input beside `cargo tree` is `THIRD_PARTY_NOTICES.md` at the repository root, a file outside `checks/` that the row's own re-measurement rule does not name — the rule stays as written, and the row says which root file the step reads; the name set is `no-network.sh`'s `cargo tree` argument list and reading, copied and not shared (`checks/notices.sh:L22-L26`), so a reviewer of one list holds the other; a name is present only as a whole token split at every byte outside `[A-Za-z0-9_-]`, in its own case; it writes no file, reads no variable but PATH (`:L32-L36`), exits 1 naming each missing name and 1 with one line when it could not compare — the notices file unreadable, `cargo tree` non-zero or printing no name — 2 on any argument, and never 0 on a signal (`:L39-L40`, `:L48`); the CP ids its suite cites are the change's own, and the row names the script and not its rule, as for QC-28's and QC-53's. (4) The network sentence gains two steps that reach none: `cargo tree` runs `--offline` in the check and in the suite's last case, and the suite's other twelve cases drive the real script with a stand-in `cargo` first on PATH under a `mktemp -d` work directory of their own; the last case runs the real tree and asserts the repository's `git status --porcelain --ignored` and `Cargo.lock`'s checksum unchanged, so a dirty tree after the step is the suite's failure, not the row's. (5) The line map: `gate.sh` gained two lines at `:L2-L3` and eight at `:L123-L130`, so every locator this row pinned at `2d7c4f9` from old `:L2` to old `:L120` reads two higher and every one from old `:L121` ten higher — the list `:L58-L162` reads `:L60-L172`, the dispatcher `:L40-L47` reads `:L42-L49`, *Build KA-Reader.app* `:L80` reads `:L82`, *Test gate* `:L81` reads `:L83`, *View check* `:L96` reads `:L98`, *Read-only, submodule* `:L110` reads `:L112`, *No-network suite* `:L120` reads `:L122`, *Offline page, repository* and its suite `:L121-L122` read `:L131-L132`, *Strings check* `:L127` reads `:L137`, *Strings check step suite* `:L129` reads `:L139`, the release block `:L135-L140` reads `:L145-L150` with its comment `:L130-L134` at `:L140-L144`, *Own state suite* `:L141` reads `:L151`, *VM refusal suite* `:L147` reads `:L157`, *Launch the built bundle* `:L159` reads `:L169`, *Own state* `:L162` reads `:L172`, and the version lines 1.11.0 to 1.2.0 read `:L4-L5` to `:L15-L16`; § 4 C-I3's three — `:L40-L47`, `:L80`, `:L96` at `2d7c4f9` — read `:L42-L49`, `:L82`, `:L98`, and every `ci.yml`, `release.yml` and `test_read_only.sh` locator stands, those files unchanged. (6) GitHub Actions is still disabled (`gh api repos/<owner>/<repository>/actions/permissions` prints `enabled: false`, re-read 2026-11-09) and the repository is private, so the two notices steps' hosted result is unread, `release.yml` has never run, and the row says what is on disk, not that a step is green. § 6 S-7's command half already names `checks/notices.sh` and is not amended; `docs/nfdr.md` QC-41's release-only wording, § 9's suite count and QC-70's reading are the Principal Architect's, carried by `docs/architecture_open_issues.md` §§ 3.1–3.3, and are stated here as facts of the tree, not pre-empted. Reasoning: `docs/trail/sdd/self_answer-91.md`.

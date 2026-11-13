# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-13
- **Sources re-read:** None outside this repository. The rules the answer applies were read where
  they are held, in the shared core the run resolves: the NFDR template's § 9 Behave and way-in
  lines, `product-architecture`'s prompt (the Behave call and the way-in pick), the Behave starter's
  README § *The three ways in*, and the change walk's gate in `<CORE>/tools/chain_development.py`
  (`:L418-L435`), which halts on an NFDR with no `**Behave:**` line, a `behave` with no way-in line,
  or a way-in line still holding its three forms.

## Items worked

### 3.1 — The NFDR records no Behave call and no way in for QA's scenarios

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** **`**Behave:** behave` and `**Behave way in:** command`, with four bounds the fold carries
  into § 9.** The item carries no draft, so it is answered from scratch.

  *Seat.* Making the Behave call and picking the way in is this seat's by `product-architecture`'s
  own prompt, which has the Principal Architect make both and write them in § 9. The criteria are the
  owner's (ruled 2026-11-10), and applying them binds no person, money or outside party. Nothing
  here is a ground the run cannot see, so the item is the run's to answer in the owner's seat.

  *Widening.* The item asks § 9 to state two lines it does not state, so it widens the document. It
  cites an occurrence: a measured failure, the walk halting before QA with the gate's own message,
  and the gate in `chain_development.py` does say that. So the widening is taken.

  *The call.* ka-reader is a product we own, with code, that a person uses. That is the first of the
  owner's criteria, so the call is `behave`. The card's test command is `checks/gate.sh`, not `none`,
  so the card rule does not turn it to `none`. The card already reads `**Behave:** behave`, which
  agrees.

  *The pick.* The run tried each of the starter's three ways in against what the product is.
  - `browser` reaches nothing. The web renderer left with `ka-reader-ui` (`docs/nfdr.md` § 9, RN-22),
    and the product serves no page.
  - `server` reaches nothing. The product has no HTTP surface and its executable links no network
    (`docs/nfdr.md` QC-3; `docs/fdr.md` PD-26).
  - `command` reaches it, and it reaches it the way the product's own harness already does. A step
    runs a program and gets its exit status and output (`.behave/features/command_way_in.py`). The
    in-process driver over `SM-4` through `SM-5` is such a program (`crates/ka-reader-core/tests/walk.rs`,
    run by `checks/read-only.sh`, layer 3). So are the `checks/` scripts that run the built bundle
    (layer 5).

  So `command` is the pick, and the prompt's "none of the three reaches the product" case does not
  apply. The run was close to that case, because the person-facing entry point is the AppKit window
  and no way in drives it. What tipped it: the behaviour lives in the core and the bridge, the shell
  holds no I/O and draws only from projections, and a command reaches all of that. Rule 3 of the
  owner's criteria also says that being hard to test is never a reason to fall short. Making a
  change's behaviour testable through the recorded way in is the design step's work.

  *Check 3 — what it must not contradict, which is where the four bounds come from.*
  1. The FDR says the product has no command-line interface (PD-26) and takes no launch argument
     (OOS-19). So the program a scenario runs is a test host or a `checks/` script, never the
     shipped app with an argument. A scenario that would need one is a finding for the design step,
     not a new product surface.
  2. The SDD says no harness drives the AppKit views (§ 4 C-I3, § 9 TO-7). So a scenario asserts what
     the core and the bridge answer, which is the projection a view is drawn from. The drawing stays
     at layer 4, and `docs/SRS.md` AC-10 stays a manual walk.
  3. § 9's layer-7 row reads "until a QA seat writes the layer". With the call made, that row now
     names QA's scenarios under `.behave/features/`, run with `uv run --locked behave` from
     `.behave/`, through the command way in. Without this, § 9 would say two things at once.

  *Check 4 — the failure paths.*
  - **Absent:** a scenario that runs the built bundle needs the bridge assembled from this checkout
    first, as every run already does under § 9. A machine without `uv` cannot run the scenarios at
    all, and the starter's README says so.
  - **Refused:** a VM admission refusal, or a window the window server did not place in a locked
    session, is a run that did not read the change. It is never a red. This matters because QA's red
    step reads a failing scenario on the code before the change as the change's red. Bound 3 in the
    slot carries this together with the absent case, because both are § 9's existing preconditions.
  - **Concurrent:** two runs that launch the bundle at once share the app's one container log. This
    is not covered here. It is the same exposure the existing launch check has, and no item raised it.
  - **Empty** and **stale** add nothing beyond the bridge-assembly precondition above.

  *Left out on purpose.* Whether `.behave/` joins `checks/gate.sh` as a step is a separate question.
  No item raised it and no occurrence shows it, so the answer says it is not this item's. No ADR is
  owed. The call applies a standing rule, so reversing it is cheap and it involves no trade-off of
  its own. That fails the significance test.

  *Found while reading, not this item's:* an untracked `features/` folder sits at the product root.
  It holds an older Behave example (`example.feature`, `steps/example_steps.py`, dated 2026-11-11),
  outside `.behave/` and outside both records. The run left it alone: deleting someone else's
  untracked files in the main checkout is not this run's move.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`

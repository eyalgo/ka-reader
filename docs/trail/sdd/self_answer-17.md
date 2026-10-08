# Self-answer report — docs/SDD.md

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v8, Settled)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-23
- **Sources re-read:** None. No answer below depends on a source outside this repository. The one
  vendor claim in C-I3 is Apple's "Sandbox column" sentence, and § 5.1 neither changes it nor
  relies on it.

## Items worked

### 5.1 — C-I3's "a red run says how long it waited" does not say whether it covers a run ended by a failed ask

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The PM's lean is taken, but with a different reason and three additions. The item sits
  in the raised-from-downstream bucket and has only an Answer slot. It carries a lean, though, so
  this run treated the lean as a draft.

  *Whose it is (check 1).* The edit belongs in `SDD.md` § 4 C-I3, which is the CTO's clause in
  this document. The only thing it commits is how consistent the document is with itself. So it
  is this document's to answer, and I answered it in the owner's seat.

  *Is the draft sound (check 2)? The conclusion holds; the reason does not.* The lean says "a run
  that did not wait has no wait to report". But a run can fail on a late ask. At the default 40
  asks, a failure on ask 30 comes after about seven seconds of waiting
  (`checks/bundle.sh:L83`, `:L337-L338`). So "did not wait" is not always true. The real reason
  is why the sentence exists at all. The answer that added the printed bound gave its purpose:
  "Otherwise a red run cannot tell 'waited long enough and the wall is absent' from 'gave up
  early'" (`docs/trail/sdd/self_answer-12.md`, addition 1). That question only arises when the
  run ends because the window ran out. A failed ask did not give up early. It stopped on a
  failure it names, and on the die path the failure line includes the probe's stderr
  (`checks/bundle.sh:L338`). For a gone process, that stderr reads "no process has pid N, so
  sandbox_check has nothing to read" (`checks/sandbox_probe.rs:L110-L113`). That covers the
  lean's "names what failed". The line does not say which ask failed, so the lean's "does not say
  which ask failed" is right too.

  *Does it contradict anything settled (check 3)?* No. § 11 R-8's *shows up as* describes only
  the window-out case: "finding no ask, within the bounded window …, on which … — the red run
  printing how long it waited" (`SDD.md:L1982-L1985`). So R-8 already reads this way and does not
  move. C-I3's *Violated by* phrase "a bound not printed" (`SDD.md:L566`) is read with the same
  scope, which makes the script's failed-ask line compliant. That matches how the script was
  built (`checks/bundle.sh:L38-L41`: "The bound is printed on the pass line and on the red
  closing line"). NFDR QC-25 copies the sentence word for word (`docs/nfdr.md:L253-L254`). By the
  opening note of SDD § 4, it is re-derived from § 4 after the fold. It is not contradicted
  meanwhile, only less precise, so I raised no item on the architecture companion. The fold is
  where that change is made, as RN-48 did for the window.

  *Does it hold on the failure paths (check 4)? These are the additions.*
  - **(a) The clause itself.** C-I3 states which red runs the bound covers. A run ended by a
    failed ask — `sandbox_check` missing or erroring, or the pid no longer naming a process —
    ends at once and names what failed. This corrects the reach of a sentence that is already
    there, so it is not a widening.
  - **(b) Refused / the control.** The item covers the ordinary path and says nothing of the
    control's red. The control ends at once on the first report that is not `sandboxed: no`
    (`checks/bundle.sh:L305-L311`). Its red line prints no bound (`:L323`), and only its pass
    line prints one (`:L322`). The same scoping covers it: no red run of the control ends because
    the window ran out, so none owes a bound.
  - **(c) Absent: a process gone mid-window.** The failure line does not say on which ask the run
    ended. So on a hosted runner, a launch crash and a crash late in the window read the same.
    The item's doubt proposes widening the sentence to "or on which ask it ended". The item cites
    no run where a process was gone mid-window. Under the prompt's § *A widening item waits until
    it occurs*, that half is answered "not until it occurs". C-I3 names it as a case it does not
    cover, the same way it already names the uncovered yes→no case. `checks/bundle.sh` owes no
    change.

  *What would have tipped it.* One hosted-runner run that failed on a gone process, where knowing
  the ask would have changed the diagnosis. That would be an occurrence, and addition (c) would
  then become the doubt's wider sentence plus a script change.

## Left for the owner

None this run.

## Skipped

None this run. § 5.1 was the only item in the file and its slot was at its placeholder. The
companion's provenance blockquote says "The companion holds one item, § 5.1". That stops being
true once § 2.1 is appended below. I did not edit it because it is the PM's text. The fold
removes it with the file.

## Raised on this document

### 2.1 — The Version line has lost versions 5–7, and v8's entry runs into the tail of v5's

- **What the document is owed:** Put back v5's opening clause
  (`ka-reader@67372a5:docs/SDD.md:L9`). Restore the v7 and v6 entries from line 9 of
  `ka-reader@c1f8a20` and `ka-reader@b3439e8`. From now on, bump the version by adding a new first line
  above the old ones, never by replacing it.
- **Why it is worth a cycle:** It meets the first ground in `decide_companion_answers.md`
  § *The items are not the whole of what a document is owed*: a fact in it is now false. The
  measurement is `git show <sha>:docs/SDD.md | sed -n 9,11p` at `67372a5`, `b3439e8`, `c1f8a20`
  and `9b36a42`. Line 9 is each run's own version, and line 10 is v5's continuation all four
  times. So today the v8 entry reads as if it consumed `cycle-3.md` and removed the companion.
  Run 5 did those things. A round is already owed on this document for § 5.1, so this adds no
  extra run. It went into *Choices to confirm* with its slot at the placeholder.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh ka-reader`

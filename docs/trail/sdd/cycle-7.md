# SDD open issues — KA-Reader

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

> **No `product-sdd` run opened this companion. The PM opened it on 2026-09-23.** `SDD.md` is
> settled at v8 and had no companion on disk. Without one, a `product-sdd` re-run would read the SDD
> as done and find nothing to act on. The companion holds one item, § 5.1.

---

## 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override

### 2.1 The Version line has lost versions 5–7, and v8's entry runs into the tail of v5's

> **No producing run wrote this item.** The `companion-self-answer` run answering this file raised
> it on 2026-09-23, under `<CORE>/prompts/decide_companion_answers.md` § *The items are not the
> whole of what a document is owed*. That section covers this case as *the document you are
> answering*. It came from reading `SDD.md` whole to answer § 5.1, and it has nothing to do with
> § 5.1. This item's slot is left at its placeholder: the reasoning is that run's, and the decision
> belongs to the next round. Reasoning: `docs/trail/sdd/self_answer-17.md`, § *Raised on this
> document*.

- **Raised by:** `companion-self-answer`, answering this file — 2026-09-23
- **Drafted into the SDD:** Nothing has been written into the SDD yet. As it stands,
  `SDD.md:L9-L50` gives v8's entry. Its next line starts mid-sentence: "recall outstanding, and
  `docs/SDD_open_issues.md` no longer stands on disk, so this document is stamped Settled. The run
  consumed the one companion item …". That is v5's entry with its opening clause missing, and
  there is no entry for v6 or v7. The draft change: put back v5's opening clause, "**Version:** 5
  — run 5 (`docs/trail/sdd/run-5.md`): all three seats declared `no_followup` with no"
  (`ka-reader@67372a5:docs/SDD.md:L9`). Write back the v7 and v6 entries from line 9 of
  `ka-reader@c1f8a20` and `ka-reader@b3439e8`, newest first after v8. Any later bump then adds a new
  first line above the old ones and never replaces it.
- **Rationale:** Runs 6, 7 and 8 each replaced line 9 when they should have added a line above
  it. At `67372a5` (v5), line 9 opens v5's entry and line 10 continues it. At `b3439e8` (v6),
  `c1f8a20` (v7) and `9b36a42` (v8), line 9 is that run's own version and line 10 is still v5's
  continuation. So the Version line now says something false. A cold reader takes run 5's close
  as v8's: the `cycle-3.md` consumption, RN-41 – RN-43 repointed, and "`SDD_open_issues.md`
  removed". Run 5 did those things. The v6 and v7 changes (RC-1, RN-45 – RN-47) have no entry at
  all. This needs no further argument than the measurement. The text to restore is all in git,
  so nothing is re-derived.
- **If overridden:** Nothing outside the Version line moves. Without the change, the line keeps
  crediting run 5's work to v8, and the next bump that replaces line 9 hides v8 in the same way.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

---

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 C-I3's "a red run says how long it waited" does not say whether it covers a run ended by a failed ask
- **Raised by:** PM — 2026-09-23
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing is waiting on it to be built. But one sentence can be read two ways,
  and `docs/nfdr.md` QC-25 copies it (`nfdr.md:L253-L254`). C-I3 says "the script prints the bound
  in the probe's output, so a red run says how long it waited" (`SDD.md:L537-L538`). The same
  clause names two failures that do not wait out the window. One is "a process gone before the pass
  is a failure" (`:L540-L541`). The other is `sandbox_check` returning "an error on any ask"
  (`:L556`). A reader cannot tell whether "a red run" includes these two.
- **Where it shows:** In `checks/bundle.sh` as it stands on `main` (`0877635`). When the window runs
  out, the red line states the bound: "no ask held all three within <N> asks, 0.25 s apart"
  (`:L375`). When an ask fails, the run ends at once with "the operating system's sandbox report for
  pid <pid> could not be read: …" (`:L338`). That line states no bound and does not say which ask
  failed. A gone process takes this path too, because the probe refuses a pid that names no
  process (`checks/sandbox_probe.rs:L103-L115`). The negative control's failed ask ends the same way
  (`bundle.sh:L303`).
- **If a document has to be written:** None. What is owed is one clause in C-I3 saying which red
  runs state the bound. **The PM's lean:** the sentence reaches only a run that ends when the window
  runs out. A failed ask ends the run at once and names what failed, and a run that did not wait has
  no wait to report. Stating this in C-I3 keeps the script as it stands and closes the question.
  **The doubt:** on a hosted runner, a gone process is the failure where knowing *when* matters most.
  An ask count on the failure line would say whether the process died at launch or late in the
  window. If the seat wants that, C-I3 should say "a red run says how long it waited, or on which
  ask it ended", and the script owes that line a change.
- **Answer:** Take the PM's lean: the sentence covers only a red run that ends because the window
  ran out. The lean gives the wrong reason, though, and three things need adding. The reason: the
  bound is printed so that a red run can tell "waited out the whole window, and the wall is
  absent" apart from "gave up early" (`docs/trail/sdd/self_answer-12.md`, addition 1). A run
  ended by a failed ask did not give up waiting. It stopped on a failure that it names. It may
  well have waited, so "a run that did not wait" is the wrong ground. The additions:
  (a) C-I3 says in one clause which red runs the bound reaches. A red run that ends because the
  window ran out says how long it waited. A run ended by a failed ask ends at once and names what
  failed — `sandbox_check` missing or returning an error, or the pid no longer naming a process.
  *Violated by*'s "a bound not printed" reads the same way. § 11 R-8 already describes only the
  window-out case and does not change.
  (b) The same holds for the negative control. The control's red run ends at once, on the first
  report that is not `sandboxed: no` (`checks/bundle.sh:L311`, `:L323`), so of the control's
  lines only its pass line prints the bound (`:L322`).
  (c) The failed-ask line does not say on which ask the run ended, so a process that dies does
  not say whether it died at launch or late in the window. C-I3 names this as a case it does not
  cover. The widening the doubt proposes ("or on which ask it ended") cites no run where that
  mattered, so it waits until one occurs. `checks/bundle.sh` stays as it is. After the fold,
  NFDR QC-25 (`docs/nfdr.md:L253-L254`), which copies the sentence, is re-derived from § 4.
  Reasoning: `docs/trail/sdd/self_answer-17.md` § 5.1.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.

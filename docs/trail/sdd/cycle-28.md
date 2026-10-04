# SDD open issues — Nozoki

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


> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-04 from the SDD's own companion
> template. From `nozoki@129586e` the shell calls `nozoki_read_git`, so the release executable links
> the export. Two statements of the SDD say no Swift source calls it and no such build has been read.
> The SDD is Settled, and with no companion on disk a `product-sdd` re-run reads it as done and has
> nothing to act on. Its two items are in § 5.

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

### 5.1 § 4 C-I3 says the `nm` read has not met an executable that links `nozoki_read_git`; it has, and it passes
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. A reader of C-I3 learns the transport claim is unproved for the
  linked export, and it now is.
- **Where it shows:** § 4 C-I3, the transport-read sentences (`docs/SDD.md:L771-L775`): "It has not met
  one that links the `nozoki_read_git` export: the same `nm` output holds no `_nozoki_read_git`, and no
  Swift source calls it." At `nozoki@129586e`, `nozoki-mac/Sources/Nozoki/NativeBridge.swift:L26`
  calls `nozoki_read_git()`. Measured 2026-10-04 at that commit: `nozoki-mac/assemble.sh` exits 0;
  `nm` on `target/release/bundle/macos/Nozoki.app/Contents/MacOS/Nozoki` holds `_nozoki_read_git`; and
  `checks/view.sh` exits 0, printing "links no WebKit or JavaScriptCore and carries no Git transport —
  nothing found". The likely fold: the read has met the executable that links the export, from
  `nozoki@129586e`, and passed.
- **If a document has to be written:** none. C-I3's transport-read sentences in `SDD.md`.
- **Answer:** Take the likely fold, with four additions. Answered in the CTO's seat by an
  unattended `companion-self-answer` run on 2026-10-04, which rebuilt the bundle and re-ran the
  read before answering.
  **The fold.** C-I3's sentences "It has not met one that links the `nozoki_read_git` export: the
  same `nm` output holds no `_nozoki_read_git`, and no Swift source calls it" and "The read runs on
  every build, so it meets that executable in the build where `mac-shell` first calls the export,
  with nothing further owed" stop being true at `nozoki@129586e`. They are replaced by the
  measurement: the read has met the executable that links the export, and it passed.
  **(1) The measurement C-I3 carries.** This run's own, at `nozoki@cfcbedf`, whose tree outside
  `docs/` is the tree at `nozoki@129586e` (`git diff --quiet 129586e HEAD -- . ':!docs'` exits 0):
  `nozoki-mac/assemble.sh` exits 0, and `checks/view.sh` exits 0 on the bundle it built, printing
  "38 Swift files scanned" and "links no WebKit or JavaScriptCore and carries no Git transport —
  nothing found". `nm` on that executable prints `T _nozoki_read_git`, `_git_repository_open_ext`
  and `_git_status_list_new`, 781 defined `_git_` symbols by the `awk` command C-I3 already
  carries, no `git_smart_subtransport_` symbol, and no undefined `_connect`, `_socket` or
  `_getaddrinfo`. The measurement at `nozoki@0aab3e7` stays as a dated earlier one.
  **(2) Where the read ran.** On the owner's machine, twice. No hosted runner has read this build:
  `main` is ahead of `origin/main`, and the newest CI run is dated 2026-10-02. C-I3 says so beside
  the measurement, and says that CI runs the same script after `assemble.sh` on every push
  (`.github/workflows/ci.yml:L41`, `:L51`).
  **(3) C-R6 points at C-I3's executable.** C-R6 names three defined symbols the pattern does not
  match, read on "the executable C-I3's transport-read sentences name"
  (`docs/SDD.md:L641-L645`). The executable built at `nozoki@129586e` still defines all three, so
  C-R6's sentence holds once C-I3 names the new executable; its date is re-pinned to this read.
  **(4) What stays scoped.** "The claim is proved for one executable" keeps its form: the claim is
  proved for each executable the read has met, and for no later one until the read meets it. What
  a red read on a later build means is § 5.2's answer.
  Reasoning: `docs/trail/sdd/self_answer-40.md`.

### 5.2 § 11 R-15 says the build that links the export has not been read; it has been read, and it passes
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. R-15 reads as open for want of a measurement that now exists.
- **Where it shows:** § 11 R-15 (`docs/SDD.md:L2803-L2805`): "That executable does not link the
  `nozoki_read_git` export, which no Swift source calls, so the build that links the export has not
  been read and this risk is not closed." The first build that links it is `nozoki@129586e`, and its
  read passes (the measurement in § 5.1). Whether R-15 closes on one passing build or is kept is the
  CTO's call.
- **If a document has to be written:** none. R-15's sentence in `SDD.md`.
- **Answer:** R-15 is kept and restated. It is not closed. Answered in the CTO's seat by an
  unattended `companion-self-answer` run on 2026-10-04.
  **What is corrected.** "That executable does not link the `nozoki_read_git` export, which no
  Swift source calls, so the build that links the export has not been read and this risk is not
  closed" is false from `nozoki@129586e`. R-15 says instead that the build that links the export
  has been read and passes both halves, and points at C-I3's transport-read sentences for the
  measurement, as it does now (§ 5.1's answer carries the measurement).
  **Why it is not closed.** One passing build answers the question R-15 was holding open: whether
  the link drops libgit2's transports from an executable that links the export. It does not remove
  what the pass depends on. The vendored library compiles its transports whatever the features
  (§ 4 C-R6), so the pass holds for this version of `libgit2-sys`, this release link, and the
  libgit2 code the product calls today, which is the open and the status read. Each of the three
  can move in a later change, and `see-git-status` is not reached yet. So R-15 stays in § 11 as a
  standing risk held by the read on every build, and it names those three as what makes it real: a
  `libgit2-sys` version change, a change to how the release executable is built or linked, and a
  change that calls libgit2 code beyond the open and the status read.
  **Two clauses that described a moment now past.** *Shows up as* names "the first release build
  whose executable links a Git export, which is the build in which `mac-shell` first calls
  `nozoki_read_git`". That build was read and was not red. The clause now reads: the `nm` read
  turning red on any release build. *Response* reads "a re-cut recorded in § 10 before anything
  is built on that export". The Git view is built on it from `nozoki@129586e`. The response keeps
  its substance and names a moment that can still be met: the change whose build turns the read
  red does not land until the re-cut is recorded in § 10. The last two sentences of R-15, on
  whose call it is to state the claim lower (`docs/fdr.md` PD-27), stay word for word.
  **What this answer does not cover.** The read ran on the owner's machine and on no hosted
  runner (§ 5.1's answer, addition 2). R-15 says that the pass is a local one until CI has run it.
  Reasoning: `docs/trail/sdd/self_answer-40.md`.

**How it closes.** `product-sdd` folds these on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.

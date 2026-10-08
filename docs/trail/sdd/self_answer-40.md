# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v32, Settled)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-04
- **Sources re-read:** None. Both answers rest on measurements this run made on the product's own
  tree and on the executable it built. Neither rests on a source outside this repository. The
  SDD's statements about libgit2's own source (§ 4 C-R6, "the vendored libgit2 compiles its
  transports and its streams whatever the features") were not re-read at the registry copy: the
  answers take that sentence as the SDD states it and say so where they lean on it.

**What this run read, and what it did not.** `docs/SDD.md` was not read whole. It is 5,825 lines.
This run read the header and version lines, § 4 C-R6's transport sentences (`:L626-L653`), § 4
C-I3 from its head to the bundle probe (`:L730-L804`), § 10 RC-4 (`:L2640-L2684`), § 11 R-14's
tail to R-16 (`:L2794-L2840`) and *Open Questions* whole (`:L5720-L5825`). It searched the rest
for `ka_reader_read_git`, `R-15`, `C-I3`, `no Swift source`, `has not met`, `has not been read`,
`not closed` and `first calls`. A sentence elsewhere that states either claim in other words was
not seen. `docs/PRD.md`, `docs/SRS.md` and `docs/UXD.md` were not opened: the answers move no
requirement and no experience entry. `docs/nfdr.md` was read at QC-3 (`:L158-L178`) and at
`:L4410-L4420`, and searched for `R-15`. `docs/architecture_open_issues.md` was read whole.

**What this run measured.** The tree outside `docs/` at the commit this run started from,
`ka-reader@cfcbedf`, is the tree at `ka-reader@129586e`: `git diff --quiet 129586e HEAD -- . ':!docs'`
exits 0.

- `ka-reader-mac/Sources/KAReader/NativeBridge.swift:L26` reads `adopt(ka_reader_read_git())`.
- `ka-reader-mac/assemble.sh` exits 0 and writes
  `target/release/bundle/macos/KA-Reader.app/Contents/MacOS/KAReader`.
- `checks/view.sh` exits 0 on that executable and prints "38 Swift files scanned under
  ka-reader-mac/Sources, … links no WebKit or JavaScriptCore and carries no Git transport — nothing
  found". It was run twice: on the executable found on disk, and on the one this run rebuilt.
- `nm` on the executable prints `T _ka_reader_read_git`, `T _git_repository_open_ext` and
  `T _git_status_list_new`.
- `nm … | awk 'NF==3 && $2!="U" && $3 ~ /^_git_/' | wc -l` prints 781.
- `nm … | grep -c 'git_smart_subtransport_'` prints 0.
- `nm -u … | grep -E '^_(connect|socket|getaddrinfo)$'` prints nothing.
- `nm` prints `_git_socket_stream_global_init`, `_git_stream_registry_global_init` and
  `_git_transport_ssh_libssh2_global_init`, each as a local defined symbol (`t`).
- `git status -sb` prints `main...origin/main [ahead 214]`. `gh run list --commit 129586e` prints
  nothing, and the newest run `gh run list` shows is dated 2026-10-02.
- `checks/tests/test_view.sh` was not run.

## Items worked

### 5.1 — § 4 C-I3 says the `nm` read has not met an executable that links `ka_reader_read_git`; it has, and it passes

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item carries a lean ("The likely fold: the read has met the executable that links
  the export, from `ka-reader@129586e`, and passed"), so it was weighed as a draft. The draft holds,
  and four things are added to it.

  **Whose it is.** The item's `Seat:` is `cto`. The change lands in `docs/SDD.md` alone, in § 4
  C-I3, which is the CTO's lane. It commits nobody outside the document: it replaces a statement
  about a measurement with the measurement.

  **Not a widening.** The item asks the SDD to correct two sentences that are now false. It asks
  for no new case, form or requirement. The rule that a widening item waits until it occurs does
  not apply.

  **Is the draft sound.** The PM's measurement was not taken on trust. This run rebuilt the bundle
  and re-ran the read, and the list above is what it printed. Each of the PM's three claims holds:
  the shell calls the export, the executable defines `_ka_reader_read_git`, and `checks/view.sh`
  exits 0. So C-I3's sentences at `docs/SDD.md:L771-L775` are false from `ka-reader@129586e`, and the
  draft's replacement is true.

  **The four additions.**
  1. *The measurement itself.* The draft says "passed" and gives no figures. C-I3 gives figures
     for the earlier executable (781 defined `_git_` symbols, the two libgit2 symbols, no
     transport symbol, no import of the three calls; `docs/SDD.md:L767-L770`). The answer gives
     the same figures for the new one, so the fold does not have to choose between restating the
     old figures as if they were re-read and stating none.
  2. *Where the read ran.* C-I3's headline is "proved on every build". This read ran on the
     owner's machine. `main` is 214 commits ahead of `origin/main`, so no hosted runner has built
     `ka-reader@129586e`. The earlier measurement C-I3 carries was local too
     (`docs/SDD.md:L764-L766` cites `docs/trail/sdd/self_answer-38.md`), so this is the same
     kind of evidence, and the answer asks C-I3 to say so.
  3. *C-R6 points here.* C-R6 names three defined symbols the read's pattern does not match and
     says they were read on "the executable C-I3's transport-read sentences name"
     (`docs/SDD.md:L641-L645`). Once C-I3 names a different executable, that sentence is a claim
     about the new one. It was checked: all three are still defined, and none of the three
     imports is present. The item did not mention C-R6. Without this addition the fold would
     leave C-R6 asserting a read nobody made.
  4. *What stays scoped.* "The claim is proved for one executable" (`docs/SDD.md:L764`) is the
     sentence that keeps a pass from reading as a property of the product. The answer keeps that
     form.

  **Against the settled record.** § 10 RC-4's *Still unresolved* ties the `nm` read to the first
  export that reaches `git-reader` and makes no claim about the calling build
  (`docs/SDD.md:L2668-L2679`), so it does not move. *Open Questions*' config-named-path item
  carries "Until the shell calls the export the bundle opens no repository" inside a dated note
  that the next note already marks as describing an earlier tree (`docs/SDD.md:L5812-L5815`), so
  it does not move either. § 11 R-16 says "From the first build in which `mac-shell` calls
  `ka_reader_read_git` until that item is settled" (`docs/SDD.md:L2833-L2834`), which is still true
  now that the build exists. `docs/nfdr.md` QC-3 repeats C-I3's two sentences
  (`docs/nfdr.md:L164-L167`); that is already carried at `docs/architecture_open_issues.md`
  § 3.1.

  **On the failure paths.**
  - *Empty:* an `nm` that prints no symbol is a red read by the script's own rule
    (`checks/view.sh`, header: "It never passes having read nothing"). The pass above read 781
    `_git_` symbols.
  - *Absent:* the hosted runner's read of this build does not exist. Addition 2 states it.
  - *Stale:* the pass is a fact about one executable. A later build is read again by the same
    script, and addition 4 keeps the sentence that says so.
  - *Concurrent:* not reached. A read of one file by one script.
  - *Refused:* a red read is § 11 R-15's, which § 5.2 answers.

  **What would have tipped it.** Had the rebuild gone red, or had `nm` shown no
  `_ka_reader_read_git`, this would have been an override: the item's premise would be false and
  C-I3 would stand. Had the item asked C-I3 to stop scoping the claim to an executable, that half
  would have been refused.

### 5.2 — § 11 R-15 says the build that links the export has not been read; it has been read, and it passes

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** The item gives no lean on its real question ("Whether R-15 closes on one passing build
  or is kept is the CTO's call"), so it was answered from scratch. R-15 is kept, its false
  sentence is corrected, and two clauses that describe a moment now past are restated.

  **Two questions, one seat.** The item holds a correction (the sentence is false) and a decision
  (close or keep). Both land in § 11 R-15 and both are the CTO's, so both are answered in the one
  slot. It was asked whether close-or-keep is the owner's, because R-15 guards a product
  decision: `docs/fdr.md` PD-27, "Nothing the product ships carries a network transport", as
  R-15 quotes it (`docs/SDD.md:L2813-L2814`). It is not. Lowering that claim is the owner's, and
  R-15 already says so. Whether a technical risk stays listed in § 11 changes no claim and binds
  nobody, and keeping it is the choice that leaves the owner's promise guarded.

  **Not a widening.** The correction replaces a false sentence. The restated clauses replace two
  that name a build already past.

  **Why kept.** § 11's own rule is "A risk with no trigger and no response is an observation"
  (`docs/SDD.md:L2688-L2689`). R-15 still has both. The pass rests on the linker leaving out
  transport code that the vendored library compiles whatever the features (§ 4 C-R6,
  `docs/SDD.md:L626-L631`). That outcome depends on three things that later changes can move: the
  `libgit2-sys` version, how the release executable is built and linked, and which libgit2 code
  the product calls. Today it calls the open and the status read; the SDD's § 3 `GitState` says
  "Three things this entity lists are still the design and are in no landed change: the history
  window and the `Diff`" (`docs/SDD.md:L491-L492`). So one passing build closes the question
  "has the build that links the export been read", and leaves the risk. The `nm` read on every
  build is what holds it.

  **Why the two clauses move.** *Shows up as* names one build: "the first release build whose
  executable links a Git export, which is the build in which `mac-shell` first calls
  `ka_reader_read_git`" (`docs/SDD.md:L2808-L2809`). That build has been read and was not red, so a
  reader would take the clause to mean the risk can no longer show up. *Response* says "a re-cut
  recorded in § 10 before anything is built on that export" (`docs/SDD.md:L2811`). The Git view
  is built on the export from `ka-reader@129586e`, so that moment cannot be met again. The answer
  keeps the response's substance, a re-cut recorded before the work goes on, and ties it to a
  moment that still exists: the change whose build turns the read red does not land until the
  re-cut is recorded. This is the part of the answer nearest to drafting the SDD's words. The
  fold may word it differently. What it may not do is leave a response that names a moment
  already past.

  **Against the settled record.** § 5.1's answer and this one were decided in order and agree:
  § 5.1 puts the measurement in C-I3, and this one points R-15 at it. R-15's last two sentences
  (`docs/SDD.md:L2812-L2814`) are not touched. `docs/nfdr.md` QC-3 quotes the old response
  (`docs/nfdr.md:L170-L171`), which goes stale once the SDD folds this answer. That is the
  Principal Architect's record, and it is carried on that seat's companion (below).
  `docs/nfdr.md:L4416-L4418` says QC-3's sentence about the calling build "stays" because SDD
  RN-92 named R-15 as unmoved. That was true of the v32 fold and is a dated note.

  **On the failure paths.**
  - *Empty:* not reached. R-15 is a statement about a read that § 5.1 shows is not empty.
  - *Absent:* no hosted runner has read the build. The answer asks R-15 to say that the pass is
    a local one until CI has run it. A red read on the runner is R-15 firing, with its response.
  - *Stale:* this is the case the answer is built on. The pass is true of one executable and goes
    stale with any of the three changes named. Keeping the risk is what covers it.
  - *Concurrent:* not reached.
  - *Refused:* the read goes red. The restated response says what happens then. If the build
    cannot be changed so the claim holds, R-15's last sentences already send the claim to the
    owner.

  **What would have tipped it.** If the pass depended on nothing a later change can move, for
  example a library built with no transport code in it at all, R-15 would close on this build.
  C-R6 says the opposite of the vendored library, so it stays.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

- **`docs/architecture_open_issues.md`** — **updated** — companion to `adr/` and `nfdr.md`, item
  `3.1`, which previously read `"…The SDD's own sentence (§ 4 C-I3) is raised on
  docs/SDD_open_issues.md § 5.1; QC-3 re-derives from it."` as the end of its *Where it shows*
  field, landed in commit `f3aa266`

**What was added, and why.** Item 3.1 was open, with its **Answer** slot at its placeholder, and
it is the item about QC-3 and the transport read. It named one stale passage of QC-3, the one
that repeats C-I3. QC-3 also quotes R-15's response (`docs/nfdr.md:L170-L171`), and § 5.2's answer
asks the SDD to restate that response. So the same item now names both passages. A second item
would have asked the Principal Architect the same question twice. The added passage says in the
file which run wrote it. Nothing else in that file moved, and its two slots are still empty.

**One doubt, also written in that item.** The added passage is owed only after `product-sdd`
folds § 5.2. Until then QC-3 quotes R-15 as R-15 reads. If the records' round runs first, that
half of item 3.1 should stay open.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
- **`adr/` and `nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`

# Self-answer report — CONTENT.md

## Header

- **Companion:** `docs/CONTENT_open_issues.md`
- **Document:** `docs/CONTENT.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-10
- **Sources re-read:** None. Every answer rests on files in this repository, read at `ka-reader@7c50f78` (the code under `ka-reader-mac/` and `crates/` is unchanged since `7a88215`, which the item cites).

## Items worked

### 3.1 — The beta's unexplained-fault sentence names "this repository" when the stop came before any repository was found

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the verbal language
- **Verdict:** answered
- **Why:**
  - **Check 1 — the item is this document's, in the owner's seat.** The edit lands in § Message patterns, Error. It commits no person, money, legal position or outside party. Whether the Git view has a failure slot for this stop is already settled (`docs/UXD.md` UX-I16, the item that stopped); only the words are open, and words are this seat's.
  - **Check 2 — no draft; the question is sound with one narrowing.** The item says the stop came "before any repository was found". The code is more exact: the open-time probe's `RepositoryReadFailed` is "Git refused a `.git` folder the probe could look inside" (`crates/ka-reader-core/src/git_reader.rs:L341-L342`). A `.git` folder was seen; no repository was established, because Git refused it. The defect is the same and the right test is "before KA-Reader had established a repository", not "before a `.git` folder was seen". The answer is written to that test.
  - **The item widens the document, so the widening rule was applied and an occurrence is cited.** CONTENT states no case for a stop during root finding. The item cites a site in the product: the catalogue returns the one repository sentence for `.probeRepositoryReadFailed` (`ka-reader-mac/Sources/Surfaces/GitSentences.swift:L94-L96`), and I re-read that line. Reachability is measured: a `.git/config` holding `bare = = nonsense` makes the probe answer `RootFinding::Failed(ProbeCondition::RepositoryReadFailed)` (`crates/ka-reader-core/tests/root_finding.rs:L502-L513`). So the beta form is taken.
  - **Check 3 — the document's own rules point the same way.** § Message patterns' first formula says a message states what KA-Reader actually read (`docs/CONTENT.md:L76`). § Terminology narrowed *repository* to "a folder that is the root of a Git repository" because using it for a folder not shown to be one "made a folder without Git read as a refusal" (`docs/CONTENT.md:L181-L182`). The product's own pre-repository sentences already hold the line: the catalogue says "find out whether it's a repository" (`GitSentences.swift:L78-L80`) and "found no repository there" (`:L89-L91`), and names the Git directory where that is what it read. The fault sentence is the one pre-repository stop that still says *this repository*. "The folder you opened" is the term for the input (`docs/CONTENT.md:L181`), so the draft names no repository and does not say *this folder*.
  - **Check 3 — the lock example does not contradict this.** `docs/CONTENT.md:L282-L289` says *this repository's Git status* where `.git/index.lock` was observed. A lock file inside a `.git` folder was read there, so the repository was established. The answer's rule is the same test applied both ways.
  - **Check 4 — failure paths.**
    - Empty: a folder with no `.git` entry is not this class. It takes the observed-condition sentences, so nothing changes there.
    - Absent or refused: a `.git` entry that is unreadable or not a directory is observed, and keeps its own sentences.
    - Stale: the draft says *When you opened the folder*, which stays true after the folder changes.
    - Concurrent: a stop in the later status read, after the probe succeeded, comes after a repository was established at open. It keeps the existing example. If the folder changed between probe and read, *this repository* still names what the probe found when the folder was opened.
    - Not covered: I did not decide `.notARoot` and `.machineConfigNotSwitchedOff`, which the catalogue also maps to the fault (`GitSentences.swift:L94-L95`). I did not trace when either is produced, and the item cites no occurrence for them.
  - **The day Git state follows the disk: not until it occurs.** The item also asks for that day's form. No product behaviour draws it, and whether root finding runs again then is not decided in any document I read. The item cites no site for it, so by the widening rule it is answered "not until it occurs". The beta sentence is valid until the beta statement is retired, and that retirement is when the day form is written.
  - **Close to a different verdict:** "the beta example already covers it" would have been the confirm-nothing answer. It fails on the two points above: § Terminology's reason for narrowing *repository*, and the product's other pre-repository sentences. The count of sentences that avoid the word argues for a rule rather than a one-off.
- **Answer written:** the stop before a repository is established gets its own whole sentence in the beta, with a draft wording; the rule is that *this repository* appears in an unexplained-fault sentence only after a repository was established; the day form is not until it occurs. The wording is a draft for the fold to finalise against § Terminology and § Localization.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/CONTENT.md** — `<CORE>/launchers/skill/launcher.sh product-content ka-reader`

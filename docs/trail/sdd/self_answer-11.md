# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-19
- **Sources re-read:** None. The answer rests on the SDD, the NFDR and the product tree at
  `ka-reader@422f6d1`, all in this repository. It rests on no claim about Tauri's capability or
  protocol mechanics. Where the asset scheme is granted is left to S-3, which is where the third
  *Open Question* already settles it.

## Items worked

### 5.1 — C-R7 and SM-4 state the whole command list as the grant, while the slices grant it one command at a time

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item sits in a *Raised from downstream* section and carries the PM's lean, so the run
  weighed the lean as a draft.

  *Seat.* The edit lands in `SDD.md` § 4 C-R7 and § 3 SM-4. The answer commits nothing to a person
  or an outside party, and it moves no member of the owner-confirmed 1.0.0 contract. So it is this
  document's to answer, in the owner's seat. It is not a widening waiting for an occurrence. It
  corrects a contradiction inside the SDD, and it cites an occurrence: the built tree.

  *The draft holds, and for the reason it gives.* The SDD's own slice bars stage the grant. S-2
  (`SDD.md:L1117`), S-3 (`L1185`) and S-6 (`L1368`) put their command "on SM-4's list and in the
  capability file" in the slice that builds it. S-8 (`L1487`), S-9 (`L1540`) and S-10 (`L1591`)
  say theirs "joins" the list. S-11 (`L1663`, `L1671`) checks for "SM-4's eight commands" at
  `v1.0.0`. So "exactly SM-4's command list" in C-R7 (`L486-L488`) is the sentence the slices
  contradict, and no build before the last slice could meet it. Measured: the tree grants
  `allow-open-folder` and `allow-list-tree` and nothing else
  (`crates/ka-reader-app/capabilities/main.json:L5`). Its config test holds set equality against those
  two (`crates/ka-reader-app/tests/config.rs:L231-L234`).

  *The PM's doubt resolves into the lean.* The alternative was that "exactly the whole list" was
  meant only for 1.0.0. At 1.0.0 the two readings give the same list, because S-11 and C-I6 already
  require all eight commands in the capability file and pin them. Before 1.0.0 only the staged
  reading can be met. So one sentence covers both: the grant follows the landed slices, and from
  `v1.0.0` it is SM-4's list whole.

  *Addition 1: C-I3 takes the same staging.* The item cites C-I3's "exercises every command on
  SM-4's list" (`L512`), but its "what is owed" names only C-R7 and SM-4. If C-I3 is left as it is,
  the fold is half done: on an S-1 build, `read-only.sh` would be required to exercise commands that
  do not exist. C-I3's own *Violated by*, "a slice that lands a command the harness does not
  exercise", already reads staged. The fix is "every command the build grants".

  *Addition 2: equality against what is registered, not a copy.* This came from check 4. Stale case:
  the tree's test holds a hand-kept constant beside the capability file (`config.rs:L231-L234`).
  That is a second list that can drift from the commands the host actually registers. Refused case:
  a slice task that is deferred leaves its command unregistered. Concurrent case: two slices on
  separate branches each add a command, and the merged tree has to hold their union. All three are
  closed by one rule. The grant equals the set the host registers, and that set is checked to be
  inside SM-4's list. How the test reads the registered set is the tech lead's to plan. That the
  test reads it is the SDD's rule to state.

  *Addition 3: one uncovered case, named.* Before `v1.0.0`, suppose a later change stops
  registering a command an earlier slice built. The staged check passes, because grant and
  registration move together. Only that earlier slice's bar holds the command, and C-I6's pin does
  not exist yet (`L562-L563`). That fits C-6's pre-1.0.0 half, which C-I6 states rather than tests.
  It is recorded so nobody reads the staged check as covering it.

  *The asset-scheme half.* It is keyed on C-R7's state, as NFDR QC-23 already keys the CSP half
  (`nfdr.md:L188-L200`). The scheme enters the grant in the slice that settles its origin form (S-3,
  `L1185-L1188`), and not before. The answer does not say whether a Tauri capability file or the
  protocol registration is where the scheme is granted. The third *Open Question* asks exactly that
  (`L2591-L2594`), and the answer would otherwise rest on a vendor claim this run did not re-read.

  *Check 3, downstream.* `architecture_open_issues.md` § 3.1 asks for NFDR QC-24's check "re-derived
  from whatever C-R7 settles in … § 5.1", with a lean the same as this answer's. It needs no update,
  so no companion was touched. RN-38's "`read-only.sh` exercises whatever SM-4 lists" (`L2410`) is
  consistent with the staged reading and needs no change.

  *What would have tipped it.* The verdict would have been **left for the owner** if staging the
  grant moved a member of the priced 1.0.0 contract. It does not: the contract binds from the `.0.0`
  tag (C-I6), and the staged sentence names that tag as the point where the whole list binds.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-sdd/launcher.sh ka-reader`

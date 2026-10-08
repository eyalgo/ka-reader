# PRD open issues — ka-reader

> Companion to `PRD.md`. The CPO authored the PRD non-interactively; this file holds
> what it could not settle from the inputs. **Answer inline** — fill each **Answer** /
> **Confirm-or-override** slot — **commit this file**, then re-run `product-prd`. It folds
> your answers into the PRD and drops the resolved items. When nothing is left unresolved,
> `product-prd` clears this file: no file = the PRD is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CPO folds them in, it first copies
> this file whole to `docs/prd_trail/` — so what you decided, and why, stays readable
> and citable for good.

---

## 1. Open issues — product-defining questions with no answer yet

None this cycle — every unsettled call carried a defensible lean, so each is listed under §2 as
a choice to confirm.

## 2. Choices to confirm — the CPO drafted a best-effort answer; confirm or override

### 2.1 Who the product is for — and the scenario that drives it
- **Drafted into the PRD:** Target Users = developers inspecting a local repository they don't
  want to risk touching; the driving scenario is peeking at a working tree an automated tool or
  coding agent is actively changing.
- **Rationale:** the input names no user at all. The inspection-not-authoring goal implies a
  developer; the agent-tree scenario is the input's own future note ("front end for agent
  workflows") pulled forward, because it is the one scenario where the no-write guarantee is
  clearly indispensable rather than merely nice.
- **Confirm or override:** **Confirmed — with one addition that changes v1 scope.** Developers, and
  the agent-actively-changing tree stays the driving scenario. But v1 as drafted could not serve
  it: nothing in Core Features re-reads the tree or Git state, so the user would be watching a
  stale snapshot of a tree that had already moved. **Live refresh is therefore in v1.** It is
  automatic — a change on disk appears in the view without the user doing anything — because the
  scenario is watching progress, and a manual refresh button turns the user into a poller. Widen
  Core Features and Scope (In) accordingly, and see 2.4 for the bar that now measures it.

### 2.2 Run & distribution posture — local-only, one local Git repo, clone-and-run v1
- **Drafted into the PRD:** a local tool the user launches on their own machine against a single
  local Git repository; acquired clone-and-run from the public repository in v1 (packaged
  distribution decided later); nothing about its operation leaves the machine; no hosted mode.
- **Rationale:** the input calls it a "desktop-style web application" showing local repository
  status but never states how it runs against a repository or how a stranger acquires it.
  Local-only fits that frame and the instance's no-network commitment; clone-and-run is the
  smallest v1 distribution. The mechanism by which the app reaches files and Git state is
  downstream — this settles only what the product *is*.
- **Confirm or override:** **Confirmed on what is product; the acquisition mechanism is struck as
  not the PRD's to settle.**
  - **Confirmed:** ka-reader is local — it runs on the user's own machine, against one repository at a
    time; nothing about its operation leaves the machine; there is no hosted mode.
  - **One repository at a time is a v1 cut, not a permanent property.** **Switching which
    repository you are looking at — picking a different one from inside the product — is a named
    future direction.** Still one at a time, never several at once: the change is that the choice
    becomes revisitable without restarting. Put it in the ambition paragraph in Scope (In) beside
    diffs, history and search, and make sure Out of Scope reads as *"changing repository without
    restarting — beyond v1"* rather than leaving "single local Git repository" sounding permanent.
    Recorded here so the SRS knows v1 must not design the single repository in so deeply that
    switching becomes a rewrite.
  - **Struck:** *how* ka-reader is obtained and started — clone-and-run, a package, an installed
    build. **That is a CTO call and belongs to the SRS, not the PRD.** Remove the clone-and-run
    sentence from Scope (In) rather than replacing it with a different mechanism.
  - **What the PRD keeps instead, as a product property:** there is **exactly one** way to get and
    start ka-reader, and it is simple. One path, not a menu of them — a stranger should not have to
    choose how to install a viewer. How that is achieved is the CTO's; that it must be single and
    simple is the product's, and the time-to-first-success bar in 2.4 is what measures it.
  - Note for the SRS, not a product decision: the drafted clone-and-run shape sits in tension with
    that bar and with the "pick-it-up adoption" goal, since it asks for a toolchain, a clone, a
    dependency install and a run. Flagging the tension, not resolving it here.

### 2.3 The read-only promise widened to the whole product
- **Drafted into the PRD:** the product never writes to the repository — working tree or Git
  state — and a single violation is a release-blocking defect. This is a departure: the input
  said "strictly read-only" of the *editor area*; I widened it to the whole product.
- **Rationale:** a read-only editor inside a tool that still touches the repository elsewhere
  breaks the promise the product is named for. The guarantee is only a product edge if it is
  absolute — and "read-only" needed a definition either way (principle: a load-bearing concept
  must resolve).
- **Confirm or override:** **Confirmed — and make the boundary explicit.** The whole-product scope
  is right: a read-only editor inside a tool that still touches the repository elsewhere is a
  setting, not a promise. State the promises separately rather than naming one and implying the
  rest — no write to the working tree, no Git mutation (no checkout, stash, index or commit
  operation), no telemetry, no non-essential network call.
  **Where the line falls:** ka-reader writes nothing *into the repository it is pointed at*, under any
  operation. It may keep its own state — preferences, window state, anything it remembers between
  sessions — and that lives wherever it keeps its own data on the machine, never inside the
  repository. Say this in the PRD; leaving it implicit is how a stranger discovers a promise that
  was never made.

### 2.4 Success bars
- **Drafted into the PRD:** time-to-first-success ≤ 5 minutes (fresh machine, README only),
  checked before each release; zero-required-configuration as pass/fail per release;
  file-switch immediacy threshold TBD, tracked from the first working build.
- **Rationale:** the input carries no success measure. The 5-minute value operationalizes the
  domain's time-to-first-success framing at a level a clone-and-run tool should comfortably
  make; it is a starting bar to tighten with evidence, not a law.
- **Confirm or override:** **Confirmed — with one restatement and one addition.**
  - **Restate time-to-first-success without naming a mechanism (2.2):** measure from a stranger
    deciding to try ka-reader, by whatever its single install path turns out to be, to viewing a file
    of their own repository. "Fresh machine, README only" presumed clone-and-run; the bar should
    outlive whatever the CTO picks. ≤ 5 minutes stands.
  - **Add a refresh bar.** Refresh is in v1 (2.1) and the driving scenario is watching a tree that
    something else is changing, yet no metric measures whether the view keeps up. Add: a change on
    disk appears in the view within a few seconds, with no user action. Without it, the scenario
    chosen as the product's driver is the one part with no success measure.
  - **Zero required configuration:** confirmed, pass/fail per release.
  - **Numbers stay TBD** for file-switch immediacy and for refresh latency, both tracked from the
    first working build. A threshold invented before there is a build to measure is noise.

### 2.5 Licence — MIT
- **Drafted into the PRD:** MIT, recorded with its reason at first release.
- **Rationale:** a licence must be chosen at first release — a public repo with no licence is
  not open source. MIT is the smallest, most widely recognized permissive licence. Apache-2.0's
  added value is its express patent grant, and a small local viewer has minimal patent-sensitive
  surface; copyleft would serve a downstream-source-freedom goal this product doesn't claim.
- **Confirm or override:** **Confirmed — MIT.** The reasoning holds: a local read-only viewer has
  essentially no patent-sensitive surface, so Apache-2.0's express patent grant buys little here,
  and copyleft would serve a goal ka-reader does not claim. **The code is open-sourced**, and nothing
  about how it is distributed (2.2) changes that.
  Not a PRD call, recorded so it is not lost: whatever ka-reader ships as, it will bundle third-party
  components whose licences ride along — the release has to carry their notices. That is a release
  obligation for the SRS/SDD, not a product property.

## 3. Directives — an external action the owner confirms as a gate

None this cycle.

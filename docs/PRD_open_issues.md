# PRD open issues — nozoki

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
- **Confirm or override:**

### 2.2 Run & distribution posture — local-only, one local Git repo, clone-and-run v1
- **Drafted into the PRD:** a local tool the user launches on their own machine against a single
  local Git repository; acquired clone-and-run from the public repository in v1 (packaged
  distribution decided later); nothing about its operation leaves the machine; no hosted mode.
- **Rationale:** the input calls it a "desktop-style web application" showing local repository
  status but never states how it runs against a repository or how a stranger acquires it.
  Local-only fits that frame and the instance's no-network commitment; clone-and-run is the
  smallest v1 distribution. The mechanism by which the app reaches files and Git state is
  downstream — this settles only what the product *is*.
- **Confirm or override:**

### 2.3 The read-only promise widened to the whole product
- **Drafted into the PRD:** the product never writes to the repository — working tree or Git
  state — and a single violation is a release-blocking defect. This is a departure: the input
  said "strictly read-only" of the *editor area*; I widened it to the whole product.
- **Rationale:** a read-only editor inside a tool that still touches the repository elsewhere
  breaks the promise the product is named for. The guarantee is only a product edge if it is
  absolute — and "read-only" needed a definition either way (principle: a load-bearing concept
  must resolve).
- **Confirm or override:**

### 2.4 Success bars
- **Drafted into the PRD:** time-to-first-success ≤ 5 minutes (fresh machine, README only),
  checked before each release; zero-required-configuration as pass/fail per release;
  file-switch immediacy threshold TBD, tracked from the first working build.
- **Rationale:** the input carries no success measure. The 5-minute value operationalizes the
  domain's time-to-first-success framing at a level a clone-and-run tool should comfortably
  make; it is a starting bar to tighten with evidence, not a law.
- **Confirm or override:**

### 2.5 Licence — MIT
- **Drafted into the PRD:** MIT, recorded with its reason at first release.
- **Rationale:** a licence must be chosen at first release — a public repo with no licence is
  not open source. MIT is the smallest, most widely recognized permissive licence. Apache-2.0's
  added value is its express patent grant, and a small local viewer has minimal patent-sensitive
  surface; copyleft would serve a downstream-source-freedom goal this product doesn't claim.
- **Confirm or override:**

## 3. Directives — an external action the owner confirms as a gate

None this cycle.

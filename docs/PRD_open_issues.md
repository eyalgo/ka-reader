# PRD open issues — Nozoki 覗き

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

> **This round is the re-authoring pass you asked for** (`prd_trail/cycle-6.md` §2.1). The
> blurb is written, and the wording repairs that move no product fact are made in v7. What
> follows is everything the current bar would settle differently from the PRD on disk, or
> asks that the PRD never answered — each with what the PRD says now and what the bar would
> say instead. **Nothing below has been edited into the PRD**: every item that moves a product
> fact waits for you, as instructed.

---

## 1. Open issues — product-defining questions with no answer yet

### 1.1 Under what public identity is Nozoki published?
- **Why it matters:** the PRD commits the product to a public release under MIT with a README
  that is its front door, and to a support posture and a security-reporting channel that a
  stranger will address to *someone*. Whose account the repository sits under, and what name
  the maintainer answers to, is a product fact every one of those promises presupposes — and
  no input, no trail answer, and no PRD section states it. A product that publishes acts under
  an identity, chosen or defaulted; this one is currently defaulted.
- **Reasoning / what would settle it:** a one-line decision — the account (personal or an
  organisation) and the name the tool is maintained under. No lean offered: the choice is
  about you, not the product, and I have no basis to pick between a personal handle and an
  organisation. Once answered it lands in Assumptions beside the licence, and the two `[OPEN]`
  lines in Open Questions collapse to one or none.
- **Answer:** kensaiapp — the repository sits under the `kensaiapp` GitHub organisation
  (already true on disk: `git@github.com:kensaiapp/nozoki.git`), and `kensaiapp` is also the name
  the tool is maintained under. No personal handle is the public face.

### 1.2 Which platforms does v1 promise to run on?
- **Why it matters:** the PRD promises a stranger *one* supported install path and a
  time-to-first-success bar measured through it. A supported path is supported *somewhere*;
  which operating systems that somewhere includes is the part of the promise a stranger reads
  first and the PRD never states. The acquisition mechanism was rightly struck as the CTO's
  (`prd_trail/cycle-1.md` §2.2); the platforms the promise covers are not the mechanism, they
  are the promise's reach.
- **Reasoning / what would settle it:** the honest constraint is maintainer time, which the PRD
  already names as the cost side. Three platforms is three times the support surface; one is a
  narrower promise but a truthful one. No lean offered — this is a capacity call only you can
  make. Whatever you answer becomes a line in Scope (In) and a bound in Out of Scope, and the
  time-to-first-success check is run on each platform promised.
- **Answer:** macOS. v1 promises macOS and nothing else — Linux and Windows are out of
  scope for v1, stated as an exclusion rather than left unmentioned. The time-to-first-success
  bar is measured on macOS.

## 2. Choices to confirm — the CPO drafted a best-effort answer; confirm or override

### 2.1 UI language: English — now routed, was defaulted
- **Drafted into the PRD:** unchanged in substance — UX Notes, "The bounds v1 draws": *UI
  language: English*. The tag is repaired from "defaulted, not routed" to *(added — not in the
  input)*, because with this item it is routed.
- **Rationale:** the bar names language and locale as the near-universal that must be a choice,
  never a silent default (principle 5). The PRD on disk admitted in its own tag that it had
  defaulted. English is the right lean: the instance's products and their documentation are
  English-first, and a second UI language is a maintained surface the product has no reason to
  carry. Cycle 4 listed the bullet among the seven the re-authoring could keep, which is not a
  confirmation of it.
- **Confirm or override:** confirm

### 2.2 Rich rendering of non-text content is beyond v1 — an exclusion that was never confirmed
- **Drafted into the PRD:** unchanged in substance — UX Notes already said a binary file lands in
  a cannot-display-as-text state and that rich rendering "is not part of v1's proof". v7 mirrors
  that as an Out of Scope line so the exclusion is findable where exclusions live, tagged
  *(added — not in the input)*.
- **Rationale:** a scope exclusion the CPO authored is a decision, not a settled fact
  (principle 4), and this one was written in the cycle-4 re-authoring and never listed for you.
  The lean holds: the input's scope is code viewing, and image or document rendering is a
  product widening with its own maintenance cost.
- **Confirm or override:** confirm — rich rendering of non-text content is beyond v1.

### 2.3 The network promise: "no non-essential network call" or "no network call during operation"
- **Drafted into the PRD:** unchanged — Success Metrics, Out of Scope and Data & Privacy all say
  *no non-essential network call*.
- **Rationale:** the PRD leans on a concept it never defines: what network call could be
  *essential* to a local tool whose "operation stays entirely on the user's machine" (Data &
  Privacy)? The PRD's own sentence leaves none, and the phrase is the instance doctrine's floor
  (`system/doctrine/kensaiapp_doctrine.md`, telemetry section), not a product statement. A
  load-bearing concept must resolve (principle 8). **The lean is to tighten:** *no network call
  during operation — none; acquiring the tool uses the network, operating it never does.* That
  is a stronger promise than the PRD makes today, which is why it is yours: it moves the bar the
  read-only integrity metric is reckoned against. The project's Agari quotes the current
  wording; a tighter PRD promise sits inside it, not against it.
- **Confirm or override:** override — do not tighten. The wording stays *no non-essential
  network call*. The "essential" case is not empty after all: an update / version-check
  feature may be built in the future, and the looser phrase is what leaves room for it
  without the PRD having to be walked back. Operation still stays on the user's machine;
  what is being kept is the headroom, not a current call.

### 2.4 The support posture — stated, not just promised
- **Drafted into the PRD:** unchanged — Risks says a "stated support posture in the README" is a
  mitigation, and nothing in the PRD says what that posture is.
- **Rationale:** the PRD commits to one side of a relation and owes the other (principle 8): a
  posture that will be stated needs stating, and the domain doctrine scopes it *before*
  release, not after the issues arrive. **The lean:** best-effort, with no promise attached —
  issues and questions are welcome and read, with no response time and no commitment to fix;
  vulnerability reports go to a private channel and get an acknowledgement, with the expected
  response stated where the channel is; and, already in Assumptions, a version that can no
  longer be maintained is archived visibly. Confirmed, it lands in Assumptions as the support
  posture the README carries. Anything firmer than best-effort is a capacity commitment only you
  can make.
- **Confirm or override:** confirm best-effort, and state it harder than the lean does.
  The maintainer is a private individual and Nozoki is a side project, so **nothing is
  promised at all** — issues and questions are welcome and read when there is time, with
  no response time, no commitment to fix, and no commitment to a fix ever arriving. That
  applies to security reports too: a private channel exists and reports are read, but the
  acknowledgement in the lean is **not** promised and no expected response time is stated.
  A version that can no longer be maintained is archived visibly (already in Assumptions).
  The README says this plainly rather than implying more.

### 2.5 Syntax highlighting is best-effort by language; a file with no highlighter reads as plain text
- **Drafted into the PRD:** unchanged — Core Features says "read-only viewing of any file in the
  repository, with syntax highlighting", with no floor on *which* languages.
- **Rationale:** a policy that is partial in practice owes its floor and what survives the cut
  (principle 8) — no viewer highlights every language, and the PRD reads as if this one does.
  **The lean:** highlighting is offered for whatever languages the product carries, with no
  promised list in v1; a text file the product cannot highlight is shown as plain text, never
  refused and never mis-highlighted. Which languages those are is downstream; that a
  no-highlighter file is still fully readable is the product fact, and it is a new state promise,
  so it is yours to confirm before it goes into Core Features and UX Notes.
- **Confirm or override:** override — v1 does promise a floor, and it is this. Highlighting
  is promised for **every language kensaiapp currently writes in** — measured on disk today:
  Python (`.py`), shell (`.sh`) and JavaScript (`.mjs` / `.js`) — **plus JSON, YAML and
  TOML**. `.md` is not highlighted: a markdown file is **rendered by default, with a raw
  toggle** to see the source. If the toggle proves too big for v1, v1 ships rendered-only and
  the toggle waits — that fallback is the maintainer's call, not a reason to hold v1.
  For every other language there is no promise; a file the product cannot highlight is
  shown as plain text, never refused and never mis-highlighted. The list grows only when
  the maintainer needs it to — "if I need something, I will probably add".

## 3. Directives — an external action the owner confirms as a gate

None.

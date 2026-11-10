# Self-answer report — CONTENT.md

## Header

- **Companion:** `docs/CONTENT_open_issues.md`
- **Document:** `docs/CONTENT.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-10
- **Sources re-read:** In the instance repository, `system/experience/voice_restrictions.md`
  § 1 and § `one-wording-per-promise` permit tightening but prescribe literal default wording;
  `system/experience/trail/voice/cycle-1.md` § 1.1, **Answer**, is the original literal-wording
  decision. `system/experience/voice_direction.md` § 1 makes its direction replaceable and
  supplies no exception to the fence. `system/doctrine/kensaiapp_doctrine.md` § Telemetry
  states the instance default; no legal, vendor or platform claim was used in this decision.
  These were opened at their source, not inferred from CONTENT's account of them.

**Inputs read:** CONTENT Settled · PRD Settled · SRS Settled · voice restrictions Settled · voice direction Settled · writing bar Draft

This report is for the owner and the Content Manager folding the answer. It records one
wording-inheritance decision; it does not attest to the built application's network behavior.

## Items worked

### 3.1 — State how the stronger network sentence inherits the instance's fixed wording

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the verbal language
- **Verdict:** raised upstream
- **Why:** The fence needs an explicit stronger-case rule; CONTENT alone cannot supply one.
  The instance fence both permits tightening and requires its literal network sentence
  (`<the instance>/system/experience/voice_restrictions.md:L15-L19`, `:L92-L108`).
  CONTENT instead fixes "KA-Reader sends no telemetry, and it makes no network call while it
  runs — downloading it uses the network; using it does not." (`docs/CONTENT.md:L229-L235`).
  The owner explicitly selected that wording and explicitly declined the default sentence,
  not merely the weaker network permission (`docs/trail/content/cycle-1.md:L46-L66`).
  The original instance decision also explicitly required the default verbatim
  (`<the instance>/system/experience/trail/voice/cycle-1.md` § 1.1, **Answer**). Neither
  decision is silently overturned here.

  Reasoning: the item has one question with consequences in two documents, not two separable
  questions. Its decisive edit belongs in the instance's restrictions, so the verdict is
  raised upstream. Preserve the product's already-settled sentence and propose that products
  whose settled requirements forbid every operational network call may carry their stronger
  sentence instead of the generic default. Retain one wording per promise and place the
  acquisition boundary inside it. This is a wording rule proposed for the producing round;
  this run grants no network permission and enacts no fence exception.

  The framing is sound: the cited occurrence exists at `README.md:L13-L19`, and the product's
  operational prohibition and acquisition boundary are stated in `docs/PRD.md:L457-L466`
  and `docs/SRS.md:L351-L357`. This is not a speculative widening without an occurrence.
  The alternative of adding the shared sentence beside a tighter qualification was rejected
  because it would contradict the owner's explicit decision not to carry the shared sentence
  (`docs/trail/content/cycle-1.md:L46-L50`). The supporting text's silence about that prior
  explicit answer is supplied here; the existing item was not rewritten.

  Failure-path reasoning: first use, an empty folder, a missing folder, a failed read and
  concurrent file changes create no network exception under the operational prohibition
  (`docs/SRS.md:L351-L357`). Downloading remains acquisition, not operation, under the same
  requirement. A later update or version check needs a stated PRD feature and an SRS revision
  before it exists (`docs/PRD.md:L463-L466`; `docs/SRS.md:L353-L357`); it is not permission
  inferred from the generic sentence. If the instance proposal is refused, the conflict
  remains for an explicit decision; the source answer does not call it settled. If another
  run folds this source companion first, the independently committed target companion still
  carries the change. No claim of runtime verification is made by this reasoning.

  The proposed rule was written to the instance companion and its commit's file set was
  checked before this slot was filled (`kensaiapp-opensource@0a6db8eab3dbbcd3038d8bbac98f54e72fb77bca`).
  The target item stays unanswered for its next round. Its grounding also names the current
  voice-trail source location: the restriction's old `voice_trail/` locator does not resolve,
  while `system/experience/trail/voice/cycle-1.md` contains the cited answer.

## Left for the owner

None this run.

## Skipped

None this run. No filled answer slots or items addressed to another actor were present in the
source companion; its sole open item was worked (`docs/CONTENT_open_issues.md` §§ 1–3).

## Companions opened

- **system/experience/voice_restrictions_open_issues.md** — **opened** — companion to `system/experience/voice_restrictions.md`, landed in commit `0a6db8eab3dbbcd3038d8bbac98f54e72fb77bca`

The instance companion is outside the two project homes accepted by the answer launcher's
`# USAGE` contract (`<CORE>/launchers/companion-self-answer/launcher.sh:L103-L132`).
Under companion-self-answer Step 6's instance-document exception, its owed launcher is the
producer, `experience-voice`; its new item's answer slot remains at its placeholder.

## Launchers owed

- **docs/CONTENT.md** — `<CORE>/launchers/skill/launcher.sh product-content ka-reader`
- **system/experience/voice_restrictions.md** — `<CORE>/launchers/skill/launcher.sh experience-voice`

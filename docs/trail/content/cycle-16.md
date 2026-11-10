# CONTENT open issues — KA-Reader

> Companion to `CONTENT.md`. Answer inline, commit this file, then re-run `product-content`.
> The Content Manager folds the answers into the verbal language and removes resolved items;
> when nothing remains, it deletes this file. Answers are preserved whole under `docs/trail/content/`.
>
> No producing `product-content` run wrote this companion. The PM opened item 3.1 on
> 2026-11-10 because the network wording used by the README has an unsettled relation to the
> inherited wording fence. The document itself is unchanged.

## 1. Open issues

None.

## 2. Choices to confirm

None.

## 3. Raised from downstream — an item from a seat that did not write the verbal language

### 3.1 State how the stronger network sentence inherits the instance's fixed wording

- **Raised by:** PM — 2026-11-10
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** An unambiguous wording standard for the README and release text. Preserve
  the product's stronger no-network promise while resolving which wording rule applies; this item
  does not authorize a weaker promise or a job-required-network exception.
- **Where it shows:** `CONTENT.md:L229-L235` fixes the product-specific network paragraph, used
  verbatim at `README.md:L13` and `:L19`. The inherited voice restrictions, § 1 and
  `one-wording-per-promise`, permit tightening but also prescribe a literal sentence for products
  holding the instance default. They expressly cover a network-requiring departure and do not
  expressly place a stronger no-network product. The Content Manager should state how this
  product's row follows that inheritance, or raise the boundary on the instance document's own
  companion if resolving it requires the instance fence to move. The occurrence is the two
  README paragraphs, not a hypothetical future string; product meaning remains PRD Data & Privacy
  and SRS NFR-8.
- **If a document has to be written:** `CONTENT.md`, through `product-content`; any needed
  instance-fence change belongs to the Content Manager through `experience-voice` and that
  document's companion mechanism.
- **Answer:** Preserve the stronger network sentence verbatim: "KA-Reader sends no telemetry, and it makes no network call while it runs — downloading it uses the network; using it does not." The owner explicitly chose that sentence instead of the instance sentence (`docs/trail/content/cycle-1.md:L46-L66`), and the no-call requirement remains `docs/PRD.md:L457-L466` and `docs/SRS.md:L351-L357`. The literal-wording conflict belongs to the instance fence, not to a product-only reinterpretation. Its proposed stronger-case inheritance rule is now carried by `<the instance>/system/experience/voice_restrictions_open_issues.md` item 2.1, committed as `kensaiapp-opensource@0a6db8eab3dbbcd3038d8bbac98f54e72fb77bca`. That item is unanswered: do not describe the fence as already changed or the inheritance as settled. The product fold retains the stronger standing sentence and records the pending instance decision; it adds no operational network exception. Reasoning: `docs/trail/content/self_answer-14.md`.

**How it closes.** `product-content` folds this item on its next run, retaining the stronger
product promise and routing any instance-level question to its own owner.

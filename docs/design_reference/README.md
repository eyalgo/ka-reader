# Design reference

The rendered picture of Nozoki's design language: token files, twenty foundation specimens, and
(later) the component reference implementation. Open `index.html` — it is the contact sheet, and
it works with the network off.

**This is a picture, not a source.** The normative home of every token value is
`docs/DESIGN.md`, in [Google's DESIGN.md format](https://github.com/google-labs-code/design.md),
machine-linted. A value that appears both here and there is a defect of whichever copied it.

## Status: the token files here are evidence, and they are temporary

`docs/DESIGN.md` does not exist yet. Until it does, `tokens/` holds the design system's values as
they stood when they were harvested, so the specimens render and so the document that supersedes
them has something to be written *from*.

When `DESIGN.md` is authored, `scripts/design-tokens.mjs` generates `src/styles/tokens/` from it,
this folder's `tokens/` is deleted, and `styles.css` here becomes a one-line import of the
generated entry point. A second token source must not outlive its purpose.

## What is here, and what was left behind

Everything in this folder is plain HTML and CSS with no build step, no framework, and no network
access. It came from a design-system authoring tool; what that tool needs to display a library —
its card markers, its compiled component bundle, its manifest, its skill wrapper, its React
previews — did not come with it, because none of it is Nozoki.

Two rules the harvest answers to, both checked by `scripts/design-check.mjs`:

- **Nothing here reaches the network.** `SRS.md` NFR-8: the system makes no network call during
  operation, "none, not merely no non-essential", and AC-3 monitors for zero outbound traffic at
  every release. Fonts are self-hosted (see `tokens/fonts.css`) and icons are vendored
  (`third_party/lucide/`).
- **Nothing here is tooling exhaust.** A public MIT repository should read as the product and
  nothing else.

## Components

`components/` holds fifteen framework-free custom elements — `nz-button`, `nz-tree-row`,
`nz-status-letter`, `nz-commit-row`, `nz-diff-surface` and the rest — built on nothing but
`HTMLElement` and the tokens. `components/components.html` shows all of them in both themes.

They are a **reference implementation, not the product's `src/`**. Nozoki's stack is "Lit or
direct DOM" (`docs/proposal.md`) and the SDD has not chosen between them, so these are written to
the common subset: standard custom elements. If the SDD picks Lit, Lit *is* custom elements and
these survive as a base-class change; if it picks direct DOM, they already are that. Nothing here
pre-empts that decision, and none of it has been through the change pipeline.

Where the React originals tracked hover and press in component state, these use CSS `:hover` and
`:active`. Same behaviour, less machinery, and the rule stays legible in one place.

The demo page loads ES modules, which browsers refuse over `file://`. Serve the folder instead:

```
python3 -m http.server        # then open /docs/design_reference/components/components.html
```

A local server is not network egress — the no-network rule is about what the *product* does at
runtime, and nothing on these pages fetches anything.

## Specimens

The twenty files in `guidelines/` each show one foundation, and each links two stylesheets: the
tokens (`../styles.css`) and `guidelines/specimen.css`, which holds the small amount of layout the
specimens share. In the source system that layout was pasted into all twenty files; here it is
stated once.

A specimen normally reads its values through `var(--token)` so it tracks the tokens. Four do not,
deliberately: the two neutral ramps, the accent ramp, and the light syntax palette print literal
hex, because a swatch is *about* the value and must show it even when the page is in the other
theme. Each says so on the page.

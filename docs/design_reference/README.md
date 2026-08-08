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

## Specimens

The twenty files in `guidelines/` each show one foundation, and each links two stylesheets: the
tokens (`../styles.css`) and `guidelines/specimen.css`, which holds the small amount of layout the
specimens share. In the source system that layout was pasted into all twenty files; here it is
stated once.

A specimen normally reads its values through `var(--token)` so it tracks the tokens. Four do not,
deliberately: the two neutral ramps, the accent ramp, and the light syntax palette print literal
hex, because a swatch is *about* the value and must show it even when the page is in the other
theme. Each says so on the page.

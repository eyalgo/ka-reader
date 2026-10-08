# ADR-0007: The release is an ad-hoc-signed, un-notarized `.dmg` on a GitHub Release, built by CI from the tag — never Developer ID-signed

**Status:** Accepted
**Date:** 2026-09-01

## Context

There is exactly one acquisition-and-start path: no clone, no build from source, at most one
widely-available prerequisite, and a stranger reaches a viewed file within five minutes
(`docs/SRS.md` § 7 C-3; § 4.7 NFR-13). The product is published from `github.com/kensaiapp/ka-reader`
(§ 7 C-12), and the minimum macOS version is fixed with the runtime and stated wherever the install
path is offered (§ 7 C-11). The owner's standing call, for this and every app in the instance:
unsigned — "Nothing is paid for this app … no Apple Developer Program membership, now or later.
The app is **not** going into the Mac App Store; the only channel is a download from GitHub … Do
not raise signing again" — with the install mechanism handed to the CTO inside three bounds: costs
nothing, comes from GitHub, one simple path (`ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 1.1). On macOS Sequoia
a stranger can no longer Control-click to open software that is not notarized; they go through
System Settings › Privacy & Security (https://developer.apple.com/news/?id=saqachfa).

## Decision

The channel is a **GitHub Release on `github.com/kensaiapp/ka-reader` carrying `KA-Reader-<version>.dmg`
and `SHA256SUMS`, built by CI from the tagged commit and never on a maintainer's machine.** The
bundle is **ad-hoc signed** (`codesign --sign -`) — the signature that costs nothing and is what
binds the entitlements to the binary at all — and is **never Developer ID-signed or notarized**. The
install path is: download the `.dmg`, drag `KA-Reader.app` to Applications, and on first launch take
the one Privacy & Security step; the README's first screen names all three as the exact click path,
and no terminal command (`xattr`, `spctl`) is ever the documented route. A Homebrew cask is not
offered (`docs/SDD.md` § 4 C-R4; `ka-reader@70a879a:docs/SDD.md` § SDD Review Notes RN-17).

## Alternatives ruled out

- **Developer ID signing and notarization** — removes the Gatekeeper step at the cost of a paid
  membership and a signing secret in CI; ruled out by the owner for every app in the instance, and
  recorded here so the cost is stated, not so it is reopened (`ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 1.1;
  `docs/SDD.md` § 9 TO-9).
- **A Homebrew cask** — a second path, and Homebrew a prerequisite of its own: fails C-3 twice
  (`docs/SDD.md` § 4 C-R4).
- **A `.zip`** — the same walk with one convention fewer than the `.dmg` a Mac user expects to
  drag from (`ka-reader@70a879a:docs/SDD.md` § SDD Review Notes RN-17).
- **A terminal `xattr` or `spctl` step in the README** — a route the README must not open to a
  stranger (`ka-reader@70a879a:docs/SDD.md` § SDD Review Notes RN-17).

## Consequences

Easier: a channel that costs nothing and asks no account of anyone; an artifact whose provenance is
a CI run from a tag plus a published checksum, so "the release is not the reviewed tag" is a
checkable failure (`docs/SDD.md` § 11 R-7). Harder: a Gatekeeper step inside every stranger's first
five minutes, re-walked on every macOS the floor admits before each release (`docs/SDD.md` § 11
R-2); and a sandbox whose enforcement under an ad-hoc signature is proved by a probe on every build
rather than promised by a signing chain (ADR-0008; `docs/SDD.md` § 11 R-8).

What undoing it costs: a Developer ID identity and a secret in CI — a reversal the owner has ruled
out (`docs/SDD.md` § 9 TO-9).

**What this rests on, and whose it stays.** This decision rests on more platform facts it does not
control than any other in the log: Gatekeeper's treatment of un-notarized software, which Apple has
already tightened once (the Sequoia change cited above) and is expected to tighten again;
`codesign`'s ad-hoc mode binding entitlements; and GitHub Releases as the only channel. The
expected trajectory is that Apple's step grows, not shrinks. If it grows past the five-minute
clock, the finding goes to the SRS's C-3 as a companion item and never to a signing identity —
what is un-made is the README's click path and possibly the install bar, not the signing decision
(`docs/SDD.md` § 11 R-2). If GitHub stops being the channel, the owner's bound "comes from GitHub"
and C-12 are un-made together; the artifact and its checksum file are portable to any host that
serves a file.

## Traces to

- `docs/SDD.md` § 4 C-R4; § 9 TO-9; § 11 R-2, R-7, R-8; `ka-reader@70a879a:docs/SDD.md` § SDD Review Notes RN-17, RN-25.
- `ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 1.1 (unsigned; the three bounds) and § 3.3 (the release lands
  after the v1 cut; verify early).
- `docs/SRS.md` § 7 C-3, C-11, C-12; § 4.7 NFR-13; § 8 AC-10, AC-14; § SRS Review Notes RN-7, RN-12.
- `docs/fdr.md` R-128 – R-134, PD-15, PD-16, PD-17, OOS-18.
- Apple's Sequoia Gatekeeper note, cited above, as the SDD cites it.

## Binds

QC-28, QC-29, QC-56, QC-57.

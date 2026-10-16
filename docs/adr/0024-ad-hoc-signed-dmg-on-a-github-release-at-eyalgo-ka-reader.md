# ADR-0024: The release is an ad-hoc-signed, un-notarized `.dmg` on a GitHub Release at `github.com/eyalgo/ka-reader`, built by CI from the tag — never Developer ID-signed

**Status:** Accepted — supersedes ADR-0007
**Date:** 2026-10-16

## Context

ADR-0007 decided how KA-Reader reaches a stranger. Two of its sentences named the repository the
product is published from as `github.com/kensaiapp/ka-reader`
(`docs/adr/0007-ad-hoc-signed-dmg-on-a-github-release.md:L10` and `:L22`). That address no longer
holds. On 2026-10-16 the owner moved the repository from the `kensaiapp` organisation to the
maintainer's personal account, and the three documents above this log followed: `docs/PRD.md` v16
§ Assumptions "Public identity" (`:L396`), `docs/SRS.md` v13 C-12 (`:L497`) and `docs/SDD.md` v52
§ 4 C-R4 (`:L628-L629`), with the SDD's reason at RN-112. The owner raised the gap on this log's
companion and answered it: the channel follows the upstream documents, and the decision itself is
unchanged (`docs/trail/architecture/cycle-48.md` § 3.1).

The forces ADR-0007 recorded stand, and are restated so this record reads alone. There is exactly
one acquisition-and-start path: no clone, no build from source, at most one widely-available
prerequisite, and a stranger reaches a viewed file within five minutes (`docs/SRS.md` § 7 C-3;
§ 4.7 NFR-13). The product is published from `github.com/eyalgo/ka-reader` (§ 7 C-12), and the
minimum macOS version is fixed with the runtime and stated wherever the install path is offered
(§ 7 C-11). The owner's standing call, for this and every app in the instance: unsigned — "Nothing
is paid for this app … no Apple Developer Program membership, now or later. The app is **not**
going into the Mac App Store; the only channel is a download from GitHub … Do not raise signing
again" — with the install mechanism handed to the CTO inside three bounds: costs nothing, comes from
GitHub, one simple path (`ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 1.1). On macOS Sequoia a
stranger can no longer Control-click to open software that is not notarized; they go through System
Settings › Privacy & Security (https://developer.apple.com/news/?id=saqachfa).

## Decision

The channel is a **GitHub Release on `github.com/eyalgo/ka-reader` carrying
`KA-Reader-<version>.dmg` and `SHA256SUMS`, built by CI from the tagged commit and never on a
maintainer's machine.** The bundle is **ad-hoc signed** (`codesign --sign -`) — the signature that
costs nothing and is what binds the entitlements to the binary at all — and is **never Developer
ID-signed or notarized**. The install path is: download the `.dmg`, drag `KA-Reader.app` to
Applications, and on first launch take the one Privacy & Security step; the README's first screen
names all three as the exact click path, and no terminal command (`xattr`, `spctl`) is ever the
documented route. A Homebrew cask is not offered (`docs/SDD.md` § 4 C-R4;
`ka-reader@70a879a:docs/SDD.md` § SDD Review Notes RN-17).

## Alternatives ruled out

*(The first four are ADR-0007's, transcribed unchanged. The last two are the choice this record
makes, weighed in this seat on the owner's answer. None reopens the channel.)*

- **Developer ID signing and notarization** — removes the Gatekeeper step at the cost of a paid
  membership and a signing secret in CI; ruled out by the owner for every app in the instance, and
  recorded here so the cost is stated, not so it is reopened
  (`ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 1.1; `docs/SDD.md` § 9 TO-9).
- **A Homebrew cask** — a second path, and Homebrew a prerequisite of its own: fails C-3 twice
  (`docs/SDD.md` § 4 C-R4).
- **A `.zip`** — the same walk with one convention fewer than the `.dmg` a Mac user expects to
  drag from (`ka-reader@70a879a:docs/SDD.md` § SDD Review Notes RN-17).
- **A terminal `xattr` or `spctl` step in the README** — a route the README must not open to a
  stranger (`ka-reader@70a879a:docs/SDD.md` § SDD Review Notes RN-17).
- **Amend ADR-0007's two address lines in place** — the smallest edit, and the one this log never
  makes: an Accepted record is not rewritten (`docs/adr/README.md:L4-L5`), and the companion item
  itself named a superseding record as the move "if an Accepted ADR is not edited in place"
  (`docs/trail/architecture/cycle-48.md` § 3.1, *If a document has to be written*).
- **Leave ADR-0007 standing and let the SDD carry the address** — keeps a present-tense *Decision*
  naming an address no upstream document does. The delivery tier reads Accepted records as fixed,
  so a release or a check written from ADR-0007 would aim at the old organisation, and GitHub's
  redirect stops the day that name is reused (`docs/trail/architecture/cycle-48.md` § 3.1, *What it
  blocks*).

## Consequences

Easier: a channel that costs nothing and asks no account of anyone; an artifact whose provenance is
a CI run from a tag plus a published checksum, so "the release is not the reviewed tag" is a
checkable failure (`docs/SDD.md` § 11 R-7). Harder: a Gatekeeper step inside every stranger's first
five minutes, re-walked on every macOS the floor admits before each release (`docs/SDD.md` § 11
R-2); and a sandbox whose enforcement under an ad-hoc signature is proved by a probe on every build
rather than promised by a signing chain (ADR-0010; `docs/SDD.md` § 11 R-8).

The repository is private on the day of this record, and its visibility and CI billing are left to
settle later (`docs/trail/architecture/cycle-48.md` § 3.1). Nothing here is false while it stays
private: this record decides the channel the first public release uses, not when that release
happens. Two of the release's checks cannot pass until the repository is public — a stranger
opening the address, and `gh api repos/eyalgo/ka-reader/private-vulnerability-reporting` returning
`"enabled": true`, which answered `HTTP 404` on 2026-10-16 (`docs/SDD.md` RN-112, *A limit beside
the claim*).

What undoing it costs: a Developer ID identity and a secret in CI — a reversal the owner has ruled
out (`docs/SDD.md` § 9 TO-9). Moving the address again costs a new record like this one, and once a
release has shipped it costs more: the README, the release page and every adopter's bookmark point
at the address this record names.

**What this rests on, and whose it stays.** This decision rests on more platform facts it does not
control than any other in the log: Gatekeeper's treatment of un-notarized software, which Apple has
already tightened once (the Sequoia change cited above) and is expected to tighten again;
`codesign`'s ad-hoc mode binding entitlements; and GitHub Releases as the only channel. The
expected trajectory is that Apple's step grows, not shrinks. If it grows past the five-minute
clock, the finding goes to the SRS's C-3 as a companion item and never to a signing identity —
what is un-made is the README's click path and possibly the install bar, not the signing decision
(`docs/SDD.md` § 11 R-2). If GitHub stops being the channel, the owner's bound "comes from GitHub"
and C-12 are un-made together; the artifact and its checksum file are portable to any host that
serves a file. One fact is new here: the channel now sits on one person's account, not an
organisation's. If that account goes silent, the releases already offered stay where they are, no
second maintainer can cut the next one, and C-12 is the sentence that moves first.

## Traces to

- `docs/trail/architecture/cycle-48.md` § 3.1 — the owner's item and answer: the channel and every
  forward-looking check read `github.com/eyalgo/ka-reader`, and the decision is unchanged.
- `docs/SDD.md` at v52 (Settled) — § 4 C-R4 (`:L628-L639`); § 9 TO-9; § 11 R-2, R-7, R-8;
  § SDD Review Notes RN-112; `ka-reader@70a879a:docs/SDD.md` § SDD Review Notes RN-17, RN-25.
- `docs/SRS.md` at v13 (Settled) — § 7 C-3, C-7, C-11, C-12; § 4.7 NFR-13; § 8 AC-10, AC-14;
  § SRS Review Notes RN-7, RN-12, RN-38.
- `docs/PRD.md` at v16 (Settled) — § Assumptions "Public identity".
- `ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 1.1 (unsigned; the three bounds) and § 3.3 (the
  release lands after the v1 cut; verify early).
- `docs/fdr.md` R-128 – R-134, PD-15, PD-16, PD-17, OOS-18.
- ADR-0007 — the record this one supersedes. Its decision is restated here whole, with the address
  changed, so nothing in this record depends on that one being open. Its traces stand under this
  record.
- **Beyond the answer's words, two:** (1) *Consequences* cites ADR-0010 where ADR-0007 cited
  ADR-0008, because ADR-0010 superseded ADR-0008 at `docs/adr/README.md`'s ADR-0010 row; the probe
  it names is the same. (2) The one-account sentence under *What this rests on* is this seat's
  reading of the move, not a sentence from any input.
- Apple's Sequoia Gatekeeper note, cited above, as the SDD cites it.
- Inputs read for this record: PRD Settled v16 · SRS Settled v13 · SDD Settled v52 · FDR Settled v12.

## Binds

QC-28, QC-29, QC-56, QC-57.

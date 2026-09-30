# Nozoki 覗き

**Nozoki** (覗き — *"to peek / peer in"*) is a lightweight, strictly **read-only** reader of
folders, files and repositories: a stripped-down, VS Code-like tool that runs on your own
machine, for browsing a folder's tree, reading its files, and — when the folder is a Git
repository — seeing what has changed. Look, don't touch.

Nozoki never changes the folder you point it at. It writes no file in it, and it runs no Git
command that alters your repository's state.

> **Status: specified, partly built.** What exists now: the Rust library that reads a folder
> (`crates/nozoki-core`), the C interface over it (`crates/nozoki-bridge`) and the AppKit shell in
> Swift (`nozoki-mac`). In the app you choose a folder through the system's Open panel and browse
> its tree, opening folders as you go, beside a reading panel that is still empty. If you dismiss
> the panel, or the folder cannot be opened, the window says so and offers *Browse…* and *Quit*.
> Viewing a file, the Git view and live refresh are not built yet. The product is specified in
> full — what it is (`docs/PRD.md`), what it does (`docs/SRS.md`, `docs/fdr.md`), how it looks and
> reads (`docs/UXD.md`, `docs/DESIGN.md`, `docs/CONTENT.md`), and how it is built (`docs/SDD.md`,
> `docs/adr/`, `docs/nfdr.md`). There is no release yet. When there is one, it is a `.dmg` on a
> GitHub Release for macOS 14 or later, under the MIT licence.
>
> Nozoki is before version 1.0.0. Until 1.0.0, anything in it may change: what it does, how it
> looks, and how you start it.
>
> The original proposal is kept at [`docs/proposal.md`](docs/proposal.md).

## What it is

A tool optimized for **inspection rather than authoring** — select files, browse the
folder's file tree, and check its Git state in a familiar editor-like shell, without the
complexity of a full IDE. It takes one local folder at a time, a Git repository or not: when
the folder is a repository, the Git view shows its state; when it is not, the Git view is there
and shows nothing. The intentionally narrow v1:

- Read-only code viewing with syntax highlighting for Python, shell, JavaScript, JSON, YAML and
  TOML; any other text file is shown as plain text. Markdown is rendered.
- Sidebar toggle between **Files** and **Git**.
- Live refresh: a change on disk appears in the view with nothing for you to do.
- Fast file switching in a familiar workbench-style shell.
- Minimal chrome. The only input Nozoki ever needs is which folder to view.

Nozoki is used with a mouse. It has no keyboard navigation, and it makes no promise about
screen readers or other assistive technology. Neither is planned: keyboard navigation is outside
what Nozoki is built to become.

## Stack

One macOS application bundle, running as one process: an AppKit shell in Swift (`nozoki-mac`)
over a Rust library that does all the reading (`crates/nozoki-core`), reached through a C
interface (`crates/nozoki-bridge`). There is no web engine in it. The fourteen Lucide icons ship
inside the bundle. A shell harness under `checks/` proves the read-only and no-network promises
on every build. The decisions and their reasons are in [`docs/adr/`](docs/adr/README.md).

## Roadmap

1. **v1** — the file tree, reading with highlighting, the Git view, live refresh, a remembered
   theme, and a stranger picking it up from this README alone — against a plain folder as
   against a repository.
2. **Inside done, beyond v1** — diffs, commit history with branches drawn as branches, and
   switching the viewed folder without restarting (always one at a time).
3. **1.0.0** — the version number becomes a promise.

The order, slice by slice, is `docs/SDD.md` § 6.

Not on the roadmap, and not coming later: sidebar search, pane resizing and keyboard navigation
are outside what Nozoki is built to become.

## Name

*Nozoki* (覗き) is drawn from the kensaiapp naming family — Japanese terms that name a thing by
its essence. To *peek* is exactly what this tool does: it lets you peer into a folder, but
never reach in and change it.

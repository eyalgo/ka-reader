# KA-Reader

**KA-Reader** is a lightweight, strictly **read-only** reader of
folders, files and repositories: a stripped-down, VS Code-like tool that runs on your own
machine, for browsing a folder's tree, reading its files, and — when the folder is a Git
repository — seeing what has changed. Look, don't touch.

KA-Reader never changes the folder you point it at. It writes no file in it, and it runs no Git
command that alters your repository's state.

## Status

> **Status: specified, partly built.** You can choose a folder through the system's Open panel and see its entries listed, which came in with commit `1741429c5`.
> You can open and close the folders in the file tree, which came in with commit `f46269a00`.
> If you dismiss the Open panel, or the folder can't be opened, the window says so and offers *Browse…* and *Quit*, which came in with commit `2270920c8`.
> You can select a file and read its text in the reading panel, which came in with commit `75cc7ba60`.
> The reading panel highlights the code of a file in JavaScript, JSON, Python, shell, TOML or YAML, which came in with commit `6a3738a2d`.
> You can switch between Files and Git, and the Git view shows the Git state of the folder you opened, which came in with commit `129586e43`.
>
> KA-Reader does not yet follow the folder on its own, say plainly when the open file is gone, render Markdown by default, show a repository's diffs, show a repository's commit history or switch to another folder without restarting. It has no one way to get and start it, it is not public under the MIT licence and it is not at version 1.0.0 or later. The README does not yet open with what KA-Reader does, one install path, one example and what it will and won't touch, and it does not yet say that nothing is promised about issues, questions and security reports.
> The product is specified in full — what it is (`docs/PRD.md`), what it does (`docs/SRS.md`, `docs/fdr.md`), how it looks and reads (`docs/UXD.md`, `docs/DESIGN.md`, `docs/CONTENT.md`), and how it is built (`docs/SDD.md`, `docs/adr/`, `docs/nfdr.md`). There is no release yet.
>
> KA-Reader is before version 1.0.0. Until 1.0.0, anything in it may change: what it does, how it
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
- Minimal chrome. The only input KA-Reader ever needs is which folder to view.

KA-Reader is used with a mouse. It has no keyboard navigation, and it makes no promise about
screen readers or other assistive technology. Neither is planned: keyboard navigation is outside
what KA-Reader is built to become.

## Stack

One macOS application bundle, running as one process: an AppKit shell in Swift (`ka-reader-mac`)
over a Rust library that does all the reading (`crates/ka-reader-core`), reached through a C
interface (`crates/ka-reader-bridge`). There is no web engine in it. The fourteen Lucide icons ship
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
are outside what KA-Reader is built to become.

## Built by KensaiApp

KA-Reader is built by [KensaiApp](https://github.com/eyalgo/kensaiapp), a system of AI roles that
carries a software change from first ask to merged code. What that cost in Claude runs, tokens and
money is in [`docs/build_cost.md`](docs/build_cost.md).

## Name

*KA-Reader* was called *Nozoki* (覗き — *"to peek / peer in"*) until 2026-10-08.
The tool is the same: it lets you look into a folder,
but never reach in and change it.

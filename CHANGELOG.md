# Changelog — `ka-reader`

Each entry records a change to what a user of a fresh clone installs, runs, types or reads in KA-Reader. It names the project the change was made under and cites the commits that made it. The format follows [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Upgrading

- **ka-reader** — The product is renamed from Nozoki to KA-Reader. The app, its crates (`ka-reader-core`, `ka-reader-bridge`) and its Swift package (`ka-reader-mac`) carry the new name, so a clone made before the rename builds and runs under the new names. (`c915d52be`, `4b98c175e`)
- **ka-reader** — KA-Reader needs macOS 26 or later, and its bridge is built for that floor. (`f0f1e5fcf`)

### Added

- **ka-reader** — The repository holds the design language: its reference, its tokens, and a guard that holds both, run by `scripts/design-check.mjs`. (`c4fb3330c`)
- **ka-reader** — The first build: a sandboxed, ad-hoc-signed app bundle that `checks/bundle.sh` assembles and proves sandboxed on every launch, beside `checks/no-network.sh`. (`00e1bf196`, `92a76c4ca`)
- **ka-reader** — You choose a folder through the system's Open panel and see its entries listed, in the order the product's tree defines. (`1741429c5`, `46bb2752a`)
- **ka-reader** — The native shell: an AppKit app in Swift over the Rust core, reached through a C interface. (`99e2bacc5`)
- **ka-reader** — `checks/view.sh` and `checks/renderer.sh` show the shell as it draws, with an idle-shell control. (`153f5a147`)
- **ka-reader** — Folders in the file tree open and close, a folder still being read says so, and a link is followed only inside the opened folder. (`f46269a00`)
- **ka-reader** — If you dismiss the Open panel, or the folder can't be opened or read, the window says so and offers *Browse…* and *Quit*. (`2270920c8`, `d6df3e398`, `04dfab6d0`)
- **ka-reader** — The launch window draws its surfaces and holds its layout. (`8e738b7b0`, `702f7c496`)
- **ka-reader** — You select a file and read its text in the reading panel. (`75cc7ba60`)
- **ka-reader** — The reading panel highlights JavaScript, JSON, Python, shell, TOML and YAML, and the code view, its gutter and the path line wear the design's tokens. (`2026553a1`, `6a3738a2d`, `2e0c1c043`, `6c82cefce`, `25367f186`)
- **ka-reader** — A file in the tree carries its language's colour. (`a5aa4131a`)
- **ka-reader** — The reading panel says when a read is out of reach or stopped. (`eac839a60`)
- **ka-reader** — The reading panel's text menu offers Copy only. (`f5167c4bc`)
- **ka-reader** — `checks/read-only.sh` walks the app over every file of a folder, and the walk leaves the tree as it found it. (`65b1d6c5f`, `c26894526`)
- **ka-reader** — `checks/structure.sh` and `checks/entry-points.sh`, with its allow list, check the code's unit rules, its unit graph, its boundary reads and its value modules. (`463acb9d5`, `b15805201`, `8c3ab40ca`, `73c408e10`, `76666bac8`, `82a3fb12e`)
- **ka-reader** — The core reads a folder's Git state through libgit2, and treats a `.git` file as a repository root. (`126ef75bb`, `48308ff2e`, `6a0725c95`)
- **ka-reader** — You switch the sidebar between Files and Git, and the Git view shows the Git state of the folder you opened. (`392177da4`, `129586e43`)
- **ka-reader** — The file tree marks what changed, and a status letter's tooltip says its word. (`67d103d21`, `6040dc1fd`)
- **ka-reader** — A row answers the pointer, and the selected row is filled, in the file tree and the Git view. (`06d722acb`, `d5e1c1c46`, `de1138887`)
- **ka-reader** — `checks/gate.sh` runs every check in one script, the one the build's workflow calls. It runs the sanitizer step, the secret scan over the whole history with a planted-secret control, and the strings lint `checks/strings.sh`. (`8b93322be`, `389adad93`, `82352408c`, `1b3250006`, `cd65c0227`, `f25fdbb62`)
- **ka-reader** — The dependency scan reads the C and C++ sources for reads of the environment. (`6d56fb32d`)
- **ka-reader** — The README describes KA-Reader as it is defined, a reader of folders, with its real stack and its documents by path, and links what building it cost. (`2aa3fc2eb`, `33581f3a0`)
- **ka-reader** — The file tree follows the disk on its own. When something in the open folder is created, changed or removed, including inside a folder you have expanded, the tree shows it with no action from you, and your expanded folders, your selection, the sidebar view, the open file and its scroll position stay as they were. A folder that goes away and comes back is listed afresh, and a folder that can't be read again says so on its own row while the rows beside it keep their own states. (`a5712c889`, `2f1357830`, `f1ab0c91f`, `a0142be08`, `d3b346d4d`, `96d266ff1`, `a685d051e`, `87d7607c1`, `12cbec9a7`)
- **ka-reader** — `checks/tree-scene.sh` launches the built app on a copy of a fixture folder, changes that copy for thirty seconds and prints the listings the tree should then show. `checks/read-only.sh --kill` stops the walk partway and still checks that the folder is unchanged, and `checks/gate.sh` runs both over the fixture. (`214819bb3`, `5380e4545`, `1498a8358`)
- **ka-reader** — The open file follows the disk on its own. When the file changes, the reading panel shows its new content in place, with no action from you, and you stay where you were in it. When the file is deleted, renamed or moved away, the panel keeps its name and says *This file is no longer there.*, with none of the old content. When the file can be read again, its new content replaces that sentence with no message. `checks/gate.sh` also runs a scene that changes, deletes and recreates an open file in a fixture folder, then checks that folder is unchanged by the read-only walk. (`5af7f0088`, `41147fa5e`, `ef0e1c827`, `390fcbf4c`, `0e118869e`, `47226bf5e`, `800e37a1c`, `75d30c9d4`, `c4dbe863f`, `2a382c62e`, `12de2821a`, `284ddbd5c`)

### Changed

- **ka-reader** — The launch steps refuse to run off a virtual machine. (`13e8d42e9`)
- **ka-reader** — The bridge's C-string calls build under both Swift 6.3 and 6.4. (`24be58134`)

### Removed

- **ka-reader** — The Tauri build is gone. The native bundle is assembled in its place, and `checks/bundle.sh` and `checks/no-network.sh` read it. (`0aca57e4b`)

### Fixed

- **ka-reader** — Re-entering a folder through a spelling that differs only in case stays inside the opened folder, and that re-entry is limited to case-only spellings. (`368c8a4ec`, `df53a4f46`)
- **ka-reader** — Two processes writing the shared log keep it within its bound. (`af416967f`)
- **ka-reader** — When you click two files in quick succession, KA-Reader ends on the second, whichever read finishes first. The panel shows it and follows it on disk, and your place in it is kept. (`068785415`, `0203fbd5e`, `d2874d693`, `5e5f39c2e`, `3bbc07d30`)

### Security

- **ka-reader** — The Git view reads no configuration from outside the repository, and a refusal names what it saw. (`fc1457461`, `c25201af5`)
- **ka-reader** — The Git object store must stay inside the repository: alternates that point outside are refused, and the refusal says what it saw. (`66f428d85`, `0909fe00a`)
- **ka-reader** — Each `.gitmodules` section's path is checked before it is read, and the submodule walk runs on every build. (`772c63b63`, `b12e48cc6`)
- **ka-reader** — `checks/no-network.sh` refuses a system target. (`c904f8d8d`)

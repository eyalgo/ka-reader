---
name: Nozoki 覗き
omitted:
  # Nothing is omitted. Every section below applies to this product, including Localization —
  # Nozoki ships in English only, and the rules that keep a string translatable cost nothing
  # while they are being written and cannot be added afterwards (see § Localization).
---

# CONTENT — Nozoki 覗き

**Status:** Draft
**Owner:** Content Editor
**Version:** 1 — first authoring, off `docs/UXD.md` v2. Eight items are parked in `docs/CONTENT_open_issues.md`: three the run could not settle and five calls the rest of this document hangs from.

> The verbal language is the source of truth for everything this product says to a person. It is
> the peer of `DESIGN.md`, not a part of it: a rule about how something **looks** belongs there,
> a rule about what it **says** belongs here. It is authored off the UXD — the states the words
> live in are named there — and it holds **no per-change copy**: a line that would need editing
> when a feature ships belongs to that change, not to this file. Updated in place with
> versioning (bump the line above whenever a rule or the prose changes); on a revision it is
> **stable by default** — every shipped string was written under the voice as it stood, so a
> silent re-voicing invalidates the corpus without telling anyone. Every delta traces to an
> owner answer, a change in the evidence, or an upstream UXD/PRD change.

---

## Voice

Nozoki is talking to someone who has just pointed it at a repository they must not disturb —
often one an automated tool or a coding agent is changing while they watch (`docs/PRD.md`
§ Target Users). It speaks as itself: it names what it is looking at, says what it found, and
stops. Most of what is on the screen belongs to the reader — their files, their branch names,
their code, their Markdown — and Nozoki's own words are the thin frame around them, so every
sentence it adds is taking space from the repository and has to be worth it. It never bids for
attention, never states something it has not read, and never reassures the reader that nothing
has been changed: the guarantee is in what the tool cannot do, not in what it says about itself.
When no rule below settles a sentence, write the one that says what Nozoki observed, then what
you can do next, and end it there.

**These rules bind the words Nozoki writes, not the words it shows.** A viewer's screen is mostly
somebody else's text: file contents, file and branch names, commit messages, rendered Markdown.
None of it is Nozoki's writing, none of it is corrected, shortened, or re-punctuated, and no rule
in this document is applied to it. The rules govern the frame: labels, status messages, failure
text, the README, and any text a release carries.

**Who "you" is:** the person reading the repository. Nozoki is the subject of a sentence about
what the tool did; *you* is the subject of a sentence about what the reader does. There is no
*we* — no team or company speaks in this product's words (`docs/PRD.md` § Assumptions, public
identity: the tool is published under an organisation name, and no person is its public face).

**Conversational or casual:** Nozoki is conversational — contractions, ordinary words, the way a
competent person would say it to another — and **not casual**. No jokes, no slang, no informal
interjections. The reason is the moment the words land in: the reader is mid-task, watching a
tree they must not disturb, and the sentences they read most are the ones that appear when
something failed. A joke arrives at the exact moment they are deciding whether this tool can be
trusted with a repository, and the product's character is "calm, truthful, still" (`docs/PRD.md`
§ UX Notes "The character").

| We do | We are not | On a real string |
|---|---|---|
| A message says what Nozoki observed, never why it happened. Where a reason would be a guess, the message states the thing Nozoki actually read — a file that exists, a path that held nothing, a value it could not parse. | **Diagnostic.** Aiming at *helpful*, a writer explains the cause: it reads as expertise and is a claim the tool never checked. | *"Nozoki could not read this repository's Git status while `.git/index.lock` exists."* Not: *"Another Git process is running."* — Nozoki observed a file, not a process. |
| A message names one thing the reader can do next, or says that nothing can be done and what ends the wait. | **Terminal.** Aiming at *concise*, a writer stops at the diagnosis, which is the shape of every message that becomes an abandoned tool. | *"Point Nozoki at the top folder of a repository — the one you cloned — and start it again."* Not: *"Not a Git repository."* |
| The read-only guarantee is stated in its one wording on the surfaces that state it, and nowhere else. No screen, and no message, tells the reader that their repository is safe. | **Reassuring.** Aiming at *trustworthy*, a writer repeats the promise where the reader did not ask; repetition is what a tool does when the guarantee is soft. | The empty reading panel says *"Select a file to view."* Not: *"Select a file to view. Nothing you do here can change your repository."* |
| Nothing Nozoki says asks for attention. No exclamation mark anywhere, no *Note:*, no *Warning*, no capitalised word used for emphasis. A failure sentence is written in the same register as an empty state. | **Urgent.** Aiming at *clear*, a writer raises the volume of the sentence that matters most — in a product whose updates arrive with no notification and no flash at all (`docs/UXD.md` UX-I2). | *"This file is no longer in the repository."* Not: *"Warning! This file has been deleted!"* |
| A message ends at the job in hand. No second suggestion, no tip, no mention of a feature the reader did not ask about. | **Chatty.** Aiming at *friendly*, a writer adds the extra line — and in a shell with no notifications, that line is the only thing on screen the reader did not ask for. | *"This repository has no files."* Not: *"This repository has no files. Try opening a different repository, or check out a branch that has some."* |
| Nothing the reader points Nozoki at is described by its failure to satisfy the tool. A file, a path, or a repository is never *invalid*, *unsupported*, *illegal*, *malformed*, or *refused*. | **Strict.** Aiming at *precise*, a writer reaches for the machine's verdict on the reader's own material — which is exactly what a viewer promising never to refuse a file must not do (`docs/SRS.md` FR-29, *"never refused"*). | *"This file isn't text, so its contents aren't shown."* Not: *"Unsupported file type."* |
| A sentence about the repository uses the repository's own words, and a sentence about Nozoki uses this document's. Git's words — branch, staged, commit — are used where Git's own state is being reported, and nowhere else. | **Bilingual.** Aiming at *familiar*, a writer borrows Git vocabulary for something Git did not say, and the reader can no longer tell which words came from their repository. | *"Nothing has changed in this repository."* Not: *"Working tree clean."* — that is Git's sentence, not Nozoki's, and the reader cannot tell. |

## Tone

The voice does not change. What changes is how much of it is spent: how many sentences the moment
gets, and how much of the reader's attention Nozoki is entitled to take.

**Across the first run — finding Nozoki, starting it, and reading a first file** (`docs/PRD.md`
§ Success Metrics "Time-to-first-success"; `docs/UXD.md` UX-F1):

| Moment | Tone, and how far | Why it changes here |
|---|---|---|
| The README's first screen | The most words this product ever spends in one place, and every one of them a claim that can be checked in the next minute: what Nozoki does, one way to install it, one thing to type, and what it never touches. | It is the only surface that has to answer a stranger who has not started the tool, cannot ask anyone anything, and arrives expecting the documentation to be out of date. |
| Starting it | Silence, unless something failed. No banner, no version line, no greeting. | The reader started the tool in order to look at a repository; anything printed before the repository appears is the tool talking about itself. |
| Startup fails | Three sentences at most: what Nozoki was doing, what it found, what to do next. Written for someone who can follow a README and has no Git knowledge beyond that (`docs/PRD.md` § UX Notes "Failure states"). | This is the first minute, and it is the one moment where the reader has been stopped by the tool rather than by their repository. A dead end here ends the adoption. |
| Arrival, nothing open | One sentence, an instruction, no welcome. *"Select a file to view."* | There is nothing to set up, sign into, or dismiss (`docs/UXD.md` § 4), so the only thing to say is the one action available. |
| The first file opens | Nothing. The path line and the content are the whole message. | The product's job just happened; a message saying so would be Nozoki congratulating itself. |
| A file that cannot be shown as text | One sentence, stating the fact about the file, with the tree still there as the way on. | It is not a failure of the reader or of the tool, and the reader's next move is simply another file. |

**Across the lifecycle:**

| Stage | Tone, and how far | Why it changes here |
|---|---|---|
| First run | See the flow above: the README carries the words, the running tool carries almost none. | Everything the reader needs before they trust the tool has to be readable before they start it. |
| Habitual use — watching a repository change | Silent. Content changes because the repository changed; nothing announces it, nothing summarises what moved (`docs/UXD.md` UX-I2, UX-I3). | The reader is watching an agent work and is sharing the screen with it. A message per change would make the driving scenario unusable. |
| Failure | The one place Nozoki spends sentences on itself, and the shortest form that still names what happened and what to do. Never an apology, never an explanation of the cause. | A failure is where an unverifiable claim is most tempting and most expensive, and where the reader has least patience for the tool's feelings. |
| Recovery | Nothing at all. The failure sentence disappears and the state takes its place (see § Message patterns, *Recovered*). | Announcing a recovery is a second interruption for something the reader can already see, and *"back to normal"* is a claim about a cause. |
| Leaving | Nothing. Closing asks nothing and says nothing (`docs/UXD.md` UX-I5). | There is never anything to save, so a parting message would be the product inventing a reason to speak. |
| The project stops being maintained | One plain sentence where a release is offered, stating the fact and its date, with no apology and no promise of a return. | An archived tool that still looks staffed costs a stranger their time; saying so is the last useful thing the words do. |

## Grammar and mechanics

- **Person.** *Nozoki* is the subject of a sentence about what the tool did or found. *You* is the
  subject of a sentence about what the reader does. Never *we*, never *the user*, and never a
  passive that hides which of the two acted.
- **Tense.** Present for what is true now; simple past for what Nozoki observed. No future tense
  about the tool's own behaviour except where a named condition follows: *"the Git view shows the
  status as soon as Nozoki can read it"*, never *"will refresh shortly"*.
- **Sentence case everywhere**, including labels, headings and controls. The only capitalised
  words inside a sentence are *Nozoki*, *Git*, *Markdown*, and names taken from the reader's own
  repository. The Git view's section headings are written *Changes*, *Staged*, *Unstaged*,
  *Branches* and appear in capitals because the design language sets that level in uppercase
  (`docs/DESIGN.md` § Typography, `{typography.label}`); the string is written in sentence case
  and the transform is visual, so nothing in the source is typed in capitals.
- **Full stops.** A full sentence ends with a full stop, including a one-sentence status message.
  A label or a control's text carries none: *Files*, *Git*, *Light*, *Dark*, *Rendered*,
  *Source*, *Browse…*.
- **Ellipsis.** The character `…` appears in exactly one place: at the end of a control that opens
  something asking the reader for more — *Browse…* (`docs/DESIGN.md` § Components, "The menu"). It
  never marks work in progress, and no message trails off.
- **Exclamation marks and question marks.** None, anywhere. Nozoki asks the reader nothing (there
  is no confirmation, no prompt, no dialogue — `docs/UXD.md` UX-I7), and it raises its voice
  nowhere.
- **Contractions** are used — *isn't*, *can't*, *doesn't* — everywhere except inside a standing
  sentence (§ Terminology, *Standing sentences*), whose wording is fixed as written.
- **Quotation marks and emphasis.** No bold and no italics in any string the running product
  shows; the design language has no emphasised text token, and emphasis inside a status message
  is an attention bid. A name taken from the repository — a path, a branch, a file — is set in
  the path type rather than quoted (`docs/DESIGN.md` § Typography, `{typography.path}`).
- **Numbers.** Numerals always, including one to nine: every number this product shows is counted
  from the repository — a count beside a heading, a line number, a commit's position. No number is
  spelled out, and no message rounds one.
- **Dates and times.** Absolute, as `YYYY-MM-DD HH:MM`, in the reader's own local time. Never
  relative (*"2 days ago"*): the reader is comparing commits with each other, and a relative time
  changes between two glances at the same screen while the commit does not.
- **Duration.** No message states how long anything will take. Where the reader has to wait, the
  message names the condition that ends the wait, not a number — the product's own refresh
  threshold is undecided (`docs/PRD.md` § Success Metrics "Refresh immediacy", *"exact latency
  threshold TBD"*), so a duration in a string would be a number nobody has measured.
- **Units and currency.** Neither appears. No surface this product has shows a file size, a
  transfer rate, or a price. If a state ever needs a size, it is written here first.
- **Abbreviations.** None are coined. *Git* is capitalised as the name of the system and lowercase
  only inside a literal command (`git init`). *Markdown* is capitalised. *Nozoki* is capitalised
  in prose; the lowercase `nozoki` appears only as a repository or package identifier, which is a
  name and not a word. 覗き appears only where the product's name is introduced, and never in the
  running product (`docs/DESIGN.md` § Components: the shell carries no product name at all).
- **A single-letter code is never the whole of a statement.** Git's status letters are shown
  beside a changed file (`docs/DESIGN.md` § Components, "Status letters"); every place they appear
  is covered by § Accessibility of text, which states what has to name them in words.

## Terminology

The concept is the PRD's; the word is this document's. The rejected column is what stops a
rejected word coming back.

| Concept | The term | Rejected, and why | Notes |
|---|---|---|---|
| The thing Nozoki is pointed at: a local Git repository, its files and its Git state | **repository** | *repo* — an abbreviation the product never expands. *project* — used by the README today; it also means a unit of work, and Nozoki has no concept of one. *workspace* — used by the README today; in the editor this product resembles it names a saved multi-folder configuration, which Nozoki has not got. *codebase* — names the code, not the Git state, and half of what Nozoki shows is Git state. | The word for both the thing on disk and the thing on screen; there is only one at a time (`docs/PRD.md` § Out of Scope, "Several repositories at once"). |
| The sidebar's navigable list of folders and files | **file tree** | *tree* alone — the PRD uses "the tree" for both this list and the repository's files on disk, which are two concepts under one word. *explorer* — the editor's name for its own panel. *files pane* — *pane* names nothing else in this product. | Shortened to *the tree* only where the same sentence has already said *file tree*. |
| The dominant surface where a file's content is read | **reading panel** | *editor* — there is no editor; the word implies a write path that does not exist (`docs/UXD.md` UX-I1). *viewer* — the whole product is the viewer. *preview* — implies a lesser rendering of something authoritative elsewhere. | The same panel holds code, rendered Markdown, raw Markdown and a diff (`docs/UXD.md` § 9). |
| A file Git reports as different from the last commit | **changed** | *modified* — Git's own `M` is one of several changes, so the general word cannot be the same as the specific one. *dirty* — a state described as a defect of the reader's work. | The file tree's markers and the Git view's first section both use it (`docs/PRD.md` § Core Features). |
| A change Git has been told to include in the next commit | **staged** | *indexed*, *cached* — Git's internal names for the same store, which the reader has not typed. | Git's own reader-facing word, kept deliberately: it is the word the reader's own tools use. |
| The view following the repository without being asked | **live refresh** | *auto-refresh* — implies a refresh the reader could also do by hand, and there is no refresh control (`docs/UXD.md` UX-I2). *watch mode*, *polling* — name a mechanism the reader never chose. | Never used as a verb the reader performs: the reader never refreshes anything. |
| A file whose contents cannot be shown as text | **can't be shown as text** — a phrase, not a label | *binary* — a word the audience is not known to hold. *unsupported*, *unreadable* — describe the file by the tool's failure, in a product that never refuses a file. | Always said of the file, never of the reader's action. |
| The six languages Nozoki highlights | **the languages Nozoki highlights**, listed | *the floor* — the PRD's and SRS's word for the promise (`docs/PRD.md` § Core Features); it is this project's internal vocabulary and means nothing to a reader. | The list is named where the promise is made, and never abbreviated to a count. |
| What Nozoki remembers between sessions: the theme, and later the repositories it has seen | **what Nozoki remembers** — a verb | *settings*, *preferences*, *configuration*, *options* — each names a surface this product does not have and must never imply (`docs/PRD.md` § Goals, "no configuration of any kind"). | Nothing in the product is called a setting, because nothing in the product is one. |
| The control naming the current repository, which is also how the repository is changed | **repository selector** | *project picker*, *workspace switcher* — carry the rejected words above. *open recent* — names a menu of documents, and Nozoki opens one repository at a time. | Beyond v1 (`docs/UXD.md` UX-F5). Its label is the repository's own name, never the word *selector*. |
| The read-only presentation of what one commit or one working change altered | **diff** | *changes view* — collides with *changed* and with the Git view's *Changes* heading. *comparison* — nothing is being compared for the reader; two states are being shown. | Beyond v1 (`docs/UXD.md` UX-F4). The audience is expected to hold it: the stated expertise floor is a reader who can find their way around a repository on a hosting site (`docs/PRD.md` § Goals, "No learning curve"). |
| The list of commits, with the branches they belong to | **history** | *log* — Git's command name, and it collides with diagnostic logs. *timeline* — implies time is the axis; the branch topology is (`docs/UXD.md` UX-F4). | Beyond v1. |
| What the reader points Nozoki at when it starts | **path** | *directory*, *folder* — used for what a path names inside the file tree, so keeping both for the startup input makes one word do two jobs. *location*, *workspace root* — vague, and jargon. | *Folder* is correct inside the file tree, where it names a node the reader is looking at. |
| The tool's light and dark presentation | **theme**, with the values **Light** and **Dark** | *appearance*, *mode* — *mode* already names the sidebar's Files/Git state (`docs/UXD.md` UX-I3). | The control's text is the theme it switches to (`docs/DESIGN.md` § Components). |

**Banned in anything a person sees:**

| Never | Say instead | Why |
|---|---|---|
| repo | repository | An abbreviation the product never expands. |
| invalid, illegal, malformed, unsupported, refused, rejected | What Nozoki observed: *"there's no Git repository at this path"*, *"this file isn't text"* | Describes the reader's own material by its failure to satisfy the machine, in a product that promises never to refuse a file (`docs/SRS.md` FR-29). |
| binary | can't be shown as text | The reader is not known to hold the word, and the fact they need is about the display, not the encoding. |
| the floor (of languages) | the languages Nozoki highlights | This project's internal vocabulary for its own promise. |
| error, exception, failed, fatal, null, undefined, stack trace, ENOENT, EACCES | The sentence saying what Nozoki was doing and what it observed | Text from inside the tool or from something it depends on, passed through with nothing added. |
| settings, preferences, configuration, config, options | Nothing — name the specific thing, or say nothing | Names a surface the product does not have (`docs/PRD.md` § Goals). |
| just, simply, easy, quick, only takes a second | Delete the word | States how hard the reader will find something, which the tool has not observed and cannot. |
| please | Delete the word | Nozoki asks the reader for no favours; the sentence states the action instead. |
| sorry, oops, uh-oh, don't worry, no problem, great, awesome | Delete the sentence | Tells the reader how to feel about something the tool observed nothing about. |
| Note:, Warning:, Important:, Attention: | The sentence itself | A label added to make a sentence louder, in a product with no notification model at all. |
| user, users | you | The reader is addressed, not described. |
| workspace, project, codebase, repo | repository | One concept, one word (see the table above). |
| safe, safely, don't worry — nothing will be changed | Nothing, or the standing read-only sentence in its own wording | The guarantee is stated where a promise is stated, once; a screen repeating it is a product arguing for itself. |

### Standing sentences

A standing sentence is a promise or a stated limit that appears on more than one surface. Each has
**one wording**, given here, and every surface that states it carries that wording — no paraphrase,
no shortened version, and no softening with *generally*, *usually* or *by default*. These are rules
about wording, not copy for a screen: their whole point is that the words do not vary.

| What it states | The wording |
|---|---|
| Read-only — the product's defining promise (`docs/PRD.md` § Success Metrics "Read-only integrity") | **"Nozoki never changes the repository you point it at. It writes no file, and it runs no Git command that alters your repository's state."** |
| The network — see `docs/CONTENT_open_issues.md` § 1.1, which is unresolved | **"Nozoki sends no telemetry, and it makes no network call while it runs — downloading it uses the network; using it does not."** |
| Before 1.0.0 (`docs/PRD.md` § Assumptions, "Versioning") | **"Nozoki is before version 1.0.0. Until 1.0.0, anything in it may change: what it does, how it looks, and how you start it."** Retired the day 1.0.0 is released; what replaces it is written then. |
| The support posture (`docs/PRD.md` § Assumptions, "Support posture") | **"Issues and questions are welcome and are read when there is time. There is no response time, no commitment to fix, and no promise that a fix arrives. Security reports have a private channel and are read on the same terms."** |
| Archiving (`docs/PRD.md` § Assumptions) | **"If Nozoki can no longer be maintained, this repository is archived on that day, so you can see it rather than guess."** |
| The accessibility posture, on the README below its first screen (`docs/UXD.md` UX-A3) | **"Nozoki is used with a mouse. It has no keyboard navigation, and it makes no promise about screen readers or other assistive technology. Neither is planned: keyboard navigation is outside what Nozoki is built to become."** |

Whether the product states a promise at all is the PRD's, and whether a promise is true of the
built system is the SRS's. This table fixes only the words, once the promise exists.

## Message patterns

Five standing states. Every message Nozoki writes is an instance of one of them.

### Error
**Formula:** *What Nozoki was doing* + *what it observed, naming the file, path or state* + *what
you can do next, or that there is nothing to do and what ends the wait.* One sentence for each
part, three sentences at most, in that order. No cause. No apology. The surface keeps a way on
(`docs/UXD.md` UX-I14), and the sentence names it where it is not already on screen.

**Examples:**
- *"Nozoki looked for a Git repository at `/Users/you/code/app` and didn't find one. Point Nozoki
  at the top folder of a repository — the one you cloned — and start it again."*
- *"Nozoki can't read this repository's Git status while `.git/index.lock` is there. There's
  nothing to do: the Git view shows the status as soon as Nozoki can read it."*

### Empty
**Formula:** *What is not there*, stated as a fact about the repository rather than about Nozoki,
plus *the one action available* where there is one. One sentence. Never a blank surface, and never
shown before Nozoki has read the state it is reporting (`docs/UXD.md` UX-I13).

**Examples:**
- *"Select a file to view."* — the reading panel with nothing open; the action is the whole
  message.
- *"Nothing has changed in this repository."* — the Git view on a clean repository, shown only
  after Git state has been read.

### Loading
**Formula:** *Reading* + *the thing being read.* Present participle, one clause, ending in a full
stop. No percentage, no estimate, no ellipsis, and no claim of progress the tool has not measured.
Where the reader can do nothing but wait, the empty half of the surface stays empty rather than
showing a state that has not been read.

**Examples:**
- *"Reading Git status."*
- *"Reading this folder."* — a folder in the file tree that has not been read yet.

### Partial
**Formula:** *What is shown* + *what is not shown, marked in the place it would have been* +
*which of the two the reader is holding.* The missing piece is named where it belongs, never
summarised in a banner over the whole surface, because the rest of the surface is still true.

**Examples:**
- *"This image isn't loaded: Nozoki fetches nothing from outside this repository."* — in the box
  where a remote image would sit in rendered Markdown, beneath the image's own alt text
  (`docs/SRS.md` FR-32; `docs/DESIGN.md` § Components, "Rendered Markdown").
- *"Nozoki can't read this folder."* — on the one tree row, with the rest of the file tree
  standing (`docs/SRS.md` NFR-3).

### Recovered
**Formula:** *Nothing.* The failure or pending sentence disappears and the state takes its place.
No message announces a recovery, and nothing is apologised for. A recovery message would be a
second interruption for something the reader can already see, and *"back to normal"* is a claim
about a cause Nozoki never observed.

**Examples:**
- Git state becomes readable again: *"Nozoki can't read this repository's Git status…"* is
  replaced by the branch, the changed files and the staged files. Nothing else appears.
- A file that had vanished is written again: the panel's *"This file is no longer in the
  repository."* is replaced by the file's content. No *"restored"*, no *"back"*.

## Accessibility of text

This is Nozoki's own bar for text, and it sits inside the posture the product has already
declared: v1 is mouse-driven, it makes no keyboard-accessibility promise, and beyond that it makes
no assistive-technology promise (`docs/UXD.md` UX-A1). Nothing here claims conformance with any
standard, and nothing here promises anything to a screen reader. What it does is make the
product's own words legible to everyone reading them on the screen.

- **A word carries every state distinction that a colour carries.** The visual half of this rule
  is settled (`docs/UXD.md` UX-A2); the verbal half is that the word exists and is on the surface —
  a heading, a letter with its expansion, or the sentence itself. A state whose only text is a
  colour name has no text.
- **A single letter is not a word.** Git's status letters — `A`, `M`, `D`, `R`, `C`, `U` — are
  shown beside a changed file, and this product has no hover state and no tooltip in which to
  expand them (`docs/DESIGN.md` § Do's and Don'ts). Until the surface names them, the README
  carries the expansion: *added*, *modified*, *deleted*, *renamed*, *copied*, *unmerged*. Where
  the letters can be named in the view itself, that is better than a README the reader has left
  behind — the choice is open at `docs/CONTENT_open_issues.md` § 1.2.
- **Alternative text describes the state, not the glyph.** The fourteen icons this product ships
  never stand alone (`docs/UXD.md` UX-A4), so no icon is given text describing its shape. The
  words beside it are the state; an icon whose meaning is not already in those words is an icon
  this product does not use.
- **Link text means something read on its own.** In Nozoki's own writing — the README above all —
  no link is called *here*, *this*, *link*, or *read more*; the link's text names what is at the
  other end. Inside rendered Markdown the reader's own link text stands as written, and the
  destination is shown beside it (`docs/DESIGN.md` § Components, "Rendered Markdown"), so a
  reader is never asked to guess where a link goes.
- **A failure names the thing it is about, in the same sentence.** There is no form and no field
  in this product, so the tie between an error and its subject is made by naming the file, the
  path or the view inside the message, rather than by placing the message near something.
- **The reading bar, stated as a rule rather than a grade.** Every word in a message Nozoki writes
  is one of three things: a word the README already uses, a name taken from the reader's own
  repository, or one of the Git words the Git view itself shows — *branch*, *changed*, *staged*,
  *commit*. A word that is none of the three does not go in a message. This is the bar because
  the reader's stated floor is someone who can follow a README and find their way around a
  repository on a hosting site (`docs/PRD.md` § Goals, "No learning curve"), and it is checkable
  against one string without knowing anything about the reader.

## Localization

Nozoki ships in English, and no translation is planned (`docs/PRD.md` § UX Notes, "UI language:
English"). The rules below hold anyway. They cost nothing while a string is being written and
cannot be applied afterwards, and the product is public: it is read by people whose first language
is not English whether or not it is ever translated.

- **One message is one whole sentence in the source.** No message is built at runtime by joining
  fragments, and no fragment is stored as a separate string to be assembled. A message with two
  cases is two whole sentences, not one sentence with a switch inside it.
- **Every placeholder is named**, never positional: `{path}`, `{branch}`, `{file}`, `{count}`. A
  placeholder holds a value taken from the reader's repository or machine — a path, a name, a
  count. It never holds a piece of Nozoki's own prose, because a fragment substituted into a
  sentence cannot be read, translated or checked on its own.
- **No sentence carries grammar only English has.** No plural made by adding *s* to a word beside
  a count, and no article chosen from the next word's first letter. Where a count and a noun must
  appear together, they appear as the design language already puts them — a heading with a numeral
  beside it, *Changes 3* (`docs/DESIGN.md` § Components) — which is not a sentence and inflects in
  no language.
- **Every message carries its context in the source, beside the string:** what the reader was doing
  when it appears, and what each placeholder holds. That note is writable only at the moment the
  string is written, because that is the only moment anyone knows what the reader was doing. Its
  reader is not only a translator who may never arrive — it is the next person to change that
  string.
- **Never translated:** the product's name (*Nozoki*, and 覗き where the name is introduced), file
  paths, branch names, commit identifiers, Git's status letters, the licence text, and any
  environment variable a surface names. These are identifiers, not words.
- **A constraint the words impose on the layout:** a status message is prose on a surface, never
  text in a row that clips (`docs/DESIGN.md` § Components, "Status messages"). Rows clip and file
  names are the reader's, so clipping one costs nothing; clipping a sentence costs its second
  half, which is where every message here puts what the reader can do next.

## Traceability

Every state and requirement in the UXD that carries text, and what covers it here.

| UXD state or requirement | Covered by | Notes |
|---|---|---|
| UX-S1 Reading panel — empty | Message patterns § Empty | *"Select a file to view."* |
| UX-S1 Reading panel — loading | Message patterns § Loading | No progress claim; no ellipsis. |
| UX-S1 Reading panel — error (not text) | Message patterns § Error; Terminology (*can't be shown as text*) | The banned list rules out *binary* and *unsupported*. |
| UX-S1 Reading panel — error (file gone) | Message patterns § Error; § Recovered | *"This file is no longer in the repository."* — and nothing on its return. |
| UX-S1 Reading panel — error (unreadable) | Message patterns § Error | What Nozoki was doing, what it observed, the tree as the way on. |
| UX-S1 Reading panel — success | Grammar and mechanics (path line, no emphasis) | Content and path only; no message. |
| UX-S2 File tree — empty | Message patterns § Empty | *"This repository has no files."* |
| UX-S2 File tree — loading | Message patterns § Loading | *"Reading this folder."* |
| UX-S2 File tree — error (one entry) | Message patterns § Partial | Marked on the row; the rest of the tree stands. |
| UX-S2 File tree — success (markers) | Accessibility of text (a word carries the distinction; the letters' expansion) | Open at `CONTENT_open_issues.md` § 1.2. |
| UX-S3 Git view — empty | Message patterns § Empty | *"Nothing has changed in this repository."*, after reading. |
| UX-S3 Git view — loading | Message patterns § Loading | *"Reading Git status."* |
| UX-S3 Git view — error (lock) | Message patterns § Error | The nothing-to-do form, with the condition that ends the wait. |
| UX-S3 Git view — error (mid-operation is not an error) | Voice (report Git's state in Git's words, only where Git said it) | Presented as state, never as failure. |
| UX-S3 Git view — success (headings, letters) | Grammar and mechanics (sentence case, visual uppercase); Accessibility of text | *Changes*, *Staged*, *Unstaged*, *Branches*. |
| UX-S4 Startup failure | Message patterns § Error; Tone (first-run flow) | The worked example; three sentences at most. |
| UX-S5 Diff view (beyond v1) | Terminology (*diff*); Message patterns § Empty, § Error | *"This file has no remaining changes."* |
| UX-S6 History view (beyond v1) | Terminology (*history*, *branch*); Grammar (dates, numerals) | Absolute dates; identifiers untranslated. |
| UX-S7 Repository selector (beyond v1) | Terminology (*repository selector*); Grammar (*Browse…*) | First run: the browse entry alone, no explanatory sentence. |
| UX-F1 Arrive and read | Tone § first-run flow | Silence at start; one sentence at arrival. |
| UX-F2 Check what changed | Terminology (*changed*, *staged*) | Git's words where Git's state is reported. |
| UX-F3 Watch a moving tree | Tone § lifecycle (habitual use); Voice (no attention bid) | No message accompanies any update. |
| UX-F4 Inspect changes and history | Terminology (*diff*, *history*, *branch*) | Beyond v1. |
| UX-F5 Switch the viewed repository | Terminology (*repository selector*, *path*); Message patterns § Error | The startup failure wording is reused for a chosen path. |
| UX-I2 No refresh control, no ceremony | Voice (nothing asks for attention); Terminology (*live refresh* is never a verb) | |
| UX-I4 The view never lies | Voice (say what was observed); Message patterns § Error, § Partial | |
| UX-I6 Every message at the no-learning-curve bar | Message patterns § Error; Accessibility of text (the reading bar) | UX-I6 fixes what a message carries; this document fixes how it is worded. |
| UX-I12 Markdown, links, remote images | Message patterns § Partial; Accessibility of text (link text) | The reader's own link text is never rewritten. |
| UX-I13 No indicator before observation | Message patterns § Empty, § Loading | *"Nothing has changed"* only after reading. |
| UX-I14 A route out on the same surface | Message patterns § Error (the third part of the formula) | |
| UX-A1 The declared posture | Terminology § Standing sentences | No claim beyond it anywhere. |
| UX-A2 No meaning by hue alone | Accessibility of text (first two rules) | The verbal half of the rule. |
| UX-A3 The posture sentence on the README | Terminology § Standing sentences | The wording UX-A3 asks this document for. |
| UX-A4 No control by glyph alone | Accessibility of text (alternative text) | |
| UX-I11 Public pictures tell the same truth | Not covered — out of scope here | A picture is not a string; UX-I11 binds the picture. |
| PRD § Goals "Pick-it-up adoption" (the README's first screen) | Tone § first-run flow; Terminology § Standing sentences | What the README claims is the PRD's; how it is worded is this document's. |

## CONTENT Review Notes

- **RN-1:** § Voice opens by scoping every rule to *the words Nozoki writes, not the words it
  shows* — *because* this product's screen is mostly the reader's own text (code, Markdown, file
  and branch names, commit messages), and a verbal language that did not say so would read as a
  licence to normalise somebody's repository. No other document states the line: `docs/UXD.md`
  UX-I12 governs how the reader's Markdown is presented, not whether it is edited.
- **RN-2:** The voice behaviours are written against strings this run wrote, because the product
  has no strings yet: the only person-facing text in the repository is `README.md`, and the
  running product does not exist (`README.md`, *"Status: proposal — not yet implemented"*). Each
  behaviour was derived by drafting the sentence first and the rule from it, so every rule in the
  table has been applied to at least one real state from `docs/UXD.md` § 6.
- **RN-3:** *Reassuring* is named as a trait to avoid, which is unusual for a product whose whole
  claim is safety — *because* the claim is architectural (`docs/SRS.md` NFR-5 – NFR-9) and a
  screen that repeats it is a product arguing for something the build already guarantees. The
  promise is stated where a promise belongs, in one wording, and nowhere else.
- **RN-4:** The Loading pattern ends its message with a full stop rather than an ellipsis,
  although `docs/DESIGN.md` § Components ("Status messages") describes a pending state as showing
  *"the word pending"* — *because* two conventions collided and only one character was available:
  `…` already marks a control that opens a chooser (*Browse…*, `docs/DESIGN.md` § Components,
  "The menu"), and one character with two meanings is a code the reader has to learn. *Pending*
  was also a word about the tool's internal state rather than about what it was doing, so the
  pattern names the thing being read instead. This changes an example in the design language, not
  a token or a rule of it, and it is raised to the CDO rather than applied silently.
- **RN-5:** *Diff* is kept and *binary* is banned, although both are terms a non-developer would
  have to look up — *because* the stated expertise floor is a reader who "can find their way
  around a repository on GitHub and follow a README" (`docs/PRD.md` § Goals, "No learning curve"),
  which is a reader who has met a diff on a hosting site and has not necessarily met file
  encodings. The two words are treated differently on that evidence, not on how technical they
  sound.
- **RN-6:** § Terminology renames three words the shipped `README.md` uses today — *project*,
  *workspace* and *codebase*, all for one concept, in a file that also says *repository* twice.
  The rename costs a README revision and nothing else while the product has no strings, which is
  the cheapest this decision will ever be. It is a call the owner is asked to confirm
  (`docs/CONTENT_open_issues.md` § 2.5).
- **RN-7:** *Tree* alone is rejected for the sidebar's list — *because* `docs/PRD.md` uses "the
  tree" for both that list and the repository's files on disk ("watch a moving tree", "the tree
  they expanded"), which is one word doing two jobs in the document this one derives from. This is
  a wording decision inside two concepts the PRD already holds separately; it asks the CPO for
  nothing.
- **RN-8:** The Recovered pattern is *no message at all*, which is the only pattern here with no
  string — *because* `docs/UXD.md` UX-I2 states that updates arrive with no notification and no
  attention bid, and a recovery is an update. The pattern exists rather than being omitted so that
  the next person to write a recovery message finds the decision already made, with its reason.
- **RN-9:** § Grammar states that the Git view's headings are written in sentence case and
  displayed in capitals — *because* `docs/DESIGN.md` § Typography sets `{typography.label}` in
  uppercase, and a string typed in capitals in the source would be both a duplicated decision and
  an untranslatable one. The visual transform is the design language's; the source string is this
  document's.
- **RN-10:** No duration appears in any message, and a wait is ended by a named condition —
  *because* the product's own refresh threshold is undecided (`docs/PRD.md` § Success Metrics
  "Refresh immediacy", *"exact latency threshold TBD"*), so any number in a string would be one
  nobody has measured. When that threshold is set, this rule is revisited rather than assumed to
  have changed.
- **RN-11:** § Accessibility of text declares a reading bar as three permitted sources of words
  rather than as a grade level — *because* no reading-level standard is claimed anywhere in this
  product's documents, and a grade is not checkable by a person holding one string. The three
  sources are checkable that way, which is the test this document is written to.
- **RN-12:** The Git status letters are raised as an open issue rather than settled here
  (`docs/CONTENT_open_issues.md` § 1.2) — *because* the two ways to expand them are a change to
  the Git view, which is the CDO's, or a line in the README, which is the CPO's surface. This
  document holds the interim rule (the README carries the expansion) so that no release ships with
  the letters unexplained while the question is open. `docs/UXD.md` UX-A2 permits a letter as the
  cue that survives without colour, and this note does not reopen that: the question here is
  whether the letter can be understood at all, not whether it survives without colour.
- **RN-13:** § Localization holds, although `docs/PRD.md` § UX Notes fixes the UI language as
  English and no translation is planned — *because* every rule in it constrains how a string is
  written rather than requiring a translation, and each is unaffordable to apply once strings
  exist. The context note beside each string has a reader either way: the next person to change
  that string.
- **RN-14:** § Terminology carries a *Standing sentences* table, which is the one place this
  document holds actual wording rather than rules about wording — *because* a promise stated in
  two wordings is two promises, and the rule for these sentences is precisely that the words do
  not vary. Their shelf life is the test the template sets, and each survives the next feature;
  the pre-1.0.0 sentence carries its own retirement condition in the table.
- **RN-15:** This document quotes and cites only files a reader who has cloned this repository can
  open. Where a rule here restates a limit this product inherits from the organisation that
  publishes it, the limit is written as Nozoki's own rule in Nozoki's own words, with no pointer
  to a file outside the repository — a pointer a reader cannot follow is worse than no pointer.
  The house writing bar that governs documents authored for this product asks for a locator on
  every claim about another file's contents; naming no outside file means no such claim is made,
  so nothing is owed. This is recorded here rather than settled silently, as that bar requires of
  a conflict between itself and a document's own template.

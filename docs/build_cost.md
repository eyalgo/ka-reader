# What building ka-reader cost

ka-reader was built by KensaiApp's roles, each step a Claude Code run. From 2026-10-08 to 2026-11-19 that took **978 runs**, **24,709 model requests** and **$2,073.15** of Claude usage. One change, every walk it took counted, typically cost **$23.12**.

Every figure below is what Claude Code reported for each request, never a price worked out from tokens. Runs on Codex, and interactive sessions, are not counted. How each figure is measured is at the end. A step is one of KensaiApp's skills; its [glossary](https://github.com/eyalgo/kensaiapp/blob/main/about/glossary.md) says what each one does. The figures start when telemetry was first received for this project; work done before 2026-10-08 is not in them.

## Cost by model and effort

| model · effort | runs | entry | peak, median | peak, max | requests/run | minutes/run | $/run | $ total | cache hit |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| claude-opus-5-5 · high | 264 | 23,996 | 160,762 | 412,632 | 36 | 6.2 | $3.01 | $794.51 | 96.7% |
| claude-fable-5-1 · high | 81 | 27,127 | 194,536 | 497,602 | 16 | 9.2 | $7.50 | $607.44 | 90.3% |
| claude-sonnet-5-5 · medium | 487 | 24,369 | 79,755 | 414,455 | 12 | 1.2 | $0.81 | $392.70 | 95.4% |
| claude-opus-5-5 · medium | 77 | 26,417 | 136,210 | 215,747 | 33 | 4.4 | $2.05 | $157.86 | 96.3% |
| claude-fable-5-1 · medium | 28 | 25,062 | 127,758 | 215,738 | 14 | 3.8 | $3.67 | $102.65 | 89.1% |
| claude-sonnet-5-5 · low | 27 | 23,815 | 52,432 | 60,867 | 9 | 0.7 | $0.27 | $7.23 | 89.2% |
| claude-sonnet-5-5 · high | 4 | 24,767 | 166,058 | 184,545 | 22 | 4.5 | $1.18 | $4.74 | 93.9% |
| claude-opus-5-5 · default | 4 | 24,530 | 98,991 | 105,172 | 14 | 1.5 | $1.10 | $4.41 | 90.4% |
| qwen3-coder:30b · default | 2 | 6,180 | 34,854 | 41,847 | 40 | 3.3 | $0.77 | $1.54 | 96.9% |
| claude-haiku-5-5 · low | 3 | 24,820 | 48,492 | 77,829 | 12 | 0.7 | $0.02 | $0.06 | 89.6% |
| claude-haiku-5-5 · medium | 1 | 25,037 | 64,271 | 64,271 | 15 | 1.1 | $0.02 | $0.02 | 91.3% |

## Context: where each run starts and how large it grows

A run starts with its instructions and the files it is handed (*entry*). Each request then carries the whole conversation so far, so the context grows until the run ends (*peak*). The line is the 250,000-token cap the change chain sets on a developer run; it takes effect only once the task in progress finishes, so a run can pass it.

```mermaid
xychart-beta
    title "Peak context per run, median, by step"
    x-axis ["product-sdd", "companion-self-answer (SDD)", "implementation", "code-integrity", "specs", "shukuba-refine", "product-architecture", "design", "security", "companion-self-answer (architecture)", "audit", "content"]
    y-axis "tokens" 0 --> 283630
    bar [217064, 185232, 257846, 206720, 193041, 153704, 137262, 242686, 127758, 127842, 65676, 164198]
    line [250000, 250000, 250000, 250000, 250000, 250000, 250000, 250000, 250000, 250000, 250000, 250000]
```

| step | runs | entry | peak, median | peak, max | over the cap | requests/run | minutes/run | $/run | $ total | cache hit |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| product-sdd | 41 | 27,403 | 217,064 | 497,602 | 16 | 16 | 10.9 | $8.31 | $340.79 | 90.2% |
| companion-self-answer (SDD) | 40 | 27,124 | 185,232 | 342,688 | 7 | 16 | 8.4 | $6.67 | $266.65 | 90.5% |
| development-implementation | 104 | 25,056 | 257,846 | 414,455 | 56 | 44 | 32.4 | $2.11 | $219.74 | 97.2% |
| development-code-integrity | 44 | 25,066 | 206,720 | 367,577 | 16 | 51 | 51.1 | $4.26 | $187.62 | 97.3% |
| development-specs | 44 | 23,734 | 193,041 | 268,531 | 3 | 52 | 10.0 | $3.68 | $162.13 | 97.2% |
| shukuba-refine | 42 | 27,220 | 153,704 | 215,747 | 0 | 41 | 5.4 | $2.66 | $111.52 | 96.8% |
| product-architecture | 50 | 24,734 | 137,262 | 229,117 | 0 | 33 | 4.7 | $2.23 | $111.32 | 96.3% |
| development-design | 21 | 23,991 | 242,686 | 412,632 | 9 | 53 | 12.0 | $5.10 | $107.06 | 97.1% |
| development-security | 28 | 25,062 | 127,758 | 215,738 | 0 | 14 | 3.8 | $3.67 | $102.65 | 89.1% |
| companion-self-answer (architecture) | 48 | 24,802 | 127,842 | 212,966 | 0 | 28 | 4.0 | $2.13 | $102.11 | 95.9% |
| development-audit | 188 | 24,194 | 65,676 | 113,290 | 0 | 11 | 1.1 | $0.37 | $68.92 | 88.9% |
| development-content | 23 | 23,182 | 164,198 | 231,131 | 0 | 24 | 5.6 | $2.34 | $53.86 | 94.1% |
| development-plan | 40 | 24,324 | 121,372 | 238,196 | 0 | 18 | 2.5 | $0.94 | $37.67 | 93.1% |
| changelog-line | 26 | 23,897 | 80,624 | 97,394 | 0 | 18 | 1.7 | $1.01 | $26.25 | 92.5% |
| tobiishi-seal | 44 | 27,162 | 97,521 | 128,325 | 0 | 12 | 1.2 | $0.52 | $22.90 | 89.9% |
| nemawashi-refine | 9 | 26,937 | 139,937 | 188,748 | 0 | 30 | 3.8 | $2.23 | $20.08 | 96.1% |
| tobiishi-open | 48 | 27,140 | 73,710 | 104,528 | 0 | 10 | 0.8 | $0.39 | $18.59 | 88.7% |
| product-fdr | 6 | 26,132 | 149,530 | 292,176 | 1 | 32 | 4.1 | $2.70 | $16.21 | 96.5% |
| companion-self-answer (FDR) | 4 | 24,302 | 171,854 | 226,502 | 0 | 29 | 3.8 | $2.46 | $9.84 | 95.3% |
| shukuba-open | 23 | 26,481 | 61,534 | 91,762 | 0 | 11 | 0.8 | $0.33 | $7.61 | 89.1% |
| shukuba-retire | 26 | 23,872 | 53,272 | 60,867 | 0 | 10 | 0.7 | $0.28 | $7.29 | 89.6% |
| product-srs | 4 | 27,424 | 116,294 | 165,242 | 0 | 27 | 2.7 | $1.73 | $6.91 | 95.3% |
| product-prd | 4 | 27,326 | 126,732 | 138,889 | 0 | 24 | 4.1 | $1.69 | $6.74 | 94.6% |
| companion-self-answer (SRS) | 3 | 27,145 | 142,110 | 174,702 | 0 | 21 | 3.2 | $1.96 | $5.88 | 93.7% |
| companion-self-answer (CONTENT) | 4 | 24,767 | 166,058 | 184,545 | 0 | 22 | 4.5 | $1.18 | $4.74 | 93.9% |
| product-design | 2 | 27,966 | 145,682 | 173,872 | 0 | 40 | 4.9 | $2.34 | $4.68 | 96.8% |
| seeds-from-product-docs | 5 | 25,335 | 130,106 | 158,433 | 0 | 22 | 2.0 | $0.87 | $4.34 | 93.7% |
| stations-from-seed | 10 | 26,464 | 75,160 | 133,748 | 0 | 11 | 0.9 | $0.41 | $4.06 | 89.8% |
| companion-self-answer (PRD) | 3 | 27,148 | 113,497 | 118,937 | 0 | 17 | 1.9 | $1.33 | $3.98 | 93.1% |
| readme-status | 12 | 22,789 | 56,790 | 97,581 | 0 | 9 | 0.6 | $0.32 | $3.86 | 87.7% |
| product-card | 3 | 24,294 | 100,834 | 105,172 | 0 | 14 | 1.7 | $1.17 | $3.52 | 90.6% |
| product-uxd | 1 | 27,985 | 193,826 | 193,826 | 0 | 43 | 7.5 | $3.30 | $3.30 | 96.9% |
| companion-self-answer (UXD) | 1 | 27,148 | 208,010 | 208,010 | 0 | 38 | 6.6 | $3.30 | $3.30 | 96.2% |
| nemawashi-pick | 8 | 26,420 | 53,936 | 85,709 | 0 | 10 | 0.7 | $0.40 | $3.18 | 89.9% |
| companion-self-answer (DESIGN) | 2 | 27,134 | 133,592 | 164,645 | 0 | 16 | 1.9 | $1.52 | $3.04 | 91.6% |
| companion-self-answer (fdr) | 1 | 24,817 | 171,805 | 171,805 | 0 | 31 | 4.8 | $2.58 | $2.58 | 95.7% |
| product-content | 4 | 25,738 | 93,700 | 133,811 | 0 | 14 | 1.2 | $0.58 | $2.32 | 91.7% |
| first-what-left | 1 | 25,594 | 143,209 | 143,209 | 0 | 37 | 6.3 | $2.02 | $2.02 | 95.8% |
| red-behaviour | 2 | 24,197 | 80,009 | 96,405 | 0 | 14 | 2.0 | $0.96 | $1.92 | 90.8% |
| nemawashi-unpick | 1 | 25,929 | 89,288 | 89,288 | 0 | 11 | 0.7 | $0.89 | $0.89 | 89.4% |
| seed-pick | 2 | 27,158 | 62,305 | 68,223 | 0 | 10 | 0.6 | $0.31 | $0.61 | 89.2% |
| nemawashi-retire | 5 | 23,719 | 47,487 | 77,829 | 0 | 11 | 0.7 | $0.09 | $0.46 | 88.4% |
| dependency-repair | 1 | 25,037 | 64,271 | 64,271 | 0 | 15 | 1.1 | $0.02 | $0.02 | 91.3% |

## Writing the product's documents

Before any change, KensaiApp's definition roles write the product down, document by document. Each document's run parks what it cannot settle in a companion file of open questions, and a later run answers them and writes the document again. Writing the documents cost **$894.60** in all.

| document | runs | writing | answering its questions | total |
|---|--:|--:|--:|--:|
| SDD | 81 | $340.79 | $266.65 | $607.44 |
| architecture | 98 | $111.32 | $102.11 | $213.43 |
| FDR | 10 | $16.21 | $9.84 | $26.05 |
| SRS | 7 | $6.91 | $5.88 | $12.80 |
| PRD | 7 | $6.74 | $3.98 | $10.72 |
| DESIGN | 4 | $4.68 | $3.04 | $7.71 |
| CONTENT | 8 | $2.32 | $4.74 | $7.05 |
| project card | 3 | $3.52 | $0.00 | $3.52 |
| UXD | 1 | $0.00 | $3.30 | $3.30 |
| fdr | 1 | $0.00 | $2.58 | $2.58 |

## What a change costs

40 changes were walked to their seal. A change typically cost **$23.12**, the highest $59.33, $1,100.89 in all. 14 of them halted and were resumed, so their cost spans more than one walk; each change is counted whole. 1 more were not sealed when the data ends, dropped or still being walked, and are left out.

```mermaid
xychart-beta
    title "Cost of each sealed change, in the order they were opened, USD"
    x-axis ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40"]
    y-axis "USD" 0 --> 65
    bar [6.53, 11.42, 10.5, 15.38, 16.89, 17.56, 15.09, 26.3, 20.27, 17.68, 22.56, 13.18, 18.49, 16.09, 23.41, 16.05, 15.86, 49.74, 59.33, 50.96, 27.91, 39.34, 31.81, 45.97, 39.67, 32.61, 20.49, 35.15, 32.75, 24.96, 32.65, 22.83, 20.34, 21.29, 36.35, 46.32, 40.68, 22.62, 35.46, 48.4]
```

## What a walk costs

A walk is one launch of a chain, and every run it started: *walk* carries a change from its station to its seal and the review after it, *change* carries a change toward its seal (the older chain), *product* and *agari* write the product's documents, *build-idea* moves the journey between changes.

| chain | walks | median | highest | total |
|---|--:|--:|--:|--:|
| product | 49 | $17.10 | $67.08 | $878.44 |
| walk | 39 | $20.34 | $59.33 | $785.20 |
| change | 30 | $10.05 | $26.30 | $322.25 |
| (none) | 1 | $47.90 | $47.90 | $47.90 |
| build-idea | 15 | $0.85 | $4.99 | $26.06 |
| development | 3 | $4.72 | $5.77 | $13.30 |

## The most expensive runs

| started (UTC) | step | model · effort | cost | requests | peak | minutes |
|---|---|---|--:|--:|--:|--:|
| 2026-11-18 21:38 | product-sdd | claude-fable-5-1 · high | $18.86 | 20 | 497,602 | 39 |
| 2026-11-06 16:19 | companion-self-answer (SDD) | claude-fable-5-1 · high | $17.78 | 49 | 207,994 | 24 |
| 2026-11-10 22:15 | product-sdd | claude-fable-5-1 · high | $16.92 | 23 | 399,711 | 35 |
| 2026-11-14 21:37 | product-sdd | claude-fable-5-1 · high | $15.00 | 21 | 440,541 | 23 |
| 2026-11-06 15:56 | product-sdd | claude-fable-5-1 · high | $13.87 | 19 | 365,610 | 23 |

## Cost by week

```mermaid
xychart-beta
    title "Claude cost by week, USD"
    x-axis ["2026-W41", "2026-W42", "2026-W43", "2026-W44", "2026-W45", "2026-W46", "2026-W47"]
    y-axis "USD" 0 --> 807
    bar [12.86, 298.2, 210.58, 131.38, 733.64, 503.94, 182.55]
```

## How it was measured

- Source: the OpenTelemetry events Claude Code sent while the runs worked, received by ka-telemetry, keeping the runs labelled `kensai.instance=kensaiapp-opensource` and `kensai.project=ka-reader`.
- A run is one `kensai.run_id`. Only `claude_code.api_request` events of the main agent count; helper calls inside a run, such as a web search or fetch, are left out.
- A request's context is its input + cache-read + cache-write tokens. *Entry* is a run's first request's context, *peak* its largest.
- *Cost* is the `cost_usd` Claude Code reported. *$/run* is the average, so runs × $/run is the total. *Cache hit* is cache-read tokens over all input tokens.
- *Minutes* run from a run's first request to its last. A walk is every run sharing one `kensai.walk_id`.
- A change is the walks of the walk, change and development chains from one walk that opens it and writes its spec to the next, in start order; a project walks one change at a time. A walk that only opened a change counts toward the change after it. A change counts once a walk sealed it.
- A run started by a launcher arm rather than a skill, such as the self-answer of a document's open questions, is named by that arm and the document.
- Generated 2026-11-19 from data up to 2026-11-19 07:43 UTC.

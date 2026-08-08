#!/usr/bin/env node
/**
 * Two rules Nozoki holds, checked rather than remembered.
 *
 * 1. NO RUNTIME NETWORK. SRS NFR-8: "The system makes no network call during operation — none,
 *    not merely no non-essential." AC-3 monitors for zero outbound traffic across a full session
 *    at every release. A CDN reference in a stylesheet or a component would fail that check the
 *    moment it shipped, so it fails here first. Fonts are self-hosted; icons are vendored.
 *
 * 2. NO TOOLING EXHAUST. The design language was authored with an external design-system tool.
 *    Its card markers, compiled bundles, manifests and skill wrappers are that tool's furniture,
 *    not Nozoki, and a public MIT repository should read as the product and nothing else.
 *
 * Usage: node scripts/design-check.mjs [--verbose]
 * Exits 0 when clean, 1 on the first rule broken. Scans git-tracked files only.
 */

import { execFileSync } from 'node:child_process'
import { readFileSync, statSync } from 'node:fs'

const RULES = [
  {
    rule: 'no-runtime-network',
    why: 'SRS NFR-8 — no network call during operation; AC-3 checks zero outbound traffic at every release',
    patterns: [
      /https?:\/\/[^\s'"()]*unpkg\.com/i,
      /https?:\/\/[^\s'"()]*fonts\.googleapis\.com/i,
      /https?:\/\/[^\s'"()]*fonts\.gstatic\.com/i,
      /https?:\/\/[^\s'"()]*cdn[.\-][^\s'"()]*/i,
      /https?:\/\/[^\s'"()]*jsdelivr\.net/i,
    ],
  },
  {
    rule: 'no-tooling-exhaust',
    why: 'a public repository should read as the product, not as the tools used to build it',
    patterns: [/@dsCard/, /_ds_bundle/, /_ds_manifest/, /NozokiDesignSystem_/, /\bclaude\b/i], // design-check: allow no-tooling-exhaust
  },
]

// Binary and vendored-notice files carry no rules of ours.
const SKIP = /(^|\/)(third_party\/lucide\/LICENSE)$|\.(png|jpe?g|gif|webp|ico|woff2?|ttf|otf|pdf|zip)$/i

// A file may exempt one rule on one line with a trailing `design-check: allow <rule>`,
// so that documenting a forbidden thing is possible without weakening the check.
const allows = (line, rule) => new RegExp(`design-check:\\s*allow\\s+${rule}\\b`).test(line)

const verbose = process.argv.includes('--verbose')
// Tracked files plus anything new that is not ignored — so the check is meaningful before
// a commit, not only after one.
const files = execFileSync(
  'git',
  ['ls-files', '-z', '--cached', '--others', '--exclude-standard'],
  { encoding: 'utf8' },
)
  .split('\0')
  .filter((f) => f && !SKIP.test(f))

const failures = []
let scanned = 0

for (const file of files) {
  let text
  try {
    if (statSync(file).size > 2_000_000) continue
    text = readFileSync(file, 'utf8')
  } catch {
    continue // unreadable or not valid UTF-8: nothing textual to check
  }
  scanned++
  const lines = text.split('\n')
  for (const { rule, why, patterns } of RULES) {
    for (const pattern of patterns) {
      lines.forEach((line, i) => {
        const hit = line.match(pattern)
        if (hit && !allows(line, rule)) {
          failures.push({ file, line: i + 1, rule, why, match: hit[0].slice(0, 80) })
        }
      })
    }
  }
}

if (failures.length === 0) {
  console.log(`design-check: clean — ${scanned} files, ${RULES.length} rules`)
  process.exit(0)
}

const byRule = new Map()
for (const f of failures) {
  if (!byRule.has(f.rule)) byRule.set(f.rule, [])
  byRule.get(f.rule).push(f)
}
for (const [rule, hits] of byRule) {
  console.error(`\n${rule} — ${hits[0].why}`)
  for (const h of verbose ? hits : hits.slice(0, 10)) {
    console.error(`  ${h.file}:${h.line}  ${h.match}`)
  }
  if (!verbose && hits.length > 10) console.error(`  … and ${hits.length - 10} more (--verbose)`)
}
console.error(`\ndesign-check: ${failures.length} violation(s) across ${byRule.size} rule(s)`)
process.exit(1)

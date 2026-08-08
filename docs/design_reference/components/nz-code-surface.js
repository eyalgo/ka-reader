import { NzElement, css, esc } from './base.js'

/**
 * The dominant reading surface: read-only, monospace, syntax-highlighted, with line numbers.
 * There is no editing affordance here and no framing that implies one exists elsewhere —
 * read-only is nozoki's identity, not a mode (UX-I1).
 *
 * The highlighter is deliberately small: it demonstrates the palette's roles, it is not the
 * product's. The real one is Monaco (docs/proposal.md).
 *
 * Set the source as a property: `el.code = '...'`.
 */
const RULES = [
  [/(\/\/[^\n]*|#[^\n]*|\/\*[\s\S]*?\*\/)/g, 'var(--code-comment)'],
  [/("(?:[^"\\]|\\.)*"|'(?:[^'\\]|\\.)*'|`(?:[^`\\]|\\.)*`)/g, 'var(--code-string)'],
  [
    /\b(const|let|var|function|return|import|from|export|class|extends|if|else|for|while|new|await|async|type|interface|readonly|public|private)\b/g,
    'var(--code-keyword)',
  ],
  [/\b(\d+(?:\.\d+)?)\b/g, 'var(--code-number)'],
]

function highlight(line) {
  const marks = []
  for (const [re, color] of RULES) {
    re.lastIndex = 0
    let m
    while ((m = re.exec(line))) {
      const start = m.index
      const end = start + m[0].length
      if (marks.some((k) => start < k.end && end > k.start)) continue
      marks.push({ start, end, color })
    }
  }
  marks.sort((a, b) => a.start - b.start)

  let out = ''
  let i = 0
  for (const k of marks) {
    if (k.start > i) out += esc(line.slice(i, k.start))
    out += `<span style="color:${k.color}">${esc(line.slice(k.start, k.end))}</span>`
    i = k.end
  }
  return out + esc(line.slice(i))
}

export class NzCodeSurface extends NzElement {
  static observedAttributes = ['start-line']
  static styles = css`
    :host {
      display: block; height: 100%;
      background: var(--surface-panel);
      font: var(--type-code);
      overflow: auto;
    }
    .pad { padding: var(--space-4) 0; }
    .line { display: flex; }
    .n {
      width: 52px; flex: 0 0 auto; text-align: right;
      padding-right: var(--space-5);
      color: var(--text-disabled);
      user-select: none;
    }
    .src { white-space: pre; padding-right: var(--space-6); color: var(--text-code); }
  `

  #code = ''

  set code(value) {
    this.#code = String(value ?? '')
    if (this.isConnected) this.render()
  }

  get code() {
    return this.#code
  }

  render() {
    const start = this.num('start-line', 1)
    const lines = this.#code.replace(/\n$/, '').split('\n')
    this.shadowRoot.innerHTML = `<div class="pad">${lines
      .map((l, i) => `<div class="line"><span class="n">${start + i}</span><span class="src">${highlight(l)}</span></div>`)
      .join('')}</div>`
  }
}

customElements.define('nz-code-surface', NzCodeSurface)

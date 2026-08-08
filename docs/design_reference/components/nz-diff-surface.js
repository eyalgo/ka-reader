import { NzElement, css, esc } from './base.js'

/**
 * A read-only diff (beyond v1). The same presentation serves a working-tree diff and a
 * per-commit diff (UX-F4). Presenting the staged state stages nothing — there are no
 * stage/unstage controls, because no user action changes the repository (UX-I7).
 *
 * Staged and unstaged are told apart by the heading and by the +/- sign in the gutter, never
 * by colour alone (UX-A2).
 *
 * Set the content as a property: `el.hunks = [{ header, lines }]`.
 */
export class NzDiffSurface extends NzElement {
  static observedAttributes = ['staged']
  static styles = css`
    :host { display: block; height: 100%; background: var(--surface-panel); overflow: auto; }
    .head {
      display: flex; align-items: center; gap: var(--space-4);
      height: 26px; padding: 0 var(--space-5);
      border-bottom: var(--hairline);
      font: var(--type-section);
      letter-spacing: var(--tracking-caps);
      text-transform: uppercase;
      color: var(--text-tertiary);
    }
    .hunk-head {
      font: var(--type-code-sm);
      color: var(--text-tertiary);
      background: var(--diff-gutter);
      padding: var(--space-1) var(--space-5);
    }
    .line { display: flex; font: var(--type-code); }
    .line.add { background: var(--diff-added-bg); }
    .line.del { background: var(--diff-removed-bg); }
    .sign {
      width: 20px; flex: 0 0 auto; text-align: center;
      color: var(--text-tertiary); user-select: none;
    }
    .src { white-space: pre; color: var(--text-code); }
  `

  #hunks = []

  set hunks(value) {
    this.#hunks = Array.isArray(value) ? value : []
    if (this.isConnected) this.render()
  }

  get hunks() {
    return this.#hunks
  }

  render() {
    const body = this.#hunks
      .map(
        (h) =>
          `<div class="hunk-head">${esc(h.header)}</div>` +
          h.lines
            .map((l) => {
              const sign = l[0]
              const kind = sign === '+' ? 'add' : sign === '-' ? 'del' : ''
              return `<div class="line ${kind}"><span class="sign">${sign === ' ' ? '' : esc(sign)}</span><span class="src">${esc(l.slice(1))}</span></div>`
            })
            .join(''),
      )
      .join('')

    this.shadowRoot.innerHTML = `<div class="head">${this.bool('staged') ? 'Staged changes' : 'Changes'}</div>${body}`
  }
}

customElements.define('nz-diff-surface', NzDiffSurface)

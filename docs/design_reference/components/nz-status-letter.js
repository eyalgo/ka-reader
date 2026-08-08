import { NzElement, css, esc } from './base.js'

/**
 * Git's own status letter. The single most load-bearing rule in the system: state is a letter
 * first, a colour second. Never a coloured dot, never translated — the letters are Git's, and
 * removing all colour must leave the Git view still readable (UX-A2).
 */
const MEANING = {
  A: ['var(--git-added)', 'Added'],
  M: ['var(--git-modified)', 'Modified'],
  D: ['var(--git-deleted)', 'Deleted'],
  U: ['var(--git-untracked)', 'Untracked'],
  R: ['var(--git-renamed)', 'Renamed'],
  C: ['var(--git-conflict)', 'Conflicted'],
}

export class NzStatusLetter extends NzElement {
  static observedAttributes = ['status']
  static styles = css`
    :host {
      font: var(--type-status-letter);
      width: 12px;
      text-align: center;
      display: inline-block;
      flex: 0 0 auto;
      color: var(--text-tertiary);
    }
  `

  render() {
    const status = this.attr('status')
    const [color, label] = MEANING[status] || ['var(--text-tertiary)', status]
    this.style.color = color
    this.setAttribute('title', label)
    this.setAttribute('aria-label', label)
    this.shadowRoot.innerHTML = esc(status)
  }
}

customElements.define('nz-status-letter', NzStatusLetter)

import { NzElement, css, esc } from './base.js'
import './nz-icon.js'

/** Where a branch currently points, readable in the graph itself (beyond v1). */
export class NzBranchChip extends NzElement {
  static observedAttributes = ['name', 'current']
  static styles = css`
    :host {
      display: inline-flex; align-items: center; gap: var(--space-2);
      height: 16px; padding: 0 var(--space-3);
      border-radius: var(--radius-pill);
      background: var(--surface-active); color: var(--text-secondary);
      font: var(--type-meta);
    }
    :host([current]) { background: var(--accent-quiet); color: var(--text-accent); }
  `

  render() {
    this.shadowRoot.innerHTML = `<nz-icon name="git-branch" size="11"></nz-icon>${esc(this.attr('name'))}`
  }
}

customElements.define('nz-branch-chip', NzBranchChip)

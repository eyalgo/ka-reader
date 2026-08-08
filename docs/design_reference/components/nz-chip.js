import { NzElement, css } from './base.js'

/** A small count or label. Reports state; never bids for attention. */
export class NzChip extends NzElement {
  static observedAttributes = ['tone', 'pill']
  static styles = css`
    :host {
      font: var(--type-meta);
      padding: 1px var(--space-3);
      border-radius: var(--radius-sm);
      display: inline-flex;
      align-items: center;
      min-height: 16px;
      background: var(--surface-active);
      color: var(--text-secondary);
    }
    :host([pill]) { border-radius: var(--radius-pill); }
    :host([tone='accent']) { background: var(--accent-quiet); color: var(--text-accent); }
    :host([tone='outline']) {
      background: transparent;
      color: var(--text-secondary);
      box-shadow: inset 0 0 0 var(--border-width) var(--border-default);
    }
  `

  render() {
    if (!this.shadowRoot.firstChild) this.shadowRoot.innerHTML = '<slot></slot>'
  }
}

customElements.define('nz-chip', NzChip)

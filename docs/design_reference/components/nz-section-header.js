import { NzElement, css, esc } from './base.js'
import './nz-icon.js'
import './nz-chip.js'

/** A group heading in the sidebar — CHANGES, STAGED. The only uppercase in the system. */
export class NzSectionHeader extends NzElement {
  static observedAttributes = ['label', 'count', 'collapsed', 'collapsible']
  static styles = css`
    :host { display: block; }
    .row {
      display: flex; align-items: center; gap: var(--space-2);
      height: var(--row-height); padding: 0 var(--space-4);
      font: var(--type-section);
      letter-spacing: var(--tracking-caps);
      text-transform: uppercase;
      color: var(--text-tertiary);
      transition: var(--transition-hover);
      cursor: default;
    }
    :host([collapsible]) .row { cursor: pointer; }
    :host([collapsible]) .row:hover { background: var(--surface-hover); }
    nz-chip { margin-left: auto; }
  `

  connectedCallback() {
    super.connectedCallback()
    this.addEventListener('click', () => {
      if (!this.bool('collapsible')) return
      this.toggleAttribute('collapsed')
      this.emit('toggle', { collapsed: this.bool('collapsed') })
    })
  }

  render() {
    const chevron = this.bool('collapsible')
      ? `<nz-icon name="${this.bool('collapsed') ? 'chevron-right' : 'chevron-down'}" size="12"></nz-icon>`
      : ''
    const count = this.hasAttribute('count') ? `<nz-chip>${esc(this.attr('count'))}</nz-chip>` : ''
    this.shadowRoot.innerHTML = `<div class="row">${chevron}<span>${esc(this.attr('label'))}</span>${count}</div>`
  }
}

customElements.define('nz-section-header', NzSectionHeader)

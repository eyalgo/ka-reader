import { NzElement, css, esc } from './base.js'
import './nz-icon.js'
import './nz-status-letter.js'

/**
 * One row of the file tree. Selection is a tint plus a 2px bar on the left edge — the bar is
 * the colour-free cue. A file gone from disk is struck through, not merely greyed: the view
 * never lies (UX-I4), and the strike survives without colour (UX-A2).
 */
export class NzTreeRow extends NzElement {
  static observedAttributes = ['name', 'kind', 'depth', 'expanded', 'selected', 'unfocused', 'status', 'missing']
  static styles = css`
    :host { display: block; }
    .row {
      display: flex; align-items: center; gap: var(--space-2);
      height: var(--row-height);
      padding-right: var(--space-4);
      font: var(--type-tree);
      color: var(--text-secondary);
      cursor: pointer;
      transition: var(--transition-hover);
      background: transparent;
    }
    .row:hover { background: var(--surface-hover); }
    :host([selected]) .row {
      background: var(--surface-selected);
      color: var(--text-primary);
      box-shadow: inset 2px 0 0 var(--border-accent);
    }
    :host([selected][unfocused]) .row {
      background: var(--surface-inactive-selected);
      box-shadow: none;
    }
    :host([missing]) .row { color: var(--text-disabled); }
    :host([missing]) .label { text-decoration: line-through; }
    .twist { width: 12px; display: inline-flex; color: var(--text-tertiary); }
    .glyph { display: inline-flex; color: var(--text-tertiary); }
    .label { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    nz-status-letter { margin-left: auto; }
  `

  connectedCallback() {
    super.connectedCallback()
    this.addEventListener('click', () => this.emit('select', { name: this.attr('name') }))
  }

  render() {
    const folder = this.attr('kind', 'file') === 'folder'
    const expanded = this.bool('expanded')
    const twist = folder
      ? `<nz-icon name="${expanded ? 'chevron-down' : 'chevron-right'}" size="12"></nz-icon>`
      : ''
    const glyph = folder ? (expanded ? 'folder-open' : 'folder') : 'file'
    const status = this.hasAttribute('status')
      ? `<nz-status-letter status="${esc(this.attr('status'))}"></nz-status-letter>`
      : ''

    this.shadowRoot.innerHTML = `
      <div class="row" style="padding-left:${8 + this.num('depth', 0) * 12}px">
        <span class="twist">${twist}</span>
        <span class="glyph"><nz-icon name="${glyph}" size="14"></nz-icon></span>
        <span class="label">${esc(this.attr('name'))}</span>
        ${status}
      </div>`
  }
}

customElements.define('nz-tree-row', NzTreeRow)

import { NzElement, css, esc } from './base.js'
import './nz-icon.js'

/**
 * The repository's name in the shell chrome IS the control that changes it (UX-F5, RN-15).
 * On first run the list holds only the browse entry (UX-S7).
 *
 * Set the list as a property, not an attribute: `el.repositories = [{name, path}]`.
 */
export class NzRepositorySelector extends NzElement {
  static observedAttributes = ['name', 'open']
  static styles = css`
    :host { position: relative; display: inline-block; }
    .name {
      display: inline-flex; align-items: center; gap: var(--space-3);
      height: 24px; padding: 0 var(--space-4);
      border: var(--border-width) solid transparent;
      border-radius: var(--radius-md);
      cursor: pointer; background: transparent;
      font: var(--type-chrome); color: var(--text-primary);
      transition: var(--transition-hover);
    }
    .name:hover { background: var(--surface-hover); }
    :host([open]) .name { background: var(--surface-active); }
    .name .repo { font-family: var(--font-mono); }
    .chev { color: var(--text-tertiary); display: inline-flex; }

    .menu {
      position: absolute; top: 28px; left: 50%; transform: translateX(-50%);
      min-width: 260px;
      background: var(--surface-raised);
      border: var(--hairline);
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-popover);
      padding: var(--space-2);
      z-index: var(--z-popover);
    }
    .item {
      display: flex; align-items: center; gap: var(--space-3);
      padding: var(--space-3) var(--space-4);
      border-radius: var(--radius-md); cursor: pointer;
      transition: var(--transition-hover);
    }
    .item:hover { background: var(--surface-hover); }
    .item .glyph { color: var(--text-tertiary); display: inline-flex; }
    .label { font: var(--type-chrome); color: var(--text-primary); }
    .label.mono { font-family: var(--font-mono); }
    .meta { font: var(--type-meta); color: var(--text-tertiary); overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    .current { margin-left: auto; font: var(--type-meta); color: var(--text-accent); }
    .empty { font: var(--type-chrome); color: var(--text-tertiary); padding: var(--space-4) var(--space-4) var(--space-3); }
    .rule { height: 1px; background: var(--border-subtle); margin: var(--space-2) 0; }
  `

  repositories = []

  connectedCallback() {
    super.connectedCallback()
    this.shadowRoot.addEventListener('click', (event) => {
      if (event.target.closest('.name')) {
        this.toggleAttribute('open')
        return
      }
      const item = event.target.closest('.item')
      if (!item) return
      this.removeAttribute('open')
      if (item.dataset.browse) this.emit('browse')
      else this.emit('choose', this.repositories[Number(item.dataset.index)])
    })
  }

  render() {
    const name = this.attr('name')
    const list = this.repositories.length
      ? this.repositories
          .map(
            (r, i) => `
        <div class="item" data-index="${i}">
          <div style="min-width:0">
            <div class="label mono">${esc(r.name)}</div>
            <div class="meta">${esc(r.path)}</div>
          </div>
          ${r.name === name ? '<span class="current">current</span>' : ''}
        </div>`,
          )
          .join('')
      : '<div class="empty">No repositories yet — browse for one</div>'

    const menu = this.bool('open')
      ? `<div class="menu" role="listbox">
           ${list}
           <div class="rule"></div>
           <div class="item" data-browse="1">
             <span class="glyph"><nz-icon name="folder-open" size="14"></nz-icon></span>
             <div class="label">Browse for a repository…</div>
           </div>
         </div>`
      : ''

    this.shadowRoot.innerHTML = `
      <button type="button" class="name" aria-expanded="${this.bool('open')}">
        <span class="repo">${esc(name)}</span>
        <span class="chev"><nz-icon name="chevron-down" size="12"></nz-icon></span>
      </button>${menu}`
  }
}

customElements.define('nz-repository-selector', NzRepositorySelector)

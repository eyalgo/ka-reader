import { NzElement, css, esc } from './base.js'
import './nz-icon.js'

/** Absence, stated. "Nothing changed" is information; a blank pane is a bug (UXD RN-3). */
export class NzEmptyState extends NzElement {
  static observedAttributes = ['icon', 'title', 'detail']
  static styles = css`
    :host {
      height: 100%;
      display: flex; flex-direction: column;
      align-items: center; justify-content: center;
      gap: var(--space-5);
      padding: var(--space-9);
      text-align: center;
      background: var(--surface-panel);
      box-sizing: border-box;
    }
    .glyph { color: var(--text-disabled); display: inline-flex; }
    .title { font: var(--type-body-lg); color: var(--text-secondary); }
    .detail { font: var(--type-body); color: var(--text-tertiary); max-width: 42ch; }
  `

  render() {
    const icon = this.hasAttribute('icon')
      ? `<span class="glyph"><nz-icon name="${esc(this.attr('icon'))}" size="16" stroke-width="2"></nz-icon></span>`
      : ''
    const detail = this.hasAttribute('detail')
      ? `<div class="detail">${esc(this.attr('detail'))}</div>`
      : ''
    this.shadowRoot.innerHTML = `${icon}<div class="title">${esc(this.attr('title'))}</div>${detail}<slot></slot>`
  }
}

customElements.define('nz-empty-state', NzEmptyState)

import { NzElement, css, esc } from './base.js'
import './nz-icon.js'

/** A square, quiet chrome control — the theme toggle. Always carries an accessible label. */
export class NzIconButton extends NzElement {
  static observedAttributes = ['name', 'label', 'size', 'active']
  static styles = css`
    :host { display: inline-flex; }
    button {
      width: 24px; height: 24px;
      display: inline-flex; align-items: center; justify-content: center;
      border: none; border-radius: var(--radius-md); cursor: pointer;
      background: transparent; color: var(--text-tertiary);
      transition: var(--transition-hover);
    }
    :host([active]) button { color: var(--text-primary); }
    button:hover { background: var(--surface-hover); }
    button:active { background: var(--surface-active); }
    button:focus-visible { outline: var(--border-width-strong) solid var(--focus-ring); outline-offset: 1px; }
  `

  render() {
    const label = esc(this.attr('label'))
    this.shadowRoot.innerHTML = `
      <button type="button" aria-label="${label}" title="${label}">
        <nz-icon name="${esc(this.attr('name'))}" size="${this.num('size', 14)}"></nz-icon>
      </button>`
  }
}

customElements.define('nz-icon-button', NzIconButton)

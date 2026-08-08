import { NzElement, css, esc } from './base.js'

/**
 * The sidebar's only mode switch: a pair of labelled text tabs, not an icon rail (UXD RN-16).
 * Exactly two destinations exist. Selection carries an accent bar as well as a colour shift,
 * so it survives without colour.
 */
export class NzSidebarTabs extends NzElement {
  static observedAttributes = ['tabs', 'value']
  static styles = css`
    :host { display: block; }
    [role='tablist'] {
      display: flex;
      height: var(--tabbar-height);
      border-bottom: var(--hairline);
      background: var(--surface-sidebar);
    }
    button {
      flex: 1; border: none; background: transparent; cursor: pointer; height: 100%;
      font: var(--type-tab); color: var(--text-tertiary);
      transition: var(--transition-hover);
    }
    button:hover { color: var(--text-secondary); }
    button[aria-selected='true'] {
      color: var(--text-primary);
      box-shadow: inset 0 -2px 0 var(--border-accent);
    }
    button:focus-visible { outline: var(--border-width-strong) solid var(--focus-ring); outline-offset: -2px; }
  `

  get tabs() {
    return this.attr('tabs', 'Files,Git').split(',').map((t) => t.trim()).filter(Boolean)
  }

  connectedCallback() {
    super.connectedCallback()
    this.shadowRoot.addEventListener('click', (event) => {
      const tab = event.target.closest('button')
      if (!tab) return
      this.setAttribute('value', tab.dataset.tab)
      this.emit('change', { value: tab.dataset.tab })
    })
  }

  render() {
    const value = this.attr('value', this.tabs[0])
    this.shadowRoot.innerHTML = `<div role="tablist">${this.tabs
      .map(
        (t) =>
          `<button role="tab" data-tab="${esc(t)}" aria-selected="${t === value}">${esc(t)}</button>`,
      )
      .join('')}</div>`
  }
}

customElements.define('nz-sidebar-tabs', NzSidebarTabs)

import { NzElement, css } from './base.js'

/**
 * The only button in nozoki. Buttons never act on the repository — they browse, choose,
 * dismiss. There is no editing affordance anywhere, not even disabled (UX-I1).
 *
 * Hover and press are CSS states, not tracked state: pressing something in nozoki should feel
 * like pressing a key, not a button on a website — overlay only, no shrink, no shadow change.
 */
export class NzButton extends NzElement {
  static observedAttributes = ['variant', 'size', 'disabled']
  static styles = css`
    :host { display: inline-flex; }
    button {
      font: var(--type-chrome);
      border-radius: var(--radius-md);
      border: var(--border-width) solid transparent;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: var(--space-3);
      white-space: nowrap;
      transition: var(--transition-hover);
      height: 28px;
      padding: 0 var(--space-5);
      background: transparent;
      color: var(--text-primary);
      border-color: var(--border-default);
    }
    :host([size='sm']) button { height: 22px; padding: 0 var(--space-4); }

    :host([variant='primary']) button {
      background: var(--accent-solid);
      color: var(--text-on-accent);
      border-color: transparent;
    }
    :host([variant='ghost']) button {
      background: transparent;
      color: var(--text-secondary);
      border-color: transparent;
    }

    button:hover:not(:disabled) { background: var(--surface-hover); color: var(--text-primary); }
    button:active:not(:disabled) { background: var(--surface-active); }
    :host([variant='primary']) button:hover:not(:disabled),
    :host([variant='primary']) button:active:not(:disabled) {
      background: var(--accent-solid-hover);
      color: var(--text-on-accent);
    }

    button:disabled { color: var(--text-disabled); cursor: default; background: transparent; }
    :host([variant='primary']) button:disabled { background: var(--surface-active); }
    button:focus-visible { outline: var(--border-width-strong) solid var(--focus-ring); outline-offset: 1px; }
  `

  render() {
    if (!this.shadowRoot.firstChild) {
      this.shadowRoot.innerHTML = '<button type="button"><slot></slot></button>'
    }
    this.shadowRoot.querySelector('button').disabled = this.bool('disabled')
  }
}

customElements.define('nz-button', NzButton)

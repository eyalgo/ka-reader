import { NzElement, css, esc } from './base.js'
import './nz-icon.js'

/**
 * A plain statement of what happened and what to do next, at the no-learning-curve bar
 * (UX-I6) — never a raw diagnostic. It degrades one item, never the shell (UX-I10), and it
 * does not bid for attention: no toast, no flash, no badge.
 *
 * The tone carries a distinct glyph as well as a colour, so it reads without either.
 */
const TONES = {
  info: ['var(--text-tertiary)', 'info'],
  degraded: ['var(--status-degraded)', 'clock'],
  error: ['var(--status-error)', 'circle-alert'],
}

export class NzStatusMessage extends NzElement {
  static observedAttributes = ['tone', 'title', 'detail', 'inline']
  static styles = css`
    :host {
      display: flex; align-items: flex-start; gap: var(--space-4);
      padding: var(--space-5) var(--space-6);
      border: var(--hairline);
      border-radius: var(--radius-md);
      background: var(--surface-raised);
      box-sizing: border-box;
    }
    :host([inline]) {
      padding: var(--space-3) var(--space-4);
      border: none; border-radius: 0; background: transparent;
    }
    .glyph { display: inline-flex; padding-top: 1px; flex: 0 0 auto; }
    .title { font: var(--type-body); color: var(--text-primary); }
    .detail { font: var(--type-body); color: var(--text-tertiary); margin-top: var(--space-1); }
    .action { margin-top: var(--space-4); }
  `

  render() {
    const [color, icon] = TONES[this.attr('tone', 'info')] || TONES.info
    const detail = this.hasAttribute('detail')
      ? `<div class="detail">${esc(this.attr('detail'))}</div>`
      : ''
    this.shadowRoot.innerHTML = `
      <span class="glyph" style="color:${color}"><nz-icon name="${icon}" size="14"></nz-icon></span>
      <div>
        <div class="title">${esc(this.attr('title'))}</div>
        ${detail}
        <div class="action"><slot></slot></div>
      </div>`
  }
}

customElements.define('nz-status-message', NzStatusMessage)

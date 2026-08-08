import { NzElement, css, esc } from './base.js'
import './nz-branch-chip.js'

/**
 * One commit in the history graph (beyond v1). The rails carry topology — which commits belong
 * to which branch, and where they diverge and merge — because a flat list flattens them
 * together, which the owner ruled out (UXD RN-14). The row carries identity: sha, message,
 * author, date.
 *
 * A merge commit is drawn as a hollow node, so the distinction survives without colour.
 *
 * Set branch tips as a property: `el.tips = [{ name, current }]`.
 */
const RAILS = ['var(--git-renamed)', 'var(--git-added)', 'var(--git-modified)', 'var(--git-untracked)']
const RAIL_W = 14

export class NzCommitRow extends NzElement {
  static observedAttributes = ['sha', 'message', 'author', 'date', 'lane', 'lanes', 'merge', 'selected']
  static styles = css`
    :host { display: block; }
    .row {
      display: flex; align-items: center; gap: var(--space-4);
      min-height: 26px; padding: 0 var(--space-5);
      cursor: pointer; transition: var(--transition-hover);
      background: transparent;
    }
    .row:hover { background: var(--surface-hover); }
    :host([selected]) .row {
      background: var(--surface-selected);
      box-shadow: inset 2px 0 0 var(--border-accent);
    }
    .graph { position: relative; height: 26px; flex: 0 0 auto; }
    .rail { position: absolute; top: 0; bottom: 0; width: 1px; opacity: 0.85; }
    .node { position: absolute; top: 9px; width: 8px; height: 8px; border-radius: var(--radius-pill); }
    .sha { font: var(--type-meta); color: var(--text-tertiary); flex: 0 0 auto; }
    .message {
      font: var(--type-tree); color: var(--text-primary);
      overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
    }
    .who {
      margin-left: auto; display: flex; gap: var(--space-5); flex: 0 0 auto;
      font: var(--type-meta); color: var(--text-tertiary);
    }
  `

  tips = []

  connectedCallback() {
    super.connectedCallback()
    this.addEventListener('click', () => this.emit('select', { sha: this.attr('sha') }))
  }

  render() {
    const lanes = Math.max(1, this.num('lanes', 1))
    const lane = this.num('lane', 0)
    const merge = this.bool('merge')
    const color = RAILS[lane % RAILS.length]

    const rails = Array.from({ length: lanes }, (_, i) =>
      `<span class="rail" style="left:${i * RAIL_W + RAIL_W / 2 - 0.5}px;background:${RAILS[i % RAILS.length]}"></span>`,
    ).join('')

    const node = `<span class="node" style="left:${lane * RAIL_W + RAIL_W / 2 - 4}px;background:${
      merge ? 'var(--surface-panel)' : color
    };${merge ? `box-shadow:inset 0 0 0 2px ${color}` : ''}" title="${merge ? 'Merge commit' : 'Commit'}"></span>`

    const tips = this.tips
      .map((t) => `<nz-branch-chip name="${esc(t.name)}"${t.current ? ' current' : ''}></nz-branch-chip>`)
      .join('')

    this.shadowRoot.innerHTML = `
      <div class="row">
        <span class="graph" style="width:${lanes * RAIL_W}px">${rails}${node}</span>
        <span class="sha">${esc(this.attr('sha'))}</span>
        <span class="message">${esc(this.attr('message'))}</span>
        ${tips}
        <span class="who"><span>${esc(this.attr('author'))}</span><span>${esc(this.attr('date'))}</span></span>
      </div>`
  }
}

customElements.define('nz-commit-row', NzCommitRow)

import { NzElement, css, esc } from './base.js'

/**
 * Lucide glyphs, vendored — lucide-static v0.454.0, ISC, (c) Lucide Contributors.
 * Sources in third_party/lucide/icons/; the notice ships with every release (SRS C-5).
 *
 * Inlined rather than fetched: nozoki makes no network call during operation (SRS NFR-8;
 * AC-3 checks zero outbound traffic at every release). The inventory is closed — a name
 * outside it renders nothing. If Lucide has no glyph for something, use a word.
 */
const GLYPHS = {
  'chevron-down':
    '<path d="m6 9 6 6 6-6" />',
  'chevron-right':
    '<path d="m9 18 6-6-6-6" />',
  'circle-alert':
    '<circle cx="12" cy="12" r="10" /> <line x1="12" x2="12" y1="8" y2="12" /> <line x1="12" x2="12.01" y1="16" y2="16" />',
  'clock':
    '<circle cx="12" cy="12" r="10" /> <polyline points="12 6 12 12 16 14" />',
  'file-code':
    '<path d="M10 12.5 8 15l2 2.5" /> <path d="m14 12.5 2 2.5-2 2.5" /> <path d="M14 2v4a2 2 0 0 0 2 2h4" /> <path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7z" />',
  'file':
    '<path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z" /> <path d="M14 2v4a2 2 0 0 0 2 2h4" />',
  'folder-open':
    '<path d="m6 14 1.5-2.9A2 2 0 0 1 9.24 10H20a2 2 0 0 1 1.94 2.5l-1.54 6a2 2 0 0 1-1.95 1.5H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H18a2 2 0 0 1 2 2v2" />',
  'folder':
    '<path d="M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z" />',
  'git-branch':
    '<line x1="6" x2="6" y1="3" y2="15" /> <circle cx="18" cy="6" r="3" /> <circle cx="6" cy="18" r="3" /> <path d="M18 9a9 9 0 0 1-9 9" />',
  'git-commit-horizontal':
    '<circle cx="12" cy="12" r="3" /> <line x1="3" x2="9" y1="12" y2="12" /> <line x1="15" x2="21" y1="12" y2="12" />',
  'git-merge':
    '<circle cx="18" cy="18" r="3" /> <circle cx="6" cy="6" r="3" /> <path d="M6 21V9a9 9 0 0 0 9 9" />',
  'info':
    '<circle cx="12" cy="12" r="10" /> <path d="M12 16v-4" /> <path d="M12 8h.01" />',
  'moon':
    '<path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z" />',
  'sun':
    '<circle cx="12" cy="12" r="4" /> <path d="M12 2v2" /> <path d="M12 20v2" /> <path d="m4.93 4.93 1.41 1.41" /> <path d="m17.66 17.66 1.41 1.41" /> <path d="M2 12h2" /> <path d="M20 12h2" /> <path d="m6.34 17.66-1.41 1.41" /> <path d="m19.07 4.93-1.41 1.41" />',
}

/** A Lucide glyph at nozoki's stroke weight. Icons are always secondary to text. */
export class NzIcon extends NzElement {
  static observedAttributes = ['name', 'size', 'stroke-width', 'label']
  static styles = css`
    :host { display: inline-flex; align-items: center; justify-content: center; flex: 0 0 auto; color: inherit; }
    svg { display: block; }
  `

  render() {
    const body = GLYPHS[this.attr('name')]
    const size = this.num('size', 14)
    const stroke = this.num('stroke-width', 1.5)
    const label = this.attr('label')

    this.style.width = `${size}px`
    this.style.height = `${size}px`
    if (label) {
      this.setAttribute('role', 'img')
      this.setAttribute('aria-label', label)
    } else {
      this.setAttribute('aria-hidden', 'true')
    }

    this.shadowRoot.innerHTML = body
      ? `<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 24 24"
           fill="none" stroke="currentColor" stroke-width="${esc(stroke)}"
           stroke-linecap="round" stroke-linejoin="round">${body}</svg>`
      : ''
  }
}

customElements.define('nz-icon', NzIcon)

/**
 * The smallest base a custom element needs, and nothing more.
 *
 * These components are framework-free on purpose: nozoki's stack is "Lit or direct DOM"
 * (docs/proposal.md), and the SDD has not chosen between them. Standard custom elements are
 * the common subset — if the SDD picks Lit, Lit *is* custom elements and these survive as a
 * base-class change; if it picks direct DOM, they already are that.
 *
 * They are a reference implementation, not yet the product's src/. They read the same tokens
 * the specimens do, so what you see here is what docs/DESIGN.md says.
 */

/** Tagged template for a constructable stylesheet. */
export function css(strings, ...values) {
  const sheet = new CSSStyleSheet()
  sheet.replaceSync(String.raw({ raw: strings }, ...values))
  return sheet
}

/** Escape a value for interpolation into markup. Every dynamic string goes through this. */
export function esc(value) {
  return String(value ?? '').replace(
    /[&<>"']/g,
    (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c],
  )
}

export class NzElement extends HTMLElement {
  /** Subclasses set this to a CSSStyleSheet from css``. */
  static styles = null

  constructor() {
    super()
    this.attachShadow({ mode: 'open' })
    const { styles } = this.constructor
    if (styles) this.shadowRoot.adoptedStyleSheets = [styles]
  }

  connectedCallback() {
    this.render()
  }

  attributeChangedCallback() {
    if (this.isConnected) this.render()
  }

  /** Attribute presence as a boolean. */
  bool(name) {
    return this.hasAttribute(name)
  }

  /** Attribute value, or a fallback. */
  attr(name, fallback = '') {
    return this.getAttribute(name) ?? fallback
  }

  /** Attribute parsed as a number, or a fallback. */
  num(name, fallback = 0) {
    const n = Number(this.getAttribute(name))
    return Number.isFinite(n) && this.hasAttribute(name) ? n : fallback
  }

  /** Emit a composed CustomEvent so listeners outside the shadow root hear it. */
  emit(type, detail) {
    this.dispatchEvent(new CustomEvent(type, { detail, bubbles: true, composed: true }))
  }

  render() {}
}

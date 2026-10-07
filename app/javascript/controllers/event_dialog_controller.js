import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "frame", "heading"]

  disconnect() {
    if (this.hasDialogTarget && this.dialogTarget.open) this.dialogTarget.close()
    document.documentElement.classList.remove("event-dialog-open")
  }

  open(event) {
    if (event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return
    if (typeof this.dialogTarget.showModal !== "function") return

    event.preventDefault()
    this.returnFocus = event.currentTarget
    this.eventURL = event.currentTarget.href
    this.loading()
    this.frameTarget.src = this.eventURL
    this.dialogTarget.showModal()
    document.documentElement.classList.add("event-dialog-open")
  }

  loading() {
    const notice = document.createElement("p")
    notice.className = "launch-dialog-loading"
    notice.setAttribute("role", "status")
    notice.textContent = "Loading event details…"
    this.frameTarget.replaceChildren(notice)
  }

  loaded() {
    if (this.dialogTarget.open && this.hasHeadingTarget) this.headingTarget.focus({ preventScroll: true })
  }

  retry() {
    this.loading()
    this.frameTarget.reload()
  }

  failed(event) {
    event.preventDefault()
    this.frameTarget.innerHTML = `
      <section class="launch-event-detail">
        <h2 tabindex="-1" data-event-dialog-target="heading">Event details are temporarily unavailable.</h2>
        <p>Please try again shortly before making plans.</p>
        <button class="main-action" data-action="event-dialog#retry">Try again</button>
      </section>`
    this.loaded()
  }

  closed() {
    document.documentElement.classList.remove("event-dialog-open")
    this.frameTarget.removeAttribute("src")
    this.frameTarget.replaceChildren()
    if (this.returnFocus?.isConnected) this.returnFocus.focus({ preventScroll: true })
  }

  trapFocus(event) {
    if (event.key !== "Tab") return

    const controls = this.dialogTarget.querySelectorAll("a[href], button:not([disabled])")
    const first = controls[0]
    const last = controls[controls.length - 1]
    if (controls.length === 1 || (event.shiftKey && document.activeElement === first) || (!event.shiftKey && document.activeElement === last)) {
      event.preventDefault()
      const next = event.shiftKey ? last : first
      next.focus()
    }
  }

  backdrop(event) {
    if (event.target !== this.dialogTarget) return
    const bounds = this.dialogTarget.getBoundingClientRect()
    if (event.clientX < bounds.left || event.clientX > bounds.right || event.clientY < bounds.top || event.clientY > bounds.bottom) {
      this.dialogTarget.close()
    }
  }
}

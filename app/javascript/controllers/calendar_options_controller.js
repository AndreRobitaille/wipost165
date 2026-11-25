import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  dismiss(event) {
    if (!this.element.contains(event.target)) this.element.open = false
  }

  escape(event) {
    if (!this.element.open) return
    event.preventDefault()
    event.stopPropagation()
    this.element.open = false
    this.element.querySelector("summary").focus()
  }
}

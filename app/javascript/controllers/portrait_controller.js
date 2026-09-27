import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const image = this.element.querySelector("img")
    if (image.complete && image.naturalWidth === 0) this.unavailable()
  }

  unavailable() {
    this.element.querySelector("img").hidden = true
    this.element.querySelector(".portrait-fallback").hidden = false
  }
}

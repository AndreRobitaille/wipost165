import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["map"]

  connect() {
    // iPadOS can send the same desktop user agent as a Mac.
    if (navigator.platform === "MacIntel" && navigator.maxTouchPoints > 1) {
      this.element.dataset.eventDevice = "ios"
      if (this.hasMapTarget) this.mapTarget.href = this.mapTarget.dataset.iosHref
    }
  }
}

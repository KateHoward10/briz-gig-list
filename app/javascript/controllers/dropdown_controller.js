import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  openMenu() {
    this.menuTarget.classList.remove("hidden")
  }

  closeMenu() {
    this.menuTarget.classList.add("hidden")
  }
}

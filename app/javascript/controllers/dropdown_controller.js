import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from "stimulus-use"

export default class extends Controller {
  static targets = ["button", "menu"]

  connect() {
    useClickOutside(this, { element: this.menuTarget, eventPrefix: false })
  }

  showMenuButton() {
    this.buttonTarget.classList.remove("hidden")
  }

  hideMenuButton() {
    this.buttonTarget.classList.add("hidden")
  }

  openMenu() {
    this.menuTarget.classList.remove("hidden")
    this.hideMenuButton()
  }

  closeMenu(e) {
    e.preventDefault()
    this.menuTarget.classList.add("hidden")
  }
}

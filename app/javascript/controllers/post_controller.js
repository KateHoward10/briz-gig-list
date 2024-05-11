import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from "stimulus-use"

export default class extends Controller {
  static targets = ["menu", "reactionList"]

  connect() {
    useClickOutside(this, { element: this.menuTarget, eventPrefix: false })
    useClickOutside(this, { element: this.reactionListTarget, eventPrefix: false })
  }

  openMenu() {
    this.menuTarget.classList.remove("hidden")
    this.hideMenuButton()
  }

  closeMenu(e) {
    e.preventDefault()
    this.menuTarget.classList.add("hidden")
  }

  openReactionList() {
    this.reactionListTarget.classList.remove("hidden")
  }

  closeReactionList(e) {
    e.preventDefault()
    this.reactionListTarget.classList.add("hidden")
  }
}

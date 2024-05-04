import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ["active", "inactive"]
  static targets = ["btn", "tab"]
  static values = { defaultTab: String }

  connect() {
    this.tabTargets.map(x => {
      x.hidden = x.id !== this.defaultTabValue
    })
    this.switchClasses(this.defaultTabValue)
  }

  switchClasses(id) {
    this.btnTargets.map(x => {
      if (x.id === id) {
        x.classList.remove(...this.inactiveClasses)
        x.classList.add(...this.activeClasses)
      } else {
        x.classList.remove(...this.activeClasses)
        x.classList.add(...this.inactiveClasses)
      }
    })
  }

  select(event) {
    this.tabTargets.map(x => {
      x.hidden = x.id !== event.currentTarget.id
    })
    this.switchClasses(event.currentTarget.id)
  }
}

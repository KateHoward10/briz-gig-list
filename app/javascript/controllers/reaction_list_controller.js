import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list"]

  toggleReactionList() {
    this.listTarget.classList.toggle("hidden")
  }
}

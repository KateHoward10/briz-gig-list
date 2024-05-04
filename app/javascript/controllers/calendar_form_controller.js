import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ["hidden", "form"]

  handleChange(e) {
    this.hiddenTarget.value = e.target.value + "-01"
    this.formTarget.submit()
  }
}

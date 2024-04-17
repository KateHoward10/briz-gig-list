import { Controller } from '@hotwired/stimulus'
import mql from '@microlink/mql'

export default class extends Controller {
  static targets = ["url", "status", "text"]

  async handleURL() {
    if (this.urlTarget.value === "") return;
    this.statusTarget.textContent = "Checking URL...";
    this.textTarget.disabled = true;
    const { status, data } = await mql(this.urlTarget.value);
    if (status == "success") {
      this.setFormData(data?.title);
      this.statusTarget.textContent = "";
      this.textTarget.disabled = false;
    }
  }

  setFormData(value) {
    this.textTarget.value = value ? value : null;
  }
}

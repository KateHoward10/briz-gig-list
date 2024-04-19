import { Controller } from '@hotwired/stimulus'
import mql from '@microlink/mql'

export default class extends Controller {
  static targets = ["url", "status", "text"]

  reset() {
    this.statusTarget.textContent = "";
    this.textTarget.disabled = false;
  }

  async handleURL() {
    if (this.urlTarget.value === "") {
      this.setFormData("");
      return this.reset();
    }
    this.statusTarget.textContent = "Checking URL...";
    this.textTarget.disabled = true;
    try {
      mql(this.urlTarget.value).then(({ status, data }) => {
        if (status == "success") {
          this.setFormData(data?.title);
        }
      }).then(() => this.reset());
    } catch (error) {
      this.reset();
    }
  }

  setFormData(value) {
    this.textTarget.value = value ? value : null;
  }
}

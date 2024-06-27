import { Controller } from '@hotwired/stimulus'
import mql from '@microlink/mql'

export default class extends Controller {
  static targets = ["url", "status", "text", "summary"]

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
          this.setFormData(data);
        }
      }).then(() => this.reset());
    } catch (error) {
      this.reset();
    }
  }

  setFormData({ publisher, title }) {
    this.textTarget.value = publisher || null;
    if (this.hasSummaryTarget && title) {
      const separators = [" at ", " Tickets | ", " | ", " + "];
      let titleParts = [];
      separators.some((separator) => {
        if (title.split(separator)[0] !== title) {
          titleParts = title.split(separator);
          return true;
        }
      })
      const artist = titleParts[0];
      if (artist) this.summaryTarget.value = artist;
    }
  }
}

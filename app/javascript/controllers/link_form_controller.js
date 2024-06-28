import { Controller } from '@hotwired/stimulus'
import mql from '@microlink/mql'

const separators = [
  " Tickets | ",    // Dice
  " | ",            // e.g. Beacon
  " — ",            // e.g. Trinity
  " at "            // Headfirst
]

const months = {
  "jan": "01",
  "feb": "02",
  "mar": "03",
  "apr": "04",
  "may": "05",
  "jun": "06",
  "jul": "07",
  "aug": "08",
  "sep": "09",
  "oct": "10",
  "nov": "11",
  "dec": "12"
}

const currentYear = new Date().getFullYear();

export default class extends Controller {
  static targets = ["url", "status", "text", "summary", "startDate", "endDate"]

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

  setFormData({ publisher, title, url }) {
    this.textTarget.value = publisher || null;
    if (this.hasSummaryTarget && title) {
      let artist;
      separators.some((separator) => {
        const titleParts = title.split(separator);
        if (titleParts[0] !== title) {
          if (separator === " at " && titleParts.length > 2) {
            artist = `${titleParts[0]} at ${titleParts[1]}`;
          } else {
            artist = titleParts[0];
          }
          return true;
        }
      })
      if (artist) this.summaryTarget.value = artist;
    }
    if (this.hasStartDateTarget && url) {
      let startDate;
      const urlParts = url.split("-");
      const monthKeys = Object.keys(months);
      urlParts.findLast((part, index) => {
        if (monthKeys.includes(part)) {
          const dayOfMonth = urlParts[index - 1];
          if (dayOfMonth) {
            const day = dayOfMonth.replace(/\D/g,'');
            if (!(+day.isNaN)) {
              startDate = `${currentYear}-${months[part]}-${day.length < 2 ? `0${day}` : day}`
            }
          }
          return true;
        }
      })
      if (startDate) {
        this.startDateTarget.value = startDate;
        if (this.hasEndDateTarget) this.endDateTarget.value = startDate;
      }
    }
  }
}

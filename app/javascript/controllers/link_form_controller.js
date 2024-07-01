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
  static targets = ["url", "status", "text", "summary", "startDate", "endDate", "location", "venueList", "image", "preview", "removeButton"]

  reset() {
    this.statusTarget.textContent = "";
    this.textTarget.disabled = false;
    if (this.hasSummaryTarget) this.summaryTarget.disabled = false;
    if (this.hasStartDateTarget) this.startDateTarget.disabled = false;
    if (this.hasEndDateTarget) this.endDateTarget.disabled = false;
    if (this.hasLocationTarget) this.locationTarget.disabled = false;
  }

  async handleURL() {
    if (this.urlTarget.value === "") {
      this.setFormData("");
      return this.reset();
    }
    this.statusTarget.textContent = "Checking URL...";
    this.textTarget.disabled = true;
    if (this.hasSummaryTarget) this.summaryTarget.disabled = true;
    if (this.hasStartDateTarget) this.startDateTarget.disabled = true;
    if (this.hasEndDateTarget) this.endDateTarget.disabled = true;
    if (this.hasLocationTarget) this.locationTarget.disabled = true;
    try {
      mql(this.urlTarget.value).then(({ status, data }) => {
        if (status == "success") {
          this.setFormData(data);
        } else {
          this.reset();
        }
      }).then(() => this.reset());
    } catch (error) {
      this.reset();
    }
  }

  setFormData({ publisher, title, url, image }) {
    this.textTarget.value = publisher || null;
    if (this.hasSummaryTarget && title) {
      let artist, location;
      separators.some((separator) => {
        const titleParts = title.split(separator);
        if (titleParts[0] !== title) {
          if (separator === " at " && titleParts.length > 2) {
            artist = `${titleParts[0]} at ${titleParts[1]}`;
            location = titleParts[2];
          } else {
            artist = titleParts[0];
            location = titleParts[1];
          }
          return true;
        }
      })
      if (artist) this.summaryTarget.value = artist;
      if (location && this.hasLocationTarget && this.hasVenueListTarget) {
        const venues = [...this.venueListTarget.children].map(venue => venue.value);
        const existing = venues.find(venue => location.indexOf(venue.split(", ")[0]?.replace("The ", "")) > -1);
        if (existing) {
          this.locationTarget.value = existing;
        };
      }
    }
    this.setDates(url);
    if (image?.url) this.setImage(image.url);
  }

  setDates(url) {
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

  setImage(url) {
    if (this.hasImageTarget && this.hasPreviewTarget && url) {
      this.imageTarget.value = url;
      this.previewTarget.src = url;
      this.previewTarget.parentElement.classList.remove("hidden");
    }
  }

  removeImage() {
    if (this.hasImageTarget && this.hasPreviewTarget) {
      this.imageTarget.value = null;
      this.previewTarget.src = null;
      this.previewTarget.parentElement.classList.add("hidden");
    }
  }
}

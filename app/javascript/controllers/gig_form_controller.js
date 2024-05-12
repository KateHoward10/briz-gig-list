import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["endDate", "field"]

  connect() {
    if (typeof(google) != "undefined") {
      this.initMap()
    }
  }

  initMap() {
    this.autocomplete = new google.maps.places.Autocomplete(this.fieldTarget)
    this.autocomplete.setFields(["address_components", "geometry", "icon", "name"])
  }

  setEndDate(e) {
    this.endDateTarget.value = e.target.value
  }
}

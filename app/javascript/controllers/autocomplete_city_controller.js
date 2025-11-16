import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autocomplete-city"
export default class extends Controller {
  static targets = ["input", "results", "latitude", "longitude", "timezone"]

  connect() {
  }

  // Make an API call to the autocomplete endpoint and display matching cities
  search() {
    const city = this.inputTarget.value
    if (city.length > 2) {
      fetch(`/searches/autocomplete?city=${city}`)
        .then(response => response.json())
        .then(data => {
          let html = ""
          data.forEach(city => {
            html += `
              <div class="hover:bg-gray-200"
                data-action="click->autocomplete-city#select"
                data-lat="${city.latitude}"
                data-long="${city.longitude}"
                data-tz="${city.timezone}"
              >
                ${city.name}, ${city.admin1}, ${city.country}
              </div>
            `
          })
          this.resultsTarget.innerHTML = html
        })
    }
    else { 
      this.resultsTarget.innerHTML = ""
    }
  }

  // Handle the selection of a city
  select(event) { 
    this.inputTarget.value = event.currentTarget.textContent.trim();
    this.latitudeTarget.value = event.currentTarget.dataset.lat;
    this.longitudeTarget.value = event.currentTarget.dataset.long;
    this.timezoneTarget.value = event.currentTarget.dataset.tz;
    
    this.resultsTarget.innerHTML = "";
  }
}

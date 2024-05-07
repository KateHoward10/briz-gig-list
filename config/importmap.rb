# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@microlink/mql", to: "@microlink--mql.js" # @0.13.5
pin "@joeattardi/emoji-button", to: "@joeattardi--emoji-button.js" # @4.6.4

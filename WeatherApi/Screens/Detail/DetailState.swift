import SwiftUI

@Observable
class DetailState {
    var place: LocationItem // Selected locality for the detail screen
    var weatherData: WeatherData? // Loaded data for selected locality
    
    init(place: LocationItem) {
            self.place = place
        }
}

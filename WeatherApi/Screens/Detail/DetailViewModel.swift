import SwiftUI

@Observable
class DetailViewModel {
    var state: DetailState
    private let weatherManager: APIManaging
    private var dataManager: DataManaging
        
    init(place: LocationItem) {
        self.state = DetailState(place: place)
        self.weatherManager = DIContainer.shared.resolve()
        self.dataManager = DIContainer.shared.resolve()
    }
    
    // Loads weather asynchronously for coordinates from stateplace.coordinates
    // into state.weatherData
    func loadWeather() async {
        do {
            let weather: WeatherData = try await weatherManager.request(
                WeatherDataRouter.weather(
                    long: state.place.coordinate.longitude,
                    lat: state.place.coordinate.latitude
                )
            )
            state.weatherData = weather
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removePlace() {
        dataManager.removePlace(state.place)
    }
}

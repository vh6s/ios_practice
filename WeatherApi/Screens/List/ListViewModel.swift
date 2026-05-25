import SwiftUI
import MapKit
import Foundation

@Observable
class ListViewModel {
    var state = ListState()
    private var dataManager: DataManaging
    private var weatherManager: APIManaging

    init() {
        dataManager = DIContainer.shared.resolve()
        weatherManager = DIContainer.shared.resolve()
    }

    // async function to load places into state
    func loadPlaces() async {
        var places = dataManager.fetchPlaces() // fetch places from CoreData
        
        for index in places.indices {
            do {
                // weather api call to retrieve weather data for each place in CoreData
                let weather: WeatherData = try await weatherManager.request(WeatherDataRouter.weather(
                    long: places[index].coordinate.longitude,
                    lat: places[index].coordinate.latitude)
                )
                // set weather data for each place model
                places[index].currentTemperature = weather.current.temp
                places[index].rainSum = weather.daily.rainSum.first
            } catch {
                print(error.localizedDescription)
            }
        }
        // add all places with weather data into state
        state.places = places
    }
}

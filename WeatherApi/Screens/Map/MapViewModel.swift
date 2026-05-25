import SwiftUI
import Foundation

@Observable
class MapViewModel {
    var state: MapState = MapState()
    var dataManager: DataManaging
    var locationManager: LocationManaging
    
    init() {
        dataManager = DIContainer.shared.resolve()
        locationManager = DIContainer.shared.resolve()

    }
    
    func saveLocation() async {
        let coordinate = state.centerCoordinate // retrieve coordinates for the point on map

        let locationName =
            await locationManager.getCurrentLocationName(from: coordinate) ?? "Unknown location" // retrieve the location name
        
        let item = LocationItem(coordinate: coordinate, name: locationName) // create the model representation to be used for save into CoreData

        dataManager.savePlace(item)
    }
}

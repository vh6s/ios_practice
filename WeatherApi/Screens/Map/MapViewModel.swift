//
//  MapViewModel.swift
//  WeatherApi
//
//  Created by Matěj on 24.05.2026.
//
import SwiftUI

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
        guard let camera = state.cameraPosition.camera else {
            return
        }

        let coordinate = camera.centerCoordinate
            
        let locationName =
            await locationManager.getCurrentLocationName(from: coordinate) ?? "Unknown location"
        
        let item = LocationItem(
            coordinate: coordinate,
            name: locationName
        )
        dataManager.savePlace(item)
        state.selectedPlace = item
    }
}

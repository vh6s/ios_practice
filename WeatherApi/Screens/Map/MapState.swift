//
//  MapState.swift
//  WeatherApi
//
//  Created by Matěj on 24.05.2026.
//

import SwiftUI
import MapKit

@Observable
class MapState {
    var selectedPlace: LocationItem? = nil
    var cameraPosition: MapCameraPosition = .camera(
        .init(
            centerCoordinate: .init(latitude: 49.7437, longitude: 15.3386),
            distance: 1000000
        )
    )
    
}

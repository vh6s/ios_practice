//
//  DetailState.swift
//  WeatherApi
//
//  Created by Matěj on 24.05.2026.
//

import SwiftUI

@Observable
class DetailState {
    var place: LocationItem
    var weatherData: WeatherData?
    
    init(place: LocationItem) {
            self.place = place
        }
}

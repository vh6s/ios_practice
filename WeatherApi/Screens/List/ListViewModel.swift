//
//  ListViewModel.swift
//  WeatherApi
//
//  Created by Matěj on 24.05.2026.
//

import SwiftUI
import MapKit

@Observable
class ListViewModel {
    var state = ListState()
    private var dataManager: DataManaging

    init() {
        dataManager = DIContainer.shared.resolve()
    }

    func loadPlaces() {
        state.places = dataManager.fetchPlaces()
    }
}

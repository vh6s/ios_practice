//
//  PlantListViewModel.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 10.10.2026.
//

import SwiftUI

@Observable
class PlantListViewModel {
    var state: PlantListViewState = PlantListViewState()

    private var dataManager: DataManaging

    init() {
        dataManager = DIContainer.shared.resolve()
    }

    func fetchPlants() {
        state.plants = dataManager.fetchPlants().sorted{ $0.nextWatering < $1.nextWatering}
    }
}

//
//  PlantDetailViewModel.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 10.10.2026.
//

import SwiftUI

@Observable
class PlantDetailViewModel {
    var state: PlantDetailViewState
    
    private let connector: WatchConnecting
    private var dataManager: DataManaging

    init(plant: Plant) {
        state = PlantDetailViewState(plant: plant)
        dataManager = DIContainer.shared.resolve()
        connector = DIContainer.shared.resolve()
    }

    func deletePlant() {
        dataManager.deletePlant(state.plant)
    }
    
    func sendToWatch() {
        connector.send(state.plant)
    }
}

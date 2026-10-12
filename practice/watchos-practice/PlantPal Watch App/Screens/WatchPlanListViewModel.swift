//
//  WatchPlanListViewModel.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 11.10.2026.
//

import SwiftUI

@Observable
final class WatchPlanListViewModel {
    var state = WatchPlanListViewState()
    
    private var dataManager: DataManaging
    private let connector: WatchConnecting
    
    init() {
        dataManager = DIContainer.shared.resolve()
        connector = DIContainer.shared.resolve()
        
        connector.onPlantReceived = { [weak self] plant in
            self?.dataManager.savePlant(plant)
            self?.fetchPlants()
        }
    }
    
    var isPhoneReachable: Bool {
        connector.isReachable
    }
    
    func fetchPlants() {
        state.plants = dataManager.fetchPlants().sorted{
            $0.nextWatering < $1.nextWatering
        }
    }
    
    func water(_ plant: Plant) {
        let now = Date()
        dataManager.waterPlant(id: plant.id, date: now)
        connector.sendWatered(plantId: plant.id, date: now)
        fetchPlants()
    }
}

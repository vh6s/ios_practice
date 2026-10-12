//
//  PlantDetailViewState.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 10.10.2026.
//

import SwiftUI

@Observable
class PlantDetailViewState {
    var plant: Plant

    init(plant: Plant) {
        self.plant = plant
    }
}

//
//  PlantFormViewModel.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 10.10.2026.
//

import SwiftUI
import PhotosUI

@Observable
class PlantFormViewModel {
    var state = PlantFormViewState()

    private let plant: Plant?
    private var dataManager: DataManaging

    init(plant: Plant? = nil) {
        self.plant = plant
        dataManager = DIContainer.shared.resolve()

        if let plant {
            state.name = plant.name
            state.coordinate = plant.coordinate
            state.image = plant.image
            state.wateringIntervalDays = plant.wateringIntervalDays
            state.isOutdoor = plant.isOutdoor
            state.room = plant.room
            state.title = "Edit"
        }
    }

    func savePlant() {
        let plant = Plant(
            id: plant?.id ?? UUID(), // same id = savePlant updates instead of inserting
            name: state.name,
            room: state.room,
            isOutdoor: state.isOutdoor,
            wateringIntervalDays: state.wateringIntervalDays,
            lastWatered: plant?.lastWatered ?? .now,
            image: state.image ?? UIImage(),
            coordinate: state.coordinate
        )

        dataManager.savePlant(plant)
    }

    func loadPickedImage() {
        Task { @MainActor in
            if let data = try? await state.pickedItem?.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                state.image = image
            }
        }
    }
}

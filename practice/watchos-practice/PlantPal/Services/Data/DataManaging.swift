//
//  DataManaging.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 10.10.2026.
//

import Foundation

protocol DataManaging {
    func savePlant(_ plant: Plant)
    func fetchPlants() -> [Plant]
    func waterPlant(id: UUID, date: Date)
    func deletePlant(_ plant: Plant)
}

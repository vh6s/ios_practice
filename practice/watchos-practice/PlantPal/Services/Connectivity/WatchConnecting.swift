//
//  WatchConnecting.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 10.10.2026.
//
import Foundation

protocol WatchConnecting: AnyObject {
    var isReachable: Bool { get }
    var onPlantReceived: (Plant) -> Void { get set }
    var onWateredReceived: (UUID, Date) -> Void { get set }
    func send(_ plant: Plant)
    func sendWatered(plantId: UUID, date: Date)
}

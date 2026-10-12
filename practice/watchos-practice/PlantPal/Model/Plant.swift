//
//  Plant.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 10.10.2026.
//

import Foundation
import SwiftUI

enum Room: Int16, Identifiable, CaseIterable {
    var id: Int16 { rawValue }
    
    case livingRoom = 1
    case bedRoom = 2
    case kitchen = 3
    case balcony = 4
    
    var name: String {
        switch self {
        case .livingRoom: return "Living room"
        case .bedRoom: return "Bed room"
        case .kitchen: return "Kitchen"
        case .balcony: return "Balcony"
        }
    }
}

struct Plant: Identifiable {
    var id = UUID()
    var name: String
    var room: Room
    var isOutdoor: Bool
    var wateringIntervalDays: Int
    var lastWatered: Date
    var image: UIImage
    var coordinate: CLLocationCoordinate2D
    var nextWatering : Date {
        Calendar.current.date(byAdding: .day, value: wateringIntervalDays, to: lastWatered) ?? lastWatered
    }
    var isDueToday : Bool {
        return nextWatering <= Calendar.current.dateInterval(of: .day, for: .now)?.end ?? .now
    }
}

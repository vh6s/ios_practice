//
//  PlantFormViewState.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 10.10.2026.
//

import SwiftUI
import CoreLocation
import PhotosUI

@Observable
class PlantFormViewState {
    var name: String = ""
    var room: Room = .livingRoom
    var isOutdoor: Bool = false
    var wateringIntervalDays: Int = 7
    var image: UIImage?
    var coordinate: CLLocationCoordinate2D = .init(latitude: 49.2099, longitude: 16.6142) // Brno, fallback without GPS

    var pickedItem: PhotosPickerItem?
    
    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && image != nil
    }
    
    var title: String = "Add"
}

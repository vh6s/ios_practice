//
//  LocationManaging.swift
//  WeatherApi
//
//  Created by Matěj on 24.05.2026.
//

import SwiftUI
import CoreLocation

protocol LocationManaging {
    func getCurrentLocation() -> CLLocationCoordinate2D?
    func getCurrentLocationName(from coordinate: CLLocationCoordinate2D) async -> String?
}

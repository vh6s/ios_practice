//
//  LocationItem.swift
//  WeatherApi
//
//  Created by Matěj on 24.05.2026.
//
import SwiftUI
import MapKit

struct LocationItem: Identifiable {
    var id: UUID = UUID()
    var coordinate: CLLocationCoordinate2D
    var name: String
    var currentTemperature: Double?
    var rainSum: Double?
}

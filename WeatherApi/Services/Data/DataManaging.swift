//
//  DataManaging.swift
//  WeatherApi
//
//  Created by Matěj on 24.05.2026.
//

protocol DataManaging {
    func savePlace(_ item: LocationItem)
    func fetchPlaces() -> [LocationItem]
    func removePlace(_ item: LocationItem)
}

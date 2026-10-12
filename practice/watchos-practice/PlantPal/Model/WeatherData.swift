//
//  WeatherData.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 10.10.2026.
//

import Foundation

struct WeatherData: Codable {
    let daily: Daily
}

struct Daily: Codable {
    let time: [String]
    let precipitationSums: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case precipitationSums = "precipitation_sum"
    }
}

//
//  WeatherDataRouter.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 10.10.2026.
//

import Foundation

enum WeatherDataRouter {
    case dailyPrecipitationSum(long: Double, lat: Double)
}

extension WeatherDataRouter: Router {
    var host: String {
        "https://api.open-meteo.com"
    }
    
    var path: String {
        "v1/forecast"
    }
    
    var method: HttpMethod {
        switch self {
        case .dailyPrecipitationSum:
            .get
        }
    }
    
    var urlParameters: [String : Any]? {
        switch self {
        case let .dailyPrecipitationSum(long: long, lat: lat):
            [
                "longitude": long,
                "latitude": lat,
                "daily": "precipitation_sum",
            ]
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .dailyPrecipitationSum:
            [:]
        }
    }
}

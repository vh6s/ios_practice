enum WeatherDataRouter {
    case weather(long: Double, lat: Double)
}

// if you want to see API documentation, open `open-meteo.com`
//https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&daily=temperature_2m_max,temperature_2m_min,rain_sum&current=temperature_2m

extension WeatherDataRouter: Router {
    var host: String {
        "https://api.open-meteo.com"
    }
    
    var path: String {
        "v1/forecast"
    }
    
    var method: HttpMethod {
        switch self {
        case .weather:
            .get
        }
    }
    
    // URL parameters that would be added into the query string
    var urlParameters: [String : Any]? {
        switch self {
        case let .weather(long: long, lat: lat):
            [
                "longitude": long,
                "latitude": lat,
                "daily": "temperature_2m_max,temperature_2m_min,rain_sum",
                "current": "temperature_2m"
            ]
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .weather:
            [:]
        }
    }
}

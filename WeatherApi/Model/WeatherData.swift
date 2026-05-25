import Foundation

struct WeatherData: Codable {
    let daily: Daily
    let current: Current
}

struct Daily: Codable {
    let time: [String]
    let maxTemperatures: [Double]
    let minTemperatures: [Double]
    let rainSum: [Double]

    // Mapping klicu do swiftu z JSONu
    enum CodingKeys: String, CodingKey {
        case time
        case maxTemperatures = "temperature_2m_max"
        case minTemperatures = "temperature_2m_min"
        case rainSum = "rain_sum"
    }
}

struct Current: Codable {
    let temp: Double
    
    enum CodingKeys: String, CodingKey {
        case temp = "temperature_2m"
    }
}



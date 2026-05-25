import SwiftUI
import MapKit

// V modelu ulozime vse, co je v CoreData + co jde videt v List screene
struct LocationItem: Identifiable {
    var id: UUID = UUID()
    var coordinate: CLLocationCoordinate2D
    var name: String
    var currentTemperature: Double?
    var rainSum: Double?
}

import SwiftUI
import CoreLocation

protocol LocationManaging {
    func getCurrentLocationName(from coordinate: CLLocationCoordinate2D) async -> String?
}

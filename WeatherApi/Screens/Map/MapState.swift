import SwiftUI
import MapKit

@Observable
class MapState {
    // default map camera center
    var centerCoordinate = CLLocationCoordinate2D(
            latitude: 49.7437,
            longitude: 15.3386
    )
    
    // actual camera position defaulty set to czech republic center
    var cameraPosition: MapCameraPosition = .camera(
        .init(
            centerCoordinate: .init(latitude: 49.7437, longitude: 15.3386),
            distance: 1000000
        )
    )
    
}

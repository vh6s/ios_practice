import SwiftUI
import MapKit

struct MapView: View {
    let viewModel: MapViewModel
    
    var body: some View {
        // ZStack to render the position marker over the map
        ZStack {
            /// Manual binding so the camera could sync with state
            /// - get: map takes current camera position in state
            /// - set: the position in state is updated on user move/zoom on map
            Map(position: Binding(
                get: {
                    viewModel.state.cameraPosition
                },
                set: {
                    viewModel.state.cameraPosition = $0
                }
            )
            // this updates the state centerCoordinates on every move. Used in place save
            ).onMapCameraChange {
                context in viewModel.state.centerCoordinate = context.camera.centerCoordinate
            }
            // Marker for map center for better UX
            Circle().fill(.cyan).frame(width: 16, height: 16)
                .overlay {
                    Circle().stroke(.white, lineWidth: 3)
                }
        }
    }
}

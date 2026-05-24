//
//  MapView.swift
//  WeatherApi
//
//  Created by Matěj on 24.05.2026.
//
import SwiftUI
import MapKit

struct MapView: View {
    @State private var viewModel: MapViewModel
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Map(position: $viewModel.state.cameraPosition)
            Circle().fill(.cyan).frame(width: 16, height: 16)
                .overlay {
                    Circle().stroke(.white, lineWidth: 3)
                }
        }
    }
}

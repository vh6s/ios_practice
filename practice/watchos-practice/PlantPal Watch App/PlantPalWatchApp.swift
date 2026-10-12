//
//  PlantPalWatchApp.swift
//  PlantPal Watch App
//
//  Created by Pavel Priehoda on 10.10.2026.
//

import SwiftUI

@main
struct PlantPalWatchApp: App {
    @State private var viewModel = WatchPlanListViewModel()
    
    var body: some Scene {
        WindowGroup {
            WatchPlanListView(viewModel: viewModel)
        }
    }
}

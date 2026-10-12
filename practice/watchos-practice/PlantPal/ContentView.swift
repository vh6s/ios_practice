//
//  ContentView.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 10.10.2026.
//

import SwiftUI

struct ContentView: View {
    var plantListViewModel = PlantListViewModel()

    var body: some View {
        TabView {
            Tab("Today", systemImage: "calendar.day") {

            }
            Tab("Map", systemImage: "map") {

            }
            Tab("Flowers", systemImage: "leaf") {
                PlantListView(viewModel: plantListViewModel)
            }
        }
    }
}


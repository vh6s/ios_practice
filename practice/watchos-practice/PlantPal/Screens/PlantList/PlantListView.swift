//
//  PlantListView.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 10.10.2026.
//

import SwiftUI

struct PlantListView: View {
    @State private var viewModel: PlantListViewModel
    @State private var isNewPlantPresented = false

    init(viewModel: PlantListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            List(viewModel.state.plants) { plant in
                NavigationLink {
                    PlantDetailView(plant: plant)
                        
                } label: {
                    Text(plant.name)
                }
            }
            .navigationTitle("Plants")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("New plant", systemImage: "plus") {
                        isNewPlantPresented.toggle()
                    }
                }
            }
            .sheet(isPresented: $isNewPlantPresented, onDismiss: viewModel.fetchPlants) {
                PlantFormView()
            }
            .onAppear {
                viewModel.fetchPlants()
            }
        }
    }

}


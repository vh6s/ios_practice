//
//  WatchPlanListView.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 11.10.2026.
//

import SwiftUI

struct WatchPlanListView: View {
    let viewModel: WatchPlanListViewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.state.plants) { plant in
                NavigationLink {
                    
                } label: {
                    Label(plant.name, systemImage: "leaf")
                }
            }
            .navigationTitle("Plants")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: viewModel.isPhoneReachable
                          ? "iphone.radiowaves.left.and.right"
                          : "iphone.slash")
                        .foregroundStyle(viewModel.isPhoneReachable ? .green : .secondary)
                }
            }
            .onAppear() {
                viewModel.fetchPlants()
            }
        }
    }
}

//
//  PlantDetailView.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 10.10.2026.
//

import SwiftUI

// TODO: history, Watered, reload after Edit (stage 3)
struct PlantDetailView: View {
    @State private var viewModel: PlantDetailViewModel
    @State private var isEditPresented = false
    @State private var isDeleteConfirmationPresented = false
    @Environment(\.dismiss) private var dismiss

    init(plant: Plant) {
        viewModel = PlantDetailViewModel(plant: plant)
    }

    var body: some View {
        Form {
            Section("Photo") {
                Image(uiImage: viewModel.state.plant.image)
                    .resizable()
                    .scaledToFit()
            }

            Section("Details") {
                LabeledContent("Room", value: viewModel.state.plant.room.name)
                LabeledContent("Outdoor", value: viewModel.state.plant.isOutdoor ? "Yes" : "No")
                LabeledContent("Water every", value: "\(viewModel.state.plant.wateringIntervalDays) days")
            }

            Section("Watering") {
                LabeledContent("Last watered") {
                    Text(viewModel.state.plant.lastWatered, format: .dateTime.day().month().year())
                }
                LabeledContent("Next watering") {
                    Text(viewModel.state.plant.nextWatering, format: .dateTime.day().month().year())
                }
            }

            Section("Location") {
                LabeledContent("Latitude", value: "\(viewModel.state.plant.coordinate.latitude)")
                LabeledContent("Longitude", value: "\(viewModel.state.plant.coordinate.longitude)")
            }

            Section {
                Button("Delete plant", role: .destructive) {
                    isDeleteConfirmationPresented = true
                }
            }
        }
        .navigationTitle(viewModel.state.plant.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    isEditPresented = true
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Send to Watch", systemImage: "applewatch") {
                    viewModel.sendToWatch()
                }
            }
        }
        .sheet(isPresented: $isEditPresented) {
            PlantFormView(plant: viewModel.state.plant)
        }
        .confirmationDialog(
            "Delete \(viewModel.state.plant.name)?",
            isPresented: $isDeleteConfirmationPresented,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                viewModel.deletePlant()
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        PlantDetailView(plant: Plant(
            name: "Monstera",
            room: .livingRoom,
            isOutdoor: false,
            wateringIntervalDays: 7,
            lastWatered: .now,
            image: UIImage(),
            coordinate: .init(latitude: 49.2099, longitude: 16.6142)
        ))
    }
}

//
//  PlantFormView.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 10.10.2026.
//
import SwiftUI
import PhotosUI

struct PlantFormView: View {
    @State private var viewModel : PlantFormViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(plant: Plant? = nil) {
        viewModel = PlantFormViewModel(plant: plant)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(content: {
                    TextField("Plant name", text: $viewModel.state.name)
                }, header: {
                    Text("Name")
                }, footer: {
                    HStack {
                        Text("Latitude: \(viewModel.state.coordinate.latitude)")
                        Spacer()
                        Text("Longitude: \(viewModel.state.coordinate.longitude)")
                    }
                })

                Section("Details") {
                    Picker("Room", selection: $viewModel.state.room) {
                        ForEach(Room.allCases) { room in
                            Text(room.name).tag(room)
                        }
                    }

                    Stepper(
                        "Water every \(viewModel.state.wateringIntervalDays) days",
                        value: $viewModel.state.wateringIntervalDays,
                        in: 1...60
                    )

                    Toggle("Outdoor", isOn: $viewModel.state.isOutdoor)
                }

                Section("Image") {
                    if let image = viewModel.state.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }

                    PhotosPicker("Select image", selection: $viewModel.state.pickedItem, matching: .images)
                        .onChange(of: viewModel.state.pickedItem) {
                            viewModel.loadPickedImage()
                        }
                }
            }
            .navigationTitle("\(viewModel.state.title) plant")
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.savePlant()
                        dismiss()
                    }
                    .disabled(!viewModel.state.canSave)
                }
            }
        }
    }
}

 
#Preview {
    PlantFormView()
}

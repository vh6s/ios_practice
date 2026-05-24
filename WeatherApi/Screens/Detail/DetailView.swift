//
//  DetailView.swift
//  WeatherApi
//
//  Created by Matěj on 24.05.2026.
//

import SwiftUI

struct DetailView: View {
    @State var viewModel: DetailViewModel
    @State var listViewModel: ListViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        DetailContent(viewModel: viewModel)
            .navigationTitle(viewModel.state.place.name)
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button("Remove") {
                        viewModel.removePlace()
                        listViewModel.loadPlaces()
                        dismiss()
                    }
                }
            }
    }
}

struct DetailContent: View {
    let viewModel: DetailViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Temperature")) {
                Text("\(viewModel.state.weatherData?.current.temp) °C")
            }
            Section(header: Text("Min. Temperature")) {
                Text("\(viewModel.state.weatherData?.daily.minTemperatures.first) °C")
            }
            Section(header: Text("Max. Temperature")) {
                Text("\(viewModel.state.weatherData?.daily.maxTemperatures.first) °C")
            }
            Section(header: Text("Rain")) {
                Text("\(viewModel.state.weatherData?.daily.rainSum.first) mm")
            }
        }
    }
}

import SwiftUI

struct DetailView: View {
    @State var viewModel: DetailViewModel
    @State var listViewModel: ListViewModel
    @Environment(\.dismiss) private var dismiss // action to close current screen
    
    var body: some View {
        DetailContent(viewModel: viewModel)
            .navigationTitle(viewModel.state.place.name)
            .task {
                await viewModel.loadWeather() // await because its async function
            }
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button("Remove") {
                        Task {
                            viewModel.removePlace()
                            await listViewModel.loadPlaces()
                            dismiss()
                        } // wrapped into task because loadPlaces is async function
                    }
                }
            }
    }
}

struct DetailContent: View {
    let viewModel: DetailViewModel
    
    var body: some View {
        Form {
            DetailRow(header: "Temperature", value: viewModel.state.weatherData?.current.temp ?? 0, unit: "°C")
            DetailRow(header: "Min. temperature", value: viewModel.state.weatherData?.daily.minTemperatures.first ?? 0, unit: "°C")
            DetailRow(header: "Max. temperature", value: viewModel.state.weatherData?.daily.maxTemperatures.first ?? 0, unit: "°C")
            DetailRow(header: "Rain", value: viewModel.state.weatherData?.daily.rainSum.first ?? 0, unit: "mm")
        }
    }
}

struct DetailRow: View {
    let header: String
    let value: Double
    let unit: String
    
    var body: some View {
        Section(header: Text(header)) {
            Text("\(value, specifier: "%.1f") \(unit)")
        }
    }
}

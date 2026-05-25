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
            Section(header: Text("Temperature")) {
                Text("\(viewModel.state.weatherData?.current.temp ?? 0, specifier: "%.1f")  °C")
            }
            Section(header: Text("Min. Temperature")) {
                Text("\(viewModel.state.weatherData?.daily.minTemperatures.first ?? 0, specifier: "%.1f") °C")
            }
            Section(header: Text("Max. Temperature")) {
                Text("\(viewModel.state.weatherData?.daily.maxTemperatures.first ?? 0, specifier: "%.1f") °C")
            }
            Section(header: Text("Rain")) {
                Text("\(viewModel.state.weatherData?.daily.rainSum.first ?? 0, specifier: "%.1f") mm")
            }
        }
    }
}

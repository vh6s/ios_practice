import SwiftUI
import Foundation

struct ListView: View {
    @State private var viewModel: ListViewModel
    @State private var isMapPresent: Bool = false
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
    }
 
    var body: some View {
        NavigationStack {
            List(viewModel.state.places) { item in
                NavigationLink {
                    DetailView(viewModel: DetailViewModel(place: item), listViewModel: viewModel)
                        .navigationTitle(item.name)
                } label: {
                    ListRow(place: item)
                }
            }
            .sheet(isPresented: $isMapPresent) {
                NavigationStack {
                    showMapView()
                }
            }
            .navigationTitle(Text("Weather"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isMapPresent.toggle()
                    } label: {
                        Image(systemName: "plus").font(.title2)
                    }
                }
            }
        }
        .task {
            await viewModel.loadPlaces() // load list of places on screen appear
        }
    }

    func showMapView() -> some View {
        let mapViewModel = MapViewModel()
        
        return MapView(viewModel: mapViewModel)
            .navigationTitle("Select Location")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isMapPresent.toggle()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // musime zabalit do Task, jelikoz je ukaldani async funkce
                        Task {
                            await mapViewModel.saveLocation()
                            await viewModel.loadPlaces() // znovu nacteme lokace v listu, aby se objevila nove ulozene misto
                            isMapPresent.toggle()
                        }
                    }
                }
            }
    }
}

struct ListRow: View {
    let place: LocationItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(place.name)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(Int(place.currentTemperature ?? 0)) °C").foregroundStyle(
                    (place.currentTemperature ?? 0) > 20 ? .red : .blue) // more than 20°C = red, less than 20°C = blue
                    
                Text("\(Int(place.rainSum ?? 0)) mm")
            }
        }
    }
}

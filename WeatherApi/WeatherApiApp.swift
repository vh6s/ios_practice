import SwiftUI

@main
struct WeatherApiApp: App {
    var body: some Scene {
        WindowGroup {
            ListView(viewModel: ListViewModel())
        }
    }
}

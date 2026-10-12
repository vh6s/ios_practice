import SwiftUI

@main
struct PlantPalApp: App {
    
    init() {
        let connector: WatchConnecting = DIContainer.shared.resolve()
        let dataManager: DataManaging = DIContainer.shared.resolve()
        connector.onWateredReceived = { id, date in
            dataManager.waterPlant(id: id, date: date)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

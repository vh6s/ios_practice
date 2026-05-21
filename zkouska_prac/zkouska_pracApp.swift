//
//  zkouska_pracApp.swift
//  zkouska_prac
//
//  Created by Matěj on 18.05.2026.
//

import SwiftUI

@main
struct zkouska_pracApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

//
//  TasksApp.swift
//  Tasks Watch App
//
//  Created by Matěj on 12.10.2026.
//

import SwiftUI

@main
struct Tasks_Watch_AppApp: App {
    @State private var connector = Connector()
    
    var body: some Scene {
        WindowGroup {
            ContentView(connector: connector)
        }
    }
}

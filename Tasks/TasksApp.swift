//
//  TasksApp.swift
//  Tasks
//
//  Created by Matěj on 12.10.2026.
//

import SwiftUI

@main
struct TasksApp: App {
    @State private var connector = Connector()
    
    var body: some Scene {
        WindowGroup {
            ContentView(connector: connector)
        }
    }
}

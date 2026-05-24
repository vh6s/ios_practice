//
//  zkouska_pracApp.swift
//  zkouska_prac
//
//  Created by Matěj on 18.05.2026.
//

import SwiftUI

@main
struct zkouska_pracApp: App {
    var viewModel = LibraryViewModel()
    
    init() {
        let manager = CoreDataManager()
        manager.createMockBooks()
    }

    var body: some Scene {
        WindowGroup {
            LibraryView(viewModel: viewModel)
        }
    }
}

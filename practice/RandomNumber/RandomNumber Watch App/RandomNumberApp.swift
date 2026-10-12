//
//  RandomNumberApp.swift
//  RandomNumber Watch App
//
//  Created by Pavel Priehoda on 11.10.2026.
//

import SwiftUI

@main
struct RandomNumber_Watch_AppApp: App {
    @State private var viewModel = NumberGeneratorViewModel()
    
    var body: some Scene {
        WindowGroup {
            NumberGeneratorView(viewModel: viewModel)
        }
    }
}

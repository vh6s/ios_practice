//
//  WeatherApiApp.swift
//  WeatherApi
//
//  Created by Matěj on 24.05.2026.
//

import SwiftUI

@main
struct WeatherApiApp: App {
    var body: some Scene {
        WindowGroup {
            ListView(viewModel: ListViewModel())
        }
    }
}

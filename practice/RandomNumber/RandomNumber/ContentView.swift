//
//  ContentView.swift
//  RandomNumber
//
//  Created by Pavel Priehoda on 11.10.2026.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            Tab("Numbers", systemImage: "number.sign") {
                NumberListView()
            }
            Tab("Neco", systemImage: "trash") {
                
            }
        }
    }
}

#Preview {
    ContentView()
}

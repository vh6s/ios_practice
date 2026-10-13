//
//  ContentView.swift
//  pripravaNaTestIOS2
//
//  Created by endurovojta173 on 09.10.2026.
//

import SwiftUI

struct ContentView: View {
    
    var listViewModel = ListViewModel()
    
    var body: some View {
        TabView{
            Tab("Tasks", systemImage: "list.bullet"){
                ListView(viewModel: listViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}

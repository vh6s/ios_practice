//
//  NumberListView.swift
//  RandomNumber
//
//  Created by Pavel Priehoda on 11.10.2026.
//

import SwiftUI

struct NumberListView: View {
    private var viewModel = NumberListViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.state.numbers) { number in
                NavigationLink {
                    
                } label: {
                    LabeledContent("\(number.number)", value: "\(number.date)")
                }
            }
            .navigationTitle(Text("Numbers"))
            .onAppear {
                viewModel.fetchNumbers()
            }
        }
    }
}

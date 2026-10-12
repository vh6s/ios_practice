//
//  NumberGeneratorView.swift
//  RandomNumber
//
//  Created by Pavel Priehoda on 11.10.2026.
//
import SwiftUI

struct NumberGeneratorView: View {
    let viewModel: NumberGeneratorViewModel
    
    var body: some View {
        VStack {
            Text("\(viewModel.state.number?.number ?? 0)")
            Button("Generate Number") {
                viewModel.sendNumber()
            }
        }
    }
}

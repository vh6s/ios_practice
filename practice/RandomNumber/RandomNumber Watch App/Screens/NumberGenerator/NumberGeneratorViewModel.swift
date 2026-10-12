//
//  NumberGeneratorViewModel.swift
//  RandomNumber
//
//  Created by Pavel Priehoda on 11.10.2026.
//
import SwiftUI

@Observable
final class NumberGeneratorViewModel {
    var state = NumberGeneratorViewState()
    
    private var connector: WatchConnecting
    
    init() {
        connector = DIContainer.shared.resolve()
    }
    
    func sendNumber() {
        state.number = NumberMessage(
            number: Int.random(in: 1 ... 100),
            date: .now)
        connector.send(state.number!)
    }
}

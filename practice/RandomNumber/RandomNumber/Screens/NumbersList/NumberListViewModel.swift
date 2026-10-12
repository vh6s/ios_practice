//
//  NumberListViewModel.swift
//  RandomNumber
//
//  Created by Pavel Priehoda on 11.10.2026.
//

import Foundation

@Observable
class NumberListViewModel {
    var state: NumberListViewState = NumberListViewState()
    
    private var dataManager: DataManaging
    private var connector: WatchConnecting
    
    init() {
        dataManager = DIContainer.shared.resolve()
        connector = DIContainer.shared.resolve()
        
        connector.onNumberReceived = { [weak self] number in
            self?.dataManager.saveNumber(number)
            self?.fetchNumbers()
        }
    }
    
    func fetchNumbers() {
        state.numbers = dataManager.fetchNumbers()
    }
}

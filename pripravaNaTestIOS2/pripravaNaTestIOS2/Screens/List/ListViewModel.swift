//
//  ListViewModel.swift
//  pripravaNaTestIOS2
//
//  Created by endurovojta173 on 10.10.2026.
//

import SwiftUI

@Observable
class ListViewModel{
    
    var state: ListViewState = ListViewState()
    
    //Musime zakomponovat connector aby se odesilali data do hodinek
    var connector = Connector()
    
    private var dataManager: DataManaging
    
    init() {
        dataManager = DIContainer.shared.resolve()
        
        // Odchycení akce z hodinek
        connector.onTaskToggled = { [weak self] id in
            self?.dataManager.toggleTask(id: id)
            self?.fetchTasks() // fetchTasks načte nová data a rovnou je odešle (obsahuje connector.sendTasks)
        }
    }
    
    func fetchTasks(){
        state.tasks = dataManager.fetchTasks()
        
        connector.sendTasks(state.tasks)
    }
    
}

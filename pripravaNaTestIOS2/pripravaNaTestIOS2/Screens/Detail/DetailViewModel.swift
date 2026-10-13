//
//  DetailViewModel.swift
//  pripravaNaTestIOS2
//
//  Created by endurovojta173 on 10.10.2026.
//

import SwiftUI

@Observable

class DetailViewModel{
    var state: DetailViewState
    
    private var dataManager: DataManaging
    
    init(task: Task){
        self.state = DetailViewState(task: task)
        self.dataManager = DIContainer.shared.resolve()
    }
    
    func deleteTask(){
        dataManager.deleteTask(id: state.task.id)
    }
    
    //Zavola se pri editaci tasku
    func refreshTask() {
        if let updatedTask = dataManager.fetchTask(id: state.task.id) {
            state.task = updatedTask
        }
    }
}

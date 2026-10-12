//
//  AddTaskViewModel.swift
//  Tasks
//
//  Created by Pavel Priehoda on 12.10.2026.
//
import Foundation

@Observable
class AddTaskViewModel {
    var state = AddTaskViewState()
    
    private var dataManager: DataManaging
    private var connector: ConnectorManaging
    
    init() {
        dataManager = DIContainer.shared.resolve()
        connector = DIContainer.shared.resolve()
    }
    
    func addTask() {
        let task = TaskItem(
            title: state.title,
            taskDescription: state.taskDescription,
            completionDate: state.completionDate)
        dataManager.saveTask(task)
        connector.send(task)
    }
}

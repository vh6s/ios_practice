//
//  TaskListViewModel.swift
//  Tasks
//
//  Created by Pavel Priehoda on 12.10.2026.
//
import Foundation

@Observable
final class TaskListViewModel {
    
    var state = TaskListViewState()
    private var dataManager: DataManaging
    private let connector: ConnectorManaging
    
    init() {
        dataManager = DIContainer.shared.resolve()
        self.connector = DIContainer.shared.resolve()
        
        connector.onTaskReceived = { [weak self] task in
            self?.dataManager.saveTask(task)
            self?.fetchTasks()
        }
    }
    
    func fetchTasks() {
        state.tasks = dataManager.fetchTasks()
            .sorted{ $0.completionDate < $1.completionDate }
    }
    
    func toggle(task: TaskItem) {
        var updated = task
        updated.completed.toggle()
        
        dataManager.saveTask(updated)
        connector.send(updated)
        fetchTasks()
    }
}

//
//  TaskListViewModel.swift
//  Tasks
//
//  Created by Pavel Priehoda on 12.10.2026.
//
import Foundation

@Observable
class TaskListViewModel {
    var state: TaskListViewState = TaskListViewState()
    
    private let connector: ConnectorManaging
    
    init() {
        connector = DIContainer.shared.resolve()
        
        connector.onTaskReceived = { [weak self] task in
            self?.saveTask(task: task)
        }
    }
    
    func toggle(task: TaskItem) {
        var updated = task
        updated.completed.toggle()
        saveTask(task: updated)
        connector.send(updated)
    }
    
    func saveTask(task: TaskItem) {
        if let index = state.tasks.firstIndex(where: { $0.id == task.id }) {
            state.tasks[index] = task
        } else {
            state.tasks.append(task)
        }
    }
}

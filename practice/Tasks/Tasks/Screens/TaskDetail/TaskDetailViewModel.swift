//
//  TaskDetailViewModel.swift
//  Tasks
//
//  Created by Pavel Priehoda on 12.10.2026.
//
import Foundation

@Observable
class TaskDetailViewModel {
    var state: TaskDetailViewState

    init(task: TaskItem) {
        state = TaskDetailViewState(task: task)
    }
}

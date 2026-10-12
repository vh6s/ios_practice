//
//  TaskDetailViewState.swift
//  Tasks
//
//  Created by Pavel Priehoda on 12.10.2026.
//
import Foundation

@Observable
class TaskDetailViewState {
    var task: TaskItem

    init(task: TaskItem) {
        self.task = task
    }
}

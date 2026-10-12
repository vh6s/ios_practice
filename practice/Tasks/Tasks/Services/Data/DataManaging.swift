//
//  DataManaging.swift
//  Tasks
//
//  Created by Pavel Priehoda on 12.10.2026.
//

import Foundation

protocol DataManaging {
    func saveTask(_ task: TaskItem)
    func fetchTasks() -> [TaskItem]
}

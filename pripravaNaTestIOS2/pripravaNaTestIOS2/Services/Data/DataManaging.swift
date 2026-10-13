//
//  DataManaging.swift
//  pripravaNaTestIOS2
//
//  Created by endurovojta173 on 10.10.2026.
//

import Foundation

protocol DataManaging{
    func saveTask(_ task: Task)
    func fetchTasks()->[Task]
    func fetchTask(id: UUID) -> Task?
    func deleteTask(id: UUID)
    // for checking tasks
    func toggleTask(id: UUID)
}

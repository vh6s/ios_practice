//
//  Task.swift
//  Tasks
//
//  Created by Pavel Priehoda on 12.10.2026.
//

import Foundation

struct TaskItem: Identifiable {
    var id: UUID = UUID()
    var title: String
    var taskDescription: String
    var completionDate: Date
    var completed: Bool = false

    static func getSample() -> TaskItem {
        TaskItem(
            title: "Buy milk",
            taskDescription: "Two litres, semi-skimmed",
            completionDate: Date()
        )
    }
}

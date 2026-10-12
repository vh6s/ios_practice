//
//  CompleteTaskIntent.swift
//  Tasks
//
//  Created by Pavel Priehoda on 12.10.2026.
//

import AppIntents

struct CompleteTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "Complete task"

    @Parameter(title: "Task ID")
    var taskId: String

    init() {}

    init(taskId: UUID) {
        self.taskId = taskId.uuidString
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        let dataManager: DataManaging = DIContainer.shared.resolve()
        guard var task = dataManager.fetchTasks().first(where: { $0.id.uuidString == taskId })
        else { return .result() }

        task.completed = true
        dataManager.saveTask(task)
        return .result()
    }
}

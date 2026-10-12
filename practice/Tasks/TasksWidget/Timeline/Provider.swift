//
//  Provider.swift
//  Tasks
//
//  Created by Pavel Priehoda on 12.10.2026.
//

import WidgetKit

struct Provider: TimelineProvider {
    let dataManager: DataManaging
    
    init() {
        dataManager = DIContainer.shared.resolve()
    }
    
    func placeholder(in context: Context) -> TaskEntry {
        TaskEntry(
            date: Date(),
            task: TaskItem(title: "Title", taskDescription: "Description", completionDate: .now)
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> Void) {
        Task { @MainActor in // Core Data viewContext is main-thread only
            completion(currentEntry())
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TaskEntry>) -> Void) {
        Task { @MainActor in
            // the app reloads the timeline after every saved number
            completion(Timeline(entries: [currentEntry()], policy: .never))
        }
    }

    private func currentEntry() -> TaskEntry {
        let next = dataManager.fetchTasks()
                .filter { !$0.completed }
                .min { $0.completionDate < $1.completionDate }
            return TaskEntry(date: .now, task: next)
    }
}

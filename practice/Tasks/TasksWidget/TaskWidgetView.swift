//
//  TaskWidgetView.swift
//  Tasks
//
//  Created by Pavel Priehoda on 12.10.2026.
//

import AppIntents
import SwiftUI
import WidgetKit

struct TaskWidgetView: View {
    let entry: TaskEntry

    var body: some View {
        if let task = entry.task {
            VStack(alignment: .leading) {
                Text("Next task")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(task.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(task.completionDate, format: .dateTime.day().month().hour().minute())
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Button(intent: CompleteTaskIntent(taskId: task.id)) {
                    Label("Done", systemImage: "checkmark.circle")
                        .font(.caption)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            VStack {
                Image(systemName: "checkmark.circle")
                    .font(.title)
                Text("No upcoming tasks")
                    .font(.caption)
            }
            .foregroundStyle(.secondary)
        }
    }
}

#Preview(as: .systemSmall) {
    TasksWidget()
} timeline: {
    TaskEntry(date: .now, task: TaskItem.getSample())
    TaskEntry(date: .now, task: nil)
}

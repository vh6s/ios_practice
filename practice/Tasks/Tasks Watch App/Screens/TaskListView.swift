//
//  TaskListView.swift
//  Tasks
//
//  Created by Pavel Priehoda on 12.10.2026.
//

import SwiftUI

struct TaskListView: View {
    @State private var viewModel = TaskListViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.state.tasks) { task in
                    Toggle(isOn: Binding(
                        get: { task.completed },
                        set: { _ in viewModel.toggle(task: task) }
                    )) {
                            VStack(alignment: .leading) {
                                Text(task.title)
                                Text(task.completionDate, format: .dateTime.day().month().year())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                }
            .navigationTitle("Task list")
        }
    }
}
    
    

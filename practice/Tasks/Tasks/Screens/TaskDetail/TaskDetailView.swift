//
//  TaskDetailView.swift
//  Tasks
//
//  Created by Pavel Priehoda on 12.10.2026.
//

import SwiftUI

struct TaskDetailView: View {
    @State private var viewModel: TaskDetailViewModel

    init(task: TaskItem) {
        viewModel = TaskDetailViewModel(task: task)
    }

    var body: some View {
        List {
            Section("Description") {
                Text(viewModel.state.task.taskDescription)
            }

            Section {
                LabeledContent("Completion date") {
                    Text(viewModel.state.task.completionDate, format: .dateTime.day().month().year().hour().minute())
                }
                LabeledContent("Completed") {
                    Image(systemName: viewModel.state.task.completed ? "checkmark.circle.fill" : "circle")
                }
            }
        }
        .navigationTitle(viewModel.state.task.title)
    }
}


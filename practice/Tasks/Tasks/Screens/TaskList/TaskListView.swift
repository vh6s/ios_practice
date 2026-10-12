//
//  TaskListView.swift
//  Tasks
//
//  Created by Pavel Priehoda on 12.10.2026.
//

import SwiftUI

struct TaskListView: View {
    @State private var viewModel = TaskListViewModel()
    @State private var isAddTaskPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            List(viewModel.state.tasks) { task in
                NavigationLink {
                    TaskDetailView(task: task)
                } label: {
                    Toggle(isOn: completedBinding(for: task)) {
                            VStack(alignment: .leading) {
                                Text(task.title)
                                Text(task.completionDate, format: .dateTime.day().month().year())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                }
            }
            .sheet(isPresented: $isAddTaskPresented, onDismiss: viewModel.fetchTasks) {
                AddTaskView()
            }
            .navigationTitle("Task list")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add task", systemImage: "add") {
                        isAddTaskPresented.toggle()
                    }
                }
            }
            .onAppear {
                viewModel.fetchTasks()
            }
            .refreshable {
                viewModel.fetchTasks()
            }
        }
    }
    
    private func completedBinding(for task: TaskItem) -> Binding<Bool> {
        Binding(
            get: { task.completed },
            set: { _ in viewModel.toggle(task: task) }
        )
    }
}


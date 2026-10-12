//
//  AddTaskView.swift
//  Tasks
//
//  Created by Pavel Priehoda on 12.10.2026.
//

import SwiftUI

struct AddTaskView: View {
    @State private var viewModel = AddTaskViewModel()
    @Environment(\.dismiss) private var dismiss

    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $viewModel.state.title)
                    TextField("Description", text: $viewModel.state.taskDescription)
                    DatePicker("Completion date", selection: $viewModel.state.completionDate)
                }
            }
            .navigationTitle("Add task")
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.addTask()
                        dismiss()
                    }
                }
            }
        }
        
    }
}

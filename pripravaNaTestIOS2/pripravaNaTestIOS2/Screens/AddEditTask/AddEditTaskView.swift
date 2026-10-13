//
//  AddEditTaskView.swift
//  pripravaNaTestIOS2
//
//  Created by endurovojta173 on 10.10.2026.
//

import SwiftUI

struct AddEditTaskView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AddEditTaskViewModel
    
    var onSaveSuccess: () -> Void
    
    // Vlastní init pro předání úkolu a callbacku do State ViewModelu
    init(task: Task? = nil, onSaveSuccess: @escaping () -> Void) {
        _viewModel = State(wrappedValue: AddEditTaskViewModel(task: task))
        self.onSaveSuccess = onSaveSuccess
    }
    
    var body: some View {
        NavigationStack {
            Form {
                @Bindable var bindableViewModel = viewModel
                
                TextField("Název úkolu", text: $bindableViewModel.state.title)
                TextField("Popis úkolu", text: $bindableViewModel.state.text)
            }
            // Dynamický nadpis podle toho, zda přidáváme nebo editujeme
            .navigationTitle(viewModel.isEditing ? "Upravit úkol" : "Nový úkol")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zrušit") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Uložit") {
                        viewModel.saveTask()
                        onSaveSuccess()
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}

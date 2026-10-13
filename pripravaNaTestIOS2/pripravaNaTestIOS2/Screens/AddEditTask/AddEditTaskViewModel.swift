//
//  AddEditTaskViewModel.swift
//  pripravaNaTestIOS2
//
//  Created by endurovojta173 on 10.10.2026.
//

import SwiftUI

@Observable
final class AddEditTaskViewModel {
    var state = AddEditTaskState()
    private let dataManager = CoreDataManager()
    
    // Uchováme si ID úkolu pro případ editace
    private var editingTaskID: UUID?
    
    // Pomocná vlastnost pro View
    var isEditing: Bool {
        editingTaskID != nil
    }
    
    // Pokud předáš nil, formulář bude prázdný (Přidávání)
    // Pokud předáš Task, formulář se předvyplní (Editace)
    init(task: Task? = nil) {
        if let task = task {
            self.state.title = task.title
            self.state.text = task.text
            self.editingTaskID = task.id
        }
    }
    
    func saveTask() {
        // Pokud editingTaskID existuje, použijeme ho. Jinak vytvoříme nové UUID.
        let taskToSave = Task(
            id: editingTaskID ?? UUID(),
            title: state.title,
            text: state.text
        )
        dataManager.saveTask(taskToSave)
    }
    
    var isValid: Bool {
        !state.title.isEmpty
    }
}

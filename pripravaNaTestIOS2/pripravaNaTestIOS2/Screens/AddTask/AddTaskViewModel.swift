//
//  AddTaskViewModel.swift
//  pripravaNaTestIOS2
//
//  Created by endurovojta173 on 10.10.2026.
//
import SwiftUI

@Observable
final class AddTaskViewModel {
    var state = AddTaskState()
    private let dataManager = CoreDataManager()
    
    func saveTask() {
        let newTask = Task(id: UUID(), title: state.title, text: state.text)
        dataManager.saveTask(newTask)
    }
    
    var isValid: Bool {
        !state.title.isEmpty
    }
}

//
//  AddTaskViewState.swift
//  Tasks
//
//  Created by Pavel Priehoda on 12.10.2026.
//
import Foundation

@Observable
class AddTaskViewState {
    var title: String = ""
    var taskDescription: String = ""
    var completionDate: Date = Date()
}

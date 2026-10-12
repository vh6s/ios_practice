//
//  ContentView.swift
//  Tasks Watch App
//
//  Created by Matěj on 12.10.2026.
//

import SwiftUI

struct ContentView: View {
    @Bindable var connector: Connector
    @State private var taskText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Message", text: $taskText)
                    Button("Send") {
                        let newTask = TodoTask(text: taskText, date: nil)
                        connector.tasks.insert(newTask, at: 0)
                        connector.send(newTask)
                        taskText = ""
                    }
                    .disabled(taskText.isEmpty)
                }
                
                Section("Task list") {
                    if connector.tasks.isEmpty {
                        Text("No tasks have been added")
                            .foregroundStyle(.secondary)
                    }
                    ForEach($connector.tasks) { $task in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(task.text)
                                if let completionDate = task.date {
                                    Text(completionDate.formatted(date: .numeric, time: .shortened))
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            
                            Toggle("", isOn: $task.isCompleted)
                                .labelsHidden()
                                .onChange(of: task.isCompleted) { oldVal, newVal in
                                    
                                    if newVal == true {
                                        task.date = Date()
                                    } else {
                                        task.date = nil
                                    }
                                    connector.send(task)
                                }
                        }
                    }
                }
                .navigationTitle("Todo List")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Image(systemName: connector.isReachable
                              ? "iphone.radiowaves.left.and.right"
                              : "iphone.slash")
                        .foregroundStyle(connector.isReachable ? .green : .secondary)
                    }
                }
            }
        }
    }
}



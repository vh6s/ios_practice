//
//  ContentView.swift
//  Tasks
//
//  Created by Matěj on 12.10.2026.
//

import SwiftUI

struct ContentView: View {
    @Bindable var connector: Connector
    @State private var taskText: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("", text: $taskText)
                    Button("Send") {
                        let newTask = TodoTask(text: taskText, date: nil)
                        connector.tasks.insert(newTask, at: 0)
                        connector.send(newTask)
                        taskText = ""
                    }
                    .disabled(taskText.isEmpty)
                } header: {
                    Text("New Task")
                } footer: {
                    Text(connector.isReachable
                         ? "The watch app is reachable: the message goes right away."
                         : "The watch app is not reachable: the message waits in a queue.")
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
            }
        }
    }
}

#Preview {
    ContentView(connector: Connector())
}

//
//  TasksWidget.swift
//  TasksWidget
//
//  Created by Pavel Priehoda on 12.10.2026.
//

import WidgetKit
import SwiftUI

struct TasksWidget: Widget {
    let kind: String = "TasksWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TaskWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Next Task")
        .description("Shows the nearest unfinished task.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


//
//  RandomNumberWidget.swift
//  RandomNumber Widget
//
//  Created by Pavel Priehoda on 11.10.2026.
//

import WidgetKit
import SwiftUI

struct RandomNumberWidget: Widget {
    let kind: String = "RandomNumberWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RandomNumberWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Random Number")
        .description("Shows the last saved number.")
    }
}

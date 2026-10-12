//
//  Provider.swift
//  RandomNumber Widget
//
//  Created by Pavel Priehoda on 11.10.2026.
//
import WidgetKit

struct Provider: TimelineProvider {
    private let dataManager: DataManaging

    init() {
        dataManager = DIContainer.shared.resolve()
    }

    func placeholder(in context: Context) -> NumberEntry {
        NumberEntry(date: .now, number: NumberMessage(number: 42, date: .now))
    }

    func getSnapshot(in context: Context, completion: @escaping (NumberEntry) -> Void) {
        Task { @MainActor in // Core Data viewContext is main-thread only
            completion(currentEntry())
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NumberEntry>) -> Void) {
        Task { @MainActor in
            // the app reloads the timeline after every saved number
            completion(Timeline(entries: [currentEntry()], policy: .never))
        }
    }

    private func currentEntry() -> NumberEntry {
        NumberEntry(date: .now, number: dataManager.fetchNumbers().first)
    }
}

//
//  CoreDataManager.swift
//  RandomNumber
//
//  Created by Pavel Priehoda on 11.10.2026.
//
import WidgetKit
import SwiftUI
import CoreData

final class CoreDataManager: DataManaging {

    static let appGroup = "group.paja.RandomNumber"
    
    private let container = NSPersistentContainer(name: "RandomNumber") // beware of typos!
    private var context: NSManagedObjectContext { container.viewContext }

    init() {
        if let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Self.appGroup) {
                container.persistentStoreDescriptions = [
                    NSPersistentStoreDescription(url: groupURL.appending(path: "RandomNumber.sqlite"))
                ]
            } else {
                print("App Group \(Self.appGroup) is not available, the widget will not see the data.")
            }
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to create container: \(error.localizedDescription)")
            }
        }
    }

    func saveNumber(_ number: NumberMessage) {
        let entity = RandomNumberEntity(context: context) // if none is found, create one
        entity.id = number.id
        entity.number = Int16(number.number)
        entity.date = number.date
        save()
        WidgetCenter.shared.reloadAllTimelines()
    }

    func fetchNumbers() -> [NumberMessage] {
        let request = NSFetchRequest<RandomNumberEntity>(entityName: "RandomNumberEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)] // newest first

        do {
            let entities = try context.fetch(request)
            
            return entities.map{ entity in
                return NumberMessage(
                    id: entity.id ?? UUID(),
                    number: Int(entity.number),
                    date: entity.date ?? Date())
            }
        } catch {
            print("CoreDataManager fetchPlaces error: \(error.localizedDescription)")
            return []
        }
    }
}

// MARK: Private methods
private extension CoreDataManager {

    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Cannot save MOC: \(error.localizedDescription)")
            }
        }
    }
}

//
//  CoreDataManager.swift
//  Tasks
//
//  Created by Pavel Priehoda on 12.10.2026.
//
import WidgetKit
import CoreData
import Foundation

final class CoreDataManager: DataManaging {
    static let appGroup = "group.paja.Tasks"
    
    private let container = NSPersistentContainer(name: "Tasks") // beware of typos!
    private var context: NSManagedObjectContext { container.viewContext }

    init() {
        if let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Self.appGroup) {
                container.persistentStoreDescriptions = [
                    NSPersistentStoreDescription(url: groupURL.appending(path: "Tasks.sqlite"))
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
    
    func saveTask(_ task: TaskItem) {
        let request = NSFetchRequest<TaskItemEntity>(entityName: "TaskItemEntity")
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)

        do {
            let result = try context.fetch(request)
            let entity = result.first ?? TaskItemEntity(context: context)
            entity.id = task.id
            entity.title = task.title
            entity.completionDate = task.completionDate
            entity.taskDescription = task.taskDescription
            entity.completed = task.completed
            save()
        } catch {
            print("CoreDataManager saveTask error: \(error.localizedDescription)")
        }
    }
    
    func fetchTasks() -> [TaskItem] {
        let request = NSFetchRequest<TaskItemEntity>(entityName: "TaskItemEntity")
        do {
            let entities = try context.fetch(request)
            
            return entities.map{ entity in
                return TaskItem(
                    id: entity.id ?? UUID(),
                    title: entity.title ?? "No title",
                    taskDescription: entity.taskDescription ?? "No description",
                    completionDate: entity.completionDate ?? Date(),
                    completed: entity.completed
                )
            }
        } catch {
            print("CoreDataManager fetchTasks error: \(error.localizedDescription)")
            return []
        }
    }
    
    
    
}

private extension CoreDataManager {

    func save() {
        if context.hasChanges {
            do {
                try context.save()
                WidgetCenter.shared.reloadAllTimelines()
            } catch {
                print("Cannot save MOC: \(error.localizedDescription)")
            }
        }
    }
}

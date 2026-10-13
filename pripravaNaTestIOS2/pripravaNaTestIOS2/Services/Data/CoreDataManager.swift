//
//  CoreDataManager.swift
//  pripravaNaTestIOS2
//
//  Created by endurovojta173 on 10.10.2026.
//
import SwiftUI
import CoreData


final class CoreDataManager: DataManaging{
    
    private let container = NSPersistentContainer(name: "Task") // beware of typos!
    private var context: NSManagedObjectContext { container.viewContext }

    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to create container: \(error.localizedDescription)")
            }
        }
    }
    
    func saveTask(_ task: Task){
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            let entity = results.first ?? TaskEntity(context: context) // if none is found, create one
            entity.id = task.id
            entity.title = task.title
            entity.text = task.text
            entity.isCompleted = task.isCompleted
            save()
        } catch {
            print("CoreDataManager savePlace error: \(error.localizedDescription)")
        }
        
        
    }
    func fetchTasks()->[Task]{
        
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        
        do {
            let entities = try context.fetch(request)
            
            return entities.map{ entity in
                return Task(
                    id: entity.id ?? UUID(),
                    title: entity.title ?? "Bez nadpisu",
                    text: entity.text ?? "Bez popisku",
                    isCompleted: entity.isCompleted // <-- Přidej tento řádek
                )
            }
        } catch {
            print("CoreDataManager fetchPlaces error: \(error.localizedDescription)")
            return []
        }
        
    }
    
    func fetchTask(id: UUID) -> Task?{
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try context.fetch(request)
                guard let entity = results.first else { return nil }
                
                return Task(
                    id: entity.id ?? UUID(),
                    title: entity.title ?? "Bez nadpisu",
                    text: entity.text ?? "Bez popisku",
                    isCompleted: entity.isCompleted // <-- Přidej tento řádek
                )
            } catch {
                print("CoreDataManager fetchTask error: \(error.localizedDescription)")
                return nil
            }
        
    }
    func deleteTask(id: UUID){
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try context.fetch(request)
                if let entity = results.first {
                    context.delete(entity)
                    save()
                }
            } catch {
                print("CoreDataManager deleteTask error: \(error.localizedDescription)")
            }
    }
    
    func toggleTask(id: UUID) {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            if let entity = try context.fetch(request).first {
                entity.isCompleted.toggle()
                save()
            }
        } catch {
            print("Chyba při změně stavu: \(error)")
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

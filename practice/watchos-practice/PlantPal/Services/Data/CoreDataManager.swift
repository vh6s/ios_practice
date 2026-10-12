//
//  CoreDataManager.swift
//  PlantPal
//
//  Created by Pavel Priehoda on 10.10.2026.
//
import CoreData
import SwiftUI

final class CoreDataManager: DataManaging {
    
    private let container = NSPersistentContainer(name: "PlantPal") // beware of typos!
    private var context: NSManagedObjectContext { container.viewContext }

    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to create container: \(error.localizedDescription)")
            }
        }
    }
    
    func savePlant(_ plant: Plant) {
        let request = NSFetchRequest<PlantEntity>(entityName: "PlantEntity")
        request.predicate = NSPredicate(format: "id == %@", plant.id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            let entity = results.first ?? PlantEntity(context: context)
            entity.id = plant.id
            entity.name = plant.name
            entity.image = plant.image.pngData()
            entity.room = plant.room.rawValue
            entity.isOutdoor = plant.isOutdoor
            entity.wateringIntervalDays = Int16(plant.wateringIntervalDays)
            entity.lastWatered = plant.lastWatered
            entity.latitude = plant.coordinate.latitude
            entity.longitude = plant.coordinate.longitude
            save()
        } catch {
            print("CoreDataManager savePlant error: \(error.localizedDescription)")
        }
    }
    
    func fetchPlants() -> [Plant] {
        let request = NSFetchRequest<PlantEntity>(entityName: "PlantEntity")
        do {
            let entities = try context.fetch(request)
            
            return entities.map{ entity in
                return Plant(
                    id: entity.id ?? UUID(),
                    name: entity.name ?? "No name",
                    room: Room(rawValue: entity.room) ?? .livingRoom,
                    isOutdoor: entity.isOutdoor,
                    wateringIntervalDays: Int(entity.wateringIntervalDays),
                    lastWatered: entity.lastWatered ?? .now,
                    image: UIImage(data: entity.image ?? Data()) ?? UIImage(),
                    coordinate: CLLocationCoordinate2D(latitude: entity.latitude, longitude: entity.longitude)
                )
            }
        } catch {
            print("CoreDataManager fetchPlants error: \(error.localizedDescription)")
            return []
        }
    }
    
    func waterPlant(id: UUID, date: Date) {
        let request = NSFetchRequest<PlantEntity>(entityName: "PlantEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            guard let entity = results.first else { return }
            
            let wateringEntity = WateringEntity(context: context)
            wateringEntity.date = date
            wateringEntity.plant = entity
            entity.lastWatered = date
            save()
        } catch {

        }
    }

    func deletePlant(_ plant: Plant) {
        let request = NSFetchRequest<PlantEntity>(entityName: "PlantEntity")
        request.predicate = NSPredicate(format: "id == %@", plant.id as CVarArg)

        do {
            guard let entity = try context.fetch(request).first else { return }
            context.delete(entity) // waterings go too, the relationship is Cascade
            save()
        } catch {
            print("CoreDataManager deletePlant error: \(error.localizedDescription)")
        }
    }
}

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

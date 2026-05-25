import SwiftUI
import CoreData
import MapKit
import Foundation

final class CoreDataManager: DataManaging {
    // Name must be exactly same as the `.xcdatamodeld`
    private let container = NSPersistentContainer(name: "WeatherApi")
    // context used for operations inside CoreData
    private var context: NSManagedObjectContext { container.viewContext }
    
    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to create container: \(error.localizedDescription)")
            }
        }
    }
    
    func savePlace(_ item: LocationItem) {
        let request = NSFetchRequest<Location>(entityName: "Location")
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)

        do {
            let results = try context.fetch(request)
            let entity = results.first ?? Location(context: context) // if none is found, create one
            entity.id = item.id
            entity.lat = item.coordinate.latitude
            entity.long = item.coordinate.longitude
            entity.name = item.name
            save()
        } catch {
            print("CoreDataManager savePlace error: \(error.localizedDescription)")
        }
    }
    
    func fetchPlaces() -> [LocationItem] {
        let request = NSFetchRequest<Location>(entityName: "Location")
        
        do {
            let entities = try context.fetch(request)
            
            return entities.map{ entity in
                return LocationItem(
                    id: entity.id ?? UUID(),
                    coordinate: CLLocationCoordinate2D(latitude: entity.lat, longitude: entity.long),
                    name: entity.name ?? "No name")
            }
        } catch {
            print("CoreDataManager fetchPlaces error: \(error.localizedDescription)")
            return []
        }
    }
    
    func removePlace(_ item: LocationItem) {
        let request = NSFetchRequest<Location>(entityName: "Location")
            // Najdeme konkrétní entitu podle ID, stejně jako při ukládání
            request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
                
            do {
                let results = try context.fetch(request)
                    
                // Pokud záznam existuje, smažeme ho z kontextu
                if let entityToDelete = results.first {
                    context.delete(entityToDelete)
                    save()
                }
            } catch {
                print("CoreDataManager removePlace error: \(error.localizedDescription)")
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

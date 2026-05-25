//
//  CoreDataManager.swift
//  zkouska_prac
//
//  Created by Matěj on 23.05.2026.
//
import SwiftUI
import CoreData

final class CoreDataManager: DataManaging {

    private let container = NSPersistentContainer(name: "zkouska_prac") // beware of typos!
    private var context: NSManagedObjectContext { container.viewContext }

    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to create container: \(error.localizedDescription)")
            }
        }
    }

    func saveLoan(_ item: LoanItem) {
        let request = NSFetchRequest<Loan>(entityName: "Loan")
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)

        do {
            let results = try context.fetch(request)
            let entity = results.first ?? Loan(context: context) // if none is found, create one
            entity.id = item.id
            entity.borrowDate = item.borrowDate
            entity.dueDate = item.dueDate
            entity.readerName = item.readerName
            entity.returnedDate = item.returnedDate
            
            let bookRequest = NSFetchRequest<Book>(entityName: "Book")
            bookRequest.predicate = NSPredicate(format: "id == %@", item.bookId as CVarArg)

            let bookEntity = try context.fetch(bookRequest).first

            // PROPOJENÍ LOAN -> BOOK
            entity.relationship = bookEntity
            save()
            
        } catch {
            print("CoreDataManager savePlace error: \(error.localizedDescription)")
        }
    }

    func fetchLoans() -> [LoanItem] {
        let request = NSFetchRequest<Loan>(entityName: "Loan")
        
        do {
            let entities = try context.fetch(request)
            
            return entities.map{ entity in
                return LoanItem(
                    id: entity.id ?? UUID(),
                    borrowDate: entity.borrowDate ?? Date(),
                    dueDate: entity.dueDate ?? Date(),
                    returnedDate: entity.returnedDate,
                    readerName: entity.readerName ?? "Reader name not set",
                    bookId: entity.relationship?.id ?? UUID())
            }
        } catch {
            print("CoreDataManager fetchLoans error: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchBooks() -> [BookItem] {
        let request = NSFetchRequest<Book>(entityName: "Book")
        
        do {
            let entities = try context.fetch(request)
            
            return entities.map{ entity in
                return BookItem(
                    id: entity.id ?? UUID(),
                    author: entity.author ?? "Author not set",
                    title: entity.title ?? "Title not set",
                    image: UIImage(data: entity.imageData ?? Data()) ?? UIImage(),
                    type: BookType(rawValue: entity.type) ?? .textbook,
                    loanId: entity.relationship?.id
                )
            }
        } catch {
            print("CoreDataManager fetchBooks error: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveBook(_ item: BookItem) {
        let request = NSFetchRequest<Book>(entityName: "Book")
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            let entity = results.first ?? Book(context: context)
            
            entity.id = item.id
            entity.author = item.author
            entity.title = item.title
            entity.imageData = item.image.pngData()
            entity.type = item.type.rawValue
            
            if let loanId = item.loanId {
                let loanRequest = NSFetchRequest<Loan>(entityName: "Loan")
                loanRequest.predicate = NSPredicate(format: "id == %@", loanId as CVarArg)

                entity.relationship = try context.fetch(loanRequest).first
                } else {
                    entity.relationship = nil
            }
            save()
            
        } catch {
            print("saveBook error: \(error.localizedDescription)")
        }
    }
    
    func createMockBooks() {
        let request = NSFetchRequest<Book>(entityName: "Book")
        
        do {
            let count = try context.count(for: request)
            guard count == 0 else {
                return
            }
            
            let books: [BookItem] = [
                BookItem(
                    author: "Karel Čapek",
                    title: "R.U.R.",
                    image: UIImage(named: "rur") ?? UIImage(),
                    type: .novel
                ),
                BookItem(
                    author: "George Orwell",
                    title: "1984",
                    image: UIImage(named: "1984") ?? UIImage(),
                    type: .novel
                ),
                BookItem(
                    author: "Stephen Hawking",
                    title: "Brief History of Time",
                    image: UIImage(named: "bhot") ?? UIImage(),
                    type: .textbook
                )
            ]
            
            books.forEach { saveBook($0) }
            print("Mock books inserted.")
        } catch {
            print("Seed error: \(error.localizedDescription)")
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

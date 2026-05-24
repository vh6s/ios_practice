//
//  AddLoanViewModel.swift
//  zkouska_prac
//
//  Created by Matěj on 21.05.2026.
//

import SwiftUI

@Observable
class AddLoanViewModel {
    var state: AddLoanState = AddLoanState()
    private var dataManager: DataManaging
    
    init(books: [BookItem]) {
        dataManager = DIContainer.shared.resolve()
        print("DEBUG: AddLoanViewModel init")
        print("DEBUG: books passed: \(books.count)")
        
        // vybereme jen dostupne knihy, ktere nejsou aktualne pujcene
        state.availableBooks = books.filter { book in
            book.loanId == nil
        }
        // nastavime prvni vhodnou do statu
        state.selectedBook = state.availableBooks.first
        print("DEBUG: availableBooks: \(state.availableBooks.count)")
        print("DEBUG: selectedBook: \(String(describing: state.selectedBook?.title))")
    }
    
    func addLoan() {
        print("DEBUG: addLoan() called")
        print("DEBUG: readerName raw: '\(state.readerName)'")
        print("DEBUG: selectedBook: \(String(describing: state.selectedBook?.title))")
        guard !state.readerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("DEBUG: FAIL empty readerName")
            state.errorMessage = "Reader name cannot be empty."
            return
        }
                
        guard let selectedBook = state.selectedBook else {
            print("DEBUG: FAIL no selectedBook")
            state.errorMessage = "No book selected."
            return
        }
        
        state.isSaving = true
        let calculatedDueDate = Calendar.current.date(byAdding: .day, value: 14, to: state.borrowDate) ?? state.borrowDate
        
        let newItem = LoanItem(
            id: UUID(),
            borrowDate: state.borrowDate,
            dueDate: calculatedDueDate,
            readerName: state.readerName,
            bookId: selectedBook.id
        )
        dataManager.saveLoan(newItem)
        state.isSaving = false
        print("DEBUG: saveLoan completed")
    }
}

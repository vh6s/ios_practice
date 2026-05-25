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
        
        // vybereme jen dostupne knihy, ktere nejsou aktualne pujcene
        state.availableBooks = books.filter { book in
            book.loanId == nil
        }
        // nastavime prvni vhodnou do statu
        state.selectedBook = state.availableBooks.first
    }
    
    func addLoan() {
        guard !state.readerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
                
        guard let selectedBook = state.selectedBook else {
            return
        }
        
        let calculatedDueDate = Calendar.current.date(byAdding: .day, value: 14, to: state.borrowDate) ?? state.borrowDate
        
        let newItem = LoanItem(
            id: UUID(),
            borrowDate: state.borrowDate,
            dueDate: calculatedDueDate,
            readerName: state.readerName,
            bookId: selectedBook.id
        )
        dataManager.saveLoan(newItem)
    }
}

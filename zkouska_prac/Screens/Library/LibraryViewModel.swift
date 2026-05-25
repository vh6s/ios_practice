//
//  LibraryViewModel.swift
//  zkouska_prac
//
//  Created by Matěj on 21.05.2026.
//
import SwiftUI

@Observable
class LibraryViewModel {
    var state = LibraryViewState()
    private var dataManager: DataManaging
    
    init() {
        dataManager = DIContainer.shared.resolve()
        fetchData()
    }
    
    func fetchData() {
        state.loanItems = dataManager.fetchLoans()
        state.bookItems = dataManager.fetchBooks()
    }
    
    func activeLoan(for book: BookItem) -> LoanItem? {
        state.loanItems.first {
            $0.bookId == book.id && !$0.isReturned
        }
    }
    
    func status(for book: BookItem) -> BookStatus {
        activeLoan(for: book) == nil ? .free : .borrowed
    }
    
    func remainingDays(for book: BookItem) -> Int? {
        activeLoan(for: book)?.remainingDays
    }
}

//
//  LoanViewModel.swift
//  zkouska_prac
//
//  Created by Matěj on 21.05.2026.
//

import Foundation

@Observable
class LoanViewModel {
    var state: LoanViewState
    private var dataManager: DataManaging
    
    init(book: BookItem) {
        self.state = LoanViewState(book: book)
        dataManager = DIContainer.shared.resolve()
        
        let loan = dataManager
            .fetchLoans()
            .first(where: { $0.id == book.loanId })
                
        self.state = LoanViewState(
            book: book,
            loan: loan
        )
    }
    
    func changeBookToReturned() {
        guard var loan = state.loan else {
            return
        }
        loan.returnedDate = Date()
        dataManager.saveLoan(loan)

        state.book.loanId = nil
        dataManager.saveBook (state.book)
        state.loan = nil
    }
}

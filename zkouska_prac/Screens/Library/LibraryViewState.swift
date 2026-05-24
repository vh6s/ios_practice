//
//  LibraryState.swift
//  zkouska_prac
//
//  Created by Matěj on 21.05.2026.
//

import SwiftUI

@Observable
class LibraryViewState {
    var bookItems: [BookItem] = []
    var loanItems: [LoanItem] = []
    var isLoading: Bool = false
    
    init(bookItems: [BookItem] = [], loanItems: [LoanItem] = []) {
        self.bookItems = bookItems
        self.loanItems = loanItems
    }
}

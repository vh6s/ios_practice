//
//  LoanViewState.swift
//  zkouska_prac
//
//  Created by Matěj on 21.05.2026.
//

import SwiftUI

@Observable
class LoanViewState {
    var book: BookItem
    var loan: LoanItem?
    
    init(book: BookItem, loan: LoanItem? = nil) {
        self.book = book
        self.loan = loan
    }
}

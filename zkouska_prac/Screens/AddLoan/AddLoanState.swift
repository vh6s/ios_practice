//
//  AddLoanState.swift
//  zkouska_prac
//
//  Created by Matěj on 21.05.2026.
//

import SwiftUI

@Observable
class AddLoanState {
    var selectedBook: BookItem?
    var readerName: String = ""
    var borrowDate: Date = Date()
    var dueDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 14) // trwba za 14 dni
    var availableBooks: [BookItem] = []
}

//
//  LoanItem.swift
//  zkouska_prac
//
//  Created by Matěj on 21.05.2026.
//
import SwiftUI

struct LoanItem: Identifiable, Hashable {
    var id: UUID = UUID()
    var borrowDate: Date
    var dueDate: Date
    var returnedDate: Date?
    var readerName: String
    var bookId: UUID
    var remainingDays: Int {
        // toto spocita rozmezi od Date() [nyni] do dueDate vraci pocet dnu podle prvniho parametru [.day]
        Calendar.current.dateComponents([.day], from: Date(), to: dueDate).day ?? 0
    }
    var isReturned: Bool {
            returnedDate != nil
    }
}



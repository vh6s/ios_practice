//
//  LoanItem.swift
//  zkouska_prac
//
//  Created by Matěj on 21.05.2026.
//
import SwiftUI

struct LoanItem: Identifiable {
    var id: UUID = UUID()
    var borrowDate: Date
    var dueDate: Date
    var returnedDate: Date?
    var readerName: String
    var remainingDays: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: dueDate).day ?? 0
    }
}



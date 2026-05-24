//
//  DataManaging.swift
//  zkouska_prac
//
//  Created by Matěj on 23.05.2026.
//

import Foundation

protocol DataManaging {
    func saveLoan(_ item: LoanItem)
    func fetchLoans() -> [LoanItem]
    func fetchBooks() -> [BookItem]
}

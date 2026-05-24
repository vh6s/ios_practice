//
//  BookItem.swift
//  zkouska_prac
//
//  Created by Matěj on 21.05.2026.
//

import SwiftUI

enum BookType: Int16, CaseIterable, Identifiable {
    var id: Int16 { rawValue }
    
    case novel = 1
    case textbook = 2
    case magazine = 3
    
    var type: String {
        switch self {
        case .novel: return "Novel"
        case .magazine: return "Magazine"
        case .textbook: return "Textbook"
        }
    }
}

enum BookStatus {
    case free
    case borrowed
}

struct BookItem: Identifiable, Hashable {
    var id: UUID = UUID()
    var author: String
    var title: String
    var image: UIImage
    var type: BookType
    var loanId: UUID?
}

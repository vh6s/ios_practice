//
//  Untitled.swift
//  Tasks
//
//  Created by Matěj on 12.10.2026.
//

import SwiftUI

struct TodoTask: Identifiable {
    var id = UUID()
    var text: String = ""
    var date: Date?
    var isCompleted: Bool = false
}

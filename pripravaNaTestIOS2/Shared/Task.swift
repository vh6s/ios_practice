//
//  Task.swift
//  pripravaNaTestIOS2
//
//  Created by endurovojta173 on 11.10.2026.
//

import SwiftUI

//Musi byt identifiable aby rozpoznal uuid
struct Task: Identifiable, Codable{
    var id: UUID = UUID()
    var title: String
    var text: String
    var isCompleted: Bool = false
    
    static func getSample()->Task{
        .init(title: "Vytahnout mycku", text: "Nezapomenout vytahnout mycku", isCompleted: false)
    }
}

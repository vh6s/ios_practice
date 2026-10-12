//
//  NumberMessage.swift
//  RandomNumber
//
//  Created by Pavel Priehoda on 11.10.2026.
//
import Foundation

struct NumberMessage: Identifiable {
    var id = UUID()
    var number: Int
    var date: Date

    static func getSample() -> NumberMessage {
        .init(number: 42, date: .now)
    }
}

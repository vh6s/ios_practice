//
//  DataManaging.swift
//  RandomNumber
//
//  Created by Pavel Priehoda on 11.10.2026.
//

import Foundation

protocol DataManaging {
    func saveNumber(_ number: NumberMessage)
    func fetchNumbers() -> [NumberMessage]
}

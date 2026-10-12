//
//  WatchConnecting.swift
//  RandomNumber
//
//  Created by Pavel Priehoda on 11.10.2026.
//

protocol WatchConnecting: AnyObject {
    var isReachable: Bool { get }
    var onNumberReceived: (NumberMessage) -> Void { get set }
    func send(_ number: NumberMessage)
}

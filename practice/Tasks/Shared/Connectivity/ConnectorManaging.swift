//
//  ConnectorManaging.swift
//  Tasks
//
//  Created by Pavel Priehoda on 12.10.2026.
//
import Foundation

protocol ConnectorManaging: AnyObject {
    var isReachable: Bool { get }
    var onTaskReceived: (TaskItem) -> Void { get set }
    func send(_ task: TaskItem)
}

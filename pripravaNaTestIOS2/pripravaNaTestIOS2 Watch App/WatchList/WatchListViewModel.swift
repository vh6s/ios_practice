//
//  WatchListViewModel.swift
//  pripravaNaTestIOS2
//
//  Created by endurovojta173 on 12.10.2026.
//

import SwiftUI

@Observable
class WatchListViewModel {
    var connector = Connector()
    
    // Poskytuje data pro View
    var tasks: [Task] {
        connector.tasks
    }
}

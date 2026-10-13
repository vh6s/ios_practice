//
//  DetailState.swift
//  pripravaNaTestIOS2
//
//  Created by endurovojta173 on 10.10.2026.
//

import SwiftUI

@Observable
class DetailViewState{
    var task: Task
    
    init(task: Task){
        self.task = task
    }
}

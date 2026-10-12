//
//  RandomNumberWidgetEntryView.swift
//  RandomNumber Widget
//
//  Created by Pavel Priehoda on 11.10.2026.
//
import SwiftUI

struct RandomNumberWidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        if let number = entry.number {
            VStack {
                Text("\(number.number)")
                Text("\(number.date)")
            }
        } else {
            Text("error")
        }
    }
}

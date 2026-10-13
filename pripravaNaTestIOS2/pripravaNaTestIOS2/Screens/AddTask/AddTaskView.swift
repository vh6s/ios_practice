//
//  AddTaskView.swift
//  pripravaNaTestIOS2
//
//  Created by endurovojta173 on 10.10.2026.
//

import SwiftUI

struct AddTaskView: View{
    
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = AddTaskViewModel()
    
    // Callback pro refresh seznamu
        var onSaveSuccess: () -> Void
    
    var body: some View{
        NavigationStack{
            Form{
                @Bindable var bindableViewModel = viewModel
                
                TextField("Název úkolu", text: $bindableViewModel.state.title)
                TextField("Popis úkolu", text: $bindableViewModel.state.text)
            }
            .navigationTitle("Nový úkol")
            //Zobrazi nadpis az nahore
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Zrušit") {
                                    //Enviromentalni promenna
                                    dismiss() }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Uložit") {
                                    viewModel.saveTask()
                                    onSaveSuccess()
                                    //Enviromentalni promenna
                                    dismiss()
                                }
                                .disabled(!viewModel.isValid)
                            }
                        }
            
        }
    }
}

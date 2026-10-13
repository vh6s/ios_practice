//
//  DetailView.swift
//  pripravaNaTestIOS2
//
//  Created by endurovojta173 on 10.10.2026.
//

import SwiftUI

struct DetailView: View {
    @State private var viewModel: DetailViewModel
    //Tato promenna kvuli vyskakovacimu oknu mazani
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    @State private var isShowingEditSheet = false
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Form{
            Section(header: Text("Task")){
                Text(viewModel.state.task.title).font(.title2)
            }
            Section(header: Text("Informace o tasku")){
                //LabeledContent("Category", value: viewModel.state.joke.category)

                Text(viewModel.state.task.text)
            }
            Section(header: Text("Je již splněný?")){
                //LabeledContent("Category", value: viewModel.state.joke.category)
                
                if(viewModel.state.task.isCompleted){
                    Text("Splneny")
                } else {
                    Text("Nesplneny")

                }
            }
        }
        //Tlacitko mazani
        .toolbar {
            //Pro vice prvku v toolbaru
            ToolbarItemGroup(placement: .topBarTrailing) {
                //Editace
                Button {
                            isShowingEditSheet = true
                        } label: {
                            Image(systemName: "pencil")
                        }
                //Delete
                Button {
                        showingDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red) // Obarví ikonu koše červeně
                    }
                
            }
        }
        // Ověřovací dialog
        .alert("Smazat úkol", isPresented: $showingDeleteAlert) {
                    Button("Zrušit", role: .cancel) { }
                    Button("Smazat", role: .destructive) {
                        viewModel.deleteTask() // Zavolá funkci z ViewModelu
                        dismiss() // Vrátí uživatele zpět do seznamu
                    }
                } message: {
                    Text("Opravdu chcete tento úkol smazat? Tato akce je nevratná.")
                }
                .sheet(isPresented: $isShowingEditSheet) {
                    AddEditTaskView(task: viewModel.state.task) {
                        viewModel.refreshTask()
                        
                    }
                }
    }
    
}

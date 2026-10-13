//
//  ListView.swift
//  pripravaNaTestIOS2
//
//  Created by endurovojta173 on 10.10.2026.
//

import SwiftUI

struct ListView: View {
    
    @State private var viewModel: ListViewModel
    //Pro modalni okno
    @State private var isShowingAddSheet = false
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        //Pouziva se treba pro to kdyz chci prejit z listu do detailu
        NavigationStack{
            //List je standart pro seznam
            List(viewModel.state.tasks){ task in
                
                /*
                //Zobrazeni listu bez pohledu do detailu
                VStack{
                    Text(task.title).font(.title)
                    Text(task.text)
                }*/
                
                //NavigationLink presmeruje z navigationStacku do detailu
                NavigationLink{
                    DetailView(viewModel: DetailViewModel(task: task))
                               } label: {
                                   Text(task.title) // Zde definuješ vzhled samotného tlačítka/řádku
                               }
            }
            //Funguje jako prekryti, tady v pripade 0 tasku zobrazi ze jeste zadne nejsou
            .overlay{
                if viewModel.state.tasks.isEmpty{
                    ContentUnavailableView(
                        "No tasks yet",
                        systemImage: "face.dashed",
                        description: Text("Tasks loaded on the first tab will appear here.")
                    )
                }
            }
            .navigationTitle("Seznam tasků")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Přidat", systemImage: "plus") {
                        isShowingAddSheet = true
                    }
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                AddEditTaskView {
                    viewModel.fetchTasks() // Aktualizuje data v ListView po zavření okna
                }
            }
            //Zavola se pri kazdem otevreni tohoto view
            .onAppear{
                viewModel.fetchTasks()
            }
        }
    }
}

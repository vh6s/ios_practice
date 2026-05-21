//
//  LibraryScreen.swift
//  zkouska_prac
//
//  Created by Matěj on 21.05.2026.
//

import SwiftUI

struct LibraryView: View {
    @State private var viewModel: LibraryViewModel
    @State private var isAddLoanViewPresented: Bool = false
    
    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.state.bookItems) { item in
                NavigationLink {
                    LoanView(viewModel: LoanViewModel(loan: item))
                        .navigationTitle(item.title)
                } label: {
                    LibraryRow(item: item)
                }
            }
            .sheet(isPresented: $isAddLoanViewPresented) {
                showAddLoanView()
            }
            .navigationTitle(Text("Library"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("+", systemImage: "add") {
                        isAddLoanViewPresented.toggle()
                    }
                }
            }
        }
    }
    
    func showAddLoanView() -> some View {
        let addLoanViewModel = addLoanViewModel()
        
        return NavigationStack {
            AddLoanView(viewmodel: addLoanViewModel)
                .navigationTitle("Add Loan")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isAddLoanViewPresented.toggle()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            AddLoanViewModel.addLoan()
                            isAddLoanViewPresented.toggle()
                        }
                    }
                }
        }
    }
}

struct LibraryRow: View {
    let item: BookItem
        
    var body: some View {
        HStack {
            VStack {
                Text(item.type.type)
                Text(item.title).bold()
                Text(item.author)
            }
            VStack {
                Text(item.status == .borrowed ? "Borrowed" : "Free")
                Text("\(item.loan?.remainingDays ?? 0) d").foregroundStyle(item.loan?.remainingDays ?? 0 < 0 ? .red : .green)
            }
        }
    }
}


#Preview {
    LibraryView(viewModel: LibraryViewModel())
}

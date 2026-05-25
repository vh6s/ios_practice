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
    @State private var addLoanViewModel: AddLoanViewModel
    
    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel
        self._addLoanViewModel = State(initialValue: AddLoanViewModel(books: viewModel.state.bookItems))
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.state.bookItems) { item in
                NavigationLink {
                    LoanView(viewModel: LoanViewModel(book: item))
                        .navigationTitle(item.title)
                } label: {
                    LibraryRow(item: item, viewModel: viewModel)
                }
            }
            .sheet(isPresented: $isAddLoanViewPresented) {
                showAddLoanView(viewModel: addLoanViewModel)
            }
            .navigationTitle(Text("Library"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addLoanViewModel = AddLoanViewModel(books: viewModel.state.bookItems)
                        isAddLoanViewPresented.toggle()
                    } label: {
                        Image(systemName: "plus").font(.title2)
                    }
                }
            }
        }.environment(viewModel)
    }
    
    func showAddLoanView(viewModel addLoanViewModel: AddLoanViewModel) -> some View {
        return NavigationStack {
            AddLoanView(viewModel: addLoanViewModel)
                .navigationTitle("Add Loan")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isAddLoanViewPresented.toggle()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            addLoanViewModel.addLoan()
                            viewModel.fetchData()
                            isAddLoanViewPresented.toggle()
                        }
                    }
                }
        }
    }
}

struct LibraryRow: View {
    let item: BookItem
    let viewModel: LibraryViewModel
        
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.type.type)
                Text(item.title).bold()
                Text(item.author)
            }.frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            VStack {
                viewModel.status(for: item) == .borrowed ?
                Text("Borrowed").foregroundStyle(.red) : Text("Free").foregroundStyle(.green)
                
                if let remainingDays = viewModel.remainingDays(for: item) {
                    Text("\(remainingDays) d").foregroundStyle(remainingDays < 0 ? .red : .green)
                } else {
                    Text("- d")
                }
            }
        }
    }
}


#Preview {
    LibraryView(viewModel: LibraryViewModel())
}

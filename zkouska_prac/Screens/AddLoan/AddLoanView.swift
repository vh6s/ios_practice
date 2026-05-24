//
//  AddFileView.swift
//  zkouska_prac
//
//  Created by Matěj on 21.05.2026.
//

import SwiftUI

struct AddLoanView: View {
    @State private var viewModel: AddLoanViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: AddLoanViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        AddLoanContent(viewModel: viewModel)
            .onAppear {
                print("DEBUG: AddLoanView onAppear")
                print("DEBUG: viewModel instance: \(ObjectIdentifier(viewModel))")
                print("DEBUG: availableBooks count: \(viewModel.state.availableBooks.count)")
                print("DEBUG: selectedBook: \(String(describing: viewModel.state.selectedBook?.title))")
            }
    }
}

struct AddLoanContent: View {
    @Bindable var viewModel: AddLoanViewModel
    
    var body: some View {
        Form {
            
            Section("Book") {
                Picker(viewModel.state.selectedBook?.title ?? "-", selection: $viewModel.state.selectedBook) {
                    ForEach(viewModel.state.availableBooks) { book in
                        Text(book.title).tag(Optional(book))
                    }
                }
            }
            Section("Reader") {
                TextField("Reader Name", text: $viewModel.state.readerName)
            }
            Section("Borrowed Until") {
                DatePicker("Borrow Date", selection: $viewModel.state.borrowDate, displayedComponents: .date)
                    .onChange(of: viewModel.state.borrowDate) { _, newValue in
                            viewModel.state.dueDate = Calendar.current.date(byAdding: .day, value: 14, to: newValue) ?? newValue
                        }
            }
        }
    }
}

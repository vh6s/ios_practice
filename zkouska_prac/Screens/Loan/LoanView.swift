//
//  LoanView.swift
//  zkouska_prac
//
//  Created by Matěj on 21.05.2026.
//

import SwiftUI

struct LoanView: View {
    @State private var viewModel: LoanViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(LibraryViewModel.self) private var libraryViewModel
    
    init(viewModel: LoanViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        LoanDetail(viewModel: viewModel)
            .navigationTitle(Text("Loan"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Returned") {
                        viewModel.changeBookToReturned()
                        libraryViewModel.fetchData()
                        dismiss()
                    }
                }
            }
    }
}

struct LoanDetail: View {
    let viewModel: LoanViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Book")) {
                Text(viewModel.state.book.title)
            }
            Section(header: Text("Author")) {
                Text(viewModel.state.book.author)
            }
            Section(header: Text("Reader")) {
                Text(viewModel.state.loan?.readerName ?? "Name not set")
            }
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Borrowed")
                        Text(viewModel.state.loan?.borrowDate.formatted(date: .numeric, time: .omitted) ?? "")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    VStack(alignment: .leading) {
                        Text("Until")
                        Text(viewModel.state.loan?.dueDate.formatted(date: .numeric, time: .omitted) ?? "")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Section() {
                Image(uiImage: viewModel.state.book.image)
                    .resizable()
                    .scaledToFill()
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }
    }
}

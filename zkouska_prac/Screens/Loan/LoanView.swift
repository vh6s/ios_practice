//
//  LoanView.swift
//  zkouska_prac
//
//  Created by Matěj on 21.05.2026.
//

struct LoanView: View {
    @State private var viewModel: LoanViewModel
    
    init(viewModel: LoanViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Form {
            Section(header: Text("Book")) {
                Text(viewModel.state.bookItem.title).bold()
            }
            Section(header: Text("Author")) {
                Text(viewModel.state.bookItem.author).bold()
            }
            Section(header: Text("Reader")) {
                Text(viewModel.state.bookItem.loan?.readerName).bold()
            }
            HStack {
                VStack {
                    Text("Borrowed")
                    Text(viewModel.state.bookitem.loan?.borrowDate).bold()
                }
                VStack {
                    Text("Until")
                    Text(viewModel.state.bookitem.loan?.dueDate).bold()
                }
            }
            Section() {
                Image(uiImage: viewModel.state.bookItem.image)
                    .resizable()
                    .scaledToFill()
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }
    }
}

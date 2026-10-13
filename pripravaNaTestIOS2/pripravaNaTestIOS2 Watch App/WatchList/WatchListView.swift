import SwiftUI

struct WatchListView: View {
    @State private var viewModel = WatchListViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.tasks) { task in
                NavigationLink {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(task.title).font(.title3)
                            Text(task.text)
                        }
                        .padding()
                    }
                    .navigationTitle("Detail")
                } label: {
                    HStack {
                        // Texty úkolu
                        VStack(alignment: .leading) {
                            Text(task.title)
                                .font(.headline)
                                .strikethrough(task.isCompleted) // Přeškrtne hotový úkol
                            
                            Text(task.text)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        
                        // Odškrtávací tlačítko
                        Button {
                            viewModel.connector.sendToggle(id: task.id)
                        } label: {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                                .foregroundStyle(task.isCompleted ? .green : .gray)
                        }
                        .buttonStyle(.plain) // Klíčové: Zabrání tomu, aby se po kliknutí na tlačítko otevřel detail
                    }
                }
            }
            .navigationTitle("Úkoly")
            .overlay {
                if viewModel.tasks.isEmpty {
                    ContentUnavailableView(
                        "Žádná data",
                        systemImage: "applewatch.radiowaves.left.and.right",
                        description: Text("Otevřete aplikaci na iPhonu pro synchronizaci.")
                    )
                }
            }
        }
    }
}

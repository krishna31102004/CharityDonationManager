import SwiftUI
import SwiftData

struct Dashboard: View {
    let user: User

    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    @State private var newItemText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome, \(user.name)!")
                    .font(.headline)
                    .padding()

                List {
                    ForEach(items.filter { $0.user == user }) { item in
                        Text(item.timestamp, style: .date)
                    }
                }

                HStack {
                    TextField("New Item", text: $newItemText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add") {
                        addItem()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()

                NavigationLink(destination: ProfileView(viewModel: ProfileViewModel(context: modelContext))) {
                    Text("Go to Profile")
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Dashboard")
        }
    }

    private func addItem() {
        guard !newItemText.isEmpty else { return }

        let newItem = Item(timestamp: Date(), user: user)
        modelContext.insert(newItem)

        newItemText = ""
    }
}

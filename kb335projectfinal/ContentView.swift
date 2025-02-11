import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            PlacesView()
                .tabItem {
                    Label("Places", systemImage: "map.fill")
                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }

            DonationHistoryView()
                .tabItem {
                    Label("History", systemImage: "list.bullet.rectangle")
                }

            ProfileView(viewModel: ProfileViewModel(context: modelContext))
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

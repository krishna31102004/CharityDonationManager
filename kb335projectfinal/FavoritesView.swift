import SwiftUI
import SwiftData
import MapKit

struct FavoritesView: View {
    @Query(sort: \FavoritesModel.primaryText, order: .forward) var favorites: [FavoritesModel]
    @Environment(\.modelContext) private var modelContext

    @State private var showDeleteConfirmation = false
    @State private var favoriteToDelete: FavoritesModel?
    @State private var searchQuery: String = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search favorites...", text: $searchQuery)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)

                if filteredFavorites.isEmpty {
                    VStack {
                        Image(systemName: "star.slash.fill")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No favorites match your search!")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                    }
                } else {
                    List {
                        ForEach(filteredFavorites) { favorite in
                            VStack(alignment: .leading) {
                                Text(favorite.primaryText)
                                    .font(.headline)
                                if let secondaryText = favorite.secondaryText {
                                    Text(secondaryText)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    favoriteToDelete = favorite
                                    showDeleteConfirmation = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)

                                Button {
                                    openInMaps(favorite: favorite)
                                } label: {
                                    Label("Navigate", systemImage: "map")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                }
            }
            .alert("Delete Favorite", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let favorite = favoriteToDelete {
                        deleteFavorite(favorite: favorite)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this favorite?")
            }
            .navigationTitle("Favorites")
        }
    }

    private var filteredFavorites: [FavoritesModel] {
        if searchQuery.isEmpty {
            return favorites
        } else {
            return favorites.filter { $0.primaryText.localizedCaseInsensitiveContains(searchQuery) }
        }
    }

    private func deleteFavorite(favorite: FavoritesModel) {
        modelContext.delete(favorite)
        do {
            try modelContext.save()
        } catch {
            print("Error deleting favorite: \(error.localizedDescription)")
        }
    }

    private func openInMaps(favorite: FavoritesModel) {
        let coordinate = CLLocationCoordinate2D(latitude: favorite.latitude, longitude: favorite.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = favorite.primaryText
        mapItem.openInMaps()
    }
}

import Foundation
import SwiftData

class FavoritesViewModel: ObservableObject {
    private var modelContext: ModelContext

    init(context: ModelContext) {
        self.modelContext = context
    }

    func savePlace(place: PlacesModel) {
        let favorite = FavoritesModel(
            id: place.id,
            primaryText: place.primaryText,
            secondaryText: place.secondaryText,
            latitude: place.latitude ?? 0,
            longitude: place.longitude ?? 0
        )
        modelContext.insert(favorite)
        do {
            try modelContext.save()
        } catch {
            print("Error saving favorite: \(error.localizedDescription)")
        }
    }

    func deletePlace(place: FavoritesModel) {
        modelContext.delete(place)
        do {
            try modelContext.save()
        } catch {
            print("Error deleting favorite: \(error.localizedDescription)")
        }
    }

    func updateFavorite(favorite: FavoritesModel, newPrimaryText: String, newSecondaryText: String?) {
        favorite.primaryText = newPrimaryText
        favorite.secondaryText = newSecondaryText
        do {
            try modelContext.save()
        } catch {
            print("Error updating favorite: \(error.localizedDescription)")
        }
    }
}

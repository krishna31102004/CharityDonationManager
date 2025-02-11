import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    @Relationship var user: User? 

    init(timestamp: Date, user: User? = nil) {
        self.timestamp = timestamp
        self.user = user
    }
}

@Model
final class User: ObservableObject {
    @Attribute(.unique) var email: String
    var hashedPassword: String
    var name: String

    @Relationship var items: [Item] = []
    @Relationship var favorites: [FavoritesModel] = []
    @Relationship var donations: [DonationRecord] = []

    init(email: String, hashedPassword: String, name: String) {
        self.email = email
        self.hashedPassword = hashedPassword
        self.name = name
    }

    func addItem(_ item: Item) {
        items.append(item)
    }

    func addFavorite(_ favorite: FavoritesModel) {
        favorites.append(favorite)
    }

    func addDonation(_ donation: DonationRecord) {
        donations.append(donation)
    }
}

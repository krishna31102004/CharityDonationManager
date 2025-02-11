import Foundation
import SwiftData

@Model
class FavoritesModel {
    @Attribute(.unique) var id: String = UUID().uuidString 
    var primaryText: String
    var secondaryText: String?
    var latitude: Double
    var longitude: Double

    init(id: String = UUID().uuidString, primaryText: String, secondaryText: String?, latitude: Double, longitude: Double) {
        self.id = id
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.latitude = latitude
        self.longitude = longitude
    }
}

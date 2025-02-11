import Foundation
import MapKit

struct PlacesModel: Identifiable {
    let id: String
    let primaryText: String
    let secondaryText: String?
    let latitude: Double?
    let longitude: Double?
}


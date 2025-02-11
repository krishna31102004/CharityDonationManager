import Foundation
import GooglePlaces
import CoreLocation
import MapKit

class PlacesViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var predictions: [PlacesModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery: String = "charity"
    @Published var radius: Double = 1000

    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?

    override init() {
        super.init()
        configureLocationManager()
    }

    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = location
            print("Debug: Updated current location to \(location.coordinate.latitude), \(location.coordinate.longitude).")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = "Failed to fetch location: \(error.localizedDescription)"
        }
    }

    func performSearch() {
        guard let location = currentLocation else {
            errorMessage = "Unable to get location. Please enable location services."
            print("Debug: Current location is nil.")
            return
        }

        print("Debug: Using location \(location.coordinate.latitude), \(location.coordinate.longitude)")

        isLoading = true
        errorMessage = nil

        let placesClient = GMSPlacesClient.shared()

        
        let center = location.coordinate
        let northEast = CLLocationCoordinate2D(
            latitude: center.latitude + (radius / 111000),
            longitude: center.longitude + (radius / 111000)
        )
        let southWest = CLLocationCoordinate2D(
            latitude: center.latitude - (radius / 111000),
            longitude: center.longitude - (radius / 111000)
        )
        let bounds = GMSPlaceRectangularLocationOption(northEast, southWest)

        let filter = GMSAutocompleteFilter()
        filter.locationBias = bounds

        let token = GMSAutocompleteSessionToken()
        placesClient.findAutocompletePredictions(
            fromQuery: searchQuery,
            filter: filter,
            sessionToken: token
        ) { [weak self] results, error in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Search Error: \(error.localizedDescription)"
                    self.isLoading = false
                    return
                }

                guard let results = results else {
                    self.errorMessage = "No results found for \(self.searchQuery)."
                    self.isLoading = false
                    return
                }

                var places: [PlacesModel] = []
                let dispatchGroup = DispatchGroup()

                for prediction in results {
                    let placeID = prediction.placeID ?? UUID().uuidString
                    dispatchGroup.enter()

                    placesClient.fetchPlace(fromPlaceID: placeID, placeFields: [.coordinate], sessionToken: token) { place, error in
                        if let place = place {
                            let model = PlacesModel(
                                id: placeID,
                                primaryText: prediction.attributedPrimaryText.string,
                                secondaryText: prediction.attributedSecondaryText?.string,
                                latitude: place.coordinate.latitude,
                                longitude: place.coordinate.longitude
                            )
                            places.append(model)
                        }
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    self.predictions = places
                    self.isLoading = false
                }
            }
        }
    }
}

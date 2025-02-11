import SwiftUI
import MapKit

struct PlaceDetailView: View {
    let place: PlacesModel
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @State private var region: MKCoordinateRegion

    init(place: PlacesModel) {
        self.place = place
        if let latitude = place.latitude, let longitude = place.longitude {
            _region = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            ))
        } else if let currentLocation = CLLocationManager().location {
            _region = State(initialValue: MKCoordinateRegion(
                center: currentLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            ))
        } else {
            _region = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            ))
        }
    }

    var body: some View {
        VStack {
            if let latitude = place.latitude, let longitude = place.longitude {
                Map(coordinateRegion: $region, annotationItems: [place]) { location in
                    MapMarker(
                        coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                        tint: .red
                    )
                }
                .frame(height: 300)

                Text(place.primaryText)
                    .font(.title)
                    .padding()

                if let secondaryText = place.secondaryText {
                    Text(secondaryText)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                }
                Button("Save to Favorites") {
                    favoritesViewModel.savePlace(place: place)
                }
                .buttonStyle(.borderedProminent)
                .padding()
                Button("Get Directions") {
                    openInMaps(latitude: latitude, longitude: longitude, placeName: place.primaryText)
                }
                .buttonStyle(.borderedProminent)
                .padding()
                NavigationLink(destination: DonationView(place: place)) {
                    Text("Donate Now")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            } else {
                Text("Location data unavailable.")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationTitle("Place Details")
    }

    private func openInMaps(latitude: Double, longitude: Double, placeName: String) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = placeName
        mapItem.openInMaps()
    }
}

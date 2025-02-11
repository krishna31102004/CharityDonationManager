import SwiftUI
import SwiftData
import GooglePlaces

@main
struct kb335projectfinalApp: App {
    @State private var isLoggedIn = false

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            User.self,
            FavoritesModel.self,
            DonationRecord.self,
            ProfileModel.self
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var favoritesViewModel: FavoritesViewModel

    init() {
        GMSPlacesClient.provideAPIKey("AIzaSyA7IRtvHgMfLoRKEA4IKyt9YnlCJp0tge8") // API KEY
        self.favoritesViewModel = FavoritesViewModel(context: sharedModelContainer.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView()
                    .environmentObject(favoritesViewModel)
                    .modelContainer(sharedModelContainer)
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
                    .modelContainer(sharedModelContainer) 
            }
        }
    }
}

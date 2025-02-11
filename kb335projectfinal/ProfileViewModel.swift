import Foundation
import SwiftData

class ProfileViewModel: ObservableObject {
    @Published var profile: ProfileModel?
    private let context: ModelContext
    init(context: ModelContext) {
        self.context = context
        fetchProfile()
    }

    private func fetchProfile() {
        let fetchRequest = FetchDescriptor<ProfileModel>()
        if let existingProfile = try? context.fetch(fetchRequest).first {
            self.profile = existingProfile
        } else {
            
            let newProfile = ProfileModel(name: "Default User", email: "default@example.com")
            context.insert(newProfile)
            self.profile = newProfile
        }
    }

    func updateProfile(name: String, email: String) {
        guard let profile = profile else { return }
        profile.name = name
        profile.email = email
        try? context.save() 
    }
}

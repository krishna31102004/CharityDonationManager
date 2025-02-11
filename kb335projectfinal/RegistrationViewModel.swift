import SwiftData
import Foundation
import SwiftUI

@MainActor
class RegistrationViewModel: ObservableObject {
    @Published var model = RegistrationModel()
    @Published var registrationSuccess: Bool = false
    @Published var errorMessage: String?

    private let context: ModelContext
    @Query private var users: [User]

    init(context: ModelContext) {
        self.context = context
    }

    func handleRegistration() {
        guard !model.name.isEmpty, !model.email.isEmpty, !model.password.isEmpty else {
            errorMessage = "All fields are required."
            return
        }

        guard model.password == model.confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        guard !isEmailRegistered(model.email) else {
            errorMessage = "Email is already registered."
            return
        }

        let hashedPassword = hashPassword(model.password)
        let newUser = User(email: model.email, hashedPassword: hashedPassword, name: model.name)
        context.insert(newUser)

        do {
            try context.save()
            let fetchRequest = FetchDescriptor<User>()
            let savedUsers = try context.fetch(fetchRequest)
            print("Saved users: \(savedUsers.map { $0.email })")

            registrationSuccess = true
            errorMessage = nil
        } catch {
            errorMessage = "Failed to save user. Please try again."
            print("Error saving user: \(error)")
        }
    }

    private func isEmailRegistered(_ email: String) -> Bool {
        return users.contains { $0.email == email }
    }

    private func hashPassword(_ password: String) -> String {
        return String(password.reversed())
    }

}

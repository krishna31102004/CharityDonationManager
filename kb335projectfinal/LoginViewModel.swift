import SwiftData
import Foundation
import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    @Published var model = LoginModel()
    @Published var loginFailed: Bool = false

    private let context: ModelContext
    @Query private var users: [User]

    init(context: ModelContext) {
        self.context = context
    }

    var modelContext: ModelContext {
        return context
    }

    func handleLogin(completion: (Bool) -> Void) {
        guard !model.email.isEmpty, !model.password.isEmpty else {
            loginFailed = true
            completion(false)
            return
        }

        let fetchRequest = FetchDescriptor<User>()
        do {
            let fetchedUsers = try context.fetch(fetchRequest)
            if let user = fetchedUsers.first(where: { $0.email == model.email }) {
                if user.hashedPassword == hashPassword(model.password) {
                    loginFailed = false
                    completion(true) 
                } else {
                    print("Password mismatch for user: \(model.email)")
                    loginFailed = true
                    completion(false)
                }
            } else {
                print("User not found for email: \(model.email)")
                loginFailed = true
                completion(false)
            }
        } catch {
            print("Error fetching users: \(error)")
            loginFailed = true
            completion(false)
        }
    }


    private func hashPassword(_ password: String) -> String {
        return String(password.reversed()) 
    }

}

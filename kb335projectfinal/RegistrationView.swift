import SwiftUI
import SwiftData

struct RegistrationView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var registrationSuccess: Bool = false
    @State var errorMessage: String?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Register") {
                handleRegistration()
            }
            .padding()
            .buttonStyle(.borderedProminent)

            if registrationSuccess {
                Text("Registration Successful!")
                    .foregroundColor(.green)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            }

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }

    private func handleRegistration() {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "All fields are required."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        guard !isEmailRegistered(email) else {
            errorMessage = "Email is already registered."
            return
        }

        let newUser = User(email: email, hashedPassword: hashPassword(password), name: name)
        modelContext.insert(newUser)
        registrationSuccess = true
        errorMessage = nil
    }

    private func isEmailRegistered(_ email: String) -> Bool {
        return users.contains { $0.email == email }
    }

    private func hashPassword(_ password: String) -> String {
        return String(password.reversed())
    }
}

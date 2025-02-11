import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User] 
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginFailed: Bool = false
    @Binding var isLoggedIn: Bool

    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Login") {
                    handleLogin()
                }
                .padding()
                .buttonStyle(.borderedProminent)

                if loginFailed {
                    Text("Invalid credentials")
                        .foregroundColor(.red)
                        .padding(.top)
                }

                Spacer()

                
                NavigationLink("Register Now", destination: RegistrationView())
                    .padding()
            }
            .padding()
            .navigationTitle("Login")
        }
    }

    private func handleLogin() {
        if let user = users.first(where: { $0.email == email }) {
            if user.hashedPassword == hashPassword(password) {
                loginFailed = false
                isLoggedIn = true
            } else {
                loginFailed = true
            }
        } else {
            loginFailed = true
        }
    }

    private func hashPassword(_ password: String) -> String {
        return String(password.reversed()) 
    }
}

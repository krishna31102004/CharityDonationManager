import SwiftUI
import SwiftData

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    @State private var name: String = ""
    @State private var email: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                viewModel.updateProfile(name: name, email: email)
            }) {
                Text("Save Changes")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            if let profile = viewModel.profile {
                name = profile.name
                email = profile.email
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let schema = Schema([ProfileModel.self]) 
        let modelContainer = try! ModelContainer(for: schema)
        let context = modelContainer.mainContext
        
        return ProfileView(viewModel: ProfileViewModel(context: context))
    }
}

import Foundation
import SwiftData

@Model
class ProfileModel {
    @Attribute var name: String
    @Attribute var email: String

    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}

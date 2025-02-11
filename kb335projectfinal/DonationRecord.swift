import SwiftData
import Foundation

@Model
class DonationRecord {
    @Attribute(.unique) var id: UUID
    var charityName: String
    var donationAmount: Double
    var date: Date
    var paymentMethod: String

    init(charityName: String, donationAmount: Double, date: Date, paymentMethod: String) {
        self.id = UUID() 
        self.charityName = charityName
        self.donationAmount = donationAmount
        self.date = date
        self.paymentMethod = paymentMethod
    }
}


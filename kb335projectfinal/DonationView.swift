import SwiftUI
import SwiftData

struct DonationView: View {
    let place: PlacesModel
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var pinCode = ""
    @State private var amount = ""
    @State private var paymentType = "Credit Card"
    @State private var paymentMessage = ""
    @State private var showSuccessMessage = false

    @Environment(\.modelContext) private var modelContext

    let paymentTypes = ["Credit Card", "Debit Card"]

    var body: some View {
        VStack(spacing: 20) {
            Text("Make a Donation")
                .font(.title)
                .bold()

            Text("Donate to \(place.primaryText)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 10)

           
            TextField("Enter Amount ($)", text: $amount)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Picker("Payment Type", selection: $paymentType) {
                ForEach(paymentTypes, id: \.self) { type in
                    Text(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            TextField("Card Number (16 digits)", text: $cardNumber)
                .onChange(of: cardNumber) { newValue in
                    cardNumber = formatCardNumber(newValue)
                }
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            
            TextField("Expiry Date (MM/YY)", text: $expiryDate)
                .onChange(of: expiryDate) { newValue in
                    expiryDate = validateExpiryDate(newValue)
                }
                .keyboardType(.numbersAndPunctuation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            
            SecureField("PIN Code (3 digits)", text: $pinCode)
                .onChange(of: pinCode) { newValue in
                    pinCode = String(newValue.prefix(3))
                }
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: processDonation) {
                Text("Submit Payment")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Text(paymentMessage)
                .foregroundColor(paymentMessage.contains("Success") ? .green : .red)
                .padding()
        }
        .padding()
        .alert(isPresented: $showSuccessMessage) {
            Alert(
                title: Text("Thank You!"),
                message: Text("Your donation has been successfully recorded."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func processDonation() {
        guard let donationAmount = Double(amount), donationAmount > 0 else {
            paymentMessage = "Invalid donation amount. Please enter a valid number."
            return
        }

        if cardNumber.replacingOccurrences(of: " ", with: "").count != 16 ||
            !expiryDate.contains("/") ||
            pinCode.count != 3 {
            paymentMessage = "Invalid Payment Details"
            return
        }

        let donation = DonationRecord(
            charityName: place.primaryText,
            donationAmount: donationAmount,
            date: Date(),
            paymentMethod: paymentType
        )

        do {
            modelContext.insert(donation)
            try modelContext.save()
            showSuccessMessage = true
            paymentMessage = "Payment of $\(donationAmount) was successful using \(paymentType)!"
            print("Donation successfully saved: \(donation)")
        } catch {
            paymentMessage = "Failed to process the donation. Please try again."
            print("Failed to save donation: \(error)")
        }

        print("Processing a donation of \(donationAmount) to \(place.primaryText) via \(paymentType).")
    }

    private func formatCardNumber(_ input: String) -> String {
        let digits = input.replacingOccurrences(of: " ", with: "")
        let formatted = stride(from: 0, to: digits.count, by: 4).map { index in
            let startIndex = digits.index(digits.startIndex, offsetBy: index)
            let endIndex = digits.index(startIndex, offsetBy: 4, limitedBy: digits.endIndex) ?? digits.endIndex
            return String(digits[startIndex..<endIndex])
        }
        return formatted.joined(separator: " ")
    }

    private func validateExpiryDate(_ input: String) -> String {
        if input.count > 5 {
            return String(input.prefix(5))
        }

        let components = input.split(separator: "/").map { String($0) }

        if components.count == 1 {
            if let month = Int(components[0]), month >= 1 && month <= 12 {
                return input
            } else {
                return String(input.prefix(input.count - 1))
            }
        } else if components.count == 2 {
            if let month = Int(components[0]), month >= 1 && month <= 12,
               components[1].count <= 2, Int(components[1]) != nil {
                return input
            } else {
                return String(input.prefix(input.count - 1))
            }
        }
        return input
    }
}

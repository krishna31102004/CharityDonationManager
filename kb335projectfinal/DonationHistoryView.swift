import SwiftUI
import SwiftData

struct DonationHistoryView: View {
    @Query(sort: \DonationRecord.date, order: .reverse) private var donations: [DonationRecord]
    @State private var searchQuery: String = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search donations...", text: $searchQuery)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)

                if filteredDonations.isEmpty {
                    VStack {
                        Image(systemName: "tray.fill")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No donations match your search!")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                    }
                } else {
                    List(filteredDonations, id: \.id) { donation in
                        VStack(alignment: .leading) {
                            Text(donation.charityName)
                                .font(.headline)
                            Text("Amount: $\(donation.donationAmount, specifier: "%.2f")")
                                .padding(.top, 2)
                            Text("Payment Method: \(donation.paymentMethod)")
                                .foregroundColor(.gray)
                                .padding(.top, 1)
                            Text("Date: \(donation.date.formatted(.dateTime.month().day().year()))")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.top, 1)
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Donation History")
        }
    }

    private var filteredDonations: [DonationRecord] {
        if searchQuery.isEmpty {
            return donations
        } else {
            return donations.filter { donation in
                donation.charityName.localizedCaseInsensitiveContains(searchQuery) ||
                "\(donation.donationAmount)".localizedCaseInsensitiveContains(searchQuery) ||
                donation.paymentMethod.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
}

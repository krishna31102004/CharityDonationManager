import SwiftUI
import MapKit

struct PlacesView: View {
    @StateObject private var viewModel = PlacesViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [.blue.opacity(0.3), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search for places...", text: $viewModel.searchQuery)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    VStack {
                        Text("Radius: \(Int(viewModel.radius)) meters")
                            .font(.headline)
                        Slider(value: $viewModel.radius, in: 500...5000, step: 500)
                            .accentColor(.blue)
                            .padding(.horizontal)
                    }

                    Picker("Category", selection: $viewModel.searchQuery) {
                        Text("All").tag("")
                        Text("Charity").tag("charity")
                        Text("Food").tag("food")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    Button(action: {
                        viewModel.performSearch()
                    }) {
                        HStack {
                            Image(systemName: "magnifyingglass.circle.fill")
                            Text("Search")
                        }
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }

                    Spacer()

                    if viewModel.isLoading {
                        ProgressView("Searching...")
                            .padding()
                    } else if let error = viewModel.errorMessage {
                        VStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                            Text(error)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    } else if viewModel.predictions.isEmpty {
                        Text("No results found. Try a different query or radius.")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        List(viewModel.predictions) { prediction in
                            NavigationLink(destination: PlaceDetailView(place: prediction)) {
                                VStack(alignment: .leading) {
                                    Text(prediction.primaryText).font(.headline)
                                    if let secondaryText = prediction.secondaryText {
                                        Text(secondaryText).font(.subheadline)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search Places")
        }
    }
}

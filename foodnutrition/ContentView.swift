import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FoodViewModel()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter food name", text: Binding(
                    get: { viewModel.food?.description ?? "" },
                    set: { viewModel.fetchFood(with: $0) }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.white.opacity(0.8)) // Add a background color for contrast
                .cornerRadius(10)
                .padding(.horizontal)

                Button(action: {
                    viewModel.fetchFood(with: viewModel.food?.description ?? "")
                }) {
                    Text("Search")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                if let food = viewModel.food {
                    ScrollView { // Added ScrollView for better responsiveness
                        FoodDetailView(food: food)
                            .padding()
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Text("Enter a food name and tap 'Search' to find details.")
                        .padding()
                }
            }
            .navigationTitle("Food Details")
        }
        .background(Color(.systemGray6)) // Set background color for the entire view
        .edgesIgnoringSafeArea(.all) // Allow the background to fill the screen
    }
}

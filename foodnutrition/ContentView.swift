import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FoodViewModel()
    @State private var showResultSheet = false
    @State private var query = ""

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.orange.opacity(0.2), .white], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    // 🔍 Search Field
                    TextField("Search food e.g. Oatmeal", text: $query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                        .padding(.horizontal)

                    Button(action: {
                        viewModel.fetchFood(with: query)
                        showResultSheet = true
                    }) {
                        HStack {
                            Spacer()
                            if viewModel.isLoading {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Search")
                                    .fontWeight(.bold)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }

                    // 🔁 Recent Searches
                    if !viewModel.recentSearches.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recent Searches")
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(viewModel.recentSearches, id: \.self) { term in
                                HStack {
                                    Text(term)
                                        .onTapGesture {
                                            query = term
                                            viewModel.fetchFood(with: term)
                                            showResultSheet = true
                                        }

                                    Spacer()

                                    Button(action: {
                                        viewModel.deleteSearch(term)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(10)
                                .shadow(radius: 1)
                                .padding(.horizontal)
                            }
                        }
                    }

                    Spacer()
                }

                // ✅ Result Sheet
                if let food = viewModel.food, showResultSheet {
                    FoodResultSheet(food: food) {
                        showResultSheet = false
                    }
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: showResultSheet)
                }

                // ⚠️ Error
                if let error = viewModel.errorMessage, showResultSheet {
                    VStack {
                        Text("⚠️ \(error)")
                            .foregroundColor(.red)
                        Button("Dismiss") {
                            showResultSheet = false
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 6)
                }
            }
            .navigationTitle("Nutrition Lookup")
        }
    }
}

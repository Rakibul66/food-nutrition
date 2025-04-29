import Foundation
import Combine

class FoodViewModel: ObservableObject {
    @Published var food: Food?
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var recentSearches: [String] = []

    private let historyKey = "recent_food_searches"
    private var foodService = FoodService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadRecentSearches()
    }

    func fetchFood(with name: String) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        isLoading = true
        errorMessage = nil
        food = nil
        saveToHistory(name)

        let encoded = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://food-nutrition-information.p.rapidapi.com/foods/search?query=\(encoded)&pageSize=1&pageNumber=1"

        foodService.fetchFoodDetails(urlString: urlString) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if let first = response.foods.first {
                        self?.food = first
                    } else {
                        self?.errorMessage = "No food found."
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    private func saveToHistory(_ term: String) {
        var current = UserDefaults.standard.stringArray(forKey: historyKey) ?? []
        if !current.contains(term) {
            current.insert(term, at: 0)
            let limitedArray = Array(current.prefix(10)) // ✅ Convert to Array
            UserDefaults.standard.set(limitedArray, forKey: historyKey)
            recentSearches = limitedArray
        }
    }


    func loadRecentSearches() {
        recentSearches = UserDefaults.standard.stringArray(forKey: historyKey) ?? []
    }

    func deleteSearch(_ term: String) {
        recentSearches.removeAll { $0 == term }
        UserDefaults.standard.set(recentSearches, forKey: historyKey)
    }
}

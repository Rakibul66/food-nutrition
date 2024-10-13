//
//  FoodViewModel.swift
//  foodnutrition
//
//  Created by Roxy  on 3/10/24.
//

import Foundation
import Combine

class FoodViewModel: ObservableObject {
    @Published var food: Food?
    @Published var errorMessage: String?
    private var foodService = FoodService()
    private var cancellables = Set<AnyCancellable>()

    func fetchFood(with name: String) {
        let encodedFoodName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://food-nutrition-information.p.rapidapi.com/foods/search?query=\(encodedFoodName)&pageSize=1&pageNumber=1"

        foodService.fetchFoodDetails(urlString: urlString) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let foodResponse):
                    if let firstFood = foodResponse.foods.first {
                        self?.food = firstFood
                        self?.errorMessage = nil
                    } else {
                        self?.errorMessage = "No food found."
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

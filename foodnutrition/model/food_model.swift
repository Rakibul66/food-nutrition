import Foundation

struct FoodResponse: Codable {
    let foods: [Food]
}

struct Food: Codable, Identifiable {
    let id: Int
    let description: String
    let brandName: String
    let ingredients: String
    let foodCategory: String
    let foodNutrients: [Nutrient]

    enum CodingKeys: String, CodingKey {
        case id = "fdcId"
        case description, brandName, ingredients, foodCategory, foodNutrients
    }
}

struct Nutrient: Codable {
    let nutrientName: String
    let value: Double
    let unitName: String
}

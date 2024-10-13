import Foundation

class FoodService {
    func fetchFoodDetails(urlString: String, completion: @escaping (Result<FoodResponse, Error>) -> Void) {
        let headers = [
            "x-rapidapi-key": "8ec235d2f6mshbffe97c67b86260p1a6cb8jsna608fd681823",
            "x-rapidapi-host": "food-nutrition-information.p.rapidapi.com"
        ]
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let foodResponse = try JSONDecoder().decode(FoodResponse.self, from: data)
                completion(.success(foodResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
}

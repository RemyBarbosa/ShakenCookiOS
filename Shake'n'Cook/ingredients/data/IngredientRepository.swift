//
//  IngredientRepository.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 18/03/2023.
//

import Foundation
import Alamofire

class IngredientRepository {

    init() {
    }
    
    func getIngredients(query:String, completion: @escaping (Result<[IngredientAPI], Error>) -> Void) {
        let endpoint = "https://trackapi.nutritionix.com/v2/search/instant"
        let headers: HTTPHeaders = [
            "x-app-id": "2cf21d04",
            "x-app-key": "72a98ea691c2301c2443931a16529a5e"
        ]
        let parameters: Parameters = [
            "query": query,
        ]
        AF.request(endpoint,parameters: parameters, headers: headers).responseDecodable(of: IngredientResponse.self) { response in
            switch response.result {
            case .success(let answer):
                if let ingredients = answer.common {
                    completion(.success(ingredients))
                } else {
                    completion(.failure(ShakeError.nullableError(message: "impossible to retrieve ingredients")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

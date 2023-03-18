//
//  IngredientResponse.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 18/03/2023.
//

import Foundation

struct IngredientResponse: Decodable {
    let common: [IngredientAPI]?
}

struct IngredientAPI: Decodable {
    let food_name: String?
    let tag_id: String?
    var photo: IngredientPhoto?
}

struct IngredientPhoto: Decodable {
    var thumb: String?
}

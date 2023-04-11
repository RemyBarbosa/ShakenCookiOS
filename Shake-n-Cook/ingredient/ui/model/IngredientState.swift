//
//  IngredientState.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 18/03/2023.
//

import Foundation

enum IngredientState :Equatable {
    case idle
    case loading
    case ingredients(ingredients: [Ingredient])
    case error
}

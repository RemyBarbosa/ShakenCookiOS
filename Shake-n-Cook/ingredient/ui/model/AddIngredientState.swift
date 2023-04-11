//
//  AddIngredientState.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 08/04/2023.
//

import Foundation

enum AddIngredientState: Equatable {
    case idle
    case loading
    case ingredient(ingredient: Ingredient)
    case error
}

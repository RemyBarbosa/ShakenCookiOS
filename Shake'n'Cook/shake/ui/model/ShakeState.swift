//
//  ShakeState.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 17/03/2023.
//

import Foundation

enum ShakeState : Equatable {
    case idle
    case loading
    case noRecipe(isFiltered:Bool)
    case shaked(recipe:Recipe)
    case addFilter(ingredients: [Ingredient])
    case error
}

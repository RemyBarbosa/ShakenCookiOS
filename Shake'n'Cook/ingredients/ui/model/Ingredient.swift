//
//  Ingredient.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 18/03/2023.
//

import Foundation

struct Ingredient : Hashable {
    let ingredientFirebase: IngredientFirebase
    var isSelected: Bool = false
    
    static func defaultIngredient() -> Ingredient {
        return Ingredient(ingredientFirebase: IngredientFirebase.defaultIngredient())
    }
}

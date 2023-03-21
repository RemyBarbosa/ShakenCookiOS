//
//  RecipeViewModel.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 19/03/2023.
//

import Foundation

class RecipeViewModel: ObservableObject {
    @Published var currentIngredients = [Ingredient]()
}

//
//  RecipesViewModel.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 29/03/2023.
//

import Foundation

class RecipesViewModel: ObservableObject { 
    private let recipesRepository: RecipesRepository
    @Published var state  = RecipesState.idle
    var currentRecipe : Recipe?
    
    init(recipesRepository: RecipesRepository) {
        self.recipesRepository = recipesRepository
    }
    
    func getRecipes() {
        state  = RecipesState.loading
        guard let currentUserID = UserDefaults.standard.string(forKey: "firebaseUserId") else {
            return
        }
        recipesRepository.getRecipes(userId: currentUserID) { recipes in
            guard let recipesNonNull = recipes else {
                self.state = RecipesState.error
                return
            }
            if (recipesNonNull.isEmpty) {
                self.state = RecipesState.error
            } else {
                self.state = RecipesState.content(recipes: recipesNonNull)
            }
        }
    }
    
    func getTotalWith(recipe : Recipe) -> String {
        var sum = 0.0
        for (index, _) in recipe.ingredients.enumerated() {
            let kcal = recipe.ingredients[index].nutrient.kcal
            let quantity = recipe.quantities[index]
            sum += kcal * quantity.value * quantity.kind.kcalMultiplier
        }
        return "\(String(format: "%.2f", sum))g"
    }
    
    func getTotalKcal(recipe : Recipe) -> String {
        var sum = 0.0
        for (index, _) in recipe.ingredients.enumerated() {
            let kcal = recipe.ingredients[index].nutrient.kcal
            let quantity = recipe.quantities[index]
            sum += kcal * quantity.value * quantity.kind.kcalMultiplier
        }
        return "\(String(format: "%.2f", sum))g"
    }
    
    func getTotalCarbs(recipe : Recipe) -> String {
        var sum = 0.0
        for (index, _) in recipe.ingredients.enumerated() {
            let kcal = recipe.ingredients[index].nutrient.carb
            let quantity = recipe.quantities[index]
            sum += kcal * quantity.value * quantity.kind.kcalMultiplier
        }
        return "\(String(format: "%.2f", sum))g"
    }
    
    func getTotalFat(recipe : Recipe) -> String {
        var sum = 0.0
        for (index, _) in recipe.ingredients.enumerated() {
            let kcal = recipe.ingredients[index].nutrient.fat
            let quantity = recipe.quantities[index]
            sum += kcal * quantity.value * quantity.kind.kcalMultiplier
        }
        return "\(String(format: "%.2f", sum))g"
    }
    
    func getTotalProt(recipe : Recipe) -> String {
        var sum = 0.0
        for (index, _) in recipe.ingredients.enumerated() {
            let kcal = recipe.ingredients[index].nutrient.prot
            let quantity = recipe.quantities[index]
            sum += kcal * quantity.value * quantity.kind.kcalMultiplier
        }
        return "\(String(format: "%.2f", sum))g"
    }
    
    func getTotalFibers(recipe : Recipe) -> String {
        var sum = 0.0
        for (index, _) in recipe.ingredients.enumerated() {
            let kcal = recipe.ingredients[index].nutrient.fiber
            let quantity = recipe.quantities[index]
            sum += kcal * quantity.value * quantity.kind.kcalMultiplier
        }
        return "\(String(format: "%.2f", sum))g"
    }
}

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
    var cachedRecipe : Recipe?
    var currentRecipes = [Recipe]()
    
    init(recipesRepository: RecipesRepository) {
        self.recipesRepository = recipesRepository
    }
    
    func getRecipes() {
        state  = RecipesState.loading
        guard let currentUserID = UserDefaults.standard.string(forKey: "firebaseUserId") else {
            return
        }
        recipesRepository.fetchAllRecipes(userId: currentUserID) { result in
            switch result {
            case .success(let recipes):
                if (recipes.isEmpty) {
                    self.state = RecipesState.error
                    return 
                }
                self.currentRecipes = recipes
                self.state = RecipesState.content(recipes: recipes)
            case .failure(let error):
                print("Error fetching recipes: \(error.localizedDescription)")
                self.state = RecipesState.error
            }
        }
    }
    
    func removeRecipe(at offsets: IndexSet, completion : @escaping () -> Void) {
        let recipesToRemove = offsets.map { currentRecipes[$0] }
        recipesToRemove.forEach { recipe in
            recipesRepository.removeRecipe(recipe: recipe, completion: completion)
        }
        currentRecipes.remove(atOffsets: offsets)
    }
    
    func removeRecipe(recipe : Recipe, completion : @escaping () -> Void) {
        recipesRepository.removeRecipe(recipe: recipe, completion: completion)
    }
    
    func getTotalWith(recipe : Recipe) -> String {
        var sum = 0.0
        for (index, _) in recipe.ingredients.enumerated() {
            let kcal = recipe.ingredients[index].nutrient.kcal
            let quantity = recipe.quantities[index]
            let portionCount = recipe.portionCount
            sum += (kcal * quantity.value * quantity.kind.kcalMultiplier) / Double(portionCount)
        }
        return "\(String(format: "%.2f", sum))g"
    }
    
    func getTotalKcal(recipe : Recipe) -> String {
        var sum = 0.0
        for (index, _) in recipe.ingredients.enumerated() {
            let kcal = recipe.ingredients[index].nutrient.kcal
            let quantity = recipe.quantities[index]
            let portionCount = recipe.portionCount
            sum += (kcal * quantity.value * quantity.kind.kcalMultiplier) / Double(portionCount)
        }
        return "\(String(format: "%.2f", sum))g"
    }
    
    func getTotalCarbs(recipe : Recipe) -> String {
        var sum = 0.0
        for (index, _) in recipe.ingredients.enumerated() {
            let kcal = recipe.ingredients[index].nutrient.carb
            let quantity = recipe.quantities[index]
            let portionCount = recipe.portionCount
            sum += (kcal * quantity.value * quantity.kind.kcalMultiplier) / Double(portionCount)
        }
        return "\(String(format: "%.2f", sum))g"
    }
    
    func getTotalFat(recipe : Recipe) -> String {
        var sum = 0.0
        for (index, _) in recipe.ingredients.enumerated() {
            let kcal = recipe.ingredients[index].nutrient.fat
            let quantity = recipe.quantities[index]
            let portionCount = recipe.portionCount
            sum += (kcal * quantity.value * quantity.kind.kcalMultiplier) / Double(portionCount)
        }
        return "\(String(format: "%.2f", sum))g"
    }
    
    func getTotalProt(recipe : Recipe) -> String {
        var sum = 0.0
        for (index, _) in recipe.ingredients.enumerated() {
            let kcal = recipe.ingredients[index].nutrient.prot
            let quantity = recipe.quantities[index]
            let portionCount = recipe.portionCount
            sum += (kcal * quantity.value * quantity.kind.kcalMultiplier) / Double(portionCount)
        }
        return "\(String(format: "%.2f", sum))g"
    }
    
    func getTotalFibers(recipe : Recipe) -> String {
        var sum = 0.0
        for (index, _) in recipe.ingredients.enumerated() {
            let kcal = recipe.ingredients[index].nutrient.fiber
            let quantity = recipe.quantities[index]
            let portionCount = recipe.portionCount
            sum += (kcal * quantity.value * quantity.kind.kcalMultiplier) / Double(portionCount)
        }
        return "\(String(format: "%.2f", sum))g"
    }
}

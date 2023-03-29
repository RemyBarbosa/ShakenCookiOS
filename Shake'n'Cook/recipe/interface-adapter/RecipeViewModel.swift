//
//  RecipeViewModel.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 19/03/2023.
//

import Foundation

class RecipeViewModel: ObservableObject {
    private let recipesRepository: RecipesRepository
    @Published var currentIngredients = [Ingredient]()
    @Published var currentQuantities = [Quantity]()
    @Published var currentSteps = [Step]()

    @Published var state  = RecipeState.idle
    
    init(recipesRepository: RecipesRepository) {
        self.recipesRepository = recipesRepository
    }
    
    func initWith(recipe : Recipe?) {
        if let recipe = recipe {
            currentIngredients = recipe.ingredients.map{Ingredient(ingredientFirebase: $0)}
            currentQuantities = recipe.quantities
            currentSteps = recipe.steps
        }
    }
    
    func getIngredients(step : Step) -> [Ingredient] {
        return step.ingredientIds.compactMap{ ingredientId in currentIngredients.first { ingredientId == $0.ingredientFirebase.id } }
    }
    
    func handleStep(ingredients : [Ingredient], description:String, currentStep:Step?) {
        let ingredientIds = ingredients.compactMap { $0.ingredientFirebase.id }
        if let currentStepNumber = currentStep?.number {
            if let index = currentSteps.firstIndex(where: { $0.number == currentStepNumber }) {
                currentSteps[index] = Step(ingredientIds: ingredientIds, number: currentStepNumber, description: description)
            } else {
                currentSteps.append(Step(ingredientIds: ingredientIds, number: currentSteps.count+1, description: description))
            }
        } else {
            currentSteps.append(Step(ingredientIds: ingredientIds, number: currentSteps.count+1, description: description))
        }
        
    }
    
    func removeIngredient(ingredient : Ingredient) {
        currentSteps = currentSteps.compactMap { step in
            let ingredientIds = step.ingredientIds.compactMap {
                return $0 == ingredient.ingredientFirebase.id ? nil : $0
            }
            return ingredientIds.isEmpty ? nil : Step(ingredientIds: ingredientIds, number: step.number, description: step.description)
        }
        currentQuantities.removeAll{ $0.ingredientId == ingredient.ingredientFirebase.id }
        currentIngredients.removeAll { $0.ingredientFirebase.id == ingredient.ingredientFirebase.id }
    }
    
    func addIngredientsToList(ingredientsToAdd : [Ingredient]) {
        ingredientsToAdd.forEach() { ingredient in
            if (!currentIngredients.contains() { $0.ingredientFirebase.id == ingredient.ingredientFirebase.id }) {
                currentIngredients.append(ingredient)
                currentQuantities.append(Quantity(ingredientId: ingredient.ingredientFirebase.id))
            }
        }
    }
    
    func removeStep(step : Step) {
        if let index = currentSteps.firstIndex(where: { $0.number == step.number }) {
            currentSteps.remove(at: index)
        }
    }
    
    func uploadRecipe(title : String, recipeKind : RecipeKind, initialRecipe : Recipe?) {
        state = RecipeState.loading
        guard let currentUserID = UserDefaults.standard.string(forKey: "firebaseUserId") else {
            return
        }
        let recipe = Recipe(
            id: initialRecipe?.id ?? nil,
            userId: currentUserID,
            title: title,
            kind: recipeKind,
            ingredients: currentIngredients.compactMap{$0.ingredientFirebase},
            quantities: currentQuantities,
            steps: currentSteps
        )
        recipesRepository.uploadRecipe(recipe: recipe) { success in
            if (success) {
                self.state = RecipeState.uploaded
            } else {
                self.state = RecipeState.error
            }
        }
    }
}

//
//  RecipeViewModel.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 19/03/2023.
//

import Foundation

class RecipeViewModel: ObservableObject {
    @Published var currentIngredients = [Ingredient]()
    @Published var currentQuantities = [Quantity]()
    @Published var currentSteps = [Step]()
    
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
}

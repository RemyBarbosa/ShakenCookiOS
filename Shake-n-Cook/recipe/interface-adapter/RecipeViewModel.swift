//
//  RecipeViewModel.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 19/03/2023.
//

import Foundation

class RecipeViewModel: ObservableObject {
    private let recipesRepository: RecipesRepository
    private let userRepository = UserRepository()
    @Published var currentIngredients = [Ingredient]()
    @Published var currentQuantities = [Quantity]()
    @Published var currentSteps = [Step]()
    @Published var currentStep : Step?
    @Published var currentRecipe : Recipe?
    @Published var portionCount : Int = 1

    @Published var state  = RecipeState.idle
    
    init(recipesRepository: RecipesRepository) {
        self.recipesRepository = recipesRepository
    }
    
    fileprivate func initRecipe(_ recipe: Recipe) {
        currentIngredients = recipe.ingredients.map{Ingredient(ingredientFirebase: $0)}
        currentQuantities = recipe.quantities
        currentSteps = recipe.steps
        portionCount = recipe.portionCount
    }
    
    func initWith(recipe : Recipe?) {
        if let recipe = recipe {
            initRecipe(recipe)
        } else if let recipe = currentRecipe {
            initRecipe(recipe)
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
        let recipe = RecipeFirebase(
            id: initialRecipe?.id ?? nil,
            userId: currentUserID,
            title: title,
            kind: recipeKind,
            ingredientIds: currentIngredients.compactMap{$0.ingredientFirebase.id},
            quantities: currentQuantities,
            steps: currentSteps,
            portionCount: self.portionCount
        )
        recipesRepository.uploadRecipe(recipe: recipe) { success in
            if (success) {
                self.state = RecipeState.uploaded
            } else {
                self.state = RecipeState.error
            }
        }
    }
    
    func saveCache(title : String, recipeKind : RecipeKind, initialRecipe : Recipe?) {
        if (initialRecipe?.id != nil) { return }
        guard let currentUserID = UserDefaults.standard.string(forKey: "firebaseUserId") else {
            return
        }
        currentRecipe = Recipe(
            id: nil,
            userId: currentUserID,
            title: title,
            kind: recipeKind,
            ingredients: currentIngredients.compactMap{$0.ingredientFirebase},
            quantities: currentQuantities,
            steps: currentSteps,
            portionCount: self.portionCount
        )
    }
    
    func saveDailyNutrients(title : String, recipeKind : RecipeKind, initialRecipe : Recipe?) {
        state = RecipeState.loading
        guard let currentUserID = UserDefaults.standard.string(forKey: "firebaseUserId") else {
            return
        }
        let recipe = Recipe(
           id: nil,
           userId: currentUserID,
           title: title,
           kind: recipeKind,
           ingredients: currentIngredients.compactMap{$0.ingredientFirebase},
           quantities: currentQuantities,
           steps: currentSteps,
           portionCount: self.portionCount
       )
        userRepository.uploadDailyNutrients(recipe: recipe, userId: currentUserID)  { [weak self] response in
            switch response {
            case .success(let nutrient):
                DispatchQueue.main.async {
                    self?.state = RecipeState.nutrient(nutrient : nutrient)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                    self?.state = RecipeState.nutrientUploadError
                }
            }
        }
        
    }
}

//
//  File.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 17/03/2023.
//

import Foundation

class ShakeViewModel: ObservableObject {
    private let recipesRepository = RecipesRepository()
    @Published var state = ShakeState.idle
    @Published var currentIngredients = [Ingredient]()
    
    fileprivate func handleFetchRecipesResult(isFiltered : Bool, _ result: Result<[Recipe], Error>) {
        switch result {
        case .success(let recipes):
            guard let  randomRecipe = recipes.randomElement() else {
                print("no random recipe")
                self.state = ShakeState.noRecipe(isFiltered: isFiltered)
                return
            }
            self.state = ShakeState.shaked(recipe: randomRecipe)
        case .failure(let error):
            print("Error fetching recipes: \(error.localizedDescription)")
            self.state = ShakeState.error
        }
    }
    
    func deviceHasBeenShake() {
        state = ShakeState.loading
        guard let currentUserID = UserDefaults.standard.string(forKey: "firebaseUserId") else {
            return
        }
        if (currentIngredients.isEmpty) {
            recipesRepository.fetchAllRecipes(userId: currentUserID) { result in
                self.handleFetchRecipesResult(isFiltered: false, result)
            }
        } else {
            recipesRepository.fetchAllRecipes(
                userId: currentUserID,
                ingredientIds: currentIngredients.compactMap {$0.ingredientFirebase.id}
            ) { result in
                self.handleFetchRecipesResult(isFiltered: true, result)
            }
        }
    }
    
    func setFilteredShake(selectedIngredients: [Ingredient]) {
        if (!selectedIngredients.isEmpty) {
            currentIngredients = selectedIngredients
            state = ShakeState.addFilter(ingredients: selectedIngredients)
        } else {
            state = ShakeState.idle
        }
    }
    
    func resetFilter() {
        currentIngredients = [Ingredient]()
        state = ShakeState.idle
    }
    
    func showLastState() {
        if (currentIngredients.isEmpty) {
            state = ShakeState.idle
        } else {
            state = ShakeState.addFilter(ingredients: currentIngredients)
        }
    }
}

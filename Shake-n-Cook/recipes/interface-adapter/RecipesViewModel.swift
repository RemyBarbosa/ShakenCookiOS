//
//  RecipesViewModel.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 29/03/2023.
//

import Foundation

class RecipesViewModel: ObservableObject { 
    private let recipesRepository: RecipesRepository
    private let userRepository = UserRepository()
    @Published var state  = RecipesState.idle
    @Published var nutrient : NutrientFirebase?
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
    
    func getNutrients() {
        guard let currentUserID = UserDefaults.standard.string(forKey: "firebaseUserId") else {
            return
        }
        userRepository.fetchDailyUserNutrients(userId: currentUserID) { result in
            switch result {
            case .success(let nutrients):
                if (nutrients.isEmpty) {
                    return
                }
                self.nutrient = NutrientFirebase(
                    kcal: nutrients.compactMap {$0.nutrient.kcal}.reduce(0.0, +),
                    prot: nutrients.compactMap {$0.nutrient.prot}.reduce(0.0, +),
                    fat: nutrients.compactMap {$0.nutrient.fat}.reduce(0.0, +),
                    carb: nutrients.compactMap {$0.nutrient.carb}.reduce(0.0, +),
                    fiber: nutrients.compactMap {$0.nutrient.fiber}.reduce(0.0, +)
                )
            case .failure(let error):
                print("Error fetching recipes: \(error.localizedDescription)")
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
}

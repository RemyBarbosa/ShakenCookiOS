//
//  RecipesViewModel.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 29/03/2023.
//

import Foundation

class RecipesViewModel {
    private let recipesRepository: RecipesRepository
    @Published var state  = RecipesState.idle
    
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
}

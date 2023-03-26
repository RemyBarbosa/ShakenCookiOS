//
//  IngredientViewModel.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 18/03/2023.
//

import Foundation
import Combine
import SwiftUI

class IngredientViewModel: ObservableObject {
    private let ingredientRepository: IngredientRepository
    @Published var searchText: String = ""
    @Published var state  = IngredientState.idle
    var selectedIngredients = [Ingredient]() {
        didSet {
            if case .ingredients(let ingredients) = state {
                if (searchText.count > 0) {
                    state = IngredientState.ingredients(ingredients: ingredients.compactMap { ingredient in
                        return self.getIngredientsWithSelected(viewModel: self, ingredientApi: ingredient.ingredientFirebase.toIngredientAPI())
                    })
                } else {
                    state = IngredientState.ingredients(ingredients:selectedIngredients.filter { $0.isSelected })
                }
            }
            if case .idle = state {
                let ingredients: [Ingredient] = selectedIngredients.filter { $0.isSelected }
                if (!ingredients.isEmpty) {
                    state = IngredientState.ingredients(ingredients:ingredients)
                } 
            }
        }
    }
    
    private let searchDelay = 0.5
    private var searchCancellable: AnyCancellable?
    
    init(ingredientRepository: IngredientRepository) {
        self.ingredientRepository = ingredientRepository
    }
    
    func initDebounce() {
        searchCancellable = $searchText
            .debounce(for: .seconds(searchDelay), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { searchText in
                if (searchText.count == 0) {
                    self.state = IngredientState.ingredients(ingredients:self.selectedIngredients)
                }
                return searchText.count > 2
            }
            .sink(receiveValue: { [weak self] query in
                self?.search(query: query)
            })
    }
    
    func initWith(ingredients:[Ingredient]){
        selectedIngredients = ingredients
    }
    
    private func getIngredientsWithSelected(
        viewModel : IngredientViewModel?,
        ingredientApi : IngredientAPI
    ) -> Ingredient? {
        let isSelected = viewModel?.selectedIngredients.contains { ingredient in
            ingredient.ingredientFirebase.id == ingredientApi.foodId && ingredient.isSelected
        } ?? false
        guard let ingredientFirebase = ingredientApi.toIngredientFirebase() else { return nil }
        var ingredient = Ingredient(ingredientFirebase: ingredientFirebase)
        ingredient.isSelected = isSelected
        return ingredient
    }
    
    func search(query:String) {
        state = IngredientState.loading
        ingredientRepository.getIngredients(query: query.lowercased()) { [weak self] response in
            switch response {
            case .success(let ingredients):
                let result = ingredients.compactMap{ ingredientApi in
                    return self?.getIngredientsWithSelected(viewModel : self, ingredientApi: ingredientApi)
                }
                DispatchQueue.main.async {
                    self?.state = IngredientState.ingredients(ingredients:result)
                }
            case .failure( _):
                // todo handle error with state
                self?.state = IngredientState.error
            }
        }
    }
    
    func handleIngredient(ingredient :Ingredient) {
        var newIngredient = ingredient
        newIngredient.isSelected = !newIngredient.isSelected
        if let index = selectedIngredients.firstIndex(where: { $0.ingredientFirebase.name == newIngredient.ingredientFirebase.name }) {
            selectedIngredients.remove(at: index)
        } else {
            selectedIngredients.append(newIngredient)
        }
    }
    
    func saveIngredientOnFirebase(ingredient: Ingredient) {
        ingredientRepository.saveIngredientOnFirebase(ingredient: ingredient)
    }
}

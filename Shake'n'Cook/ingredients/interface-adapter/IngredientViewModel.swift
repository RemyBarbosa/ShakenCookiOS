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
                        return self.getIngredientsWithSelected(viewModel: self, ingredient.name, ingredient.id, ingredient.pictureUrl)
                    })
                } else {
                    state = IngredientState.ingredients(ingredients:selectedIngredients.filter { $0.isSelected })
                }
            }
            if case .idle = state {
                state = IngredientState.ingredients(ingredients:selectedIngredients.filter { $0.isSelected })
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
    
    fileprivate func getIngredientsWithSelected(viewModel : IngredientViewModel?, _ name: String, _ tagdId: String, _ pictureUrl: String?) -> Ingredient? {
        let isSelected = viewModel?.selectedIngredients.contains { ingredient in
            ingredient.name == name && ingredient.isSelected
        } ?? false
        let computedPictureUrl = pictureUrl?.contains("nix-apple-grey") == true ? nil : pictureUrl
        return Ingredient( id : tagdId, name: name, pictureUrl: computedPictureUrl, isSelected: isSelected)
    }
    
    func search(query:String) {
        state = IngredientState.loading
        ingredientRepository.getIngredients(query: query) { [weak self] response in
            switch response {
            case .success(let ingredients):
                let result = ingredients.compactMap{ ingredientApi in
                    if let name = ingredientApi.food_name, let tagId = ingredientApi.tag_id {
                        return self?.getIngredientsWithSelected(viewModel : self, name, tagId, ingredientApi.photo?.thumb)
                    } else {
                        return nil
                    }
                }
                DispatchQueue.main.async {
                    self?.state = IngredientState.ingredients(ingredients:result)
                }
            case .failure(let error):
                // todo handle error with state
                print(error)
            }
        }
    }
    
    func handleIngredient(ingredient :Ingredient) {
        var newIngredient = ingredient
        newIngredient.isSelected = !newIngredient.isSelected
        if let index = selectedIngredients.firstIndex(where: { $0.name == newIngredient.name }) {
            selectedIngredients.remove(at: index)
        } else {
            selectedIngredients.append(newIngredient)
        }
    }
    
    func saveIngredientOnFirebase(ingredient: Ingredient) {
        ingredientRepository.saveIngredientOnFirebase(ingredient: ingredient)
    }
}

//
//  StepViewModel.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 26/03/2023.
//

import Foundation

class StepViewModel: ObservableObject {
    @Published var currentIngredients : [Ingredient] = [Ingredient]()
    
    func initWith(ingredients:[Ingredient], currentStep:Step?){
        currentIngredients = ingredients
        if let ingredientIds = currentStep?.ingredientIds {
            for (index, _) in currentIngredients.enumerated() {
                currentIngredients[index].isSelected = ingredientIds.contains { $0 == currentIngredients[index].ingredientFirebase.id }
            }
        } else {
            for (index, _) in currentIngredients.enumerated() {
                currentIngredients[index].isSelected = false
            }
        }
    }
}

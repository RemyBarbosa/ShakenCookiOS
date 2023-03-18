//
//  File.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 17/03/2023.
//

import Foundation

class ShakeViewModel: ObservableObject {
    @Published var state = ShakeState.idle
    @Published var currentIngredients = [Ingredient]()
    private var shakeCount = 0
    
    func deviceHasBeenShake() {
        shakeCount+=1
        state = ShakeState.shaked(count: shakeCount)
    }
    
    func setFilteredShake(selectedIngredients: [Ingredient]) {
        if (!selectedIngredients.isEmpty) {
            currentIngredients = selectedIngredients
            state = ShakeState.addFilter(ingredients: selectedIngredients)
        } else {
            state = ShakeState.idle
        }
    }
}

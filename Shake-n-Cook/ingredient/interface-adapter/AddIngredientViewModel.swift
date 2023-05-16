//
//  AddIngredientViewModel.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 18/03/2023.
//

import Foundation
import Combine
import SwiftUI

class AddIngredientViewModel: ObservableObject {
    private let ingredientRepository: IngredientRepository
    @Published var state  = AddIngredientState.idle
    
    @Published var titleText :String = ""
    @Published var image: UIImage? = nil
    @Published var barcodeValue: String = "No barcode"
    let barcodeDefaultValue: String = "No barcode"
    
    @Published var kcal :Double = 0
    @Published var carbs :Double  = 0
    @Published var fat  :Double = 0
    @Published var prot :Double  = 0
    @Published var fiber :Double = 0
    
    @Published var kind: QuantityKind = QuantityKind.g
    
    init(ingredientRepository: IngredientRepository) {
        self.ingredientRepository = ingredientRepository
    }
    
    func createIngredient() {
        state = AddIngredientState.loading
        guard let image = image else {
            state = AddIngredientState.error
            return
        }
        if (barcodeValue == barcodeDefaultValue) {
            state = AddIngredientState.error
            return
        }
        
        let id = titleText
            .precomposedStringWithCanonicalMapping
            .folding(options: .diacriticInsensitive, locale: .current)
            .filter { CharacterSet.alphanumerics.contains($0.unicodeScalars.first!) }
            .filter { !$0.isWhitespace }
            .lowercased()
        let ingredient = IngredientFirebase(
            id: barcodeValue+id,
            name: titleText.lowercased(),
            nameFr: titleText.lowercased(),
            label: titleText,
            nutrient: NutrientFirebase(
                kcal: kcal,
                prot: prot,
                fat: fat,
                carb: carbs,
                fiber: fiber
            ),
            pictureUrl: nil,
            searchArray: titleText.lowercased().split(separator: " ").map(String.init)
        )
        
        ingredientRepository.saveShakeIngredientOnFirebase(
            ingredient: ingredient,
            image: image
        ) { [weak self] response in
            switch response {
            case .success(let ingredient):
                DispatchQueue.main.async {
                    self?.state = AddIngredientState.ingredient(ingredient: ingredient.toUnselectedIngredient())
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                    self?.state = AddIngredientState.error
                }
            }
        }
    }
    
}

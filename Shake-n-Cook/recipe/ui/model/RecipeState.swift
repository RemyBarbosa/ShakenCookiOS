//
//  RecipeState.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 29/03/2023.
//

import Foundation

enum RecipeState:Equatable {
    case idle
    case loading
    case uploaded
    case nutrient(nutrient: DailyNutrientFirebase)
    case nutrientUploadError
    case error
}

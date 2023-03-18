//
//  ShakeState.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 17/03/2023.
//

import Foundation

enum ShakeState {
    case idle
    case shaked(count: Int)
    case addFilter(ingredients: [Ingredient])
}

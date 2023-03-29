//
//  RecipesState.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 29/03/2023.
//

import Foundation

enum RecipesState {
    case idle
    case loading
    case content(recipes : [Recipe])
    case error
}


//
//  Ingredient.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 18/03/2023.
//

import Foundation

struct Ingredient : Hashable{
    let id: String
    let name: String
    let pictureUrl: String?
    var isSelected: Bool = false
}

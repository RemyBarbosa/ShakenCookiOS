//
//  File.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 24/03/2023.
//

import Foundation

struct Quantity {
    let ingredientId: String?
    var kind: QuantityKind = QuantityKind.no
    var value: Double = 0
}

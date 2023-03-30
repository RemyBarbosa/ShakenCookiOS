//
//  Recipe.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 29/03/2023.
//

import Foundation
import FirebaseFirestoreSwift
import CodableFirebase

struct RecipeFirebase : Codable, Hashable {
    @DocumentID var id: String?
    let userId: String
    let title: String
    let kind: RecipeKind
    let ingredientIds: [String]
    let quantities: [Quantity]
    let steps: [Step]
    
    func toRecipe(ingredients : [IngredientFirebase]) -> Recipe {
        return Recipe (id:id, userId: userId, title: title, kind: kind, ingredients: ingredients, quantities: quantities, steps: steps)
    }
}

struct Recipe : Codable, Hashable {
    @DocumentID var id: String?
    let userId: String
    let title: String
    let kind: RecipeKind
    let ingredients: [IngredientFirebase]
    let quantities: [Quantity]
    let steps: [Step]
}

enum RecipeKind : CaseIterable, Codable, Hashable{
    case aperitif
    case starter
    case mainCourse
    case dessert
    case beverage
    
    var title: String {
        switch self {
        case .aperitif:
            return "Aperitif"
        case .starter:
            return "Starter"
        case .mainCourse:
            return "Main Course"
        case .dessert:
            return "Dessert"
        case .beverage:
            return "Beverage"
        }
    }
}

struct Quantity : Codable, Hashable {
    let ingredientId: String?
    var kind: QuantityKind = QuantityKind.g
    var value: Double = 100
}

enum QuantityKind : String, CaseIterable, Codable, Hashable{
    case g
    case mg
    case kg
    case tsp
    case tbp
    case ml
    case cl
    case l
    case p
    
    var kcalMultiplier: Double {
        switch self {
        case .g:
            return 0.01
        case .mg:
            return 0.00001
        case .kg:
            return 10
        case .ml:
            return 0.00001
        case .cl:
            return 1
        case .l:
            return 10
        default :
            return 0
        }
    }
    
    var title: String {
        switch self {
        case .tsp:
            return "tea spoon"
        case .tbp:
            return "table spoon"
        case .p:
            return "piece"
        default :
            return self.rawValue
        }
    }
}

struct Step : Codable, Hashable{
    var ingredientIds: [String]
    var number: Int
    var description: String
}





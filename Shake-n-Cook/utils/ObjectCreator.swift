//
//  ObjectCreator.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 26/03/2023.
//

import Foundation

struct ObjectCreator {
    var currentIngredients = [Ingredient.defaultIngredient(), Ingredient(ingredientFirebase: IngredientFirebase(id: "id2", name: "name2", nameFr: "namefr2", label: "label2", nutrient: NutrientFirebase.defaultNutrient(), pictureUrl: "https://firebasestorage.googleapis.com:443/v0/b/shake-n-cook.appspot.com/o/ingredients%2Ffood_a9dpcnjb883g67b3lq82ca0421ql.jpg?alt=media&token=9c4d968e-c8cb-4e36-8aab-439a3acbfed4", searchArray: [String]())),
                              Ingredient(ingredientFirebase: IngredientFirebase(id: "id3", name: "name3", nameFr: "namefr3", label: "label3", nutrient: NutrientFirebase.defaultNutrient(), pictureUrl: "https://firebasestorage.googleapis.com:443/v0/b/shake-n-cook.appspot.com/o/ingredients%2Ffood_a9dpcnjb883g67b3lq82ca0421ql.jpg?alt=media&token=9c4d968e-c8cb-4e36-8aab-439a3acbfed4", searchArray: [String]()))]
    var currentQuantities = [Quantity(ingredientId: "id"),Quantity(ingredientId: "id2"),Quantity(ingredientId: "id3")]
    var currentSteps = [Step(ingredientIds: ["id", "id2", "id3"], number: 1, description: "faire en sorte que ça marche, faire en sorte que ça marche, faire en sorte que ça marche , faire en sorte que ça marche, faire en sorte que ça marche faire en sorte que ça marche faire en sorte que ça marchefaire en sorte que ça marchefaire en sorte que ça marchefaire en sorte que ça marchefaire en sorte que ça marchefaire en sorte que ça marchefaire en sorte que ça marchefaire en sorte que ça marchefaire en sorte que ça marchefaire en sorte que ça marchefaire en sorte que ça marchefaire en sorte que ça marchefaire en sorte que ça marchefaire en sorte que ça marchefaire en sorte que ça marchefaire en sorte que ça marchefaire en sorte que ça marche")]
    
}

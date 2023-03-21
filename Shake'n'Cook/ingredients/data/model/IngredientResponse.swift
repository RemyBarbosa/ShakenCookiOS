//
//  IngredientResponse.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 18/03/2023.
//

import Foundation
import FirebaseFirestoreSwift
import CodableFirebase

struct FoodResponse: Decodable {
    let parsed: [Food]?
    let hints: [Food]?
}

struct Food: Decodable {
    let food: IngredientAPI?
}

struct IngredientAPI: Decodable, Hashable {
    let foodId: String?
    let knownAs: String?
    let label: String?
    let nutrients: NutrientAPI?
    let image: String?
    
    func toIngredientFirebase() -> IngredientFirebase? {
        if (foodId == nil || knownAs == nil || label == nil) {
            return nil
        }
        return IngredientFirebase(
            id: foodId!,
            name: knownAs!,
            nameFr: knownAs!,
            label: label!,
            nutrient: nutrients?.toNutrientFireBase() ?? NutrientFirebase.defaultNutrient(),
            pictureUrl: image
        )
    }
}

struct NutrientAPI: Decodable, Hashable {
    let ENERC_KCAL: Double?
    let PROCNT: Double?
    let FAT: Double?
    let CHOCDF: Double?
    let FIBTG: Double?
    
    func toNutrientFireBase() -> NutrientFirebase {
        return NutrientFirebase(kcal: ENERC_KCAL ?? 0, prot: PROCNT ?? 0, fat: FAT ?? 0, carb: CHOCDF ?? 0, fiber: FIBTG ?? 0)
    }
}

struct IngredientFirebase: Codable, Hashable {
    @DocumentID var id: String?
    let name: String
    let nameFr: String
    let label: String
    let nutrient: NutrientFirebase
    var pictureUrl: String?
    
    func toIngredientAPI() -> IngredientAPI {
        return IngredientAPI(
            foodId: id,
            knownAs: name,
            label: label,
            nutrients: nutrient.toNutrientAPI(),
            image: pictureUrl
        )
    }
    
    static func defaultIngredient() -> IngredientFirebase {
        return IngredientFirebase(id: "id", name: "name", nameFr: "nameFr", label: "label", nutrient: NutrientFirebase.defaultNutrient(), pictureUrl: nil)
    }
}

struct NutrientFirebase: Codable, Hashable {
    @DocumentID var id: String?
    let kcal: Double
    let prot: Double
    let fat: Double
    let carb: Double
    let fiber: Double
    
    func toNutrientAPI() -> NutrientAPI {
        return NutrientAPI(ENERC_KCAL: kcal, PROCNT: prot, FAT: fat, CHOCDF: carb, FIBTG: fiber)
    }
    
    static func defaultNutrient() -> NutrientFirebase {
        return NutrientFirebase(kcal: 0, prot: 0, fat: 0, carb: 0, fiber: 0)
    }
}

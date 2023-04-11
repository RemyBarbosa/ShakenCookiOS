//
//  DailyNutrientF.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 11/04/2023.
//

import Foundation
import FirebaseFirestoreSwift
import CodableFirebase
import FirebaseFirestore

struct DailyNutrientFirebase: Codable, Hashable {
    let nutrient: NutrientFirebase
    let userId: String
    let createAt: Timestamp
}

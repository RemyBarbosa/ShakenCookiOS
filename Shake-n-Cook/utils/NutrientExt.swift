//
//  NutrientExt.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 11/04/2023.
//

import Foundation

extension NutrientFirebase {
    func getFormattedKcal() -> String {
        return "\(String(format: "%.2f", self.kcal))g"
    }
    func getFormattedProt() -> String {
        return "\(String(format: "%.2f", self.prot))g"
    }
    func getFormattedFat() -> String {
        return "\(String(format: "%.2f", self.fat))g"
    }
    func getFormattedCarb() -> String {
        return "\(String(format: "%.2f", self.carb))g"
    }
    func getFormattedFiber() -> String {
        return "\(String(format: "%.2f", self.fiber))g"
    }
}

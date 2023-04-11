//
//  RecipeExt.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 09/04/2023.
//

import Foundation

extension Recipe {
    func getTotalKcal() -> String {
        return "\(String(format: "%.2f", getTotalKcalValue()))g"
    }
    
    func getTotalKcalValue() -> Double {
        var sum = 0.0
        for (index, _) in self.ingredients.enumerated() {
            let kcal = self.ingredients[index].nutrient.kcal
            let quantity = self.quantities[index]
            let portionCount = self.portionCount
            sum += (kcal * quantity.value * quantity.kind.kcalMultiplier) / Double(portionCount)
        }
        return sum
    }
    
    func getTotalCarbs() -> String {
        return "\(String(format: "%.2f", getTotalCarbsValue()))g"
    }
    
    func getTotalCarbsValue() -> Double {
        var sum = 0.0
        for (index, _) in self.ingredients.enumerated() {
            let kcal = self.ingredients[index].nutrient.carb
            let quantity = self.quantities[index]
            let portionCount = self.portionCount
            sum += (kcal * quantity.value * quantity.kind.kcalMultiplier) / Double(portionCount)
        }
        return sum
    }
    
    func getTotalFat() -> String {
        return "\(String(format: "%.2f", getTotalFatValue()))g"
    }
    
    func getTotalFatValue() -> Double {
        var sum = 0.0
        for (index, _) in self.ingredients.enumerated() {
            let kcal = self.ingredients[index].nutrient.fat
            let quantity = self.quantities[index]
            let portionCount = self.portionCount
            sum += (kcal * quantity.value * quantity.kind.kcalMultiplier) / Double(portionCount)
        }
        return  sum
    }
    
    func getTotalProt() -> String {
        return "\(String(format: "%.2f", getTotalProtValue()))g"
    }
    
    func getTotalProtValue() -> Double {
        var sum = 0.0
        for (index, _) in self.ingredients.enumerated() {
            let kcal = self.ingredients[index].nutrient.prot
            let quantity = self.quantities[index]
            let portionCount = self.portionCount
            sum += (kcal * quantity.value * quantity.kind.kcalMultiplier) / Double(portionCount)
        }
        return sum
    }
    
    func getTotalFibers() -> String {
        return "\(String(format: "%.2f", getTotalFibersValue()))g"
    }
    
    func getTotalFibersValue() -> Double {
        var sum = 0.0
        for (index, _) in self.ingredients.enumerated() {
            let kcal = self.ingredients[index].nutrient.fiber
            let quantity = self.quantities[index]
            let portionCount = self.portionCount
            sum += (kcal * quantity.value * quantity.kind.kcalMultiplier) / Double(portionCount)
        }
        return sum
    }
}

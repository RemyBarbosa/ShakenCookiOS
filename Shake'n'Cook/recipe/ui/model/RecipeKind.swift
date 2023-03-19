//
//  File.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 19/03/2023.
//

import Foundation

enum RecipeKind : CaseIterable{
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
            return "West"
        }
    }
}

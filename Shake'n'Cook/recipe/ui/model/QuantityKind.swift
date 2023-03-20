//
//  QuantityKind.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 20/03/2023.
//

import Foundation

enum QuantityKind : String, CaseIterable, Hashable{
    case g
    case mg
    case kg
    case tsp
    case tbp
    case cup
    case ml
    case cl
    case l
    case p
    
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

//
//  QuantityKind.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 20/03/2023.
//

import Foundation

enum QuantityKind : String, CaseIterable, Hashable{
    case no
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
        case .no:
            return "No quantity"
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

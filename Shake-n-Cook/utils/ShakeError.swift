//
//  Error.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 18/03/2023.
//

import Foundation

enum ShakeError: Error {
    case nullableError(message: String)
    case firebaseNoDocument(message: String)
    case networkError(message: String)
    case genericError(message: String)
}

//
//  SVGImage.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 17/03/2023.
//

import SwiftUI
import SVGKit

// extension of Temperature class
extension SVGKImage {
    
    // add new methods`
    func resize(width: Double, height:Double) -> UIImage{
        let uiImage = UIImage(cgImage: self.uiImage.cgImage!)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        let resizedImage = renderer.image { _ in
            uiImage.draw(in: CGRect(x: 0, y: 0, width:width, height: height))
        }
        return resizedImage
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

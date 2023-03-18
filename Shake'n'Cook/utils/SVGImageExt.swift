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

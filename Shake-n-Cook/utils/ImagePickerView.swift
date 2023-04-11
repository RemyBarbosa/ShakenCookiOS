//
//  ImagePickerView.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 08/04/2023.
//

import Foundation
import SwiftUI
import AVFoundation

struct ImagePickerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    typealias ResultHandler = (Result<UIImage, Error>) -> Void
    
    enum PickerError: Error {
        case imagePickingFailed
    }
    
    var sourceType: UIImagePickerController.SourceType
    var completionHandler: ResultHandler
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = true // Enable cropping
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage { // Get the cropped image
                parent.completionHandler(.success(image))
            } else {
                parent.completionHandler(.failure(PickerError.imagePickingFailed))
            }
            
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

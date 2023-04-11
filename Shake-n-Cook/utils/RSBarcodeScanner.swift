//
//  RSBarcodeScanner.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 09/04/2023.
//

import SwiftUI
import RSBarcodes_Swift

struct RSBarcodeScannerView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var onDismiss: ((String?) -> Void)?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> RSCodeReaderViewController {
        let controller = RSCodeReaderViewController()
        controller.barcodesHandler = { barcodes in
            if let barcode = barcodes.first?.stringValue {
                context.coordinator.barcodeCaptured(code: barcode)
            }
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: RSCodeReaderViewController, context: Context) {
        // No need to update the UIViewController
    }
    
    
    class Coordinator: NSObject {
        let parent: RSBarcodeScannerView
        private var isBarcodeCaptured = false
        
        init(_ parent: RSBarcodeScannerView) {
            self.parent = parent
        }
        
        func barcodeCaptured(code: String) {
            if !isBarcodeCaptured {
                isBarcodeCaptured = true
                parent.onDismiss?(code)
                parent.isPresented = false
            }
        }
    }
}


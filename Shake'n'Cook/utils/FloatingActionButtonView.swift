//
//  FloatingActionButtonView.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 20/03/2023.
//

import SwiftUI
import SVGKit

struct FloatingActionButtonView<Label> : View where Label : View {
    @ViewBuilder var  label: () -> Label
    var width = 75.0
    var height = 75.0
    var action : () -> Void = {}
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            self.label()
        })
        .frame(width: width, height: height)
        .background(Color.blue)
        .cornerRadius(200)
        .shadow(color: Color.black.opacity(0.3),radius: 3,   x: 3, y: 3)
    }
}

struct FloatingActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingActionButtonView(label: {
            Text("+").font(.largeTitle).colorInvert()
        })
    }
}

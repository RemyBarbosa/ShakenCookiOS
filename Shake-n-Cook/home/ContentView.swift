//
//  ContentView.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 17/03/2023.
//

import SwiftUI
import SVGKit

struct ContentView: View {
    var body: some View {
        TabView {
            ShakeView()
                .tabItem {
                    Image(systemName: "iphone.gen3.radiowaves.left.and.right")
                    Text("Shake")
                }
            RecipesView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Recipes")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

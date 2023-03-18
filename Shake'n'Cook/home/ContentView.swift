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
                    Image(uiImage: SVGKImage(named: "shake").resize(width: 30, height: 30))
                    Text("Shake")
                }
            Text("Profile")
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

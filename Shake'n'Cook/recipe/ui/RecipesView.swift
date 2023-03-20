//
//  RecipeView.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 19/03/2023.
//

import SwiftUI

struct RecipesView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("No recipes Found").font(.title).padding(.horizontal).padding(.top)
            Spacer()
            HStack {
                Spacer()
                FloatingActionButtonView(
                    label: {
                        Text("+").font(.largeTitle).colorInvert()
                    }
                ) {
                }
            }
        }
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView()
    }
}

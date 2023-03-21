//
//  IngredientItemView.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 20/03/2023.
//

import SwiftUI
import Kingfisher


struct IngredientItemView: View {
    var ingredient : Ingredient
    var body: some View {
        HStack{
            IngredientImageView(ingredient:ingredient)
            Image(ingredient.ingredientFirebase.label).foregroundColor(Color.black)
            Text(ingredient.ingredientFirebase.label).foregroundColor(Color.black)
            Spacer()
            if ingredient.isSelected {
                Image(systemName: "checkmark")
            }
        }
    }
}

struct IngredientImageView: View {
    var ingredient : Ingredient
    var width = 48.0
    var height = 48.0
    var body: some View {
        if let pictureUrl = URL(string: ingredient.ingredientFirebase.pictureUrl ?? "") {
            KFImage(pictureUrl)
                .placeholder {
                    ProgressView()
                }
                .retry(maxCount: 3, interval: .seconds(2))
                .cacheOriginalImage()
                .onFailure { error in
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(width*4)
                .frame(width: width, height: height)
        }else {
            Image(systemName: "questionmark")
                .frame(width: width, height: height)
        }
    }
}

struct IngredientItemView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientItemView(ingredient: Ingredient.defaultIngredient())
    }
}

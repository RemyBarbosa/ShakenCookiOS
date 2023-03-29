//
//  RecipeView.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 19/03/2023.
//

import SwiftUI
import SVGKit

struct RecipesView: View {
    @State private var showBottomSheet = false
    @StateObject var viewModel = RecipesViewModel(recipesRepository: RecipesRepository())
    
    fileprivate func nutrientView(field:String, text:String) -> some View {
        return HStack {
            Image(uiImage: SVGKImage(named:field).resize(width: 25, height:25)).padding(.horizontal, 4)
            Text(text)
                .font(.body)
                .foregroundColor(.black)
            Spacer()
        }
    }
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .idle :
                Spacer()
                Text("No recipes yet add some !").font(.title).padding(.horizontal).padding(.top)
            case .loading:
                Spacer()
                ProgressView()
            case .content(let recipes):
                let columns = [
                    GridItem(.flexible())
                ]
                LazyVGrid(columns: columns) {
                    ForEach(recipes, id: \.self) { recipe in
                        Button(action: {
                            viewModel.currentRecipe = recipe
                            showBottomSheet.toggle()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.init(hex: "EEEEEE"))
                                    .shadow(radius: 5)
                                VStack {
                                    Text(recipe.title)
                                        .font(.title3)
                                        .foregroundColor(.black)
                                        .padding()
                                    Divider()
                                    VStack {
                                        nutrientView(field: "kcal", text: "\(viewModel.getTotalKcal(recipe: recipe)) kcal")
                                        nutrientView(field: "carbs", text: "\(viewModel.getTotalCarbs(recipe: recipe)) carbs")
                                        nutrientView(field: "fat", text: "\(viewModel.getTotalFat(recipe: recipe)) fat")
                                        nutrientView(field: "prot", text: "\(viewModel.getTotalProt(recipe: recipe)) prot")
                                        nutrientView(field: "fiber", text: "\(viewModel.getTotalProt(recipe: recipe)) fiber")
                                    }
                                }
                            }
                        }.padding()
                    }
                }.padding()
            case .error:
                Spacer()
                Text("No recipes Found").font(.title).padding(.horizontal).padding(.top)
            }
            Spacer()
            HStack {
                Spacer()
                FloatingActionButtonView(
                    label: {
                        Text("+").font(.largeTitle).colorInvert()
                    }
                ) {
                    showBottomSheet.toggle()
                }.padding()
            }
        }.sheet(isPresented: $showBottomSheet, content: {
            RecipeView(initialRecipe : viewModel.currentRecipe) {
                viewModel.getRecipes()
            }
        })
        .onAppear() {
            viewModel.getRecipes()
        }
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView()
    }
}


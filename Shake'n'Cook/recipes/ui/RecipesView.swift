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
            Image(field)
                .resizable()
                .frame(width: 25, height: 25)
                .padding(.leading, 8).padding(.trailing, 4)
                .foregroundColor(Color("iconButtonColor"))
            Text(text)
                .font(.body)
                .foregroundColor(Color("textColor"))
            Spacer()
        }
    }
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .idle :
                Spacer()
                Text("No recipes yet add some !").font(.title).padding(.horizontal).padding(.top)
                Spacer()
            case .loading:
                Spacer()
                ProgressView()
                Spacer()
            case .content(let recipes):
                List {
                    ForEach(recipes, id: \.self) { recipe in
                        Button(action: {
                            viewModel.cachedRecipe = nil
                            viewModel.currentRecipe = recipe
                            showBottomSheet.toggle()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("cardColor"))
                                    .shadow(radius: 5)
                                VStack {
                                    Text(recipe.title)
                                        .font(.title3)
                                        .foregroundColor(Color("textColor"))
                                        .padding()
                                    Divider().background(Color("textColor"))
                                    VStack {
                                        nutrientView(field: "kcal", text: "\(viewModel.getTotalKcal(recipe: recipe)) kcal")
                                        nutrientView(field: "carbs", text: "\(viewModel.getTotalCarbs(recipe: recipe)) carbs")
                                        nutrientView(field: "fat", text: "\(viewModel.getTotalFat(recipe: recipe)) fat")
                                        nutrientView(field: "prot", text: "\(viewModel.getTotalProt(recipe: recipe)) prot")
                                        nutrientView(field: "fiber", text: "\(viewModel.getTotalFibers(recipe: recipe)) fiber").padding(.bottom, 8)
                                    }
                                }
                            }
                        }.padding().listRowBackground(Color.clear)
                    }.onDelete(perform: deleteItem)
                }.listStyle(PlainListStyle())
            case .error:
                Spacer()
                Text("No recipes Found").font(.title).padding(.horizontal).padding(.top)
                Spacer()
            }
            HStack {
                Spacer()
                FloatingActionButtonView(
                    label: {
                        Text("+").font(.largeTitle)
                    }
                ) {
                    if (viewModel.cachedRecipe != nil) {
                        viewModel.currentRecipe = viewModel.cachedRecipe
                    } else {
                        viewModel.currentRecipe = nil
                    }
                    showBottomSheet.toggle()
                }.padding()
            }
        }.sheet(isPresented: $showBottomSheet, content: {
            RecipeView(initialRecipe : viewModel.currentRecipe) { cachedRecipe in
                viewModel.cachedRecipe = cachedRecipe
                if (cachedRecipe == nil) {
                    viewModel.getRecipes()
                }
            }
        })
        .onAppear() {
            viewModel.getRecipes()
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        viewModel.removeRecipe(at: offsets) {
            viewModel.getRecipes()
        }
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView()
    }
}


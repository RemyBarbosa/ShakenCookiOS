//
//  ShakeView.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 17/03/2023.
//

import SwiftUI
import SVGKit

struct ShakeView: View {
    
    @State private var showBottomSheet = false
    @State private var showRecipeBottomSheet = false
    @StateObject var viewModel = ShakeViewModel()
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    switch viewModel.state {
                    case .idle:
                        Text("Shake Me").font(.largeTitle)
                    case .loading:
                        ProgressView()
                    case .error:
                        Text("Something went wrong plz try again").font(.largeTitle).multilineTextAlignment(TextAlignment.center)
                    case .noRecipe(let isFiltered):
                        if (isFiltered) {
                            Text("No recipe with thoses ingredients").font(.largeTitle).multilineTextAlignment(TextAlignment.center)
                        } else {
                            Text("No recipe ! add some and then shake again 😁 ").font(.largeTitle).multilineTextAlignment(TextAlignment.center)
                        }
                    case .shaked(_):
                        Text("Recipe Found !").font(.largeTitle)
                    case .addFilter(let ingredients) :
                        VStack {
                            Text("Now Shake Again !").font(.title).padding()
                            Button(action: {
                                viewModel.resetFilter()
                            }) {
                                HStack {
                                    Spacer()
                                    Image(systemName: "clear.fill")
                                    Text("Clear filters")
                                    Spacer()
                                }
                            }.padding()
                            List(ingredients, id: \.ingredientFirebase.label) { ingredient in
                                IngredientItemView(ingredient: ingredient)
                            }
                            .listStyle(PlainListStyle()).padding()
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
            VStack {
                Spacer() // you can use Rectangle().fill(Color.blue) to see what your doing
                HStack {
                    Spacer()
                    FloatingActionButtonView(
                        label: {
                            Image("fridge")
                                .resizable()
                                .frame(width: 35, height: 50)
                                .foregroundColor(Color("iconButtonColor"))
                        }
                    ) {
                        showBottomSheet.toggle()
                    }.padding()
                }
            }
        }.onShake {
            viewModel.deviceHasBeenShake()
        }.sheet(isPresented: $showBottomSheet, content: {
            SearchIngredientView(initialIngredients : viewModel.currentIngredients) {  selectedIngredients in
                viewModel.setFilteredShake(selectedIngredients:selectedIngredients)
            }
        })
        .sheet(isPresented: $showRecipeBottomSheet, content: {
            if case .shaked(let recipe) = viewModel.state {
                RecipeView(initialRecipe: recipe, onDisappear: {
                    viewModel.showLastState()
                })
            }
        }).onChange(of: viewModel.state) { state in
            if case .shaked(_) = state {
                showRecipeBottomSheet = true
            }
        }
    }
}

struct ShakeView_Previews: PreviewProvider {
    static var previews: some View {
        ShakeView(viewModel: ShakeViewModel())
    }
}

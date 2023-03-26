//
//  RecipeView.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 19/03/2023.
//

import SwiftUI

struct RecipeView: View {
    @State private var showBottomSheet = false
    @State private var showBottomSheetSteps = false
    @StateObject private var imageLoader = DiskCachedImageLoader()
    @State var titleText: String = ""
    @State var quantity = ""
    @State private var selectedOption = 2
    @StateObject var viewModel = RecipeViewModel()
    let numberFormatter = DoubleNumberFormatter()
    @State var currentStep : Step?
    
    var body: some View {
        
        ZStack {
            ScrollView {
                VStack {
                    Text("Title").font(.title).padding(.horizontal).padding(.top)
                    TextField("Your awesome recipe", text: $titleText).padding(.horizontal).multilineTextAlignment(.center)
                    Picker(selection: $selectedOption, label: Text("Select an option")) {
                        ForEach(Array(RecipeKind.allCases.enumerated()), id: \.1) { index, item in
                            Text(RecipeKind.allCases[index].title).tag(index)
                        }
                    }.padding(.horizontal).padding(.top).pickerStyle(.menu)
                    DashedDivider().stroke(style: StrokeStyle(lineWidth: 6, dash: [8])).foregroundColor(Color.blue).frame(height: 10)
                }
                VStack {
                    Text("Add your ingredients").font(.title2).padding(.top, 8)
                    if (!viewModel.currentIngredients.isEmpty) {
                        let withIndex = viewModel.currentIngredients.enumerated().map({ $0 })
                        LazyVStack {
                            ForEach(withIndex, id: \.offset) { ingredientIndex, ingredient in
                                HStack {
                                    IngredientImageView(ingredient: ingredient).padding(.leading)
                                    
                                    Text(ingredient.ingredientFirebase.name)
                                    
                                    Spacer()
                                    TextField("1000", value: $viewModel.currentQuantities[ingredientIndex].value, formatter: numberFormatter)
                                        .keyboardType(.decimalPad)
                                        .frame(width: 45)
                                        .multilineTextAlignment(.trailing)
                                    
                                    let quantityKinds = QuantityKind.allCases.enumerated().map({ $0 })
                                    Menu {
                                        ForEach(quantityKinds, id: \.offset) { index, kind in
                                            Button(action: { viewModel.currentQuantities[ingredientIndex].kind = kind }) {
                                                Text(kind.title)
                                            }
                                        }
                                    } label: {
                                        Text(viewModel.currentQuantities[ingredientIndex].kind.rawValue)
                                        Image(systemName: "chevron.up.chevron.down")
                                    }
                                    .padding(.trailing)
                                    Button(action: {
                                        viewModel.removeIngredient(ingredient: ingredient)
                                    }) {
                                        Image(systemName: "trash").padding(.trailing)
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    HStack {
                        Spacer()
                        FloatingActionButtonView(
                            label: {
                                Text("+").font(.largeTitle).colorInvert()
                            },
                            width: 36.0,
                            height: 36.0
                        ) {
                            showBottomSheet.toggle()
                        }
                    }.padding(.horizontal).padding(.bottom, 8)
                    
                    DashedDivider().stroke(style: StrokeStyle(lineWidth: 6, dash: [8])).foregroundColor(Color.blue).frame(height: 10)
                }
                VStack {
                    Text("Add recipes steps").font(.title2).padding(.top, 8)
                    
                    if (!viewModel.currentSteps.isEmpty) {
                        let withIndex = viewModel.currentSteps.enumerated().map({ $0 })
                        LazyVStack {
                            ForEach(withIndex, id: \.offset) { stepIndex, step in
                                VStack {
                                    HStack {
                                        Text("Step \(step.number).").font(.title2).padding(.leading)
                                        ScrollView(.horizontal) {
                                            LazyHStack {
                                                ForEach(viewModel.getIngredients(step: step), id: \.self) { ingredient in
                                                    IngredientImageView(ingredient: ingredient, width: 30, height:30)
                                                }
                                            }
                                        }
                                        Button(action: {
                                            currentStep = step
                                            showBottomSheetSteps.toggle()
                                        }) {
                                            Image(systemName: "pencil").padding(.trailing)
                                        }
                                    }.frame(alignment: Alignment.leading)
                                    HStack {
                                        Text(step.description).font(.subheadline).padding(.leading).frame(alignment: Alignment.leading)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    
                    HStack {
                        Spacer()
                        FloatingActionButtonView(
                            label: {
                                Text("+").font(.largeTitle).colorInvert()
                            },
                            width: 36.0,
                            height: 36.0
                        ) {
                            showBottomSheetSteps.toggle()
                        }
                    }.padding(.horizontal).padding(.bottom, 8)
                    
                    DashedDivider().stroke(style: StrokeStyle(lineWidth: 6, dash: [8])).foregroundColor(Color.blue).frame(height: 10)
                }
                Spacer().frame(minHeight: 100)
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingActionButtonView(
                        label: {
                            Image(systemName: "checkmark").colorInvert()
                        }
                    ) {
                        
                    }.padding()
                }
            }
            
        }.sheet(isPresented: $showBottomSheet, content: {
            SearchIngredientView(initialIngredients : viewModel.currentIngredients) {  selectedIngredients in
                viewModel.addIngredientsToList(ingredientsToAdd: selectedIngredients)
            }
        }).sheet(isPresented: $showBottomSheetSteps, content: {
            StepView(initialIngredients: viewModel.currentIngredients, currentStep : currentStep) {ingredients, description in
                viewModel.handleStep(ingredients: ingredients, description: description, currentStep : currentStep)
                currentStep = nil
            }
        })
    }
}

struct DashedDivider: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
    }
}


//
//  RecipeView.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 19/03/2023.
//

import SwiftUI

struct RecipeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showBottomSheet = false
    @State private var showBottomSheetSteps = false
    @StateObject private var imageLoader = DiskCachedImageLoader()
    @State var titleText: String = ""
    @State private var recipeKind = RecipeKind.mainCourse
    @StateObject var viewModel = RecipeViewModel(recipesRepository: RecipesRepository())
    let numberFormatter = DoubleNumberFormatter()
    @State var isTitleFilled: Bool = true
    @State var isIngredientsFilled: Bool = true
    @State var isStepsFilled: Bool = true
    @State var initialRecipe: Recipe?
    var onDismiss: ((Recipe?) -> Void)?
    var onDisappear: (() -> Void)?
    
    var body: some View {
        
        ZStack {
            ScrollView {
                VStack {
                    TextField("Your awesome recipe", text: $titleText)
                        .padding(.horizontal).padding(.top).multilineTextAlignment(.center)
                        .onAppear() {
                            if let initialRecipe = initialRecipe {
                                titleText = initialRecipe.title
                                recipeKind = initialRecipe.kind
                            }
                            viewModel.initWith(recipe: initialRecipe)
                        }
                    if !isTitleFilled && titleText.isEmpty {
                        Text("Please enter recipe title.")
                            .foregroundColor(.red)
                            .padding(.bottom, 10)
                    }
                    
                    let recipesKinds = RecipeKind.allCases
                    Picker(selection: $recipeKind, label: Text("Select an option")) {
                        ForEach(recipesKinds, id: \.self) { kind in
                            Text(kind.title).tag(kind)
                        }
                    }.padding(.horizontal).padding(.top).pickerStyle(.menu)
                    DashedDivider().stroke(style: StrokeStyle(lineWidth: 6, dash: [8])).foregroundColor(Color.blue).frame(height: 10)
                }
                VStack {
                    Text("Add your ingredients").font(.title2).padding(.top, 8)
                    if !isIngredientsFilled {
                        Text("Please add some ingredients.")
                            .foregroundColor(.red)
                            .padding(.bottom, 10)
                    }
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
                                    
                                    let quantityKinds = QuantityKind.allCases
                                    Menu {
                                        ForEach(quantityKinds, id: \.self) { kind in
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
                                Text("+").font(.largeTitle)
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
                    if !isStepsFilled {
                        Text("Please add some steps.")
                            .foregroundColor(.red)
                            .padding(.bottom, 10)
                    }
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
                                            viewModel.currentStep = step
                                            showBottomSheetSteps.toggle()
                                        }) {
                                            Image(systemName: "pencil").padding(.trailing)
                                        }
                                        Button(action: {
                                            viewModel.removeStep(step: step)
                                        }) {
                                            Image(systemName: "trash").padding(.trailing)
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
                                Text("+").font(.largeTitle)
                            },
                            width: 36.0,
                            height: 36.0
                        ) {
                            if (viewModel.currentIngredients.isEmpty) {
                                isIngredientsFilled = false
                                return
                            } else {
                                isIngredientsFilled = true
                            }
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
                            Image(systemName: "square.and.arrow.down")
                        }
                    ) {
                        if (titleText.isEmpty) {
                            isTitleFilled = false
                            return
                        } else {
                            isTitleFilled = true
                        }
                        
                        if (viewModel.currentIngredients.isEmpty) {
                            isIngredientsFilled = false
                            return
                        } else {
                            isIngredientsFilled = true
                        }
                        
                        if (viewModel.currentSteps.isEmpty) {
                            isStepsFilled = false
                            return
                        } else {
                            isStepsFilled = true
                        }
                        
                        viewModel.uploadRecipe(title: titleText, recipeKind: recipeKind, initialRecipe: initialRecipe)
                    }.padding()
                }
            }
            
        }.sheet(isPresented: $showBottomSheet, content: {
            SearchIngredientView(initialIngredients : viewModel.currentIngredients) {  selectedIngredients in
                if (!selectedIngredients.isEmpty) {
                    isIngredientsFilled = true
                }
                viewModel.addIngredientsToList(ingredientsToAdd: selectedIngredients)
            }
        }).sheet(isPresented: $showBottomSheetSteps, content: {
            StepView(initialIngredients: viewModel.currentIngredients, currentStep : viewModel.currentStep) {ingredients, description in
                
                isStepsFilled = true
                viewModel.handleStep(ingredients: ingredients, description: description, currentStep : viewModel.currentStep)
                viewModel.currentStep = nil
            }
        })
        .onChange(of: viewModel.state) { state in
            switch viewModel.state {
            case .idle :
                print("idle")
            case .error :
                print("error")
            case .loading :
                print("loading")
            case .uploaded :
                presentationMode.wrappedValue.dismiss()
                self.onDismiss?(nil)
            }
        }
        .onDisappear {
            if (initialRecipe?.id == nil) {
                viewModel.saveCache(title: titleText, recipeKind: recipeKind, initialRecipe: initialRecipe)
                self.onDismiss?(viewModel.currentRecipe)
            }
            self.onDisappear?()
        }
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


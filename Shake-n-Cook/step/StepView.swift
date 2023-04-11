//
//  SwiftUIView.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 26/03/2023.
//

import SwiftUI

struct StepView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var description: String = "Detail of the step ..."
    let placeHolderString = "Detail of the step ..."
    @StateObject var viewModel : StepViewModel = StepViewModel()
    var initialIngredients: [Ingredient]
    var currentStep: Step? = nil
    var onDismiss: (([Ingredient], String) -> Void)?
    @State var isStepFilled: Bool = true
    
    var body: some View {
        VStack {
            Text("Step Maker")
                .onAppear() {
                    if let stepDescription = currentStep?.description {
                        description = stepDescription
                    }
                    viewModel.initWith(ingredients: initialIngredients, currentStep:currentStep)
                }.padding()
            DashedDivider().stroke(style: StrokeStyle(lineWidth: 6, dash: [8])).foregroundColor(Color.blue).frame(height: 10)
            Text("Select the ingredients of the step")
            ScrollView(.horizontal) {
                LazyHStack {
                    let withIndex = viewModel.currentIngredients.enumerated().map({ $0 })
                    ForEach(withIndex, id: \.offset) { ingredientIndex, ingredient in
                        Button(action: {
                            viewModel.currentIngredients[ingredientIndex].isSelected = !viewModel.currentIngredients[ingredientIndex].isSelected
                        }) {
                            ZStack(alignment: .topTrailing) {
                                IngredientImageView(ingredient: ingredient, width: 50, height: 50)
                                if ingredient.isSelected {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.white)
                                        .background(Color.green)
                                        .clipShape(Circle())
                                        .frame(width: 20, height: 20)
                                        .padding(-5)
                                }
                            }
                        }
                    }
                }.frame(height: 60).padding(.horizontal)
            }
            
            DashedDivider().stroke(style: StrokeStyle(lineWidth: 6, dash: [8])).foregroundColor(Color.blue).frame(height: 10)
            
            if !isStepFilled && description.isEmpty {
                Text("Please explain the step")
                    .foregroundColor(.red)
                    .padding(.bottom, 10)
            }
            TextEditor(text: $description)
                .frame(minHeight: 100)
                .multilineTextAlignment(.leading)
                .padding()
                .foregroundColor(description == placeHolderString ? .gray : .primary)
                .onTapGesture {
                    if description == placeHolderString {
                        description = ""
                    }
                }
            
            HStack {
                Spacer()
                FloatingActionButtonView(
                    label: {
                        Image(systemName: "checkmark")
                    }
                ) {
                    if (description.isEmpty) {
                        isStepFilled = false
                        return
                    } else {
                        isStepFilled = true
                    }
                    presentationMode.wrappedValue.dismiss()
                }.padding()
            }
        }.onDisappear {
            if (!description.isEmpty && description != placeHolderString) {
                self.onDismiss?(viewModel.currentIngredients.filter { $0.isSelected }, description)
            }
        }
    }
    
    private var hintBackground: some View {
        VStack {
            Text("Type your hint here")
                .foregroundColor(.gray)
                .padding(.top, 8)
                .padding(.leading, 12)
            Spacer()
        }
        .allowsHitTesting(false)
    }
    
}

struct StepView_Previews: PreviewProvider {
    static var previews: some View {
        StepView(initialIngredients: ObjectCreator().currentIngredients) {_,_  in
            
        }
    }
}

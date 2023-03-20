//
//  RecipeView.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 19/03/2023.
//

import SwiftUI

struct RecipeView: View {
    @StateObject private var imageLoader = DiskCachedImageLoader()
    @State var titleText: String = ""
    @State var quantity = ""
    @State private var selectedOption = 2
    @State private var selectedKind = QuantityKind.tbp
    @StateObject var viewModel = RecipeViewModel()
    @State private var ingredients =
    [
        Ingredient(id: "id1", name: "tomate", pictureUrl: "https://firebasestorage.googleapis.com:443/v0/b/shake-n-cook.appspot.com/o/ingredients%2F1909.jpg?alt=media&token=988841ba-aa6b-4c84-9fcc-b33ea2e03296"),
        Ingredient(id: "id2", name: "persil plat", pictureUrl: "https://firebasestorage.googleapis.com:443/v0/b/shake-n-cook.appspot.com/o/ingredients%2F1909.jpg?alt=media&token=988841ba-aa6b-4c84-9fcc-b33ea2e03296"),
        Ingredient(id: "id3", name: "garlic powder mofo", pictureUrl: "https://firebasestorage.googleapis.com:443/v0/b/shake-n-cook.appspot.com/o/ingredients%2F1909.jpg?alt=media&token=988841ba-aa6b-4c84-9fcc-b33ea2e03296"),
        Ingredient(id: "id4", name: "4", pictureUrl: "https://firebasestorage.googleapis.com:443/v0/b/shake-n-cook.appspot.com/o/ingredients%2F1909.jpg?alt=media&token=988841ba-aa6b-4c84-9fcc-b33ea2e03296"),
        Ingredient(id: "id5", name: "5", pictureUrl: "https://firebasestorage.googleapis.com:443/v0/b/shake-n-cook.appspot.com/o/ingredients%2F1909.jpg?alt=media&token=988841ba-aa6b-4c84-9fcc-b33ea2e03296"),
        Ingredient(id: "id6", name: "6", pictureUrl: "https://firebasestorage.googleapis.com:443/v0/b/shake-n-cook.appspot.com/o/ingredients%2F1909.jpg?alt=media&token=988841ba-aa6b-4c84-9fcc-b33ea2e03296"),
        Ingredient(id: "id8", name: "8", pictureUrl: "https://firebasestorage.googleapis.com:443/v0/b/shake-n-cook.appspot.com/o/ingredients%2F1909.jpg?alt=media&token=988841ba-aa6b-4c84-9fcc-b33ea2e03296"),
        Ingredient(id: "id7", name: "7", pictureUrl: "https://firebasestorage.googleapis.com:443/v0/b/shake-n-cook.appspot.com/o/ingredients%2F1909.jpg?alt=media&token=988841ba-aa6b-4c84-9fcc-b33ea2e03296")
    ]
    
    var body: some View {
        
        VStack {
            ScrollView {
                VStack {
                    Text("Title").font(.title).padding(.horizontal).padding(.top)
                    TextField("Your awesome recipe", text: $titleText).padding(.horizontal).multilineTextAlignment(.center)
                    Picker(selection: $selectedOption, label: Text("Select an option")) {
                        ForEach(Array(RecipeKind.allCases.enumerated()), id: \.1) { index, item in
                            Text(RecipeKind.allCases[index].title).tag(index)
                        }
                    }.padding(.horizontal).padding(.top).pickerStyle(.menu)
                    DashedDivider().stroke(style: StrokeStyle(lineWidth: 6, dash: [8])).foregroundColor(Color.blue).frame(height: 10).padding(.top)
                    
                    Text("Add your ingredients").font(.title2).padding(.top, 8)
                    if (!ingredients.isEmpty) {
                        let withIndex = ingredients.enumerated().map({ $0 })
                        LazyVStack {
                            ForEach(withIndex, id: \.offset) { index, ingredient in
                                HStack {
                                    IngredientImageView(ingredient: ingredient)
                                    
                                        Text(ingredient.name)
                                        
                                        Spacer()
                                            TextField("1000", text: $quantity)
                                                .keyboardType(.numberPad).frame(width: 40)
                                            
                                            let values: [QuantityKind] = QuantityKind.allCases
                                            Menu {
                                                ForEach(values, id: \.self) { kind in
                                                    Button(action: { self.selectedKind = kind }) {
                                                        Text(kind.title)
                                                    }
                                                }
                                            } label: {
                                                Text(self.selectedKind.rawValue)
                                                Image(systemName: "chevron.up.chevron.down")
                                            }.padding(.trailing)
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
                        width: 48.0,
                        height: 48.0
                    ) {
                    }
                }.padding(.horizontal).padding(.bottom, 8)
                
                DashedDivider().stroke(style: StrokeStyle(lineWidth: 6, dash: [8])).foregroundColor(Color.blue).frame(height: 10)
                Spacer()
                
            }
            
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


//
//  IngredientBottomSheetView.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 18/03/2023.
//

import SwiftUI

struct SearchIngredientView: View {
    @StateObject private var imageLoader = DiskCachedImageLoader()
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = IngredientViewModel(ingredientRepository: IngredientRepository())
    var initialIngredients: [Ingredient]
    var onDismiss: (([Ingredient]) -> Void)?
    @State var userStartTyping :Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                TextField("Search 3 characters min", text: $viewModel.searchText)
                    .padding(.horizontal, 18)
                    .padding(.top)
                    .onChange(of: viewModel.searchText) { newValue in
                        if (userStartTyping == false ) {
                            userStartTyping = true
                            viewModel.initDebounce()
                        }
                    }.onAppear() {
                        viewModel.initWith(ingredients: initialIngredients)
                    }
                
                Spacer()
                switch viewModel.state {
                case .idle :
                    Text("What do you have in your fridge?")
                case .error :
                    Text("Oups we can't find that... try to find somethinf else ?")
                case .loading :
                    ProgressView()
                case .ingredients(let ingredients):
                    List(ingredients, id: \.ingredientFirebase.label) { ingredient in
                        Button(action: {
                            viewModel.handleIngredient(ingredient: ingredient)
                            self.viewModel.saveIngredientOnFirebase(ingredient : ingredient)
                        }) {
                            IngredientItemView(ingredient: ingredient)
                        }
                    }.listStyle(PlainListStyle())
                }
                Spacer()
                HStack {
                    Spacer()
                    FloatingActionButtonView(
                        label: {
                            Image(systemName: "checkmark").colorInvert()
                        }
                    ) {
                        presentationMode.wrappedValue.dismiss()
                    }.padding()
                }
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDisappear {
            self.onDismiss?(viewModel.selectedIngredients.filter { $0.isSelected })
        }
        
    }
}

struct IngredientBottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SearchIngredientView(initialIngredients : [Ingredient]())
    }
}

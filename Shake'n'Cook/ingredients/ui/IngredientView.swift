//
//  IngredientBottomSheetView.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 18/03/2023.
//

import SwiftUI

struct IngredientView: View {
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
                    HStack{
                        Text("What do you have in your fridge?")
                    }
                case .loading :
                    ProgressView()
                case .ingredients(let ingredients):
                    List(ingredients, id: \.name) { ingredient in
                        Button(action: {
                            viewModel.handleIngredient(ingredient: ingredient)
                            self.viewModel.saveIngredientOnFirebase(ingredient : ingredient)
                        }) {
                            HStack{
                                if let pictureUrl = URL(string: ingredient.pictureUrl ?? "") {
                                    AsyncImage(url: pictureUrl) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        case .failure:
                                            Image(systemName: "xmark")
                                                .frame(width: 48, height: 48)
                                        @unknown default:
                                            ProgressView()
                                        }
                                    }
                                    .frame(width: 48, height: 48)
                                    .onAppear {
                                        _ = imageLoader.loadImage(from: pictureUrl)
                                    }
                                } else {
                                    Image(systemName: "questionmark")
                                        .frame(width: 48, height: 48)
                                }
                                
                                Image(ingredient.name).foregroundColor(Color.black)
                                Text(ingredient.name).foregroundColor(Color.black)
                                Spacer()
                                if ingredient.isSelected {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }.listStyle(PlainListStyle())
                }
                Spacer()
                HStack {
                    Spacer()
                    floattingButton{
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDisappear {
            self.onDismiss?(viewModel.selectedIngredients.filter { $0.isSelected })
        }
        
    }
}

private func floattingButton(action: @escaping () -> Void) -> some View {
    return Button(action: {
        action()
    }, label: {
        Image(systemName: "checkmark").colorInvert()
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
    })
    .background(Color.blue)
    .cornerRadius(200)
    .padding()
    .shadow(color: Color.black.opacity(0.3),radius: 3,   x: 3, y: 3)
}


struct IngredientBottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientView(initialIngredients : [Ingredient]())
    }
}

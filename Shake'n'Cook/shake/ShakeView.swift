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
                    case .shaked(let count):
                        Text("Shake cunt : \(count)").font(.headline)
                    case .addFilter(let ingredients) :
                        List(ingredients, id: \.name) { ingredient in
                            Text(" \(ingredient.name)").font(.largeTitle)
                        }
                        .listStyle(PlainListStyle())
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
                            Image(uiImage: SVGKImage(named:"fridge").resize(width: 35, height:50)
                            )
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
    }
}

struct ShakeView_Previews: PreviewProvider {
    static var previews: some View {
        ShakeView(viewModel: ShakeViewModel())
    }
}

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
    @State private var selectedOption = 2
    @StateObject var viewModel = RecipeViewModel()
    @State private var ingredients = [
        Ingredient(id: "id", name: "1", pictureUrl: "https://firebasestorage.googleapis.com:443/v0/b/shake-n-cook.appspot.com/o/ingredients%2F1909.jpg?alt=media&token=988841ba-aa6b-4c84-9fcc-b33ea2e03296"),
        Ingredient(id: "id", name: "1", pictureUrl: "https://firebasestorage.googleapis.com:443/v0/b/shake-n-cook.appspot.com/o/ingredients%2F1909.jpg?alt=media&token=988841ba-aa6b-4c84-9fcc-b33ea2e03296"),
        Ingredient(id: "id", name: "1", pictureUrl: "https://firebasestorage.googleapis.com:443/v0/b/shake-n-cook.appspot.com/o/ingredients%2F1909.jpg?alt=media&token=988841ba-aa6b-4c84-9fcc-b33ea2e03296"),
        Ingredient(id: "id", name: "3", pictureUrl: "https://firebasestorage.googleapis.com:443/v0/b/shake-n-cook.appspot.com/o/ingredients%2F1909.jpg?alt=media&token=988841ba-aa6b-4c84-9fcc-b33ea2e03296")
    ]
    var body: some View {
        VStack {
            Text("Title").font(.title).padding(.horizontal).padding(.top)
            TextField("Your awesome recipe", text: $titleText).padding(.horizontal).multilineTextAlignment(.center)
            Picker(selection: $selectedOption, label: Text("Select an option")) {
                ForEach(Array(RecipeKind.allCases.enumerated()), id: \.1) { index, item in
                    Text(RecipeKind.allCases[index].title).tag(index)
                }
            }.padding(.horizontal).padding(.top).pickerStyle(.menu)
            DashedDivider().stroke(style: StrokeStyle(lineWidth: 6, dash: [8])).foregroundColor(Color.blue).frame(height: 10).padding(.top)
            
            HStack {
                ScrollView(.horizontal) {
                    HStack(alignment: .center) {
                        Spacer()
                        ForEach(ingredients, id: \.self) { ingredient in
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
                        }
                        
                        Spacer()
                    }.background(Color.red).frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                }
            }
            
            Button(action: {
            }) {
                
            }.padding(.horizontal)
            
            DashedDivider().stroke(style: StrokeStyle(lineWidth: 6, dash: [8])).foregroundColor(Color.blue).frame(height: 10).padding(.top)
            Text("No recipe found").font(.largeTitle)
            Spacer()
            HStack {
                Spacer()
                floattingButton {
                    
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
    
    private func floattingButton(action: @escaping () -> Void) -> some View {
        return Button(action: {
            action()
        }, label: {
            Text("+").font(.largeTitle).colorInvert()
        })
        .frame(width: 75, height: 75)
        .background(Color.blue)
        .cornerRadius(200)
        .padding()
        .shadow(color: Color.black.opacity(0.3),radius: 3,   x: 3, y: 3)
    }
    
    
    struct RecipeView_Previews: PreviewProvider {
        static var previews: some View {
            RecipeView()
        }
    }
}


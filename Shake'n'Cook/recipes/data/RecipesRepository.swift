//
//  RecipeRepository.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 29/03/2023.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

class RecipesRepository {
    private let ingredientRepository = IngredientRepository()
    private struct Constants {
        static let recipes = "recipes"
        static let userId = "userId"
    }
    
    private let firestoreRecipeCollection = Firestore.firestore().collection(Constants.recipes)
    
    func uploadRecipe(recipe : RecipeFirebase, completion : @escaping (Bool) -> Void) {
        guard let recipeId = recipe.id else {
            
            let collectionRef = self.firestoreRecipeCollection
            
            do {
                try collectionRef.addDocument(from : recipe) { error in
                    if let error = error {
                        completion(false)
                        print("Error adding or replace recipe: \(error.localizedDescription)")
                    } else {
                        completion(true)
                        print("New recipe added to Firestore")
                    }
                }
            } catch {
                completion(false)
                print("Error adding or replace recipe: catch")
            }
            
            return
        }
        
        let collectionRef = self.firestoreRecipeCollection.document(recipeId)
        
        do {
            try collectionRef.setData(from : recipe) { error in
                if let error = error {
                    completion(false)
                    print("Error adding or replace recipe: \(error.localizedDescription)")
                } else {
                    completion(true)
                    print("replace recipe to Firestore")
                }
            }
        } catch {
            completion(false)
            print("Error adding or replace recipe: catch")
        }
        
    }
    
    func fetchAllRecipes(userId:String, ingredientIds: [String]? = nil, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        var firebaseQuery = firestoreRecipeCollection
            .whereField(Constants.userId, isEqualTo: userId)
            .limit(to: 10)
        if let ingredientIds = ingredientIds {
            for ingredientId in ingredientIds {
                firebaseQuery = firebaseQuery.whereField("ingredientIds", arrayContains: ingredientId)
            }
        }
        
        firebaseQuery.getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            let dispatchGroup = DispatchGroup()
            var recipes: [Recipe] = []
            
            for document in querySnapshot!.documents {
                dispatchGroup.enter()
                do {
                    let firebaseRecipe = try document.data(as: RecipeFirebase.self)
                    self.ingredientRepository.fetchIngredients(withIds: firebaseRecipe.ingredientIds) { result in
                        switch result {
                        case .success(let ingredients):
                            let recipe = firebaseRecipe.toRecipe(ingredients: ingredients)
                            recipes.append(recipe)
                            dispatchGroup.leave()
                        case .failure(let error):
                            completion(.failure(error))
                            dispatchGroup.leave()
                        }
                    }
                } catch {
                    completion(.failure(error))
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(.success(recipes))
            }
        })
    }
    
    func removeRecipe(recipe:Recipe, completion : @escaping () -> Void) {
        guard let recipeId = recipe.id else {
            print("recipe with no id")
            return
        }
        let documentRef = firestoreRecipeCollection.document(recipeId)
        documentRef.delete { error in
            if let error = error {
                print("Error removing recipe: \(error.localizedDescription)")
            } else {
                completion()
                print("Recipe successfully removed!")
            }
        }
    }
    
}

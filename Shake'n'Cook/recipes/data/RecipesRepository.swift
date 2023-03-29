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
    private struct Constants {
        static let recipes = "recipes"
        static let userId = "userId"
    }
    
    private let firestoreRecipeCollection = Firestore.firestore().collection(Constants.recipes)
    
    func uploadRecipe(recipe : Recipe, completion : @escaping (Bool) -> Void) {
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
    
    func getRecipes(userId:String, completion: @escaping ([Recipe]?) -> Void) {
        // Define the query
        let firebaseQuery = firestoreRecipeCollection
            .whereField(Constants.userId, isEqualTo: userId)
            .limit(to: 10)
        
        firebaseQuery.getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error)
                completion(nil)
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                completion(nil)
                return
            }
            
            if (!querySnapshot.documents.isEmpty) {
                let recipes = querySnapshot.documents.compactMap() { document in
                    do {
                        return try document.data(as: Recipe.self)
                    } catch {
                        completion(nil)
                        return nil
                    }
                }
                completion(recipes)
            } else {
                completion(nil)
            }
        }
    }
}

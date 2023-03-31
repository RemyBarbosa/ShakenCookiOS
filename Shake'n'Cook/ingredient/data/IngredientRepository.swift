//
//  IngredientRepository.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 18/03/2023.
//

import Foundation
import Alamofire
import FirebaseStorage
import FirebaseFirestore
import SwiftUI

class IngredientRepository {
    private struct Constants {
        static let endpoint = "https://api.edamam.com/api/food-database/v2/parser?app_id=d8c1980d&app_key=8e1c77a50f5a30e4e16377c7c039323d"
        static let name = "name"
        static let nameFr = "name_fr"
        static let ingredients = "ingredients"
        static let nutrient = "nutrient"
    }
    
    private let firestoreIngredientCollection = Firestore.firestore().collection(Constants.ingredients)
    
    init() {
    }
    
    fileprivate func getIngredientByAPI(_ query: String, _ completion: @escaping (Result<[IngredientAPI], Error>) -> Void, _ firebaseIngredients : [IngredientAPI] = [IngredientAPI]()) {
        let parameters = [
            "ingr": query,
            "app_id": "d8c1980d",
            "app_key": "8e1c77a50f5a30e4e16377c7c039323d"
        ]
        AF.request(Constants.endpoint, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default).responseDecodable(of: FoodResponse.self) { response in
            switch response.result {
            case .success(let result):
                var ingredients = [IngredientAPI]()
                let parsed = result.parsed?.compactMap{$0.food} ?? [IngredientAPI]()
                let hints = result.hints?.compactMap{$0.food} ?? [IngredientAPI]()
                let ingredientsAPI = (parsed + hints)
                ingredients.append(contentsOf: ingredients)
                ingredientsAPI.forEach() { ingredient in
                    if (!ingredients.contains() { $0.foodId == ingredient.foodId || $0.knownAs == ingredient.knownAs || $0.label == ingredient.label }) {
                        ingredients.append(ingredient)
                    }
                }
                let uniqueIngredients = ingredients
                
                if (!uniqueIngredients.isEmpty) {
                    completion(.success(uniqueIngredients))
                } else {
                    completion(.failure(ShakeError.nullableError(message: "impossible to retrieve ingredients")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getIngredients(query:String, completion: @escaping (Result<[IngredientAPI], Error>) -> Void) {
        // Define the query
        let firebaseQuery = firestoreIngredientCollection
            .whereField(Constants.name, isGreaterThanOrEqualTo: query)
            .whereField(Constants.name, isLessThanOrEqualTo: query + "\u{f8ff}")
            .order(by: Constants.name)
            .limit(to: 10)
        
        firebaseQuery.getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error)
                self.getIngredientByAPI(query, completion)
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                self.getIngredientByAPI(query, completion)
                return
            }
            
            if (!querySnapshot.documents.isEmpty) {
                let ingredients = querySnapshot.documents.compactMap() { document in
                    do {
                        return try document.data(as: IngredientFirebase.self).toIngredientAPI()
                    } catch {
                        self.getIngredientByAPI(query, completion)
                        print("Error decoding ingredient: \(error.localizedDescription)")
                        return nil
                    }
                }
                self.getIngredientByAPI(query, completion, ingredients)
            } else {
                self.getIngredientByAPI(query, completion)
            }
        }
    }
    
    func saveIngredientOnFirebase(ingredient: Ingredient) {
        var ingredient = ingredient.ingredientFirebase
        guard let ingredientId = ingredient.id else { return }
        guard let url = URL(string: ingredient.pictureUrl ?? "") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Error creating image from data")
                return
            }
            
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                print("Error creating JPEG data from image")
                return
            }
            
            let storageRef = Storage.storage().reference()
            let imageRef = storageRef.child("\(Constants.ingredients)/\(ingredientId).jpg")
            
            let uploadTask = imageRef.putData(imageData, metadata: nil) { metadata, error in
                if (error != nil) {
                    print("error")
                }
                if (metadata != nil) {
                    print("success")
                }
            }
            
            uploadTask.observe(.success) { snapshot in
                // Get the download URL for the uploaded image
                imageRef.downloadURL { url, error in
                    guard let downloadURL = url else { return }
                    // Add the download URL to a new Firestore document
                    ingredient.pictureUrl = downloadURL.absoluteString
                    do {
                        let collectionRef = self.firestoreIngredientCollection.document(ingredientId)
                        
                        try collectionRef.setData(from : ingredient) { error in
                            if let error = error {
                                print("Error adding new ingredient: \(error.localizedDescription)")
                            } else {
                                print("New ingredient added to Firestore")
                            }
                        }
                    }
                    catch {
                        print("Error when trying to encode book: \(error)")
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func fetchIngredients(withIds ingredientIds: [String], completion: @escaping (Result<[IngredientFirebase], Error>) -> Void) {
        var ingredientsDict: [String: IngredientFirebase] = [:] // create an empty dictionary to store the ingredients
        let dispatchGroup = DispatchGroup()

        for ingredientId in ingredientIds {
            dispatchGroup.enter()
            firestoreIngredientCollection.document(ingredientId).getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let document = document, document.exists {
                    do {
                        let ingredient = try document.data(as: IngredientFirebase.self)
                        ingredientsDict[ingredientId] = ingredient // add the ingredient to the dictionary using its ID as the key
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "apps.horizon.ShakenCook", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            // create an array of ingredients in the same order as the input ingredientIds
            let ingredients = ingredientIds.compactMap { ingredientsDict[$0] }
            completion(.success(ingredients))
        }
    }
}

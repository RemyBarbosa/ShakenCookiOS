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
    struct Constants {
        static let endpoint = "https://trackapi.nutritionix.com/v2/search/instant"
        static let headers: HTTPHeaders = [
            "x-app-id": "2cf21d04",
            "x-app-key": "72a98ea691c2301c2443931a16529a5e"
        ]
        static let name = "name"
        static let nameFr = "name_fr"
        static let pictureUrl = "picture_url"
        static let ingredients = "ingredients"
    }
    
    let firestoreIngredientCollection = Firestore.firestore().collection(Constants.ingredients)
    
    init() {
    }
    
    fileprivate func getIngredientByWrongAPI(_ query: String, _ completion: @escaping (Result<[IngredientAPI], Error>) -> Void) {
        let parameters: Parameters = [
            "query": query,
        ]
        AF.request(Constants.endpoint, parameters: parameters, headers: Constants.headers).responseDecodable(of: IngredientResponse.self) { response in
            switch response.result {
            case .success(let answer):
                if let ingredients = answer.common {
                    completion(.success(ingredients))
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
            .whereField(Constants.name, isGreaterThanOrEqualTo: query.lowercased())
            .whereField(Constants.name, isLessThan: query.lowercased() + "\u{f8ff}")
            .order(by: Constants.name)
            .limit(to: 10)
        
        firebaseQuery.getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error)
                self.getIngredientByWrongAPI(query, completion)
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                self.getIngredientByWrongAPI(query, completion)
                return
            }
            
            if (!querySnapshot.documents.isEmpty) {
                let ingredients = querySnapshot.documents.compactMap{ document in
                    let data = document.data()
                    
                    return IngredientAPI(
                        food_name: data[Constants.name] as? String ?? "",
                        tag_id: document.documentID,
                        photo: IngredientPhoto(thumb: data[Constants.pictureUrl] as? String)
                    )
                }
                completion(.success(ingredients))
            } else {
                self.getIngredientByWrongAPI(query, completion)
            }
        }
    }
    
    func saveIngredientOnFirebase(ingredient: Ingredient) {
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
            let imageRef = storageRef.child("\(Constants.ingredients)/\(ingredient.id).jpg")
            
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
                    let docRef = self.firestoreIngredientCollection.document(ingredient.id)
                    let data = [
                        Constants.name: ingredient.name,
                        Constants.nameFr: ingredient.name,
                        Constants.pictureUrl: downloadURL.absoluteString
                    ]
                    docRef.setData(data)
                }
            }
        }
        
        task.resume()
    }
}

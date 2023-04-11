//
//  UserRepository.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 11/04/2023.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

class UserRepository {
    private struct Constants {
        static let users = "users"
        static let dailyNutrients = "daily_nutrients"
        static let userId = "userId"
    }
    
    private let firestoreUsersCollection = Firestore.firestore().collection(Constants.users)
    
    func uploadDailyNutrients(recipe : Recipe, userId : String, completion: @escaping (Result<DailyNutrientFirebase, Error>) -> Void) {
        let nutrient = NutrientFirebase(
            kcal: recipe.getTotalKcalValue(),
            prot: recipe.getTotalProtValue(),
            fat: recipe.getTotalFatValue(),
            carb: recipe.getTotalCarbsValue(),
            fiber: recipe.getTotalFibersValue()
        )
        let dialyNutrient = DailyNutrientFirebase(
            nutrient : nutrient,
            userId : userId,
            createAt : Timestamp()
        )
        
        let collectionRef = self.firestoreUsersCollection.document(userId).collection(Constants.dailyNutrients)
        
        do {
            try collectionRef.addDocument(from : dialyNutrient) { error in
                if let error = error {
                    completion(.failure(ShakeError.genericError(message: error.localizedDescription)))
                } else {
                    completion(.success(dialyNutrient))
                }
            }
        } catch {
            completion(.failure(ShakeError.genericError(message: "fail parse nutrient")))
        }
        
    }
    
    func fetchDailyUserNutrients(userId : String, completion: @escaping (Result<[DailyNutrientFirebase], Error>) -> Void) {
        let collectionRef = self.firestoreUsersCollection.document(userId).collection(Constants.dailyNutrients)
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let query = collectionRef
               .whereField("createAt", isGreaterThanOrEqualTo: Timestamp(date: startOfDay))
               .whereField("createAt", isLessThanOrEqualTo: Timestamp(date: endOfDay))
           
        query.getDocuments { (querySnapshot, error) in
                
                if let error = error {
                    print(error)
                    completion(.failure(error))
                    return
                }
                
                guard let querySnapshot = querySnapshot else {
                    return
                }
                
                if (!querySnapshot.documents.isEmpty) {
                    let nutrients = querySnapshot.documents.compactMap() { document in
                        do {
                            return try document.data(as: DailyNutrientFirebase.self)
                        } catch {
                            print("Error decoding ingredient: \(error.localizedDescription)")
                            return nil
                        }
                    }
                    completion(.success(nutrients))
                } else {
                    completion(.failure(ShakeError.genericError(message: "empty doc")))
                }
            }
    }
    
}

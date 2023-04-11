//
//  Shake_n_CookApp.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 17/03/2023.
//

import SwiftUI
import Firebase

@main
struct Shake_n_CookApp: App {
    init() {
        FirebaseApp.configure()
        Auth.auth().signInAnonymously() { (authResult, error) in
            if let user = authResult?.user {
                UserDefaults.standard.set(user.uid, forKey: "firebaseUserId")
            }
        }
        
        // Later in the app, retrieve the currentUserID from UserDefaults
        //        if let currentUserID = UserDefaults.standard.string(forKey: "firebaseUserId") {
        //          print(currentUserID)
        //        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

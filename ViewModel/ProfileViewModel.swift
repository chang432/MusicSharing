//
//  ProfileViewModel.swift
//  Login_v1
//
//  Created by Jason Lo on 5/28/20.
//  Copyright © 2020 Jason Lo. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ProfileViewModel : ObservableObject {
    @Published var profiles = [Profile]()
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("Profiles").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.profiles = documents.map { (queryDocumentSnapshot) -> Profile in
                let data = queryDocumentSnapshot.data()
                
                let username = data["username"] as? String ?? ""
                let gender = data["gender"] as? String ?? ""
                let favsong1 = data["favsong1"] as? String ?? ""
                let favsong2 = data["favsong2"] as? String ?? ""
                let favsong3 = data["favsong3"] as? String ?? ""

                let profile = Profile(username: username, gender: gender, favsong1: favsong1, favsong2: favsong2, favsong3: favsong3)
                return profile
            }
        }
    }
    
}

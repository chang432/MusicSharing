//
//  Profile.swift
//  Login_v1
//
//  Created by Jason Lo on 5/27/20.
//  Copyright © 2020 Jason Lo. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Profile: Codable, Identifiable {
    //var id: String = UUID().uuidString
    @DocumentID var id: String?
    var username: String
    var gender: String
    var favsong1: String
    var favsong2: String
    var favsong3: String
    @ServerTimestamp var createdTime: Timestamp?
    var userId: String?

    
    static let `default` = Self(username: "defaultUser", gender: "gender", favsong1: "fav1", favsong2: "fav2", favsong3: "fav3")
    init(username: String, gender: String, favsong1: String, favsong2: String, favsong3: String) {
        self.username = username
        self.gender = gender
        self.favsong1 = favsong1
        self.favsong2 = favsong2
        self.favsong3 = favsong3
    }
    
    
    
}

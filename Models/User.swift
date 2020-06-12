//
//  User.swift
//  LoginScreen
//
//  Created by Andre Chang on 6/4/20.
//  Copyright © 2020 Andre Chang. All rights reserved.
//

import Foundation

class User: Identifiable, ObservableObject {
    let id = UUID()
    @Published var topSongs: [Song]
    
    enum CodingKeys: CodingKey {
        case id, topSongs
    }
    
    init() {
        topSongs = []
    }
    
    /*required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        topSongs = try container.decode([Song].self, forKey: .topSongs)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(topSongs, forKey: .topSongs)
    }*/
}

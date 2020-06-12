//
//  SongObj.swift
//  LoginScreen
//
//  Created by Andre Chang on 5/28/20.
//  Copyright © 2020 Andre Chang. All rights reserved.
//

import Foundation

struct Song: Codable, Identifiable {
    let id = UUID()
    var songTitle: String
    var songArtists: [String]
    var songURI: String
    var songPreviewURL: String
    var songImage: String           // 64x64
    
    init() {
        songURI = ""
        songTitle = ""
        songPreviewURL = ""
        songImage = ""
        songArtists = []
    }
    
    init(songURI: String, songTitle: String, songPreviewURL: String, songImage: String, songArtists: [String]) {
        self.songURI = songURI
        self.songTitle = songTitle
        self.songPreviewURL = songPreviewURL
        self.songImage = songImage
        self.songArtists = songArtists
    }
}

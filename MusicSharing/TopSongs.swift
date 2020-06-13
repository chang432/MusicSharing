//
//  SongList.swift
//  LoginScreen
//
//  Created by Andre Chang on 6/1/20.
//  Copyright © 2020 Andre Chang. All rights reserved.
//

import SwiftUI

struct TopSongs: View {
    @ObservedObject var spAuth = SpotifyAuthentication.shared
    @ObservedObject var user: User = User()
    @State private var actionState: Int? = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    self.getTopTracks()
                }) {
                    Text("Get Top 3 Songs")
                }
                
                List {
                    ForEach(self.user.topSongs) { song in
                        Button(action: {
                            print("button tapped")
                            self.asyncTask(s: song)
                        }) {
                            Text(song.songTitle)
                        }
                    }
                    
                    NavigationLink(destination: PlayingView(songURI: ""), tag: 1, selection: self.$actionState) {
                        EmptyView()
                    }
                }
            }
        }
        .navigationBarTitle(Text("Favorite Songs"))
    }
    
    func asyncTask(s: Song) {
        //some task which on completion will set the value of actionState
        spAuth.song = s
        self.spAuth.appRemote.playerAPI?.play(spAuth.song.songURI, callback: nil)
        self.actionState = 1
    }
    
    func getTopTracks() {
        //var usr = User()
        
        let url = URL(string: "https://api.spotify.com/v1/me/top/tracks?limit=3")!
        var request = URLRequest(url: url)
        let authorizationHeaderValue = "Bearer \(SpotifyAuthentication.shared.accessToken!)"
        
        request.setValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            //let json = try? JSONSerialization.jsonObject(with: data, options: [])
            let topTracksResponse = try? JSONDecoder().decode(TopTracksResponse.self, from: data)
            
            //print(topTracksResponse?.items?[0].album?.name)
            
            self.RawDataToClass(rawData: topTracksResponse!)
        }

        task.resume()
        //return usr
    }
    
    func RawDataToClass(rawData: TopTracksResponse) {
        for index in 0...2 {
            guard let dataSongURI = rawData.items?[index].uri else { return }
            guard let dataSongTitle = rawData.items?[index].name else { return }
            guard let dataSongPreview = rawData.items?[index].previewURL else { return }
            
            var dataSongArtists = [String]()
            if let dataArtists = rawData.items?[index].artists {
                for i in 0..<(dataArtists.count) {
                    if let dataName = dataArtists[i].name {
                        dataSongArtists.append(dataName)
                    }
                }
            }
            
            user.topSongs.append(Song(songURI: dataSongURI, songTitle: dataSongTitle, songPreviewURL: dataSongPreview, songImage: "temp", songArtists: dataSongArtists))
            print(dataSongURI + "\n" + dataSongTitle)
            print(dataSongPreview)
            print(dataSongArtists)
            print("\n")
        }
    }
}

struct TopSongs_Previews: PreviewProvider {
    static var previews: some View {
        TopSongs()
    }
}

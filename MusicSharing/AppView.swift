//
//  AppView.swift
//  LoginScreen
//
//  Created by Andre Chang on 6/1/20.
//  Copyright © 2020 Andre Chang. All rights reserved.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        TabView {
            PlayingView(songURI: "spotify:track:349Wc5mDu52d4Uv8Eg9WZv")
                .tabItem() {
                    Image(systemName: "square.and.pencil")
                    Text("Now Playing")
                }
            
            /*TopSongs()
                .tabItem() {
                    Image(systemName: "list.dash")
                    Text("My Songs")
                }*/
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}

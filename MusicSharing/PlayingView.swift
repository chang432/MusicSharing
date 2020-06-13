//
//  MainView.swift
//  LoginScreen
//
//  Created by Andre Chang on 5/20/20.
//  Copyright © 2020 Andre Chang. All rights reserved.
//

import SwiftUI

struct PlayingView: View {
    @ObservedObject var spAuth = SpotifyAuthentication.shared
    @State var songURI: String
    
    var body: some View {
        VStack {
            HStack {
                
                Button(action: goHome) {
                    Text(" Back ")
                        .foregroundColor(Color.purple)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(Color.purple, style: StrokeStyle(lineWidth: 2))
                        )
                }
                
//                NavigationLink(destination: Home()) {
//                    Text("Back").frame(width:45, height: 15)
//                    .font(.system(size: 18))
//                    .padding()
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.purple
//                                , lineWidth: 2))
//                }
                
                TextField("songURI", text: $songURI)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    //spAuth.appRemote?.playerAPI?.play(trackIdentifier, callback: defaultCallback)
                    self.spAuth.appRemote.playerAPI?.play(self.songURI, callback: nil)
                }) {
                    Text(" Play ")
                        .foregroundColor(Color.purple)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(Color.purple, style: StrokeStyle(lineWidth: 2))
                        )
                }
            }
            .padding()
            
            //Divider()
            
            loadSongImage()
                .resizable()
                .frame(width: 300.0, height: 300.0)
                .padding()
                .border(Color.black, width: 2)
            
            Text(spAuth.song.songTitle)
                .font(.largeTitle)
                .padding()
                .multilineTextAlignment(.center)
                .foregroundColor(Color.purple)

            loadPlayPauseBtn()
                .resizable()
                .scaledToFit()

                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            self.playPauseBtnOnTap()
                        }
                )
        }
    }
    
    func loadSongImage() -> Image {
        var loadedImg = Image(systemName: "star")
        
        // convert string to UIImage
        if let data = Data(base64Encoded: spAuth.song.songImage, options: .ignoreUnknownCharacters){
            if let img = UIImage(data: data) {
                loadedImg = Image(uiImage: img)
            }
        }
        
        return loadedImg
    }
    
    
    func loadPlayPauseBtn() -> Image {
        /*var img: UIImage?
        if (self.playPauseState == false) {
            img = UIImage(named: "play")
        } else {
            img = UIImage(named: "pause")
        }*/

        return Image(uiImage: spAuth.playPauseBtn!)
    }
    
    func playPauseBtnOnTap() {
        if let _ = spAuth.lastPlayerState, spAuth.lastPlayerState!.isPaused {
            spAuth.appRemote.playerAPI?.resume(nil)
        } else {
            spAuth.appRemote.playerAPI?.pause(nil)
        }
    }
    
    func goHome() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: Home().environmentObject(UserData()))
            window.makeKeyAndVisible()
        }
    }
}

struct PlayingView_Previews: PreviewProvider {
    static var previews: some View {
        PlayingView(songURI: "")
    }
}

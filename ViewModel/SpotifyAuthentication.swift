//
//  SpotifyAuthentication.swift
//  LoginScreen
//
//  Created by Andre Chang on 5/23/20.
//  Copyright © 2020 Andre Chang. All rights reserved.
//

import Foundation

class SpotifyAuthentication: UIViewController, ObservableObject, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    static let shared = SpotifyAuthentication()
    
    var lastPlayerState: SPTAppRemotePlayerState?
    var accessToken: String!
    @Published var song: Song
    @Published var playPauseBtn: UIImage? = UIImage(named: "pause")
    
    private init() {
        print("initialized the class")
        self.song = Song()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let SpotifyClientID = "0848a8627d1741818db8678000bdb732"
    private let SpotifyRedirectURI = URL(string: "fuckthis://returnafterlogin/callback")!
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
        configuration.playURI = "spotify:track:4HBZA5flZLE435QTztThqH"

        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "https://hear-me-pls.herokuapp.com/api/token")
        configuration.tokenRefreshURL = URL(string: "https://hear-me-pls.herokuapp.com/api/refresh")
        return configuration
    }()
    
    // MARK: - Session Manager
    
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    
    func sessionManagerInitiateSession() {
        // The start of authentication
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate, .userTopRead]

        if #available(iOS 11, *) {
            // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
            sessionManager.initiateSession(with: scope, options: .clientOnly)
        }
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("session initiate failed")
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("session initiate renewed")
        //presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
    }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("Session Manager successfully initiated!\nAccess Token: \(session.accessToken)")
        
        self.accessToken = session.accessToken
        
        DispatchQueue.main.async {
            // have to put it on main thread to work
            self.appRemote.connectionParameters.accessToken = session.accessToken
            self.appRemote.connect()
        }
    }
    
    // MARK: - App Remote Stuff

    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("*********Appremote established a connection!************")
        
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state:" + error.localizedDescription)
            }
        })
        
        fetchPlayerState()
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("appremote disconnected with error")
        lastPlayerState = nil
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("appremote did fail connection attempt with error")
        lastPlayerState = nil
    }
    
    func fetchArtwork(for track:SPTAppRemoteTrack) {
        //print("********fetching artwork**********")
        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
            if let error = error {
                print("Error fetching track image: " + error.localizedDescription)
            } else if let image = image as? UIImage {
                //Stores UIImage as a string
                let data: Data? = image.pngData()
                self?.song.songImage = data?.base64EncodedString(options: .endLineWithLineFeed) as! String
            }
        })
    }
    
    func fetchPlayerState() {
        //print("********fetching playerstate**********")
        appRemote.playerAPI?.getPlayerState({ [weak self] (playerState, error) in
            if let error = error {
                print("Error getting player state:" + error.localizedDescription)
            } else if let playerState = playerState as? SPTAppRemotePlayerState {
                self?.update(playerState: playerState)
            }
        })
    }
    
    func update(playerState: SPTAppRemotePlayerState) {
        //print("********UPDATE**********")
        if lastPlayerState?.track.uri != playerState.track.uri {
            fetchArtwork(for: playerState.track)
        }
        lastPlayerState = playerState
        self.song.songTitle = playerState.track.name
        if playerState.isPaused {
            self.playPauseBtn = UIImage(named: "play")
        } else {
            self.playPauseBtn = UIImage(named: "pause")
        }
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        //print("********PLAYERSTATE CHANGED**********")
        update(playerState: playerState)
    }
    
}

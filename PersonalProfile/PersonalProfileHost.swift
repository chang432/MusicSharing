//
//  PersonalProfileHost.swift
//  Login_v1
//
//  Created by Jason Lo on 5/29/20.
//  Copyright © 2020 Jason Lo. All rights reserved.
//

import SwiftUI

struct PersonalProfileHost: View {
    @Environment(\.editMode) var mode
    @EnvironmentObject var userData: UserData
     
    @ObservedObject private var viewModel = ProfileViewModel()
    
    @State var draftProfile = Profile.default

    var body: some View {
        //self.viewModel.fetchData()
        //self.userData.profile = viewModel.profiles[1]?
        
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {
                
                if self.mode?.wrappedValue == .active {
                    Button("Cancel") {
                        self.draftProfile = self.userData.profile
                        self.mode?.animation().wrappedValue = .inactive
                    }
                }
                
                Spacer()
                
                EditButton()
            }
            if self.mode?.wrappedValue == .inactive {
                PersonalProfileSummary(personalProfile: userData.profile).onAppear {
                    self.viewModel.fetchData()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
                        // Code you want to be delayed
                        
                        if !self.viewModel.profiles[0].username.isEmpty {
                            self.userData.profile = self.viewModel.profiles[0]
                            //print("ahh crap")
                        }
                        self.draftProfile = self.userData.profile
                    }
                    
                    print("profiles count: \(self.viewModel.profiles.count)")
                }
            } else {
                PersonalProfileEditor(personalProfile: $draftProfile)
                    .onAppear {
                        self.viewModel.fetchData()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
                            // Code you want to be delayed
                            
                            if !self.viewModel.profiles[0].username.isEmpty {
                                self.userData.profile = self.viewModel.profiles[0]
                                //print("ahh crap")
                            }
                            self.draftProfile = self.userData.profile
                        }
                        
                        print("profiles count: \(self.viewModel.profiles.count)")
                        //print(self.viewModel.profiles.first!.username)
                }
                .onDisappear {
                    self.userData.profile = self.draftProfile
                    
                    if !self.viewModel.profiles[0].username.isEmpty {
                        self.viewModel.updateData(self.viewModel.profiles[0])
                        print("user exist, update! (from Host)")
                    }
                    else {
                        self.viewModel.addData(self.userData.profile)
                        print("no user profile! (from Host)")
                    }
                }
            
            }
        }.padding()
    }
}

struct PersonalProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        PersonalProfileHost().environmentObject(UserData())
    }
}


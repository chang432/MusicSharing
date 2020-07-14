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
    @State var profilepic = Image(systemName: "person")
//    @State var inputImage: UIImage?
//    @State var image: Image?
    
    class ProfilePic: ObservableObject {
        @Published var profilepic = Image(systemName: "person")
    }
    
    var body: some View {
        
        
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
                PersonalProfileSummary(personalProfile: userData.profile, profilepic: $profilepic).onAppear {
                    self.viewModel.fetchData()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
                        // Code you want to be delayed
                        
                        if !(self.viewModel.profiles.first?.username.isEmpty ?? true) {
                            self.userData.profile = self.viewModel.profiles[0]
                            //print("ahh crap")
                        }
                        self.draftProfile = self.userData.profile
                    }
                    
                    print("profiles count: \(self.viewModel.profiles.count)")
                }
            } else {
                PersonalProfileEditor(personalProfile: $draftProfile, profilepic2: $profilepic)
                    .onAppear {
                        self.viewModel.fetchData()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of seconds.
                            // Code you want to be delayed
                            
                            if !(self.viewModel.profiles.first?.username.isEmpty ?? true) {
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
                    
                    if !(self.viewModel.profiles.first?.username.isEmpty ?? true) {
                        print("user exist, update! (from Host)")
                        print(self.viewModel.profiles[0].id)
                        self.viewModel.updateData(self.userData.profile)
                    }
                    else {
                        self.viewModel.addData(self.userData.profile)
                        print("no user profile! (from Host)")
                    }
                }
            
            }

        }.padding()
    }
    
//    func loadImage() {
//        guard let inputImage = inputImage else { return }
//        image = Image(uiImage: inputImage)
//    }
}

struct PersonalProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        PersonalProfileHost().environmentObject(UserData())
    }
}


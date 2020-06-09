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
    @State var draftProfile = Profile.default
    
    @ObservedObject private var viewModel = ProfileViewModel()
    
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
                PersonalProfileSummary(personalProfile: userData.profile)
            } else {
                PersonalProfileEditor(personalProfile: $draftProfile)
                .onAppear {
                    self.draftProfile = self.userData.profile
                }
                .onDisappear {
                    self.userData.profile = self.draftProfile
                    self.viewModel.addData(self.userData.profile)
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


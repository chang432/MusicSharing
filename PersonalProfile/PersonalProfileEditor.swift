//
//  PersonalProfileEditor.swift
//  Login_v1
//
//  Created by Jason Lo on 5/29/20.
//  Copyright © 2020 Jason Lo. All rights reserved.
//

import SwiftUI

struct PersonalProfileEditor: View {
    @Binding var personalProfile: Profile
    @State var selectedGenderIndex: Int = 0
    var genderOptions = ["🙍‍♂️ Male", "🙍‍♀️ Female", "🤖 Other"]
    
    var body: some View {
        List{
            HStack {
                Image(systemName: "person").resizable().frame(width: 60, height: 60)
                Text("Username: ").bold()
                Divider()
                TextField("Username", text: $personalProfile.username)
            }
            
            Picker("Gender", selection: $selectedGenderIndex) {
                ForEach(0..<genderOptions.count) {
                    Text(self.genderOptions[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            TextField("Favorite song 1", text: $personalProfile.favsong1)
            TextField("Favorite song 2", text: $personalProfile.favsong2)
            TextField("Favorite song 3", text: $personalProfile.favsong3)

        }
    }
}

struct PersonalProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        PersonalProfileEditor(personalProfile: .constant(.default)).previewDevice("iPhone XS")
    }
}

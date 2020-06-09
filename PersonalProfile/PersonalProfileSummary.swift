//
//  PersonalProfileSummary.swift
//  Login_v1
//
//  Created by Jason Lo on 5/29/20.
//  Copyright © 2020 Jason Lo. All rights reserved.
//

import SwiftUI

struct PersonalProfileSummary: View {
    var personalProfile: Profile
    
    var body: some View {
        List{
            
            HStack {
                Image(systemName: "person").resizable().frame(width: 80, height: 80)
                
                Text(personalProfile.username)
                    .bold()
                    .font(.title).padding()
            }.padding()
            
            Text("Gender: \(self.personalProfile.gender)")
                .padding()
            
            VStack(alignment: .leading) {
                Text("Favorite Songs").font(.headline)
                Text("Top 1: \(self.personalProfile.favsong1)").font(.subheadline)
                Text("Top 2: \(self.personalProfile.favsong2)").font(.subheadline)
                Text("Top 3: \(self.personalProfile.favsong3)").font(.subheadline)
            }.padding()
            
        }
    }
}

struct PersonalProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        PersonalProfileSummary(personalProfile: Profile.default)
    }
}


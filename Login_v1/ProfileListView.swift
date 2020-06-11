//
//  ProfileListView.swift
//  Login_v1
//
//  Created by Jason Lo on 5/28/20.
//  Copyright © 2020 Jason Lo. All rights reserved.
//

import SwiftUI

struct ProfileListView: View {
    
    @ObservedObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            
            List(viewModel.profiles) { profile in
                VStack(alignment: .leading) {
                    Text(profile.username).font(.headline)
                    Text(profile.gender).font(.subheadline)
                    Text(profile.favsong1).font(.subheadline)
                    Text(profile.favsong2).font(.subheadline)
                    Text(profile.favsong3).font(.subheadline)
                }
            }
            .navigationBarTitle("Profiles")
            .onAppear() {
                self.viewModel.fetchData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
                    // Code you want to be delayed
                    print(self.viewModel.profiles[0].username)
                }
            }
        }
    }
}

struct ProfileListView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileListView()
    }
}

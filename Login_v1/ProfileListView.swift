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
            }
        }
    }
}

struct ProfileListView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileListView()
    }
}

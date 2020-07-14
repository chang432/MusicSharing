//
//  ProfilePicture.swift
//  MusicSharing
//
//  Created by Jason Lo on 6/21/20.
//  Copyright © 2020 Jason Lo. All rights reserved.
//

import Foundation
import SwiftUI

final class ProfilePicture: ObservableObject {
    @Published var profilepic = Image(systemName: "person")
}


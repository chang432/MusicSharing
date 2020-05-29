//
//  SwiftUIView.swift
//  Login_v1
//
//  Created by Jason Lo on 5/29/20.
//  Copyright © 2020 Jason Lo. All rights reserved.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var profile = Profile.default
}

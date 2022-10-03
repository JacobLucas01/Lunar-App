//
//  UserModel.swift
//  Lunar
//
//  Created by Jacob Lucas on 1/18/22.
//

import Foundation
import SwiftUI

struct UserModel: Identifiable, Hashable {
    var id = UUID()
    var userID: String
    var name: String
    var username: String
    var gender: String
    var age: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

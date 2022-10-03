//
//  UserCommentModel.swift
//  Lunar
//
//  Created by Jacob Lucas on 1/21/22.
//

import Foundation

struct UserCommentModel: Identifiable, Hashable {
    var id = UUID()
    var commentID: String
    var userID: String
    var username: String
    var content: String
    var dateCreated: Date
    var isRecieved: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//
//  CommentModel.swift
//  Lunar
//
//  Created by Jacob Lucas on 12/27/21.
//

import Foundation

struct CommentModel: Identifiable, Hashable {
    var id = UUID()
    var commentID: String
    var userID: String
    var username: String
    var content: String 
    var dateCreated: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

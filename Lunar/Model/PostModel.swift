//
//  PostModel.swift
//  Lunar
//
//  Created by Jacob Lucas on 12/26/21.
//

import Foundation
import SwiftUI
import MapKit

struct PostModel: Identifiable, Hashable {
    
    var id = UUID()
    var postID: String
    var userID: String
    var name: String
    var username: String
    var title: String
    var content: String
    var voiceClip: URL?
    var dateCreated: Date
    var likeCount: Int
    var dislikeCount: Int
    var likedByUser: Bool
    var dislikedByUser: Bool
    var latitude: Double
    var longitude: Double
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

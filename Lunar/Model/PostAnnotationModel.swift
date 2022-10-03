//
//  PostAnnotationModel.swift
//  Lunar
//
//  Created by Jacob Lucas on 3/21/22.
//

import Foundation

struct PostAnnotationModel: Identifiable, Hashable {
    var id: String
    var lat: Double
    var long: Double
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//
//  PostArrayObject.swift
//  Lunar
//
//  Created by Jacob Lucas on 12/26/21.
//

import Foundation
import CoreLocation

class PostArrayObject: ObservableObject {
    
    var location = CLLocation(latitude: 37.3496, longitude: -121.9390)
    
    @Published var dataArray = [PostModel]()
    @Published var likeCountString = "0"
    
//    init(shuffled: Bool) {
//        DataService.instance.getPosts(location: location) { returnedPosts in
//            self.dataArray.append(contentsOf: returnedPosts)
//        }
//    }
    
    func updateCounts() {
        
        let likeCountArray = dataArray.map { (existingPost) -> Int in
            return existingPost.likeCount
        }
        let sumOfLikeCountArray = likeCountArray.reduce(0, +)
        self.likeCountString = "\(sumOfLikeCountArray)"
        
    }
}

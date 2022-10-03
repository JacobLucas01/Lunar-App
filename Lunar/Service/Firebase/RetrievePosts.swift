//
//  RetrievePosts.swift
//  Lunar
//
//  Created by Jacob Lucas on 1/15/22.
//

import Foundation
import SwiftUI
import CoreLocation
import GeoFire
import Firebase
import AVFAudio
import AVFoundation

class RetrievePosts: ObservableObject {
    
    var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    let geofireRef = Database.database().reference()
    
    @Published var postAnnotation = [PostAnnotationModel]()
    @Published var post = [PostModel]()
    @Published var user = [UserModel]()
    @Published var loading = false
    @Published var noPosts = false
    
    var userLocation = LocationManager()
    
    var location = LocationManager()
    
    @AppStorage("user_id") var currentUserID: String?
    
    let REF_USERS = REF_FIRESTORE.collection("users")
    let REF_POSTS = REF_FIRESTORE.collection("posts")

    init() {
        getPosts()
        getUsers()
    }
    
    func getPosts() {
     //  var postArray = [PostModel]()
        self.loading = true
        
        let locationTest = CLLocation(latitude: 37.3496, longitude:  -121.939)
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        let circleQuery = geoFire.query(at: locationTest, withRadius: 100)
        
        circleQuery.observe(.keyEntered, with: { (key, location) in
            
            print("Key '\(key)' entered the search are and is at location '\(location)'")
            
            self.REF_POSTS.whereField("post_id", isEqualTo: key).getDocuments { snapshot, error in
                
                for document in snapshot!.documents {
                    self.noPosts = false
                    if
                        let userID = document.get("user_id") as? String,
                        let username = document.get("username") as? String,
                        let timestamp = document.get("date_created") as? Timestamp {
                        let name = document.get("name") as? String

                        
                        let date = timestamp.dateValue()
                        let content = (document.get("content") as? String)!
                        let title = (document.get("title") as? String)!
                        let latitude = document.get("latitude") as? Double ?? 0
                        let longitude = document.get("longitude") as? Double ?? 0
    
                        let postID = document.documentID
                        let likeCount = document.get("like_count") as? Int ?? 0
                        let dislikeCount = document.get("dislike_count") as? Int ?? 0

                        var likedByUser: Bool = false
                        var dislikedByUser: Bool = false

                        if let userIDArray = document.get("liked_by") as? [String], let userID = self.currentUserID {
                            likedByUser = userIDArray.contains(userID)
                        }
                        if let userIDArray = document.get("disliked_by") as? [String], let userID = self.currentUserID {
                            dislikedByUser = userIDArray.contains(userID)
                        }

                        let newPost = PostModel(postID: postID, userID: userID, name: name!, username: username, title: title, content: content, dateCreated: date, likeCount: likeCount, dislikeCount: dislikeCount, likedByUser: likedByUser, dislikedByUser: dislikedByUser, latitude: latitude, longitude: longitude)
                        self.post.append(newPost)
                        self.createPostAnnotations(postID: postID, lat: latitude, long: longitude)
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.loading = false
                        }
            }
           
        })
       self.setUserLocation(location: CLLocation(latitude: 37.3496, longitude: -121.9390), userID: currentUserID!)
    }
    
    func setUserLocation(location: CLLocation, userID: String) {
       let geoFire = GeoFire(firebaseRef: geofireRef)
       
       geoFire.setLocation(location, forKey: userID)
   }
    
    func getUsers() {
 //       let geoFire = GeoFire(firebaseRef: geofireRef)
        
     //   let circleQuery = geoFire.query(at: CLLocation(latitude: 37.3496, longitude: -121.9390), withRadius: 10)
        
//        circleQuery.observe(.keyEntered, with: { (key, location) in
            
//            self.REF_USERS.whereField("user_id", isEqualTo: key).getDocuments { snapshot, error in
        REF_USERS.getDocuments { snapshot, error in
                for document in snapshot!.documents {
                    if
                        let userID = document.get("user_id") as? String,
                        let username = document.get("username") as? String,
                        let gender = document.get("gender") as? String,
                        let age = document.get("age") as? String,
                        let name = document.get("name") as? String {

                        let user = UserModel(userID: userID, name: name, username: username, gender: gender, age: age)
                        self.user.append(user)
                    }
                }
//                }
            }
 //       })
    }
    
    func createPostAnnotations(postID: String, lat: Double, long: Double) {
        let newAnnotation = PostAnnotationModel(id: postID, lat: lat, long: long)
        self.postAnnotation.append(newAnnotation)
    }
    
}


//Post info is being retrieved but not displaying in feed?? Is it not being appended properly?

//if let snapshot = snapshot, snapshot.documents.count > 0 {
//
//} else {
//    print("No posts")
//}

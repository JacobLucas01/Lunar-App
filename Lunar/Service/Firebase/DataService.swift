//
//  DataService.swift
//  Lunar
//
//  Created by Jacob Lucas on 12/26/21.
//

import Foundation
import SwiftUI
import Firebase
import GeoFire
import CoreLocation

class DataService: ObservableObject {
    
//    @Published var postAnnotation = [PostAnnotationModel]()
    
    static let instance = DataService()
    
    let REF_POSTS = REF_FIRESTORE.collection("posts")
    let geofireRef = Database.database().reference()
    
    var location = LocationManager()
    
    @AppStorage("user_id") var currentUserID: String?
    
    // MARK: UPLOADING POST DATA TO FIRESTORE
    func uploadPost(userID: String, name: String, username: String, title: String, content: String, latitude: Double, longitude: Double, handler: @escaping (_ success: Bool) -> ()) {
        
        let document = REF_POSTS.document()
        let postID = document.documentID
        let postData: [String: Any] = [
            "post_id": postID,
            "user_id": userID,
            "name": name,
            "username": username,
            "title": title,
            "content": content,
            "latitude": latitude,
            "longitude": longitude,
            "date_created": FieldValue.serverTimestamp()
        ]
        
        document.setData(postData) { error in
            if let error = error {
                print("Error uploading data to post document \(error)")
                handler(false)
                return
            } else {
                handler(true)
            }
            self.setPostLocation(location: self.location.location, postID: postID)
//            self.createPostAnnotations(postID: postID, lat: self.location.loc.latitude, long: self.location.loc.longitude)
            //CHECK LINE ABOVE
        }
    }
    
//    func createPostAnnotations(postID: String, lat: Double, long: Double) {
//        let newAnnotation = PostAnnotationModel(id: postID, lat: lat, long: long)
//        self.postAnnotation.append(newAnnotation)
//    }
    
     func setPostLocation(location: CLLocation, postID: String) {
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        geoFire.setLocation(location, forKey: postID)
    }
    
    // MARK: RETRIEVING POST DATA FROM FIRESTORE
    
    //        func getPostsFromRadius(location: CLLocation) {
    //            var post = [PostModel]()
    //            let geoFire = GeoFire(firebaseRef: geofireRef)
    //    
    //            let circleQuery = geoFire.query(at: location, withRadius: 25)
    //    
    //            _ = circleQuery.observe(GFEventType.keyEntered, with: { key, location in
    //                self.REF_POSTS.whereField(key, isEqualTo: true).getDocuments { snapshot, error in
    //                    for document in snapshot!.documents {
    //                        if
    //                            let userID = document.get("user_id") as? String,
    //                            let username = document.get("username") as? String,
    //                            let name = document.get("name") as? String,
    //                            let timestamp = document.get("date_created") as? Timestamp {
    //    
    //                            let content = (document.get("content") as? String)!
    //                            let date = timestamp.dateValue()
    //                            let postID = document.documentID
    //                            let likeCount = document.get("like_count") as? Int ?? 0
    //    
    //                            var likedByUser: Bool = false
    //    
    //                            if let userIDArray = document.get("liked_by") as? [String], let userID = self.currentUserID {
    //                                likedByUser = userIDArray.contains(userID)
    //                            }
    //    
    //                            let newPost = PostModel(postID: postID, userID: userID, name: name, username: username, content: content, dateCreated: date, likeCount: likeCount, likedByUser: likedByUser)
    //                            post.append(newPost)
    //                        }
    //                    }
    //                }
    //            })
    //        }
    
    
    
    // MARK: LIKE AND UNLIKE A POST
    func likePost(postID: String, currentUserID: String) {
        // Update the post count
        // Update the array of users who liked the post
        
        let increment: Int64 = 1
        let data: [String:Any] = [
            "like_count" : FieldValue.increment(increment),
            "liked_by" : FieldValue.arrayUnion([currentUserID])
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }
    
    func unlikePost(postID: String, currentUserID: String) {
        // Update the post count
        // Update the array of users who liked the post
        
        let increment: Int64 = -1
        let data: [String:Any] = [
            "like_count" : FieldValue.increment(increment),
            "liked_by" : FieldValue.arrayRemove([currentUserID])
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }
    
    // MARK: DISLIKE AND UNDISLIKE A POST
    func dislikePost(postID: String, currentUserID: String) {
        // Update the post count
        // Update the array of users who liked the post
        
        let increment: Int64 = 1
        let data: [String:Any] = [
            "dislike_count" : FieldValue.increment(increment),
            "disliked_by" : FieldValue.arrayUnion([currentUserID])
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }
    
    func undislikePost(postID: String, currentUserID: String) {
        // Update the post count
        // Update the array of users who liked the post
        
        let increment: Int64 = -1
        let data: [String:Any] = [
            "dislike_count" : FieldValue.increment(increment),
            "disliked_by" : FieldValue.arrayRemove([currentUserID])
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }
    
    // MARK: UPLOAD AND RETRIEVE COMMENTS
    
    func uploadComment(postID: String, content: String, name: String, userID: String, handler: @escaping (_ success: Bool,_ commentID: String?) -> ()) {
        let document = REF_POSTS.document(postID).collection("comments").document()
        let commentID = document.documentID
        
        let data: [String:Any] = [
            "comment_id": commentID,
            "user_id": userID,
            "content": content,
            "name": name,
            "date_created": FieldValue.serverTimestamp()
        ]
        
        document.setData(data) { error in
            if let error = error {
                print("Error uploading post comment to firestore: \(error)")
                handler(false, nil)
            } else {
                handler(true, commentID)
            }
        }
    }
    
    func uploadUserComment(content: String, name: String, userID: String, handler: @escaping (_ success: Bool,_ commentID: String?) -> ()) {
        let document = REF_USERS.document(userID).collection("comments").document()
        let commentID = document.documentID
        
        let data: [String:Any] = [
            "comment_id": commentID,
            "user_id": userID,
            "content": content,
            "name": name,
            "date_created": FieldValue.serverTimestamp()
        ]
        
        document.setData(data) { error in
            if let error = error {
                print("Error uploading post comment to firestore: \(error)")
                handler(false, nil)
            } else {
                handler(true, commentID)
            }
        }
    }
    
    func downloadUserComments(postID: String, handler: @escaping (_ comment: [UserCommentModel]) -> ()) {
        REF_USERS.document(postID).collection("comments").order(by: "date_created", descending: false).getDocuments { snapshot, error in
            handler(self.getUserCommentsFromSnapshot(querySnapshot: snapshot))
        }
    }
    
    private func getUserCommentsFromSnapshot(querySnapshot: QuerySnapshot?) -> [UserCommentModel] {
        var commentArray = [UserCommentModel]()
        
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            
            for document in snapshot.documents {
                
                if
                    let userID = document.get("user_id") as? String,
                    let name = document.get("name") as? String,
                    let content = document.get("content") as? String,
                    let dateCreated = document.get("date_created") as? Timestamp {
                    
                    let date = dateCreated.dateValue()
                    let commentID = document.documentID
                    let newComment = UserCommentModel(commentID: commentID, userID: userID, username: name, content: content, dateCreated: date, isRecieved: false)
                    commentArray.append(newComment)
                }
            }
            return commentArray
        } else {
            print("No comments in documents for snapshot")
            return commentArray
        }
    }
    
    func downloadComments(postID: String, handler: @escaping (_ comment: [CommentModel]) -> ()) {
        REF_POSTS.document(postID).collection("comments").order(by: "date_created", descending: false).getDocuments { snapshot, error in
            handler(self.getCommentsFromSnapshot(querySnapshot: snapshot))
        }
    }
    
    private func getCommentsFromSnapshot(querySnapshot: QuerySnapshot?) -> [CommentModel] {
        var commentArray = [CommentModel]()
        
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            
            for document in snapshot.documents {
                
                if
                    let userID = document.get("user_id") as? String,
                    let name = document.get("name") as? String,
                    let content = document.get("content") as? String,
                    let dateCreated = document.get("date_created") as? Timestamp {
                    
                    let date = dateCreated.dateValue()
                    let commentID = document.documentID
                    let newComment = CommentModel(commentID: commentID, userID: userID, username: name, content: content, dateCreated: date)
                    commentArray.append(newComment)
                }
            }
            return commentArray
        } else {
            print("No comments in documents for snapshot")
            return commentArray
        }
    }
    
    func downloadPostForUser(userID: String, handler: @escaping (_ posts: [PostModel]) -> ()) {
        REF_POSTS.whereField("user_id", isEqualTo: userID).getDocuments { (querySnapshot, error) in
            handler(self.getPostsFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    private func getPostsFromSnapshot(querySnapshot: QuerySnapshot?) -> [PostModel] {
        var postArray = [PostModel]()
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {

            for document in snapshot.documents {
                if
                    let userID = document.get("user_id") as? String,
                    let username = document.get("username") as? String,
                    let name = document.get("name") as? String {

                    let content = (document.get("content") as? String)!
                    let latitude = document.get("latitude") as? Double ?? 0
                    let longitude = document.get("longitude") as? Double ?? 0
                    let title = (document.get("title") as? String)!

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
                    let newPost = PostModel(postID: postID, userID: userID, name: name, username: username, title: title, content: content, dateCreated: Date(), likeCount: likeCount, dislikeCount: dislikeCount, likedByUser: likedByUser, dislikedByUser: dislikedByUser, latitude: latitude, longitude: longitude)
                    postArray.append(newPost)
        
                }
            }
            return postArray
        } else {
            print("No documents in snapshot found for this user")
            return postArray
        }
    }
    
    func updateDisplayNameOnPosts(userID: String, name: String) {

        downloadPostForUser(userID: userID) { (returnedPosts) in
            for post in returnedPosts {
                self.updatePostDisplayName(postID: post.postID, name: name)
            }
        }

    }

    private func updatePostDisplayName(postID: String, name: String) {

        let data: [String:Any] = [
            "name" : name
        ]

        REF_POSTS.document(postID).updateData(data)
    }
    
    func getUserGender(userID: String, handler: @escaping(_ gender: String) -> ()) {
        REF_FIRESTORE.collection("users").document(userID).getDocument { snapshot, error in
            if let document = snapshot, snapshot!.exists {
                let gender = document.get("gender") as? String
                handler(gender!)
               } else {
                   print("Document does not exist")
               }
        }
    }
    
    //MARK: DELETE USER POST
    func postDeletion(postID: String, userID: String) {
        REF_POSTS.document(postID).delete()  { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}

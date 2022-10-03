//
//  Post.swift
//  Lunar
//
//  Created by Jacob Lucas on 12/26/21.
//

import SwiftUI
import CoreHaptics
import MapKit

struct Post: View {
    
    @State var likedPost: Bool = false
    @Binding var ellipsis: Bool
    @State var post: PostModel
    @State var commentArray = [CommentModel]()
    @State var profileImage: UIImage = UIImage(systemName: "person.crop.circle.fill")!
    
    @AppStorage("user_id") var currentUserID: String?
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .trailing, spacing: 0) {
                    HStack {
                        ZStack {
                            VStack(spacing: 0) {
                                Image("Black Man")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 110, height: 110)
                                    .clipShape(RoundedRectangle(cornerRadius: 28))
                            }
                            Image(systemName: "play.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                                .opacity(0.95)
                        }
                        Spacer(minLength: 0)
                        ZStack {
                            VStack(spacing: 0) {
                                
                                HStack(spacing: 0) {
                                    Spacer()
                                    Image(systemName: "ellipsis")
                                }
                                Spacer()
                                HStack {
                                    Image(systemName: "message")
                                        .font(.system(size: 14, weight: .medium))
                                        .frame(maxWidth: .greatestFiniteMagnitude)
                                    Image(systemName: "location")
                                        .font(.system(size: 15, weight: .medium))
                                        .frame(maxWidth: .greatestFiniteMagnitude)
                                    
                                    Button {
                                        if post.likedByUser {
                                            dislikePost()
                                        } else {
                                            likePost()
                                        }
                                    } label: {
                                        if post.likedByUser {
                                        Image(systemName: "heart.fill")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.pink)
                                            .frame(maxWidth: .greatestFiniteMagnitude)
                                        } else {
                                            Image(systemName: "heart")
                                                .font(.system(size: 15, weight: .medium))
                                                .frame(maxWidth: .greatestFiniteMagnitude)
                                                .foregroundColor(Color(.label))
                                        }
                                    }
                                }
                            }
                            .frame(height: 120)
                            HStack(spacing: 0) {
                                Text("REPLY")
                                    .font(.system(size: 14))
                                Image(systemName: "play.fill")
                                    .padding(.horizontal, 12)
                                ForEach(0..<13, id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: .greatestFiniteMagnitude)
                                        .frame(width: 3, height: 3)
                                        .padding(3)
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - 30)
            .padding(.vertical, 12)
            Divider()
        }
        .onAppear {
            getProfileImage()
        }
    }
    
    func getProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: post.userID) { (returnedImage) in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
    }
    
    func likePost() {
        
        guard let userID = currentUserID else {
            print("Cannot find userID while liking post")
            return
        }
        
        // Update the local data
        let updatedPost = PostModel(postID: post.postID, userID: post.userID, name: post.name, username: post.username, title: post.title, content: post.content, dateCreated: post.dateCreated, likeCount: post.likeCount + 1, dislikeCount: post.dislikeCount, likedByUser: true, dislikedByUser: false, latitude: 34.3423, longitude: 34.2345)
        self.post = updatedPost
        
        // Update the database
        DataService.instance.likePost(postID: post.postID, currentUserID: userID)
    }
    
    func dislikePost() {
        
        guard let userID = currentUserID else {
            print("Cannot find userID while liking post")
            return
        }
        
        let updatedPost = PostModel(postID: post.postID, userID: post.userID, name: post.name, username: post.username, title: post.title, content: post.content, dateCreated: post.dateCreated, likeCount: post.likeCount, dislikeCount: post.dislikeCount + 1, likedByUser: false, dislikedByUser: true, latitude: 34.3423, longitude: 34.2345)
        self.post = updatedPost
        
        DataService.instance.dislikePost(postID: post.postID, currentUserID: userID)
    }
    
    func unlikePost() {
        
        guard let userID = currentUserID else {
            print("Cannot find userID while unliking post")
            return
        }
        
        // Update the local data
        let updatedPost = PostModel(postID: post.postID, userID: post.userID, name: post.name, username: post.username, title: post.title, content: post.content, dateCreated: post.dateCreated, likeCount: post.likeCount - 1, dislikeCount: post.dislikeCount, likedByUser: false, dislikedByUser: false, latitude: 34.3423, longitude: 34.2345)
        self.post = updatedPost
        
        // Update the database
        DataService.instance.unlikePost(postID: post.postID, currentUserID: userID)
    }
    
    func undislikePost() {
        
        guard let userID = currentUserID else {
            print("Cannot find userID while unliking post")
            return
        }
        
        let updatedPost = PostModel(postID: post.postID, userID: post.userID, name: post.name, username: post.username, title: post.title, content: post.content, dateCreated: post.dateCreated, likeCount: 0, dislikeCount: post.dislikeCount - 1, likedByUser: false, dislikedByUser: false, latitude: 34.3423, longitude: 34.2345)
        self.post = updatedPost
        
        DataService.instance.undislikePost(postID: post.postID, currentUserID: userID)
    }
}

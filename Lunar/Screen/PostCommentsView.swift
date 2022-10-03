//
//  PostCommentsView.swift
//  Lunar
//
//  Created by Jacob Lucas on 12/27/21.
//

import SwiftUI

struct PostCommentsView: View {
    
    var post: PostModel
    
    @State var message: String = ""
    @State var commentArray = [CommentModel]()
    @State var currentUserProfileImage: UIImage = UIImage(systemName: "person.crop.circle.fill")!
    @State var postUserProfileImage: UIImage = UIImage(systemName: "person.crop.circle.fill")!
    
    @AppStorage("user_id") var currentUserID: String?
    @AppStorage("name") var name: String?
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 16, height: 16)
                                .foregroundColor(Color(.label))
                        }
                        Spacer()

                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(Color(.label))
                        }
                    }
                    HStack(spacing: 8) {
                        Image(uiImage: postUserProfileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                                Text(post.name)
                                    .font(.system(size: 18, weight: .medium))
                        
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 12)
                .frame(width: UIScreen.main.bounds.width - 30)
            }
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(commentArray, id: \.self) { comment in
                        PostMessage(comment: comment)
                    }
                }
            }
            VStack(spacing: 0) {
                Divider()
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 40)
                            .foregroundColor(Color(.systemGray6))
                        TextField("Type Response", text: $message)
                            .frame(width: UIScreen.main.bounds.width - 120)
                    }
                    Button {
                        if textIsAppropriate() {
                            addComment()
                        }
                    } label: {
                        Text("Send")
                            .fontWeight(.medium)
                    }
                }
                .padding(.vertical, 8)
                .frame(width: UIScreen.main.bounds.width - 30)
            }
            .navigationBarHidden(true)
            
        }
        .onAppear {
            getComments()
            getCurrentUserProfileImage()
            getPostUserProfileImage()
        }
    }
    
    func getCurrentUserProfileImage() {
        guard let userID = currentUserID else { return }
        ImageManager.instance.downloadProfileImage(userID: userID) { (returnedImage) in
            if let image = returnedImage {
                self.currentUserProfileImage = image
            }
        }
    }
    
    func getPostUserProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: post.userID) { (returnedImage) in
            if let image = returnedImage {
                self.postUserProfileImage = image
            }
        }
    }
    
    func textIsAppropriate() -> Bool {
        // Check if the text has curses
        // Check if the text is long enough
        // Check if the text is blank
        // Check for innapropriate things
        
        
        // Checking for bad words
        let badWordArray: [String] = ["shit", "ass"]
        
        let words = message.components(separatedBy: " ")
        
        for word in words {
            if badWordArray.contains(word) {
                return false
            }
        }
        
        // Checking for minimum character count
        if message.count < 3 {
            return false
        }
    
        return true
    }
    
    func getComments() {
        guard self.commentArray.isEmpty else { return }
        DataService.instance.downloadComments(postID: post.postID) { comment in
            self.commentArray.append(contentsOf: comment)
        }
    }
    
    func addComment() {
        guard let userID = currentUserID, let name = name else { return }
        DataService.instance.uploadComment(postID: post.postID, content: message, name: name, userID: userID) { success, commentID in
            
            if success, let commentID = commentID {
                let newComment = CommentModel(commentID: commentID, userID: userID, username: name, content: message, dateCreated: Date())
                self.commentArray.append(newComment)
                self.message = ""
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

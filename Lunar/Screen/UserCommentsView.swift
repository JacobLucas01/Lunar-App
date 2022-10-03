//
//  UserCommentsView.swift
//  Lunar
//
//  Created by Jacob Lucas on 1/18/22.
//

import SwiftUI

struct UserCommentsView: View {
    
    @State var message: String = ""
    @State var commentArray = [UserCommentModel]()
    @State var currentUserProfileImage: UIImage = UIImage(systemName: "person.crop.circle.fill")!
    
    @AppStorage("user_id") var currentUserID: String?
    @AppStorage("name") var name: String?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                ZStack {
                    HStack(spacing: 30) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 10, height: 10)
                                .foregroundColor(Color(.label))
                        }
                        HStack(spacing: 12) {
                            Image(uiImage: currentUserProfileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                            Text("Jake")
                                .font(.system(size: 22, weight: .medium))
                        }
                        Spacer()
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(Color(.label))
                        }

                    }
                }
                .padding(.vertical, 6)
                .frame(width: UIScreen.main.bounds.width - 30)
            }
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(commentArray, id: \.self) { comment in
                        UserMessage(userComment: comment)
                    }
                }
            }
            ZStack {
                Rectangle()
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .shadow(color: colorScheme == .light ? Color(.systemGray5) : Color.black, radius: 6, x: 0, y: 0)
                    .frame(height: 50)
                    .mask(Rectangle().padding(.top, -20))
                
                HStack {
                    Button {
                        addComment()
                    } label: {
                        Image(systemName: "globe.americas.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 34, height: 34)
                            .foregroundColor(Color(.systemGray5))
                    }
                    .padding(.horizontal, 2)
                    ZStack {
                        RoundedRectangle(cornerRadius: .infinity)
                            .frame(height: 38)
                            .foregroundColor(Color(.systemGray6))
                        TextField("New Message", text: $message)
                            .frame(width: UIScreen.main.bounds.width - 145)
                    }
                    Button {
                        addComment()
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 22, height: 22)
                    }
                    .padding(.horizontal, 6)
                }
                .padding(.vertical, 8)
                .frame(width: UIScreen.main.bounds.width - 30)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            getUserComments()
         //   getCurrentUserProfileImage()
        }
    }
    
    func getCurrentUserProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: currentUserID!) { (returnedImage) in
            if let image = returnedImage {
                self.currentUserProfileImage = image
            }
        }
    }
    
    func getUserComments() {
        guard self.commentArray.isEmpty else { return }
        DataService.instance.downloadUserComments(postID: self.currentUserID!) { comment in
            self.commentArray.append(contentsOf: comment)
        }
    }
    
    func addComment() {
        guard let userID = currentUserID, let name = name else { return }
        DataService.instance.uploadUserComment(content: message, name: name, userID: userID) { success, commentID in
            
            if success, let commentID = commentID {
                let newComment = UserCommentModel(commentID: commentID, userID: userID, username: name, content: message, dateCreated: Date(), isRecieved: false)
                self.commentArray.append(newComment)
                self.message = ""
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

struct UserCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        UserCommentsView().preferredColorScheme(.light)
    }
}

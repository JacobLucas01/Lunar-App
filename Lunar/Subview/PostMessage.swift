//
//  PostMessageView.swift
//  Lunar
//
//  Created by Jacob Lucas on 12/27/21.
//

import SwiftUI

struct PostMessage: View {
    
    @State var comment: CommentModel
    @State var profilePicture: UIImage = UIImage(systemName: "person.crop.circle.fill")!
    
    var body: some View {
        HStack(alignment: .top) {
            Image(uiImage: profilePicture)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 32, height: 32)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 6) {
                Text(comment.username)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                Text(comment.content)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray5), lineWidth: 1))
            }
            Spacer()
        }
        .padding(.vertical, 12)
        .frame(width: UIScreen.main.bounds.width - 30)
        .onAppear {
            getProfileImage()
        }
    }
    
    func getProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: comment.userID) { (returnedImage) in
            if let image = returnedImage {
                self.profilePicture = image
            }
        }
    }
}

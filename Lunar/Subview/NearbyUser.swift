//
//  NearbyUser.swift
//  Lunar
//
//  Created by Jacob Lucas on 1/17/22.
//

import SwiftUI

struct NearbyUser: View {
    
    @State var user: UserModel
    
    @State var profileImage: UIImage = UIImage(systemName: "person.crop.circle.fill")!
    
    var body: some View {
        VStack(spacing: 0) {
        HStack {
        HStack(alignment: .top, spacing: 10) {
            Image(uiImage: profileImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 38, height: 38)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 10) {
                    Text(user.name)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color(.label))
                    Spacer()
                }
                VStack(alignment: .leading) {
                    Text("previous message")
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .foregroundColor(Color(.systemGray))
                }
            }
        }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
            Divider()
        }
        .onAppear {
            getProfileImage()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    func getProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: user.userID) { (returnedImage) in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
    }
}

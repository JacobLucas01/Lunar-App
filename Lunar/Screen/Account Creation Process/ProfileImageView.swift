//
//  ProfileImageView.swift
//  Lunar
//
//  Created by Jacob Lucas on 2/20/22.
//

import SwiftUI

struct ProfileImageView: View {
    
    @Binding var showImagePicker: Bool
    @Binding var imageSelected: UIImage?
    @Binding var sourceType: UIImagePickerController.SourceType
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("ADD A PROFILE IMAGE")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.systemGray))
                Button {
                    sourceType = UIImagePickerController.SourceType.photoLibrary
                    showImagePicker.toggle()
                } label: {
                    ZStack(alignment: .bottomTrailing) {
                        if imageSelected == nil {
                            Circle()
                                .stroke(lineWidth: 1)
                                .foregroundColor(Color(.systemGray))
                                .frame(width: 95, height: 95)
                        } else {
                            Image(uiImage: imageSelected!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 95, height: 95)
                                .foregroundColor(Color(.label))
                                .clipShape(Circle())
                        }
                        ZStack {
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 32, height: 32)
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
            VStack {
                Spacer()
                Text("To add a profile image, click on the image")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.systemGray))
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical)
        }
        .frame(width: UIScreen.main.bounds.width - 50)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(imageSelected: $imageSelected, sourceType: $sourceType)
        }
    }
}


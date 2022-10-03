//
//  EditImageView.swift
//  Lunar
//
//  Created by Jacob Lucas on 1/20/22.
//

import SwiftUI

struct EditImageView: View {
    
    @Binding var profileImage: UIImage
    @State var showImagePicker: Bool = false
    @State var imageSelected: UIImage? = UIImage(systemName: "person.crop.circle.fill")!
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var savedSuccessfully: Bool = false
    
    @AppStorage("user_id") var currentUserID: String?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color(.label))
                            Text("Profile")
                                .foregroundColor(Color(.label))
                        }
                    }
                    Spacer()
                }
                Text("Edit Image")
                    .font(.system(size: 20))
                    .foregroundColor(Color(.label))
                    .fontWeight(.medium)
            }
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width - 30)
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image(uiImage: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                        Spacer()
                    }
                }
                .listRowBackground(Color(UIColor.systemGroupedBackground))
                Section {
                    HStack {
                        Spacer()
                        Button {
                            showImagePicker.toggle()
                        } label: {
                            Text("Choose Image")
                                .foregroundColor(Color(.label))
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button {
                            saveImage()
                        } label: {
                            Text("Save Image")
                                .foregroundColor(Color(.label))
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(imageSelected: $imageSelected, sourceType: $sourceType)
        }
        .alert(isPresented: $savedSuccessfully) {
            return Alert(title: Text("Image Saved"), message: Text("Your Image has been saved successfully."), dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
    
    func saveImage() {
        guard let userID = currentUserID else { return }
        
        self.profileImage = imageSelected!
        
        ImageManager.instance.uploadProfileImage(userID: userID, image: imageSelected!)
        
        self.savedSuccessfully.toggle()
    }
}

struct EditImageView_Previews: PreviewProvider {
    
    @State static var image: UIImage = UIImage(systemName: "person.crop.circle.fill")!
    static var previews: some View {
        EditImageView(profileImage: $image)
    }
}

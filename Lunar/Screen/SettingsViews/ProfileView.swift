//
//  ProfileView.swift
//  Lunar
//
//  Created by Jacob Lucas on 1/17/22.
//

import SwiftUI

struct ProfileView: View {
    
    @Binding var currentUserProfileImage: UIImage
    @State var gender: String = ""
    @State var infoAlert: Bool = false
    
    @AppStorage("name") var name: String?
    @AppStorage("username") var username: String?
    @AppStorage("email") var email: String?
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
                            Text("Menu")
                                .foregroundColor(Color(.label))
                        }
                    }
                    Spacer()
                }
                Text("Profile")
                    .font(.system(size: 20))
                    .foregroundColor(Color(.label))
                    .fontWeight(.medium)
            }
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width - 30)
            Form {
                VStack(spacing: 25) {
                    HStack {
                        Spacer()
                        Image(uiImage: currentUserProfileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                        Spacer()
                    }
                    ZStack {
                        NavigationLink(destination: EditImageView(profileImage: $currentUserProfileImage)) {
                            EmptyView()
                        }.buttonStyle(PlainButtonStyle())
                            .opacity(0.0)
                        
                        RoundedRectangle(cornerRadius: .greatestFiniteMagnitude)
                            .frame(width: 100, height: 30)
                            .foregroundColor(Color(.systemGray5))
                            .overlay(Text("Edit Image").foregroundColor(Color(.label)).font(.system(size: 16)))
                        
                    }
                    Button {
                        infoAlert.toggle()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Reactions 23")
                                .font(.system(size: 16))
                                .foregroundColor(Color(.systemGray))
                            Image(systemName: "info.circle")
                                .foregroundColor(Color(.systemGray))
                            Spacer()
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .listRowBackground(Color(UIColor.systemGroupedBackground))
                Section {
                    NavigationLink(destination: EditNameView(title: name!, placeholder: name!)) {
                        HStack(spacing: 6) {
                            Text("Name")
                            Text(name!)
                                .foregroundColor(Color(.systemGray))
                        }
                    }
                    NavigationLink(destination: EditUsernameView(title: username!, placeholder: username!)) {
                        HStack(spacing: 6) {
                            Text("Username")
                            Text(username!)
                                .foregroundColor(Color(.systemGray))
                        }
                    }
                    NavigationLink(destination: EditGenderView(title: gender, placeholder: gender)) {
                        HStack(spacing: 6) {
                            Text("Gender")
                            Text(gender)
                                .foregroundColor(Color(.systemGray))
                        }
                    }
                }
                Section {
                    NavigationLink(destination: SignOutView()) {
                        HStack {
                            Text("Sign Out")
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            getGender()
        }
        .alert(isPresented: $infoAlert) { () -> Alert in
            return Alert(title: Text("Reactions"), message: Text("Reactions are the total number of posts and comments you have created."), dismissButton: .default(Text("OK")))
        }
    }
    
    func getGender() {
        guard let userID = currentUserID else { return }
        DataService.instance.getUserGender(userID: userID) { gender in
            self.gender = gender
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    @State static var currentUserProfileImage: UIImage = UIImage(systemName: "person.crop.circle.fill")!
    
    static var previews: some View {
        ProfileView(currentUserProfileImage: $currentUserProfileImage)
    }
}

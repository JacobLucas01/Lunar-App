//
//  AccountCreationView.swift
//  Lunar
//
//  Created by Jacob Lucas on 12/25/21.
//

import SwiftUI

struct AccountCreationView: View {
    
    @Binding var name: String
    @Binding var username: String
    @Binding var age: String
    @Binding var gender: String
    @Binding var email: String
    @Binding var providerID: String
    @Binding var provider: String
    
    @State var page: Int = 0
    @State private var isBack = false
    @State var isloading: Bool = false
    @State private var progress = 0.0
    
    @State var showImagePicker: Bool = false
    @State var imageSelected: UIImage? = nil
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            //MARK: START OF HEADING VIEW FOR ACCOUNT CREATION
            VStack(spacing: 0) {
                ZStack {
                    Text("Create Account")
                        .font(.system(size: 18, weight: .medium))
                    HStack {
                        if page != 0 {
                            Button {
                                self.isBack = true
                                self.page = self.page - 1
                                if progress < 60 {
                                    progress -= 10
                                }
                            } label: {
                                Text("Back")
                                    .foregroundColor(Color(.label))
                                    .font(.system(size: 17))
                            }
                        }
                        Spacer()
                        if page != 5 {
                            Button {
                                self.isBack = false
                                self.page = self.page + 1
                                if progress < 60 {
                                    progress += 10
                                }
                            } label: {
                                Text("Next")
                                    .foregroundColor(Color(.label))
                                    .font(.system(size: 17))
                            }
                            .disabled(page == 0 && name == "" ? true : false)
                            .opacity(page == 0 && name == "" ? 0.5 : 1.0)
                            .disabled(page == 2 && imageSelected == nil ? true : false)
                            .opacity(page == 2 && imageSelected == nil ? 0.5 : 1.0)
                            .disabled(page == 3 && age == "" ? true : false)
                            .opacity(page == 3 && age == "" ? 0.5 : 1.0)
                        } else if page == 5 {
                            if isloading {
                                ProgressView()
                            } else {
                                Button {
                                    createProfile()
                                } label: {
                                    Text("Finish")
                                        .foregroundColor(Color(.label))
                                        .font(.system(size: 17))
                                }
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 50)
                ProgressView("", value: progress, total: 50)
                    .padding(.horizontal, 8)
                    .transition(AnyTransition.asymmetric(
                        insertion:.move(edge: isBack ? .leading : .trailing),
                        removal: .move(edge: isBack ? .trailing : .leading))
                    )
                    .animation(.default, value: self.progress)
                Spacer()
            }
            .padding(.vertical, 12)
            //MARK: END OF HEADING VIEW FOR ACCOUNT CREATION
            
            Group {
                switch page {
                case 0:
                    AddNameView(name: $name, username: $username)
                    
                case 1:
                    GenderView(selectedGender: $gender)
                    
                case 2:
                    ProfileImageView(showImagePicker: $showImagePicker, imageSelected: $imageSelected, sourceType: $sourceType)
                    
                case 3:
                    AgeView(age: $age)
                    
                case 4:
                    LocationRequestView()
                    
                case 5:
                    AirdropView()
                    
                default:
                    FeedView()
                }
            }
            .transition(AnyTransition.asymmetric(
                insertion:.move(edge: isBack ? .leading : .trailing),
                removal: .move(edge: isBack ? .trailing : .leading))
            )
            .animation(.default, value: self.page)
        }
    }
    
    func createProfile() {
        self.isloading = true
        AuthService.instance.createNewUserInDatabase(name: name, username: username, age: age, gender: gender, providerID: providerID, provider: provider, profileImage: imageSelected!) { (returnedUserID) in
            
            if let userID = returnedUserID {
                AuthService.instance.logInUserToApp(userID: userID) { (success) in
                    if success {
                        print("user logged in")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.isloading = false
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } else {
                        print("error logging in")
                    }
                }
            } else {
                print("error creating user in database")
            }
        }
    }
}

struct AccountCreationView_Previews: PreviewProvider {
    
    @State static var testString: String = ""
    
    static var previews: some View {
        AccountCreationView(name: $testString, username: $testString, age: $testString, gender: $testString, email: $testString, providerID: $testString, provider: $testString).preferredColorScheme(.dark)
    }
}


//
//  LoginView.swift
//  Lunar
//
//  Created by Jacob Lucas on 12/25/21.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var name: String = ""
    @State var username: String = ""
    @State var age: String = ""
    @State var gender: String = "Male"
    @State var provider: String = ""
    @State var providerID: String = ""
    
    @State var showAccountCreationView: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 14) {
                Text("SIGN IN WITH EMAIL")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.systemGray))
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(height: 40)
                        .foregroundColor(Color(.systemGray6))
                    TextField("Enter Email", text: $email)
                        .frame(width: UIScreen.main.bounds.width - 70)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(height: 40)
                        .foregroundColor(Color(.systemGray6))
                    SecureField("Enter Password", text: $password)
                        .frame(width: UIScreen.main.bounds.width - 70)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                Button {
                    self.newUserWithEmail(email: email, password: password)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 44)
                        if AuthService.instance.loading {
                            ProgressView()
                        } else {
                            Text("Continue")
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                    }
                }
//                .disabled(email == "" || password == "" ? true : false)
                NavigationLink(destination: ForgotPasswordView()) {
                    Text("I forgot my password")
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .foregroundColor(.accentColor)
                }
                Text("SIGN IN WITH APPLE")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.systemGray))
                    .padding(.top, 40)
                Button {
                    SignInWithApple.instance.startSignInWithAppleFlow(view: self)
                } label: {
                    SignInWithAppleButton()
                        .frame(height: 44)
                }
                .padding(.bottom)
            }
            VStack {
                Text("Lunar")
                    .font(.system(size: 24))
                    .fontWeight(.medium)
                Spacer()
                Text("By Signing in to Lunar, you are agreeing to the Privacy Policy and Terms and Conditions.")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.systemGray))
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical)
        }
        .frame(width: UIScreen.main.bounds.width - 50)
        .ignoresSafeArea(.keyboard)
        .fullScreenCover(isPresented: $showAccountCreationView, onDismiss: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            AccountCreationView(name: $name, username: $username, age: $age, gender: $gender, email: $email, providerID: $providerID, provider: $provider)
        }
    }
    
    func newUserWithEmail(email: String, password: String) {
        AuthService.instance.createAccountWithEmail(email: email, password: password) { success in
            if success {
                self.showAccountCreationView.toggle()
            }
        }
    }
    
    func connectToFirebase(name: String, email: String, provider: String, credential: AuthCredential) {
        AuthService.instance.logInUserToFirebase(credential: credential) { (providerID, isError, isNewUser, userID) in
            if let newUser = isNewUser {
                if newUser {
                    if let providerID = providerID, !isError {
                        self.name = name
                        self.email = email
                        self.providerID = providerID
                        self.provider = provider
                        self.showAccountCreationView.toggle()
                    } else {
                        print("Error getting provider ID from log in user to Firebase")
                    }
                } else {
                    if let userID = userID {
                        AuthService.instance.logInUserToApp(userID: userID) { (success) in
                            if success {
                                print("Successful log in existing user")
                                self.presentationMode.wrappedValue.dismiss()
                            } else {
                                print("Error logging existing user into our app")
                            }
                        }
                    } else {
                        print("Error getting USER ID from existing user to Firebase")
                    }
                }
            } else {
                print("Error getting into from log in user to Firebase")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

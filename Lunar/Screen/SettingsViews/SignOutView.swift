//
//  SignOutView.swift
//  Lunar
//
//  Created by Jacob Lucas on 1/20/22.
//

import SwiftUI

struct SignOutView: View {
    
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
                Text("Sign Out")
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
                        Text("adiós 👋")
                            .font(.title)
                            .fontWeight(.medium)
                        Spacer()
                    }
                }
                .listRowBackground(Color(UIColor.systemGroupedBackground))
                Section {
                    Button {
                        signOut()
                    } label: {
                        HStack {
                            Spacer()
                            Text("sign out")
                                .foregroundColor(Color(.label))
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    func signOut() {
        AuthService.instance.logOutUser { success in
            self.presentationMode.wrappedValue.dismiss()
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let defaultDirectory = UserDefaults.standard.dictionaryRepresentation()
                    defaultDirectory.keys.forEach { key in
                        UserDefaults.standard.removeObject(forKey: key)
                    }
                }
            } else {
                print("Error logging out")
            }
        }
    }
}

struct SignOutView_Previews: PreviewProvider {
    static var previews: some View {
        SignOutView()
    }
}

//
//  MenuView.swift
//  Lunar
//
//  Created by Jacob Lucas on 3/22/22.
//

import SwiftUI

struct MenuView: View {
    
    @State var toggleAnonymous: Bool = false
    @Binding var currentUserProfileImage: UIImage
    
    @AppStorage("user_id") var currentUserID: String?
    @AppStorage("name") var name: String?
    @Environment(\.presentationMode) var presentationMode
    @Binding var back: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack {
                HStack {
                    Button {
                        back.toggle()
                    } label: {
                        Text("Done")
                            .foregroundColor(Color(.label))
                    }
                    Spacer()
                }
                    Text("Menu")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(Color(.label))
                }
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 30)
                Form {
                    Section {
                        NavigationLink(destination: ProfileView(currentUserProfileImage: $currentUserProfileImage)) {
                            HStack(spacing: 15) {
                                Image(uiImage: currentUserProfileImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                VStack {
                                    if let name = name {
                                        Text(name)
                                            .font(.system(size: 20))
                                            .fontWeight(.medium)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    Section {
                        NavigationLink(destination: Text("NewView")) {
                            Label {
                                Text("Notifications")
                            } icon: {
                                Image(systemName: "bell")
                                    .foregroundColor(Color(.label))
                            }
                        }
                        NavigationLink(destination: SettingsView(currentUserProfileImage: $currentUserProfileImage)) {
                            Label {
                                Text("Settings")
                            } icon: {
                                Image(systemName: "gearshape")
                                    .foregroundColor(Color(.label))
                            }
                        }
                    }
                    Section(footer: Text("Toggling anonymous 'on' will hide your account from other users, however, your feed and nearby user screens will be disabled.")) {
                        Label {
                            Toggle(isOn: $toggleAnonymous) {
                                Text("Anonymous")
                            }
                            .tint(.accentColor)
                        } icon: {
                            Image(systemName: "theatermasks")
                                .foregroundColor(Color(.label))
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

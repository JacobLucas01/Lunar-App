//
//  SettingsView.swift
//  Lunar
//
//  Created by Jacob Lucas on 12/27/21.
//

import SwiftUI

struct SettingsView: View {
    
    @State var toggleAnonymous: Bool = false
    @Binding var currentUserProfileImage: UIImage
    
    @AppStorage("user_id") var currentUserID: String?
    @AppStorage("name") var name: String?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
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
                    Text("Settings")
                        .font(.system(size: 20))
                        .foregroundColor(Color(.label))
                        .fontWeight(.medium)
                }
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 30)
                Form {
                    Section {
                        NavigationLink(destination: Text("NewView")) {
                            Label {
                                Text("Notifications")
                            } icon: {
                                Image(systemName: "bell")
                                    .foregroundColor(Color(.label))
                            }
                        }
                        NavigationLink(destination: SystemDisplayView()) {
                            Label {
                                Text("System Display")
                            } icon: {
                                Image(systemName: "sun.max")
                                    .foregroundColor(Color(.label))
                            }
                        }
                        NavigationLink(destination: Text("NewView")) {
                            Label {
                                Text("Chats")
                            } icon: {
                                Image(systemName: "message")
                                    .foregroundColor(Color(.label))
                            }
                        }
                    }
                    Section {
                        NavigationLink(destination: Text("NewView")) {
                            Label {
                                Text("Blocked")
                            } icon: {
                                Image(systemName: "hand.raised")
                                    .foregroundColor(Color(.label))
                            }
                        }
                        NavigationLink(destination: Text("NewView")) {
                            Label {
                                Text("User Data")
                            } icon: {
                                Image(systemName: "archivebox")
                                    .foregroundColor(Color(.label))
                            }
                        }
                        NavigationLink(destination: Text("NewView")) {
                            Label {
                                Text("Privacy")
                            } icon: {
                                Image(systemName: "lock")
                                    .foregroundColor(Color(.label))
                            }
                        }
                    }
                    Section {
                        NavigationLink(destination: Text("NewView")) {
                            Label {
                                Text("Help")
                            } icon: {
                                Image(systemName: "questionmark")
                                    .foregroundColor(Color(.label))
                            }
                        }
                    }
                    Section() {
                        NavigationLink(destination: Text("NewView")) {
                            Label {
                                Text("Delete Account")
                            } icon: {
                                Image(systemName: "trash")
                                    .foregroundColor(Color(.label))
                            }
                        }
                    }
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    @State static var currentUserProfileImage: UIImage = UIImage(systemName: "person.crop.circle.fill")!
    
    static var previews: some View {
        SettingsView(currentUserProfileImage: $currentUserProfileImage).preferredColorScheme(.dark)
    }
}

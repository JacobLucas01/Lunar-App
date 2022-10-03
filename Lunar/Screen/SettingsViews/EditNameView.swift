//
//  EditNameView.swift
//  Lunar
//
//  Created by Jacob Lucas on 1/20/22.
//

import SwiftUI

struct EditNameView: View {
    
    @State var message: String = ""
    @State var title: String
    @State var placeholder: String
    @State var showSuccessAlert: Bool = false
    
    @AppStorage("user_id") var currentUserID: String?
    
    @Environment(\.presentationMode) var presentationMode
    
    let haptics = UINotificationFeedbackGenerator()
    
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
                Text("Edit Name")
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
                        Text(title)
                            .font(.title)
                            .fontWeight(.medium)
                        Spacer()
                    }
                }
                .listRowBackground(Color(UIColor.systemGroupedBackground))
                Section {
                    ZStack {
                        TextField("Enter new name", text: $message)
                            .multilineTextAlignment(TextAlignment.center)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                    }
                    HStack {
                        Spacer()
                    Button {
                        if textIsAppropriate() {
                            saveText()
                        }
                    } label: {
                        Text("Update Name")
                            .foregroundColor(Color(.label))
                    }
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .alert(isPresented: $showSuccessAlert) { () -> Alert in
            return Alert(title: Text("Saved Successfully"), message: nil, dismissButton: .default(Text("OK"), action: {
                dismissView()
            }))
        }
    }
    func dismissView() {
        self.haptics.notificationOccurred(.success)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func textIsAppropriate() -> Bool {
        // Check if the text has curses
        // Check if the text is long enough
        // Check if the text is blank
        // Check for innapropriate things
        
        
        // Checking for bad words
        let badWordArray: [String] = ["shit", "ass"]
        
        let words = message.components(separatedBy: " ")
        
        for word in words {
            if badWordArray.contains(word) {
                return false
            }
        }
        
        // Checking for minimum character count
        if message.count < 3 {
            return false
        }
        
        return true
    }
    
    func saveText() {
        guard let userID = currentUserID else { return }
        
        // Update the UI
        self.title = message
        
        // Update user defaults
        UserDefaults.standard.setValue(message, forKey: "name")
        
        // Update on all user posts
        DataService.instance.updateDisplayNameOnPosts(userID: userID, name: message)
        
        // Update on all user's profile in DB
        AuthService.instance.updateUserDisplayName(userID: userID, name: message) { success in
            self.showSuccessAlert.toggle()
        }
    }
}

struct EditNameView_Previews: PreviewProvider {
    static var previews: some View {
        EditNameView(title: "Jacob Lucas", placeholder: "Jacob Lucas")
    }
}

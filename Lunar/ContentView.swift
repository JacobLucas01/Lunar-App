//
//  ContentView.swift
//  Lunar
//
//  Created by Jacob Lucas on 12/25/21.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @AppStorage("user_id") var currentUserID: String?
    
    var body: some View {
        if currentUserID != nil {
            FeedView()
        } else if currentUserID == nil {
            NavigationView {
                LoginView()
                    .navigationBarHidden(true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

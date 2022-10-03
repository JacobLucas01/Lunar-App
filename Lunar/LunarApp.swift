//
//  LunarApp.swift
//  Lunar
//
//  Created by Jacob Lucas on 12/25/21.
//

import SwiftUI
import FirebaseCore

@main
struct LunarApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

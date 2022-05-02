//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Tejas Gupta on 4/2/22.
//

import SwiftUI
import Firebase

@main
struct MemorizeApp: App {
    @State private var isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
    
    init() {
        FirebaseApp.configure()
        UserDefaults.standard.set(false, forKey: "logged_in")
        print("IS LOGGED IN " + String(isLoggedIn))
    }
    
//    @State var isLoggedIn: Bool = false
    var body: some Scene {
        WindowGroup {
            if !isLoggedIn { LoginView(isLoggedIn: self.$isLoggedIn) }
            else { HomeView(isLoggedIn: self.$isLoggedIn) }
        }
//        WindowGroup {
//            if !isLoggedIn { LoginView() }
//            else { HomeView() }
//        }
    }
}

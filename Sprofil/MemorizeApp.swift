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
    init() {
        FirebaseApp.configure()
    }
    @State private var isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
//    @State var isLoggedIn: Bool = false
    var body: some Scene {
        WindowGroup {
            if !isLoggedIn { LoginView(isLoggedIn: self.$isLoggedIn) }
            else { HomeView(isLoggedIn: self.$isLoggedIn) }
        }
    }
}
//
//static func main() {
//    FirebaseApp.configure()
//}

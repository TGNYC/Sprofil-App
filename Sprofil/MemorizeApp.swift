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
    @ObservedObject var appState = AppState()
        var body: some Scene {
            WindowGroup {
                if (!AuthManager.shared.isSignedIn) { LoginView().environmentObject(appState) }
                else { HomeView().environmentObject(appState) }
        }
    }
}
//
//static func main() {
//    FirebaseApp.configure()
//}

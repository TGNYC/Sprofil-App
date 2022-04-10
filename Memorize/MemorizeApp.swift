//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Tejas Gupta on 4/2/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @State var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if !isLoggedIn { LoginView(isLoggedIn: self.$isLoggedIn) }
            else { HomeView(isLoggedIn: self.$isLoggedIn) }
        }
    }
}

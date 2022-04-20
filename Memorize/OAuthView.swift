//
//  OAuthView.swift
//  Memorize
//
//  Created by Tejas Gupta on 4/20/22.
//

import Foundation
import SwiftUI
import BetterSafariView

struct OAuthView: View {
    @Binding var isLoggedIn : Bool
    @State private var startingWebAuthenticationSession = false
    
    var body: some View {
        Button("Start WebAuthenticationSession") {
            self.startingWebAuthenticationSession = true
        }
        .webAuthenticationSession(isPresented: $startingWebAuthenticationSession) {
            WebAuthenticationSession(
                url: AuthManager.shared.signInURL!,
//                callbackURLScheme: "sprofil://spotify-login-callback".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//                callbackURLScheme: AuthManager.Constants.redirectURI
                callbackURLScheme: "sprofil"
            ) { callbackURL, error in
//                guard error == nil, let callbackURL = callbackURL else { return }

                // The callback URL format depends on the provider. For this example:
                //   exampleauth://auth?token=1234
//                let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
//                let token = queryItems?.filter({ $0.name == "token" }).first?.value
                print("PRINTING")
                print(callbackURL ?? "TEST URL")
                guard let code = URLComponents(string: callbackURL!.absoluteString)?.queryItems?.first(where: { $0.name == "code"  })?.value
                else {
                    return
                }
                print("Code: \(code)")
            }
        }
    }
}

//
//  ContentView.swift
//  Memorize
//
//  Created by Tejas Gupta on 4/2/22.
//

import SwiftUI

/*
struct ResultView: View {
    var choice: String
    var body: some View {
        Text("You choose \(choice)")
    }
}
*/

struct LoginView: View {
    @State private var isShowingSignInWebView = false
//    @Binding var isLoggedIn : Bool
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "person.crop.circle.fill")
                    .foregroundColor(Color.green)
                    .font(.system(size: 150))
                
                Text("MySpot")
                    .font(.system(size: 80, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(Color.green)
                    .padding(.bottom)
                
                Text("MySpot allows you to share and view others' tastes in music. Create a Profile by logging in below and sharing your top tracks and artists.")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding([.leading, .bottom, .trailing])
                
                NavigationLink(destination: AuthView().id(appState.rootViewId) ) {
//                    EmptyView()
                    Text("Login With Spotify")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(40)
                        .padding(10)
                }
                
//                Button("Login with Spotify") {
//                    self.isShowingSignInWebView = true
//                }
//                    .fontWeight(.bold)
//                    .font(.title)
//                    .padding()
//                    .background(Color.green)
//                    .foregroundColor(.white)
//                    .cornerRadius(40)
//                    .padding(10)
                
//                Button(self.isShowingSignInWebView = true) {
//                    Text("Login With Spotify")
//                        .fontWeight(.bold)
//                        .font(.title)
//                        .padding()
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(40)
//                        .padding(10)
//                }
                
            }
            .navigationBarHidden(true)
        }
    }
}



//struct LoginFormView : View {
//    @Binding var isLoggedIn: Bool
//
//    var body: some View {
//        NavigationView {
////            OAuthView(isLoggedIn: self.$isLoggedIn)
//            AuthView(isLoggedIn: self.$isLoggedIn)
//        }
//    }
//
//    var body: some View {
//        if !isLoggedIn {
//            NavigationView {
//                AuthView(isLoggedIn: self.$isLoggedIn)
//                    .navigationBarHidden(true)
//                    .navigationBarBackButtonHidden(true)
////                    .navigationBarTitle("Sign In", displayMode: .inline)
//            }
//
//        } else {
//            NavigationView {
//                Text("Logged In")
//                    .navigationBarHidden(true)
//                    .navigationBarBackButtonHidden(true)
////                    .navigationBarTitle("Home Screen", displayMode: .large)
//            }
//        }
//        .navigationBarHidden(true)
//        .navigationBarTitle("Sign In", displayMode: .inline)
        
//    }
//}
//
///// Code for Live Preview (ignore)
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(isLoggedIn: self.$isLoggedIn)
//    }
//}

//
//  HomeView.swift
//  Memorize
//
//  Created by Tejas Gupta on 4/4/22.
//

import SwiftUI

struct HomeView: View {
    @Binding var isLoggedIn : Bool
    
    var tracks = APICaller.shared.trackList
    
    var body: some View {
        if isLoggedIn {
            TabView {
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text("Profile")
                    }
                ExploreView()
                    .tabItem {
                        Image(systemName: "safari")
                        Text("Explore")
                    }
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                SettingsView(isLoggedIn: self.$isLoggedIn)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
            .font(.headline)
        } else {
            LoginView(isLoggedIn: self.$isLoggedIn)
        }
        
//
//        VStack {
//            Text("UserID: \(APICaller.shared.userID ?? "nil")")
//            Text("Top Tracks (out of \(tracks.count)):")
////            ForEach(0 ..< APICaller.shared.myTopTracks!.items.count, id: \.self) { value in
////                Text(String(value))
////            }
//
////            ForEach((1...10), id: \.54 self) {
////                Text("Track \($0): \(tracks[0].name)")
//////                    Text("\($0)…")
////            }
//            Button("Log Out") {
//                self.isLoggedIn = false
//            }
//
//        }
    }
}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

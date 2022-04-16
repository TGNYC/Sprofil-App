//
//  ProfileView.swift
//  Shared
//
//  Created by Ben Shi on 2/21/22.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @StateObject var firebase = FirebaseAPI()
    let gradient = Gradient(colors: [.orange, .purple])
    let ref = Database.database().reference()
    let userID = AuthManager.shared.userID ?? "100000"
    
//    func ObserveChanges() {
//        ref.child("Users").child(String(userID)).child("WIP").observe(.childChanged, with: { (snapshot) in
//            if snapshot.value as! String == "True" {
//                topArtistsStatus = true
//            }
//            else {
//                topArtistsStatus = false
//            }
//        })
//    }
    
    var body: some View {
        if firebase.loading {
            LoadingView()
        }
        else {
            VStack {
                ProfTitleView(firebase: firebase)
                ScrollView {
                    if firebase.GetWidgetStatus(widgetName: "TopArtists") {
                        TopArtistsView(firebase: firebase)
                    }
                    if firebase.GetWidgetStatus(widgetName: "TopTracks") {
                        TopTracksView(firebase: firebase)
                    }
                    if firebase.GetWidgetStatus(widgetName: "TopAlbums") {
                        TopAlbumsView(firebase: firebase)
                    }
                }
//                .onRefresh(spinningColor: .white, text: "Pull to refresh", textColor: .white, backgroundColor: Color.orange) { refreshControl in
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                refreshControl.endRefreshing()
//                            }
//                        }
            }
            .background(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
        }
    }
}

struct ProfTitleView: View {
    let firebase : FirebaseAPI
    var body: some View {
        VStack {
            Image("Drake")
             .resizable()
             .aspectRatio(contentMode: .fill)
             .frame(width: 180, height: 180)
             .clipShape(RoundedRectangle(cornerSize: CGSize(width: 30,height: 30)))
             .clipped()
             .padding(.top, 4)
            Text(firebase.GetProfName())
                .font(.system(size: 20)
                        .bold())
                .foregroundColor(.white)
                .padding(.top, 8)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}


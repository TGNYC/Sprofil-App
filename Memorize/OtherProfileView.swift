//
//  OtherProfileView.swift
//  Sprofil
//
//  Created by Ben Shi on 3/31/22.
//

import SwiftUI

struct OtherProfileView: View {
    @StateObject var firebase = FirebaseAPI()
    let profName: String
    
    init(profName: String) {
        self.profName = profName
    }
    
    let gradient = Gradient(colors: [.orange, .purple])
    var body: some View {
        if firebase.loading {
            LoadingView()
        }
        else {
            VStack {
                OtherProfTitleView(firebase: firebase, profName: profName)
                ScrollView {
                    if firebase.GetOtherWidgetStatus(widgetName: "TopArtistsShort", userID: firebase.GetUserID(profName: profName)) {
                    OtherTopArtistsViewShort(firebase: firebase, profName: profName)
                    }
                    if firebase.GetOtherWidgetStatus(widgetName: "TopArtists", userID: firebase.GetUserID(profName: profName)) {
                    OtherTopArtistsView(firebase: firebase, profName: profName)
                    }
                    if firebase.GetOtherWidgetStatus(widgetName: "TopArtistsLong", userID: firebase.GetUserID(profName: profName)) {
                    OtherTopArtistsViewLong(firebase: firebase, profName: profName)
                    }
                    if firebase.GetOtherWidgetStatus(widgetName: "TopTracksShort", userID: firebase.GetUserID(profName: profName)) {
                        OtherTopTracksViewShort(firebase: firebase, profName: profName)
                    }
                    if firebase.GetOtherWidgetStatus(widgetName: "TopTracks", userID: firebase.GetUserID(profName: profName)) {
                        OtherTopTracksView(firebase: firebase, profName: profName)
                    }
                    if firebase.GetOtherWidgetStatus(widgetName: "TopTracksLong", userID: firebase.GetUserID(profName: profName)) {
                        OtherTopTracksViewLong(firebase: firebase, profName: profName)
                    }
                    if firebase.GetOtherWidgetStatus(widgetName: "FavoriteGenre", userID: firebase.GetUserID(profName: profName)) {
                        OtherFavoriteGenreView(firebase: firebase, profName: profName)
                    }
                }
                Spacer()
            }
            .background(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
        }
    }
}

struct OtherProfTitleView: View {
    let firebase : FirebaseAPI
    let profName : String
    @State var isFriend : Bool
    
    init(firebase: FirebaseAPI, profName: String) {
        self.firebase = firebase
        self.profName = profName
        isFriend = firebase.IsFriend(userID: firebase.GetUserID(profName: profName))
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: firebase.GetOtherProfPic(profName: profName))) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
             .aspectRatio(contentMode: .fill)
             .frame(width: 180, height: 180)
             .clipShape(RoundedRectangle(cornerSize: CGSize(width: 30,height: 30)))
             .clipped()
             .padding(.top, 4)
            Text(profName)
                .font(.system(size: 20)
                        .bold())
                .foregroundColor(.white)
                .padding(.top, 8)
            Text(firebase.GetOtherProfTitle(userID: firebase.GetUserID(profName: profName)))
                .font(.system(size: 15)
                        .bold())
                .foregroundColor(.white)
            Text(firebase.GetOtherBio(userID: firebase.GetUserID(profName: profName)))
                .font(.system(size: 12))
                .foregroundColor(.white)
            HStack {
            Button(action: {
                firebase.AddFriend(profName: profName)
                isFriend = true
            }, label:{
                Text("Add Friend")
            })
                .padding()
                .padding(.horizontal, 5)
                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 20)
                .background(.ultraThinMaterial)
                .cornerRadius(50)
                .disabled(isFriend)
            Button(action: {
                    firebase.RemoveFriend(profName: profName)
                    isFriend = false
                }, label:{
                    Text("Remove Friend")
                })
                    .padding()
                    .padding(.horizontal, 5)
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 20)
                    .background(.ultraThinMaterial)
                    .cornerRadius(50)
                    .disabled(!isFriend)
            }
        }
    }
}

struct OtherProfileView_Previews: PreviewProvider {
    static var previews: some View {
        OtherProfileView(profName: "SDLFKSJDF:LK")
    }
}

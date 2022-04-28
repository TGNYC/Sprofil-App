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
    @State var id = 0
    @State var showFriends: Bool = false
    let gradient = Gradient(colors: [.orange, .purple])
    let userID = AuthManager.shared.userID ?? "test_values"
    
    var body: some View {
        if firebase.loading {
            LoadingView()
        }
        else {
            ZStack {
                VStack {
                    ProfTitleView(firebase: firebase)
                    HStack {
                        Button(action: {
                            showFriends = true
                        }, label: {
                            Text("Friends")
                                .foregroundColor(.white)
                        })
                            .sheet(isPresented: $showFriends) {
                                FriendListView(firebase: firebase)
                        }
                            .padding()
                            .padding(.horizontal, 5)
                            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 20)
                            .background(.ultraThinMaterial)
                            .cornerRadius(50)
                    }
                    ScrollView
                    {
                        if firebase.GetWidgetStatus(widgetName: "TopArtistsShort") {
                            TopArtistsViewShort(firebase: firebase)
                        }
                        if firebase.GetWidgetStatus(widgetName: "TopArtists") {
                            TopArtistsView(firebase: firebase)
                        }
                        if firebase.GetWidgetStatus(widgetName: "TopArtistsLong") {
                            TopArtistsViewLong(firebase: firebase)
                        }
                        if firebase.GetWidgetStatus(widgetName: "TopTracksShort") {
                            TopTracksViewShort(firebase: firebase)
                        }
                        if firebase.GetWidgetStatus(widgetName: "TopTracks") {
                            TopTracksView(firebase: firebase)
                        }
                        if firebase.GetWidgetStatus(widgetName: "TopTracksLong") {
                            TopTracksViewLong(firebase: firebase)
                        }
                        if firebase.GetWidgetStatus(widgetName: "TopAlbums") {
                            TopAlbumsView(firebase: firebase)
                        }
                        if firebase.GetWidgetStatus(widgetName: "FavoriteGenre") {
                            FavoriteGenreView(firebase: firebase)
                        }
                    }
                }
            }
            .background(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
        }
    }
}

struct ProfTitleView: View {
    @StateObject var firebase : FirebaseAPI
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: firebase.GetProfPic())) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
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
            Text(firebase.GetProfTitle())
                .font(.system(size: 15)
                        .bold())
                .foregroundColor(.white)
            Text(firebase.GetBio())
                .font(.system(size: 12))
                .foregroundColor(.white)
//                .padding()
        }
    }
}

struct FriendListView: View {
    var firebase: FirebaseAPI
    var body: some View {
        NavigationView {
            List {
                if firebase.GetFriendList().count == 0 || firebase.GetFriendList().count == 1 {
                    Text("You have no Friends! Head over to Explore or Search to find some!")
                        .multilineTextAlignment(.center)
                }
                else {
                ForEach(firebase.GetFriendList(), id: \.self) { item in
                    if item != "NULL"{
                    NavigationLink(destination: OtherProfileView(profName: item)) {
                        HStack(alignment: .top, spacing: 12) {
                            AsyncImage(url: URL(string: firebase.GetOtherProfPic(profName: item))) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 44, height: 44)
                            .background(Color("Background"))
                            .mask(Circle())
                            VStack {
                                Text(item).bold()
                                Text("Description")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                        .listRowSeparator(.hidden)
                    }
                    }
                }
            }
        }
            .navigationBarTitle("Friend List", displayMode: .inline)
    }
}
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}



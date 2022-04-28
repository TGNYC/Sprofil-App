//
//  SettingsView.swift
//  Sprofil (iOS)
//
//  Created by Ben Shi on 3/21/22.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var firebase = FirebaseAPI()
    var body: some View {
        if firebase.loading {
            LoadingView()
        }
        else {
        NavigationView {
            Form {
                Section(header: Text("Profile Settings")) {
                    NavigationLink(destination: WidgetsView(firebase: firebase)) {
                        FormRowStaticView(icon: "pencil", text: "Widget Settings", ifDetailed: true) }
                    NavigationLink(destination: UserView(firebase: firebase)) {
                    FormRowStaticView(icon: "person.fill", text: "User Settings", ifDetailed: true)
                    }
                }
            }
            .navigationTitle("Settings")
        }
        }
    }
}

struct WidgetsView: View {
    var firebase : FirebaseAPI
    @State var topArtists : Bool
    @State var topArtistsShort : Bool
    @State var topArtistsLong : Bool
    @State var topAlbums : Bool
    @State var topTracks : Bool
    @State var topTracksShort : Bool
    @State var topTracksLong : Bool
    @State var favoriteGenre : Bool
    
    init(firebase: FirebaseAPI) {
        self.firebase = firebase
        self.topArtists = firebase.GetWidgetStatus(widgetName: "TopArtists")
        self.topArtistsShort = firebase.GetWidgetStatus(widgetName: "TopArtistsShort")
        self.topArtistsLong = firebase.GetWidgetStatus(widgetName: "TopArtistsLong")
        self.topAlbums = firebase.GetWidgetStatus(widgetName: "TopAlbums")
        self.topTracks = firebase.GetWidgetStatus(widgetName: "TopTracks")
        self.topTracksShort = firebase.GetWidgetStatus(widgetName: "TopTracksShort")
        self.topTracksLong = firebase.GetWidgetStatus(widgetName: "TopTracksLong")
        self.favoriteGenre = firebase.GetWidgetStatus(widgetName: "FavoriteGenre")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Widgets")) {
                    Toggle(isOn: $topArtists, label: { Text("Top Artists - Last 6 Months")} ).onChange(of: topArtists) { _topArtists in
                        firebase.EditWidgetStatus(onOff: _topArtists, widgetName: "TopArtists")
                    }
                    Toggle(isOn: $topArtistsShort, label: { Text("Top Artists - Last Month")} ).onChange(of: topArtistsShort) { _topArtistsShort in
                        firebase.EditWidgetStatus(onOff: _topArtistsShort, widgetName: "TopArtistsShort")
                    }
                    Toggle(isOn: $topArtistsLong, label: { Text("Top Artists - Lifetime")} ).onChange(of: topArtistsLong) { _topArtistsLong in
                        firebase.EditWidgetStatus(onOff: _topArtistsLong, widgetName: "TopArtistsLong")
                    }
                    Toggle(isOn: $topTracks, label: { Text("Top Tracks - Last 6 Months")} ).onChange(of: topTracks) { _topTracks in
                        firebase.EditWidgetStatus(onOff: _topTracks, widgetName: "TopTracks")
                    }
                    Toggle(isOn: $topTracksShort, label: { Text("Top Tracks - Last Month")} ).onChange(of: topTracksShort) { _topTracksShort in
                        firebase.EditWidgetStatus(onOff: _topTracksShort, widgetName: "TopTracksShort")
                    }
                    Toggle(isOn: $topTracksLong, label: { Text("Top Tracks - Lifetime")} ).onChange(of: topTracksLong) { _topTracksLong in
                        firebase.EditWidgetStatus(onOff: _topTracksLong, widgetName: "TopTracksLong")
                    }
                    Toggle(isOn: $favoriteGenre, label: { Text("Favorite Genre")} ).onChange(of: favoriteGenre) { _favoriteGenre in
                        firebase.EditWidgetStatus(onOff: _favoriteGenre, widgetName: "FavoriteGenre")
                    }
                    Toggle(isOn: $topAlbums, label: { Text("Top Albums")} ).onChange(of: topAlbums) { _topAlbums in
                        firebase.EditWidgetStatus(onOff: _topAlbums, widgetName: "TopAlbums")
                    }
                }
            }
            .navigationTitle("Widget Settings")
        }
    }
}

struct UserView: View {
    var firebase : FirebaseAPI
    @State var profName: String
    @State var bio: String {
        didSet {
            if bio.count > 40 {
                bio = String(bio.prefix(40))
                firebase.EditBio(newBio: bio)
            }
        }
    }
    @State var isPrivate: Bool
    
    init(firebase: FirebaseAPI) {
        self.firebase = firebase
        profName = firebase.GetProfName()
        bio = firebase.GetBio()
        isPrivate = firebase.GetIsPrivateStatus()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Change Your Profile Name Here:")) {
                    TextField(text: $profName) {
                        Text("ProfName")
                    }
                    .onChange(of: profName) {
                        _profName in
                        firebase.EditProfName(newName: _profName)
                    }
                }
                Section(header: Text("Change Your Bio Here:")) {
//                    TextField(text: $bio) {
//                        Text("Bio").font(.body)
//                    }
                    TextEditor(text: $bio)
                    .font(.body)
                    .frame(height: 100)
                    .onChange(of: bio) {
                        _bio in
                        firebase.EditBio(newBio: _bio)
                    }
                }
                // NOTE: NEED TO CHANGE IT SO THAT FRIENDS ARE STILL ABLE TO SEE YOU, NEED TO NOT USE THE USERNAMES BRANCH AS ID to USERNAME THING
                Section(header: Text("Toggle Privacy Mode:")) {
                    Toggle(isOn: $isPrivate, label: { Text("Private Mode")} ).onChange(of: isPrivate) { _isPrivate in
                        firebase.EditIsPrivateStatus(onOff: _isPrivate)
                    }
                    Text("Private Mode allows you to be hidden from search results and the explore page, but your friends will still be able to see you.").font(.caption)
                }
            }
        }
    }
}

struct FormRowStaticView: View {
    var icon: String
    var text: String
    var ifDetailed : Bool
    
    var body: some View {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.gray)
                    Image(systemName: icon)
                        .foregroundColor(Color.white)
                }
                .frame(width: 36, height: 36, alignment: .center)
                Text(text)
                    .foregroundColor(.black)
                    .offset(x:5)
                if (ifDetailed) {
                    Spacer()
                    // INSERT ARROW SYMBOL HERE
                }
            }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

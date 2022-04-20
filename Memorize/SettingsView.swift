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
    @State var topAlbums : Bool
    @State var topTracks : Bool
    @State var funFacts : Bool
    
    init(firebase: FirebaseAPI) {
        self.firebase = firebase
        self.topArtists = firebase.GetWidgetStatus(widgetName: "TopArtists")
        self.topAlbums = firebase.GetWidgetStatus(widgetName: "TopAlbums")
        self.topTracks = firebase.GetWidgetStatus(widgetName: "TopTracks")
        self.funFacts = firebase.GetWidgetStatus(widgetName: "FunFacts")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Widgets")) {
                    Toggle(isOn: $topArtists, label: { Text("Top Artists")} ).onChange(of: topArtists) { _topArtists in
                        firebase.EditWidgetStatus(onOff: _topArtists, widgetName: "TopArtists")
                    }
                    Toggle(isOn: $topAlbums, label: { Text("Top Albums")} ).onChange(of: topAlbums) { _topAlbums in
                        firebase.EditWidgetStatus(onOff: _topAlbums, widgetName: "TopAlbums")
                    }
                    Toggle(isOn: $topTracks, label: { Text("Top Tracks")} ).onChange(of: topTracks) { _topTracks in
                        firebase.EditWidgetStatus(onOff: _topTracks, widgetName: "TopTracks")
                    }
                    Toggle(isOn: $funFacts, label: { Text("Fun Facts")} ).onChange(of: funFacts) { _funFacts in
                        firebase.EditWidgetStatus(onOff: _funFacts, widgetName: "FunFacts")
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
    @State var bio: String
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
                Section(header: Text("Change your Bio Here:")) {
                TextField(text: $bio) {
                    Text("Bio")
                }
                .onChange(of: bio) {
                    _bio in
                    firebase.EditBio(newBio: _bio)
                }
                }
                // NOTE: NEED TO CHANGE IT SO THAT FRIENDS ARE STILL ABLE TO SEE YOU, NEED TO NOT USE THE USERNAMES BRANCH AS ID to USERNAME THING
                Section(header: Text("Private Mode allows you to be hidden from search results and the explore page, but your Friends will still be able to see you.")) {
                    Toggle(isOn: $isPrivate, label: { Text("Private Mode")} ).onChange(of: isPrivate) { _isPrivate in
                        firebase.EditIsPrivateStatus(onOff: _isPrivate)
                    }
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

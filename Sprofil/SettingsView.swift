//
//  SettingsView.swift
//  Sprofil (iOS)
//
//  Created by Ben Shi on 3/21/22.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var firebase = FirebaseAPI()
    @EnvironmentObject var appState: AppState
    
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
                
                Section(header: Text("App Settings")) {
                    Button(action: {
                            UserDefaults.standard.set(nil, forKey: "user_id")
                            UserDefaults.standard.set(nil, forKey: "user_email")
                            UserDefaults.standard.set(nil, forKey: "refresh_token")
                            UserDefaults.standard.set(nil, forKey: "expirationDate")
                            UserDefaults.standard.set(nil, forKey: "access_token")
                            print("Log out tapped")
                            print("Sign in state: " + String(AuthManager.shared.isSignedIn))
                            appState.rootViewId = UUID()
                    }) { Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right") }
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
                }
                
                
                .navigationTitle("Settings")
            }
            .navigationTitle("Widget Settings")
        }
    }
}

struct UserView: View {
    var firebase : FirebaseAPI
    @State var profName: String
    @State private var showProfChange = false
    @State private var showInvalidName = false
    @State var bio: String
    @State var isPrivate: Bool
    
    init(firebase: FirebaseAPI) {
        self.firebase = firebase
        profName = firebase.GetProfName()
        bio = firebase.GetBio()
        isPrivate = firebase.GetIsPrivateStatus()
    }
    
    func validateName(name: String, firebase: FirebaseAPI) -> Bool {
        let lengthValidation: Bool = name.count < 15
        let existingValidation: Bool = firebase.ExistingProfileName(name: name)
        let charset = CharacterSet(charactersIn: ".#$[]/")
        let illegalCharValidation: Bool
        if name.rangeOfCharacter(from: charset) == nil {
            illegalCharValidation = true
        }
        else {
            illegalCharValidation = false
        }
        
        print("LENGTH VALIDATION IS " + String(lengthValidation))
        print("EXISTING VALIDATION IS " + String(existingValidation))
        print("ILLEGAL CHAR VAL IS " + String(illegalCharValidation))
        
        if lengthValidation && existingValidation && illegalCharValidation {
            return true
        }
        else {
            return false
        }
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Change Your Profile Name Here:")) {
                    Button("Press To Change", action: {
                        showProfChange = true
                    })
                        .alert(isPresented: $showProfChange, TextAlert(title: "Name Change", message: "Enter your new profile name:") { result in
                            if validateName(name: result ?? "/", firebase: firebase) {
                                firebase.EditProfName(newName: result ?? "NULL")
                            }
                            else {
                                showInvalidName = true
                            }
                        })
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
                        }.alert(isPresented: $showInvalidName) {
                            Alert(title: Text("Invalid Profile Name"), message: Text("Profile Name either contains invalid characters, or already exists. Please choose a different one!"))
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

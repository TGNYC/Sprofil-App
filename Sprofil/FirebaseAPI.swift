//
//  DatabaseAPI.swift
//  Sprofil
//
//  Created by Ben Shi on 2/21/22.
//
// Temporary place to store this
import Foundation
import UIKit
import Firebase
import os

// Describing the possible errors that could be thrown
enum FirebaseErrors: Error {
    case ParameterOutOfRange
    case CannotRetrieveData
}

class FirebaseAPI: ObservableObject {
    @Published var ref : DatabaseReference!
    @Published var loading = true
    // NEED TO FIGURE OUT HOW TO GET THE SPOTIFY ID:
    var SPOTIFY_ID = AuthManager.shared.userID?.replacingOccurrences(of: ".", with: ",") ?? "p,gupta"
    var UserSnapshot: DataSnapshot?
    var AllUserSnapshot: DataSnapshot?
    var UsernameSnapshot: DataSnapshot?
    var PrivateUsersSnapshot: DataSnapshot?
    var ExploreListSnapshot: DataSnapshot?

    init() {
        ref = Database.database().reference()
        load()
    }
    func load() {
//        ref.observeSingleEvent(of: .value, with: { snapshot in
//            self.UserSnapshot = snapshot.childSnapshot(forPath: "Users/" + String(self.SPOTIFY_ID))
//            self.AllUserSnapshot = snapshot.childSnapshot(forPath: "Users")
//            self.UsernameSnapshot = snapshot.childSnapshot(forPath: "Usernames")
//            DispatchQueue.main.async { // perform assignments on the main thread
//                self.loading = false // loading finished
//            }
//        })
        ref.observe(.value, with: { snapshot in
            self.UserSnapshot = snapshot.childSnapshot(forPath: "Users/" + String(self.SPOTIFY_ID))
            self.AllUserSnapshot = snapshot.childSnapshot(forPath: "Users")
            self.UsernameSnapshot = snapshot.childSnapshot(forPath: "Usernames")
            self.PrivateUsersSnapshot = snapshot.childSnapshot(forPath: "PrivateUsers")
            self.ExploreListSnapshot = snapshot.childSnapshot(forPath: "ExploreList")
            DispatchQueue.main.async { // perform assignments on the main thread
                self.loading = false // loading finished
            }
        })
    }

    // NOTE: Alternatively, viewDidLoad function override could implement this as well.
    // The below functions are for WRITING data:
    // Takes in a new Widget Status for a particular widget, and sets the value in the database
    func EditWidgetStatus(onOff: Bool, widgetName: String) {
        if onOff {
            ref.child("Users").child(String(SPOTIFY_ID)).child("WIP").updateChildValues([widgetName : "True"])
        }
        else {
            ref.child("Users").child(String(SPOTIFY_ID)).child("WIP").updateChildValues([widgetName : "False"])
        }
    }

    // Takes in a new Settings Status for a particular setting, and sets the value in the database accordingly.
    func EditSettingsStatus(onOff: Bool, settingName: String) {
        ref.child("Users").child(String(SPOTIFY_ID)).child("Settings").updateChildValues([settingName: String(onOff)])
    }

    // Takes in a new Profile name, and sets the database value to match.
    func EditProfName(newName: String) {
        // FORMAT A
        ref.child("Users").child(String(SPOTIFY_ID)).updateChildValues(["ProfName": newName])
    }
    
    func CreateNewUser(accessToken: String) {
        // Widgets Settings
        ref.child("Users").child(String(accessToken)).child("WIP").setValue(["TopTracks": "True"])
        ref.child("Users").child(String(accessToken)).child("WIP").setValue(["TopAlbums": "True"])
        ref.child("Users").child(String(accessToken)).child("WIP").setValue(["TopArtists": "True"])
        ref.child("Users").child(String(accessToken)).child("WIP").setValue(["FunFacts": "True"])
        
        // ProfPic
        ref.child("Users").child(String(accessToken)).setValue(["ProfPic": "5"])
        // ProfName
        ref.child("Users").child(String(accessToken)).setValue(["ProfName": "Boberto"])
        // TopArtists
        ref.child("Users").child(String(accessToken)).child("TopArtists").setValue(["1": "Ben Shi"])
    }
    
    
    func ButtonPress() {
        if !IsExistingUser(accessToken: self.SPOTIFY_ID) {
            CreateNewUser(accessToken: self.SPOTIFY_ID)
        }
        load()
    }
//
//    func EditFavorite() {
//        // FORMAT A
//        ref.child("Users").child(String(SPOTIFY_ID)).child("FavoriteArtist")
//            .updateChildValues(["Score": GetFavoriteScore()+1])
//    }
    
    func GetFavoriteScore() -> Int {
        let value = UserSnapshot?.childSnapshot(forPath:"FavoriteArtist/Score").value as? Int
        return value ?? 4
    }

    // The below functions are for RETREIVING DATA:
    // Gets the Widget Status for a particular widget, returns an on or off value
    func GetWidgetStatus(widgetName: String) -> Bool {
        let value = UserSnapshot?.childSnapshot(forPath: "WIP").childSnapshot(forPath:widgetName).value as? String
        if (value == "True") {
            return true
        }
        return false
    }
    
    // Gets the Widget Status for a particular widget for another user, returns an on or off value
    func GetOtherWidgetStatus(widgetName: String, userID: String) -> Bool {
        let value = AllUserSnapshot?.childSnapshot(forPath: userID).childSnapshot(forPath: "WIP").childSnapshot(forPath:widgetName).value as? String
        if (value == "True") {
            return true
        }
        return false
    }

    // Gets the Setting Status for a particular setting, returns an on or off value
    func GetIsPrivateStatus() -> Bool {
        let value = UserSnapshot?.childSnapshot(forPath: "IsPrivate").value as? String
        if (value == "True") {
            return true
        }
        return false
    }
    
    func EditIsPrivateStatus(onOff: Bool) {
        if onOff {
            ref.child("Users").child(String(SPOTIFY_ID)).updateChildValues(["IsPrivate" : "True"])
        }
        else {
            ref.child("Users").child(String(SPOTIFY_ID)).updateChildValues(["IsPrivate" : "False"])
        }
    }
    
    func GetBio() -> String {
        return UserSnapshot?.childSnapshot(forPath: "Bio").value as? String ?? "NULL"
    }
    
    func GetOtherBio(userID: String) -> String {
        return AllUserSnapshot?.childSnapshot(forPath: userID).childSnapshot(forPath: "Bio").value as? String ?? "NULL"
    }
    
    func GetProfTitle() -> String {
        var topGenres: [String] = GetTopGenres()
        if topGenres.count == 0 {
            topGenres.append("Pop")
        }
        return topGenres[0] + " " + (UserSnapshot?.childSnapshot(forPath: "FavoriteGenre/Title").value as? String ?? "NULL")
    }
    
    func GetOtherProfTitle(userID: String) -> String {
        var topGenres: [String] = GetOtherTopGenres(userID: userID)
        if topGenres.count == 0 {
            topGenres.append("Pop")
        }
        return topGenres[0] + " " + (AllUserSnapshot?.childSnapshot(forPath: userID).childSnapshot(forPath: "FavoriteGenre/Title").value as? String ?? "NULL")
    }
    
    func GetOtherTopGenres(userID: String) -> [String] {
        var result: [String] = []
        for obj in AllUserSnapshot?.childSnapshot(forPath: userID).childSnapshot(forPath: "FavoriteGenre").children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj.childSnapshot(forPath: "genre").value as? String ?? "NULL")
        }
        return result
    }
    
    func GetExploreInfo() -> [UserInfo] {
        var result: [Any] = []
        for obj in ExploreListSnapshot?.children.allObjects as? [DataSnapshot] ?? [] {
            var temp: [String] = []
            temp.append(obj.key as String)
            temp.append(obj.value as? String ?? "NULL")
            result.append(temp)
        }
        
        var actualRes: [UserInfo] = []
        
        if (result.count > 0) {
        for obj in result {
            let newObj = obj as? [String] ?? []
            actualRes.append(UserInfo(userID: newObj[0] as String, imageURL: newObj[1] as String))
        }
        }
        return actualRes
    }

    func GetTopGenres() -> [String] {
        var result: [String] = []
        for obj in UserSnapshot?.childSnapshot(forPath: "FavoriteGenre").children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj.childSnapshot(forPath: "genre").value as? String ?? "NULL")
        }
        print(result)
        return result
    }
    
    func GetTopGenresScores() -> [Int] {
        var result: [Int] = []
        for obj in UserSnapshot?.childSnapshot(forPath: "FavoriteGenre").children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj.childSnapshot(forPath: "score").value as? Int ?? -1)
        }
        return result
    }
    
    func EditBio(newBio: String) {
        ref.child("Users").child(String(SPOTIFY_ID)).updateChildValues(["Bio" : newBio])
    }
    
    func ExistingProfileName(name: String) -> Bool {
             for obj in UsernameSnapshot?.children.allObjects as? [DataSnapshot] ?? [] {
                 if name == obj.key {
                     return false
                 }
             }
             return true
         }


    // Gets the custom username of the user, returned as a string
    func GetProfName() -> String {
        let value = UserSnapshot?.childSnapshot(forPath:"ProfName").value as? String
        return value ?? "No_Name"
    }
    
    func GetOtherProfName(userID: String) -> String {
        let value = AllUserSnapshot?.childSnapshot(forPath: userID).childSnapshot(forPath: "ProfName").value as? String ?? "No_Name"
        return value
    }
    
    func IsUserPrivate(profName: String) -> Bool {
        return PrivateUsersSnapshot?.hasChild(profName) ?? false
    }
    
    func GetNameList() -> [String] {
        var result: [String] = []
        for obj in UsernameSnapshot?.children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj.key as String)
        }
        for obj in result {
            if IsUserPrivate(profName: obj) {
                let firstIndex = result.firstIndex(of: obj) ?? -1
                if firstIndex != -1 {
                result.remove(at: firstIndex)
                }
            }
        }
        print(result)
        return result
    }
    
//    // GETTING THE TOP TRACKS
//    func GetTopTrackInfo() -> [[String]] {
//        var result: [[String]] = []
//        for obj in UserSnapshot?.childSnapshot(forPath: "trackDB").children.allObjects as? [DataSnapshot] ?? [] {
//            result.append([obj.childSnapshot(forPath: "0").value as? String ?? "NULL", obj.childSnapshot(forPath: "1").value as? String ?? "NULL"])
//        }
//        return result
//    }
//
//
//    // GETTING OTHER PEOPLE'S TOP TRACKS
//    func GetOtherTopTrackInfo(userID: String) -> [[String]] {
//        var result: [[String]] = []
//        for obj in AllUserSnapshot?.childSnapshot(forPath: userID).childSnapshot(forPath: "trackDB").children.allObjects as? [DataSnapshot] ?? [] {
//            result.append([obj.childSnapshot(forPath: "0").value as? String ?? "NULL", obj.childSnapshot(forPath: "1").value as? String ?? "NULL"])
//        }
//        return result
//    }
    
    func GetTopTrackInfo() -> [[Any]] {
        var result: [DataSnapshot] = []
        for obj in UserSnapshot?.childSnapshot(forPath: "FavoriteTrackData/items").children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj)
        }
        
        var actualRes: [[Any]] = []
        for obj in result {
            let info = ProcessTrackSnapshot(trackSnapshot: obj)
            // IN ORDER: trackName, artistsInfo, albumInfo, albumArtists, imageURL,
            // releaseDate, duration, explicit, linkToSpot, Popularity, previewURL
            actualRes.append(info)
        }
        return actualRes
    }
    
    func GetTopTrackInfoShort() -> [[Any]] {
        var result: [DataSnapshot] = []
        for obj in UserSnapshot?.childSnapshot(forPath: "FavoriteTrackData_short/items").children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj)
        }
        
        var actualRes: [[Any]] = []
        for obj in result {
            let info = ProcessTrackSnapshot(trackSnapshot: obj)
            // IN ORDER: trackName, artistsInfo, albumInfo, albumArtists, imageURL,
            // releaseDate, duration, explicit, linkToSpot, Popularity, previewURL
            actualRes.append(info)
        }
        return actualRes
    }
    
    func GetTopTrackInfoLong() -> [[Any]] {
        var result: [DataSnapshot] = []
        for obj in UserSnapshot?.childSnapshot(forPath: "FavoriteTrackData_long/items").children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj)
        }
        
        var actualRes: [[Any]] = []
        for obj in result {
            let info = ProcessTrackSnapshot(trackSnapshot: obj)
            // IN ORDER: trackName, artistsInfo, albumInfo, albumArtists, imageURL,
            // releaseDate, duration, explicit, linkToSpot, Popularity, previewURL
            actualRes.append(info)
        }
        return actualRes
    }
    
    func GetOtherTopTrackInfo(userID: String) -> [[Any]] {
        var result: [DataSnapshot] = []
        for obj in AllUserSnapshot?.childSnapshot(forPath: userID).childSnapshot(forPath: "FavoriteTrackData/items").children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj)
        }
        
        var actualRes: [[Any]] = []
        for obj in result {
            let info = ProcessTrackSnapshot(trackSnapshot: obj)
            // IN ORDER: trackName, artistsInfo, albumInfo, albumArtists, imageURL,
            // releaseDate, duration, explicit, linkToSpot, Popularity, previewURL
            actualRes.append(info)
        }
        return actualRes
    }
    
    func GetOtherTopTrackInfoShort(userID: String) -> [[Any]] {
        var result: [DataSnapshot] = []
        for obj in AllUserSnapshot?.childSnapshot(forPath: userID).childSnapshot(forPath: "FavoriteTrackData_short/items").children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj)
        }
        
        var actualRes: [[Any]] = []
        for obj in result {
            let info = ProcessTrackSnapshot(trackSnapshot: obj)
            // IN ORDER: trackName, artistsInfo, albumInfo, albumArtists, imageURL,
            // releaseDate, duration, explicit, linkToSpot, Popularity, previewURL
            actualRes.append(info)
        }
        return actualRes
    }
    
    func GetOtherTopTrackInfoLong(userID: String) -> [[Any]] {
        var result: [DataSnapshot] = []
        for obj in AllUserSnapshot?.childSnapshot(forPath: userID).childSnapshot(forPath: "FavoriteTrackData_long/items").children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj)
        }
        
        var actualRes: [[Any]] = []
        for obj in result {
            let info = ProcessTrackSnapshot(trackSnapshot: obj)
            // IN ORDER: trackName, artistsInfo, albumInfo, albumArtists, imageURL,
            // releaseDate, duration, explicit, linkToSpot, Popularity, previewURL
            actualRes.append(info)
        }
        return actualRes
    }
    
    func ProcessTrackSnapshot(trackSnapshot: DataSnapshot) -> [Any] {
        var result: [Any] = []
        // IN ORDER: trackName, artistsInfo, albumInfo, albumArtists, imageURL,
        // duration, explicit, linkToSpot, Popularity, previewURL
        result.append(trackSnapshot.childSnapshot(forPath: "name").value as? String ?? "NULL")
        var artistsInfo: [[String]] = []
        for obj in trackSnapshot.childSnapshot(forPath: "artists").children.allObjects as? [DataSnapshot] ?? [] {
            artistsInfo.append([obj.childSnapshot(forPath: "name").value as? String ?? "NULL", obj.childSnapshot(forPath: "external_urls/spotify").value as? String ?? "NULL"])
        }
        result.append(artistsInfo)
        var albumInfo: [String] = []
        // For the Album: [Album Name, AlbumImgURL, ReleaseDate, NumTracks, LinkToSpot]
        albumInfo.append(trackSnapshot.childSnapshot(forPath: "album/name").value as? String ?? "NULL")
        albumInfo.append(trackSnapshot.childSnapshot(forPath: "album/images/0/url").value as? String ?? "NULL")
        albumInfo.append(trackSnapshot.childSnapshot(forPath: "album/release_date").value as? String ?? "NULL")
        albumInfo.append(String(trackSnapshot.childSnapshot(forPath: "album/total_tracks").value as? Int ?? -1))
        albumInfo.append(trackSnapshot.childSnapshot(forPath: "album/external_urls/spotify").value as? String ?? "NULL")
        result.append(albumInfo)
        var albumArtists: [[String]] = []
        for obj in trackSnapshot.childSnapshot(forPath: "album/artists").children.allObjects as? [DataSnapshot] ?? [] {
            albumArtists.append([obj.childSnapshot(forPath: "name").value as? String ?? "NULL", obj.childSnapshot(forPath: "external_urls/spotify").value as? String ?? "NULL"])
        }
        result.append(albumArtists)
        result.append(trackSnapshot.childSnapshot(forPath: "album/images/0/url").value as? String ?? "NULL")
        result.append(SecToString(milliSeconds: trackSnapshot.childSnapshot(forPath: "duration_ms").value as? Int ?? 0))
        result.append(BoolToString(bool:trackSnapshot.childSnapshot(forPath: "explicit").value as? Bool ?? false))
        result.append(trackSnapshot.childSnapshot(forPath: "external_urls/spotify").value as? String ?? "NULL")
        result.append(String(trackSnapshot.childSnapshot(forPath: "popularity").value as? Int ?? -1))
        result.append(trackSnapshot.childSnapshot(forPath: "preview_url").value as? String ?? "NULL")
        print(result)
        return result
    }
    
    func SecToString(milliSeconds: Int) -> String {
        let seconds = milliSeconds / 1000
        let min = seconds / 60
        let leftover = seconds % 60
        var leftoverString = String(leftover)
        if leftoverString.count == 1 {
            leftoverString = "0" + leftoverString
        }
        return String(min) + ":" + leftoverString
    }
    
    func BoolToString(bool: Bool) -> String {
        if bool {
            return "True"
        }
        else {
            return "False"
        }
    }
    
    
    // GETTING THE TOP ARTISTS
//    func GetTopArtistInfo() -> [[String]] {
//        var result: [[String]] = []
//        for obj in UserSnapshot?.childSnapshot(forPath: "artistDB").children.allObjects as? [DataSnapshot] ?? [] {
//            result.append([obj.childSnapshot(forPath: "0").value as? String ?? "NULL", obj.childSnapshot(forPath: "1").value as? String ?? "NULL"])
//        }
//        return result
//    }
    
    func GetTopArtistInfo() -> [[String]] {
        var result: [DataSnapshot] = []
        for obj in UserSnapshot?.childSnapshot(forPath: "FavoriteArtistData/items").children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj)
        }
        
        var actualRes: [[String]] = []
        for obj in result {
            let info = ProcessArtistSnapshot(artistSnapshot: obj)
            // IN ORDER: NAME, IMAGE1URL, IMAGE2URL, IMAGE3URL, SPOTIFY_LINK, FOLLOWERS, GENRE1, GENRE2, POPULARITY
            actualRes.append(info)
        }
        return actualRes
    }
    
    // IN ORDER: NAME, IMAGE1URL, IMAGE2URL, IMAGE3URL, SPOTIFY_LINK, FOLLOWERS, GENRE1, GENRE2, POPULARITY
    func ProcessArtistSnapshot(artistSnapshot: DataSnapshot) -> [String] {
        var result: [String] = []
        result.append(artistSnapshot.childSnapshot(forPath: "name").value as? String ?? "NULL")
        result.append(artistSnapshot.childSnapshot(forPath: "images/0/url").value as? String ?? "NULL")
        result.append(artistSnapshot.childSnapshot(forPath: "images/1/url").value as? String ?? "NULL")
        result.append(artistSnapshot.childSnapshot(forPath: "images/2/url").value as? String ?? "NULL")
        result.append(artistSnapshot.childSnapshot(forPath: "external_urls/spotify").value as? String ?? "NULL")
        result.append(String(artistSnapshot.childSnapshot(forPath: "followers/total").value as? Int ?? -1))
        result.append(artistSnapshot.childSnapshot(forPath: "genres/0").value as? String ?? "NULL")
        result.append(artistSnapshot.childSnapshot(forPath: "genres/1").value as? String ?? "NULL")
        result.append(String(artistSnapshot.childSnapshot(forPath: "popularity").value as? Int ?? -1))
        return result
    }
    
    func GetTopArtistInfoShort() -> [[String]] {
        var result: [DataSnapshot] = []
        for obj in UserSnapshot?.childSnapshot(forPath: "FavoriteArtistData_short/items").children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj)
        }
        
        var actualRes: [[String]] = []
        for obj in result {
            let info = ProcessArtistSnapshot(artistSnapshot: obj)
            // IN ORDER: NAME, IMAGE1URL, IMAGE2URL, IMAGE3URL, SPOTIFY_LINK, FOLLOWERS, GENRE1, GENRE2, POPULARITY
            actualRes.append(info)
        }
        return actualRes
    }
    
    func GetTopArtistInfoLong() -> [[String]] {
        var result: [DataSnapshot] = []
        for obj in UserSnapshot?.childSnapshot(forPath: "FavoriteArtistData_long/items").children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj)
        }
        
        var actualRes: [[String]] = []
        for obj in result {
            let info = ProcessArtistSnapshot(artistSnapshot: obj)
            // IN ORDER: NAME, IMAGE1URL, IMAGE2URL, IMAGE3URL, SPOTIFY_LINK, FOLLOWERS, GENRE1, GENRE2, POPULARITY
            actualRes.append(info)
        }
        return actualRes
    }
    
    // GETTING OTHER PEOPLE'S TOP ARTISTS
//    func GetOtherTopArtistInfo(userID: String) -> [[String]] {
//        var result: [[String]] = []
//        for obj in AllUserSnapshot?.childSnapshot(forPath: userID).childSnapshot(forPath: "artistDB").children.allObjects as? [DataSnapshot] ?? [] {
//            result.append([obj.childSnapshot(forPath: "0").value as? String ?? "NULL", obj.childSnapshot(forPath: "1").value as? String ?? "NULL"])
//        }
//        return result
//    }
    
    func GetOtherTopArtistInfo(userID: String) -> [[String]] {
        var result: [DataSnapshot] = []
        for obj in AllUserSnapshot?.childSnapshot(forPath: userID).childSnapshot(forPath: "FavoriteArtistData/items").children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj)
        }
        
        var actualRes: [[String]] = []
        for obj in result {
            let info = ProcessArtistSnapshot(artistSnapshot: obj)
            // IN ORDER: NAME, IMAGE1URL, IMAGE2URL, IMAGE3URL, SPOTIFY_LINK, FOLLOWERS, GENRE1, GENRE2, POPULARITY
            actualRes.append(info)
        }
        return actualRes
    }
    
    func GetOtherTopArtistInfoShort(userID: String) -> [[String]] {
        var result: [DataSnapshot] = []
        for obj in AllUserSnapshot?.childSnapshot(forPath: String(userID) + "/FavoriteArtistData_short/items").children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj)
        }
        
        var actualRes: [[String]] = []
        for obj in result {
            let info = ProcessArtistSnapshot(artistSnapshot: obj)
            // IN ORDER: NAME, IMAGE1URL, IMAGE2URL, IMAGE3URL, SPOTIFY_LINK, FOLLOWERS, GENRE1, GENRE2, POPULARITY
            actualRes.append(info)
        }
        return actualRes
    }
    
    func GetOtherTopArtistInfoLong(userID: String) -> [[String]] {
        var result: [DataSnapshot] = []
        for obj in AllUserSnapshot?.childSnapshot(forPath: String(userID) + "/FavoriteArtistData_long/items").children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj)
        }
        
        var actualRes: [[String]] = []
        for obj in result {
            let info = ProcessArtistSnapshot(artistSnapshot: obj)
            // IN ORDER: NAME, IMAGE1URL, IMAGE2URL, IMAGE3URL, SPOTIFY_LINK, FOLLOWERS, GENRE1, GENRE2, POPULARITY
            actualRes.append(info)
        }
        return actualRes
    }
    
    // GETTING THE TOP ALBUMS
    func GetTopAlbumInfo() -> [[String]] {
        var result: [[String]] = []
        for obj in UserSnapshot?.childSnapshot(forPath: "albumDB").children.allObjects as? [DataSnapshot] ?? [] {
            result.append([obj.childSnapshot(forPath: "0").value as? String ?? "NULL", obj.childSnapshot(forPath: "1").value as? String ?? "NULL"])
        }
        return result
    }
    
    // GETTING OTHER PEOPLE'S TOP ALBUMS
    func GetOtherTopAlbumInfo(userID: String) -> [[String]] {
        var result: [[String]] = []
        for obj in AllUserSnapshot?.childSnapshot(forPath: userID).childSnapshot(forPath: "albumDB").children.allObjects as? [DataSnapshot] ?? [] {
            result.append([obj.childSnapshot(forPath: "0").value as? String ?? "NULL", obj.childSnapshot(forPath: "1").value as? String ?? "NULL"])
        }
        return result
    }
    
    // Gets the list of friends (UserID) for a particular individual
    func GetFriendList() -> [String] {
        var result: [String] = []
        for obj in UserSnapshot?.childSnapshot(forPath: "Friends").children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj.key as String)
        }
        print(result)
        return result
    }
    
    // Gets the profile picture of the user
    func GetProfPic() -> String {
        return UserSnapshot?.childSnapshot(forPath: "ProfPic").value as? String ?? "NULL"
    }
    
    // Gets the profile picture of another user
    func GetOtherProfPic(profName: String) -> String {
        return AllUserSnapshot?.childSnapshot(forPath: GetUserID(profName: profName)).childSnapshot(forPath: "ProfPic").value as? String ?? "NULL"
    }
    
    // ADDS FRIEND
    func AddFriend(profName: String) {
        if !IsFriend(userID: GetUserID(profName: profName)) {
            let userID = GetUserID(profName: profName)
            ref.child("Users").child(String(SPOTIFY_ID)).child("Friends").updateChildValues([userID : userID])
        }
    }
    
    // REMOVES FRIEND
    func RemoveFriend(profName: String) {
        if IsFriend(userID: GetUserID(profName: profName)) {
            let userID = GetUserID(profName: profName)
            ref.child("Users").child(String(SPOTIFY_ID)).child("Friends").child(userID).removeValue()
        }
    }
    
    // Determines whether a user is in the current user's friend list:
    func IsFriend(userID: String) -> Bool {
        return UserSnapshot?.childSnapshot(forPath: "Friends").hasChild(userID) ?? false
    }
    
    // GETTING USER ID FROM PROFNAME:
    func GetUserID(profName: String) -> String {
        return UsernameSnapshot?.childSnapshot(forPath: profName).value as? String ?? "NULL"
    }
    
    func IsExistingUser(accessToken: String) -> Bool {
        if AllUserSnapshot == nil {
            return false
        }
        return AllUserSnapshot!.hasChild(accessToken)
    }
    
    public func EditTrackJson(artistJson: String) {
        ref.child("Users").child(String(SPOTIFY_ID)).updateChildValues(["artistJson": artistJson]);
    }
    
    public func GetFavoriteArtistData(number: Int) -> ([String], String, [String], Int, String, Int) {
        var imageURLs: [String] = []
        for obj in UsernameSnapshot?.childSnapshot(forPath: "FavoriteArtistData/items/" + String(number) + "/images").children.allObjects as? [DataSnapshot] ?? [] {
            imageURLs.append(obj.childSnapshot(forPath: "url").value as? String ?? "NULL")
        }
        let detailedTitle: String = UsernameSnapshot?.childSnapshot(forPath: "FavoriteArtistData/items/" + String(number) + "/name").value as? String ?? "NULL"
        var topGenres: [String] = []
        for obj in UsernameSnapshot?.childSnapshot(forPath: "FavoriteArtist/items/" + String(number) + "/genres").children.allObjects as? [DataSnapshot] ?? [] {
            topGenres.append(obj.value as? String ?? "NULL")
        }
        let followers: Int = UsernameSnapshot?.childSnapshot(forPath: "FavoriteArtistData/items/" + String(number) + "/followers").value as? Int ?? -1
        let linkToSpot: String = UsernameSnapshot?.childSnapshot(forPath: "FavoriteArtistData/items/" + String(number) + "/href").value as? String ?? "NULL"
        let popularity: Int = UsernameSnapshot?.childSnapshot(forPath: "FavoriteArtistData/items/" + String(number) + "/popularity").value as? Int ?? -1
        return (imageURLs, detailedTitle, topGenres, followers, linkToSpot, popularity)
    }
        
    public func EditArtistJson(tracksJson: String) {
        ref.child("Users").child(String(SPOTIFY_ID)).updateChildValues(["tracksJson": tracksJson]);
    }
}

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
//    var SPOTIFY_ID = AuthManager.shared.userID?.replacingOccurrences(of: ".", with: ",") ?? "generic_user" // switched to user id
    var SPOTIFY_ID = "generic_user" // switched to user id
    var UserSnapshot: DataSnapshot?
    var childSnap: DataSnapshot?
    var AllUserSnapshot: DataSnapshot?
    var UsernameSnapshot: DataSnapshot?

    init() {
        ref = Database.database().reference()
        load()
    }
    func load() {
        ref.observeSingleEvent(of: .value, with: { snapshot in
            self.UserSnapshot = snapshot.childSnapshot(forPath: "Users/" + String(self.SPOTIFY_ID))
            self.AllUserSnapshot = snapshot.childSnapshot(forPath: "Users")
            self.UsernameSnapshot = snapshot.childSnapshot(forPath: "Usernames")
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
        load()
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
    
    

    // Takes in a new integer to set the Profile Pic Value to. The Value should be from 1-10, with each one indicating one of the default profile picture options.
    func EditProfPic(newPic: Int) {
        if newPic < 0 || newPic > 10 {
            print("New Profile Picture number should be between 1 and 10 inclusive.")
        } else {
            // FORMAT B
            ref.child("Users").child(String(SPOTIFY_ID)).child("ProfPic").setValue(newPic)
        }
    }

    // Takes in whether one would like to add or remove a friend, and said friend's name
    // AddRemove is True for Add, False for Remove
    func ChangeFriendList(addRemove: Bool, friendName: String) {
        
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
    func GetSettingsStatus(settingName: String) -> Bool {
        let value =  UserSnapshot?.childSnapshot(forPath: "Settings").childSnapshot(forPath: settingName).value as? String
        if (value == "True") {
            return true
        }
        return false
    }

    // Gets the custom username of the user, returned as a string
    func GetProfName() -> String {
        let value = UserSnapshot?.childSnapshot(forPath:"/ProfName").value as? String
        return value ?? "No_Name"
    }

    // Gets the profile picture of the user, as an integer from 1-10
    func GetProfPic() -> Int {
        let value = UserSnapshot?.childSnapshot(forPath:"/ProfPic").value as? Int
        return value ?? 4
    }
    
    func GetNameList() -> [String] {
        var result: [String] = []
        for obj in UsernameSnapshot?.children.allObjects as? [DataSnapshot] ?? [] {
            result.append(obj.key as String)
        }
        return result
    }
    
    // GETTING THE TOP TRACKS
    func GetTopTrackInfo() -> [[String]] {
        var result: [[String]] = []
        for obj in UserSnapshot?.childSnapshot(forPath: "trackDB").children.allObjects as? [DataSnapshot] ?? [] {
            result.append([obj.childSnapshot(forPath: "0").value as? String ?? "NULL", obj.childSnapshot(forPath: "1").value as? String ?? "NULL"])
        }
        return result
    }
    
    // GETTING OTHER PEOPLE'S TOP TRACKS
    func GetOtherTopTrackInfo(userID: String) -> [[String]] {
        var result: [[String]] = []
        for obj in AllUserSnapshot?.childSnapshot(forPath: userID).childSnapshot(forPath: "trackDB").children.allObjects as? [DataSnapshot] ?? [] {
            result.append([obj.childSnapshot(forPath: "0").value as? String ?? "NULL", obj.childSnapshot(forPath: "1").value as? String ?? "NULL"])
        }
        return result
    }
    
    // GETTING THE TOP ARTISTS
    func GetTopArtistInfo() -> [[String]] {
        var result: [[String]] = []
        for obj in UserSnapshot?.childSnapshot(forPath: "artistDB").children.allObjects as? [DataSnapshot] ?? [] {
            result.append([obj.childSnapshot(forPath: "0").value as? String ?? "NULL", obj.childSnapshot(forPath: "1").value as? String ?? "NULL"])
        }
        return result
    }
    
    // GETTING OTHER PEOPLE'S TOP ARTISTS
    func GetOtherTopArtistInfo(userID: String) -> [[String]] {
        var result: [[String]] = []
        for obj in AllUserSnapshot?.childSnapshot(forPath: userID).childSnapshot(forPath: "artistDB").children.allObjects as? [DataSnapshot] ?? [] {
            result.append([obj.childSnapshot(forPath: "0").value as? String ?? "NULL", obj.childSnapshot(forPath: "1").value as? String ?? "NULL"])
        }
        return result
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
        
    public func EditArtistJson(tracksJson: String) {
        ref.child("Users").child(String(SPOTIFY_ID)).updateChildValues(["tracksJson": tracksJson]);
    }
}

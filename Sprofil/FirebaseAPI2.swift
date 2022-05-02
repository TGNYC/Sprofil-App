//
//  FirebaseAPI2.swift
//  Sprofil
//
//  Created by Tejas Gupta on 4/3/22.
//
import Foundation
import UIKit
import Firebase
import os
import FirebaseDatabase

/// Functions that Kevin created to upload the data to firebase
class FirebaseAPI2 {
    init() {}
    
    static func uploadJSON(child: String, myJSON: String, user_id: String) {
        Database.database().reference().child("Users").child(String(user_id))
            .updateChildValues([child: myJSON]);
    }
    
    static func EditArtistJson(child: String, artistJson: String, user_id: String) {
        Database.database().reference().child("Users").child(String(user_id))
            .updateChildValues([child: artistJson]);
    }
        
    static func EditTrackJson(child: String, trackJson: String, user_id: String) {
        Database.database().reference().child("Users").child(String(user_id))
            .updateChildValues([child: trackJson]);
    }

    static func CreateNew(artistJson: String, tracksJson: String, user_id: String) {
        let trackJson = tracksJson.replacingOccurrences(of: "'", with: "`").replacingOccurrences(of: "\"", with: "'");
        let artJson = artistJson.replacingOccurrences(of: "'", with: "`").replacingOccurrences(of: "\"", with: "'");
        Database.database().reference().child("Users").child(String(user_id)).updateChildValues(["ArtistJson": artJson, "TracksJson": trackJson]);
    }
    
    static func UploadArtistInfo(stringArray: [String], imageArray: [String: String], user_id: String) {
            Database.database().reference().child("Users").child(String(user_id)).updateChildValues(["artist": stringArray])
            Database.database().reference().child("Users").child(String(user_id)).updateChildValues(["artistImages": imageArray])
        }
    
    static func UploadTrackInfo(stringArray: [String], imageArray: [String: String], user_id: String) {
            Database.database().reference().child("Users").child(String(user_id)).updateChildValues(["track": stringArray])
            Database.database().reference().child("Users").child(String(user_id)).updateChildValues(["trackImages": imageArray])
        }
    
    static func UploadArtistInfoTuple(artistInfo: [String: [String]], user_id: String) {
        Database.database().reference().child("Users").child(String(user_id)).updateChildValues(["artistDB": artistInfo])
    }
    
    static func UploadTrackInfoTuple(artistInfo: [String: [String]], user_id: String) {
        Database.database().reference().child("Users").child(String(user_id)).updateChildValues(["trackDB": artistInfo])
    }
    
    static func UploadAlbumInfoTuple(artistInfo: [String: [String]], user_id: String) {
        Database.database().reference().child("Users").child(String(user_id)).updateChildValues(["albumDB": artistInfo])
    }
    
    static func UploadGeneralTuple(child: String, artistInfo: [String: [String]], user_id: String) {
        Database.database().reference().child("Users").child(String(user_id)).updateChildValues([child: artistInfo])
    }
    
    static func UploadEmail(user_id: String, user_email: String) {
        Database.database().reference().child("Users").child(String(user_id)).updateChildValues(["email": user_email])
    }
}

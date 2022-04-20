//
//  Widgets.swift
//  Sprofil (iOS)
//
//  Created by Ben Shi on 3/9/22.
//

import Foundation
import SwiftUI

// Information contained within a topArtists widget
// NEED TO CHECK FOR VALIDITY OF ARGUMENTS
struct TopArtist {
    // Title of widget I.E. Ben's Top Artists
    var title : String
    var artists : [String]
    // time listened to the corresponding artist with the same index
    var timeListened : [Int]
    var artistImages : [String:String]
    var theme : Theme
}

// Information contained within a topAlbums widget
struct TopAlbums {
    // Title of widget I.E. Ben's Top Albums
    var title : String
    var albums: [String]
    // artist of the album with the same index
    var artists : [String]
    var albumImages : [Image]
    var theme : Theme
}

struct TopSongs {
    // Title of widget I.E. Ben's Top Songs
    var title : String
    var songs : [String]
    var artists : [String]
    var songImages : [Image]
    var theme : Theme
}

extension TopArtist {
    static let sampleData : TopArtist = TopArtist(title : "Ben's Top Artists", artists: ["Katy Perry", "Adele", "Taylor Swift", "Drake", "Ben Shi", "Olivia Rodrigo"], timeListened: [100, 59, 23, 16], artistImages: ["Katy Perry":"KatyPerry", "Adele":"Adele", "Taylor Swift":"TaylorSwift", "Drake":"Drake", "Ben Shi":"BenShi", "Olivia Rodrigo":"OliviaRodrigo"], theme : .lavender
    )
}

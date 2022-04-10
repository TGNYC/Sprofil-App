//
//  Album.swift
//  Sprofil
//
//  Created by Tejas Gupta on 3/29/22.
//

import Foundation

struct Album: Codable {
    let album_type: String
    let artists: [Artist]
//    let available_markets: [String]
    let href: URL
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
//    let label: String
    let name: String
    let tracks: [Track]?
}

//struct TracksResponse: Codable {
//    let items: [Track]
//}

//
//  Track.swift
//  Sprofil
//
//  Created by Tejas Gupta on 3/29/22.
//

import Foundation

struct Track: Codable {
    let album: Album?
    let artists: [Artist]
//    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String: String]
    let id: String
    let name: String
    let preview_url: String?
}

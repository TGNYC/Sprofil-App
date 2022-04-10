//
//  Artist.swift
//  Sprofil
//
//  Created by Tejas Gupta on 3/22/22.
//

import Foundation

struct Artist: Codable {
    let external_urls: [String: String]
    // let followers: [String: Int?]
    let genres: [String]?
    let href: URL
    let id: String
    let name: String
    let type: String
    let uri: URL
    let images: [APIImage]?
    let popularity: Int?
}


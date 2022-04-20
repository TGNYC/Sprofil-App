//
//  TopTracks.swift
//  Sprofil
//
//  Created by Tejas Gupta on 3/29/22.
//

import Foundation


struct TopTracks: Codable {
    let href: URL
    let items: [Track]
    let limit: Int
    let next: URL?
    let offset: Int
    let previous: URL?
    let total: Int
}

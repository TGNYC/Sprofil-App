//
//  UserProfile.swift
//  Sprofil
//
//  Created by Tejas Gupta on 4/2/22.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let display_name: String
    // let email: String // (NEEDS EMAIL SCOPE ACCESS, unnecessary atm)
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
    let id: String
    let product: String
    let images: [APIImage]
}

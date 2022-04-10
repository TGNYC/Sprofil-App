//
//  AuthResponse.swift
//  Sprofil
//
//  Created by Tejas Gupta on 3/22/22.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}

//
//  AuthData.swift
//  MusDZList
//
//  Created by Denis Selivanov on 05.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

struct AuthData: Codable {
    
    let accessToken: String?
    let expires: Int?
    let error: Error?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expires
        case error
    }
    
    struct Error: Codable {
        let code: Int
    }
    
}

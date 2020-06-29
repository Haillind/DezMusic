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
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
    
}

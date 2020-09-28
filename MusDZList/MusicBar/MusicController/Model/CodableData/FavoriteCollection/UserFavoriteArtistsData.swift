//
//  UserFavoriteArtistsData.swift
//  MusDZList
//
//  Created by Denis Selivanov on 09.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

struct UserFavoriteArtistsData: Codable {
    
    let data: [FavoritesArtistsData]
}

struct FavoritesArtistsData: Codable {
    
    let id: Int
    let name: String
    let pictureBig: URL
    let tracklist: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case pictureBig = "picture_big"
        case tracklist
    }
}

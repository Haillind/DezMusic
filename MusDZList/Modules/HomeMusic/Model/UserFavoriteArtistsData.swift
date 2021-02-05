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
    let picture_small: URL
    let picture_big: URL
    let picture_xl: URL
}

struct FavoriteArtistModel {
    let id: Int
    let name: String
    let image: Data
}

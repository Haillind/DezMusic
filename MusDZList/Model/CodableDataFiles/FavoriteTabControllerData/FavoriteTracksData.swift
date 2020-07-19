//
//  FavoriteTracksData.swift
//  MusDZList
//
//  Created by Denis Selivanov on 10.07.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

struct FavoriteTracksData: Codable {
    let data: [FavoriteTrackInfo]
    let total: Int
    let next: URL?
    
    struct FavoriteTrackInfo: Codable {
        let id: Int
        let title: String
        let album: AlbumOFTrackInTopList
        let artist: ArtistInfo
    }
}

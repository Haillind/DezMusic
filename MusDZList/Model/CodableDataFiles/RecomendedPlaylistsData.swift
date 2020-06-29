//
//  RecomendedPlaylistsData.swift
//  MusDZList
//
//  Created by Denis Selivanov on 11.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

struct RecomendedPlaylistsData: Codable {
    let data: [RecomendedPlaylistInfo]
}

struct RecomendedPlaylistInfo: Codable {
    let id: Int
    let title: String
    let numberOfTracks: Int
    let pictureBig: URL
    let tracklist: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case numberOfTracks = "nb_tracks"
        case pictureBig = "picture_big"
        case tracklist
    }
}

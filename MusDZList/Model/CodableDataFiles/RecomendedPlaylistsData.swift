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
    let nb_tracks: Int
    let picture_big: URL
    let tracklist: URL
}

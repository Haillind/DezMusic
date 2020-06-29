//
//  ListOfTopTracksData.swift
//  MusDZList
//
//  Created by Denis Selivanov on 13.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

struct ListOfTopTracksData: Codable {
    let data: [TopTracksList]
}

struct TopTracksList: Codable {
    let title: String
    let preview: URL
    let contributors: [ContributorsOfTrack]
    let album: AlbumOFTrackInTopList
    let artist: ArtistInfo
}

struct ContributorsOfTrack: Codable {
    let name: String
}

struct AlbumOFTrackInTopList: Codable {
    let title: String
    let coverBig: URL
    
    enum CodingKeys: String, CodingKey {
        case title
        case coverBig = "cover_big"
    }
}

struct ArtistInfo: Codable {
    let name: String
}

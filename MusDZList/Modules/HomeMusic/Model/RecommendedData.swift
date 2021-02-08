//
//  RecommendedData.swift
//  MusDZList
//
//  Created by Denis Selivanov on 08.02.2021.
//  Copyright © 2021 Denis Selivanov. All rights reserved.
//

import Foundation

struct RecommendedData: Codable {
    let data: [RecommendedInfo]
}

struct RecommendedInfo: Codable {
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

struct RecommendedModel {
    let info: RecommendedInfo
    let image: Data
}

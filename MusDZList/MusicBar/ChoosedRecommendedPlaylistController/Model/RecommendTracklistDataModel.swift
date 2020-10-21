//
//  RecommendTracklistDataModel.swift
//  MusDZList
//
//  Created by Denis Selivanov on 14.10.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation
struct RecommendTracklistDataModel: Codable {
    let data: [RecommendTracklistDataModelList]
    let next: URL?
    
    struct RecommendTracklistDataModelList: Codable {
        let title: String
        let artist: ArtistInfo
        let album: AlbumOFTrackInTopList
    }
    
}

struct ChoosedList {
    let nameOfSong: String
    let artistName: String
    let albumName: String
    let image: Data?
}

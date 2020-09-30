//
//  FavoriteRow.swift
//  MusDZList
//
//  Created by Denis Selivanov on 10.08.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

struct FavoriteControllerMenuValue {
    var titleOfTableRow: FavoriteActions
    var countOfDataInfoForCurrentRow: Int
    
    init(titleOfTableRow: FavoriteActions, countOfDataInfoForCurrentRow: Int) {
        self.titleOfTableRow = titleOfTableRow
        self.countOfDataInfoForCurrentRow = countOfDataInfoForCurrentRow
    }
}

struct FavoriteTracksTabTableViewModel {
    let artistName: String
    let nameOfSong: String
    let titleAlbum: String
    let imageAlbum: Data
}

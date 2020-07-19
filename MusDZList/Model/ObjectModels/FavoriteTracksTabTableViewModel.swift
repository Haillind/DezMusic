//
//  FavoriteTracksTabTableViewModel.swift
//  MusDZList
//
//  Created by Denis Selivanov on 10.07.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

class FavoriteControllerRowValue {
    var titleOfTableRow: String
    var countOfDataInfoForCurrentRow: Int
    
    init(titleOfTableRow: String, countOfDataInfoForCurrentRow: Int) {
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

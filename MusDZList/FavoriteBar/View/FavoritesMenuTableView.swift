//
//  FavoritesMenuTableView.swift
//  MusDZList
//
//  Created by Denis Selivanov on 29.09.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

enum FavoriteActions: String {
    case Downloaded = "Downloaded"
    case FavoriteTracks = "Favorite Tracks"
    case Playlists = "Playlists"
    case Albums = "Albums"
    case Artists = "Artists"
    case Mixes = "Mixes"
}

class FavoritesMenuTableView: UITableView {
    
    var favoritesTableListEnum = [
        FavoriteControllerMenuValue(titleOfTableRow: .Downloaded, countOfDataInfoForCurrentRow: 0),
        FavoriteControllerMenuValue(titleOfTableRow: .FavoriteTracks, countOfDataInfoForCurrentRow: 0),
        FavoriteControllerMenuValue(titleOfTableRow: .Playlists, countOfDataInfoForCurrentRow: 0),
        FavoriteControllerMenuValue(titleOfTableRow: .Albums, countOfDataInfoForCurrentRow: 0),
        FavoriteControllerMenuValue(titleOfTableRow: .Artists, countOfDataInfoForCurrentRow: 0),
        FavoriteControllerMenuValue(titleOfTableRow: .Mixes, countOfDataInfoForCurrentRow: 0),
    ]
    
    init() {
        super.init(frame: .zero, style: .plain)
        
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        
        delegate = self
        dataSource = self
        register(FavoritesMenuCell.self, forCellReuseIdentifier: String(describing: FavoritesMenuCell.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func set(cells: [SearchData.SearchResult]) {
//        cellsData = cells
//    }

}

extension FavoritesMenuTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesTableListEnum.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FavoritesMenuCell.self), for: indexPath) as! FavoritesMenuCell
        
//        cell.favoriteMenuLabel.text = favoriteMenuActions[indexPath.row].rawValue
        cell.favoriteMenuLabel.text = favoritesTableListEnum[indexPath.row].titleOfTableRow.rawValue
        cell.rowInfoLabel.text = String(favoritesTableListEnum[indexPath.row].countOfDataInfoForCurrentRow)
        
        return cell
    }
    
}

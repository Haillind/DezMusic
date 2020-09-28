//
//  RecomendedPlaylistController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 23.07.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class RecomendedPlaylistController: UIViewController {
    
    var collectionViewPlaylists: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var recomendedPlaylistOptional: [RecomendedPlaylistInfo]?
    var recomendedPlaylist: [RecomendedPlaylistInfo] {
        guard let recomendedPlaylist = recomendedPlaylistOptional else {fatalError()}
        return recomendedPlaylist
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print(recomendedPlaylist)
    }
}

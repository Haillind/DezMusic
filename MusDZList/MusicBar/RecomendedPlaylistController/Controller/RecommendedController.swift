//
//  RecommendedController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 01.10.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class RecommendedController: UIViewController {
        
    let collectionView = RecommendedCollectionView()
    
    var dataForRecommendedCells: [RecomendModel]? {
        willSet {
            guard let newValue = newValue else {fatalError()}
            collectionView.recommendedList = newValue
            collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegateChoosed = self
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}

extension RecommendedController: ChoosedControllerDelegate {
    
    func presentChoosedController(indexPath: Int, trackList: RecomendModel) {
        guard let trackListInfo = dataForRecommendedCells else {return}
        let choosedVC = ChoosedRecommendedPlaylistController()
        choosedVC.tracklist = trackListInfo[indexPath]
        self.navigationController?.pushViewController(choosedVC, animated: true)
    }
    
}


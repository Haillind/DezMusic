//
//  RecommendedCollectionVIew.swift
//  MusDZList
//
//  Created by Denis Selivanov on 02.10.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

protocol ChoosedControllerDelegate: class {
    func presentChoosedController(indexPath: Int, trackList: RecomendModel)
}

class RecommendedCollectionView: UICollectionView {
    
    var recommendedList = [RecomendModel]()
    
    weak var delegateChoosed: ChoosedControllerDelegate?

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        delegate = self
        dataSource = self
        register(RecommendedControllerCell.self, forCellWithReuseIdentifier: String(describing: RecommendedControllerCell.self))
        
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RecommendedCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: RecommendedControllerCell.self), for: indexPath) as! RecommendedControllerCell
        
        cell.imageView.image = UIImage(data: recommendedList[indexPath.item].image)
        cell.nameOfPlaylist.text = recommendedList[indexPath.item].data.title
        cell.numberOfTrackInPlaylist.text = "\(recommendedList[indexPath.item].data.numberOfTracks) tracks"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegateChoosed?.presentChoosedController(indexPath: indexPath.item, trackList: recommendedList[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2 - 20, height: frame.width / 2 + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
    }
    
}

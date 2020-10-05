//
//  RecommendedControllerCell.swift
//  MusDZList
//
//  Created by Denis Selivanov on 02.10.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class RecommendedControllerCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameOfPlaylist: UILabel = {
        let label = UILabel()
        label.text = "rock"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberOfTrackInPlaylist: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        addSubview(imageView)
        addSubview(nameOfPlaylist)
        addSubview(numberOfTrackInPlaylist)
        
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        nameOfPlaylist.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15).isActive = true
        nameOfPlaylist.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        numberOfTrackInPlaylist.topAnchor.constraint(equalTo: nameOfPlaylist.bottomAnchor, constant: 6).isActive = true
        numberOfTrackInPlaylist.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 9
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 8)
        
        self.clipsToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  ChoosedTableCell.swift
//  MusDZList
//
//  Created by Denis Selivanov on 14.10.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class ChoosedTableCell: UITableViewCell {
    
    var albumImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var nameOfSong: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 0.5))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var titleOfArtistAndAlbum: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setConstraints()
    }
    
    func setConstraints() {
        addSubview(albumImage)
        addSubview(nameOfSong)
        addSubview(titleOfArtistAndAlbum)
        
        albumImage.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        albumImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        albumImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        albumImage.widthAnchor.constraint(equalToConstant: self.frame.height - 10).isActive = true
        albumImage.heightAnchor.constraint(equalToConstant: self.frame.height - 10).isActive = true
        
        nameOfSong.topAnchor.constraint(equalTo: topAnchor, constant: self.frame.height / 5.5).isActive = true
        nameOfSong.leadingAnchor.constraint(equalTo: albumImage.trailingAnchor, constant: 10).isActive = true
        
        titleOfArtistAndAlbum.topAnchor.constraint(equalTo: nameOfSong.bottomAnchor, constant: 5).isActive = true
        titleOfArtistAndAlbum.leadingAnchor.constraint(equalTo: albumImage.trailingAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

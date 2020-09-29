//
//  TopTrackListCell.swift
//  MusDZList
//
//  Created by Denis Selivanov on 28.09.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class TopTrackListCell: UITableViewCell {
    
    let trackLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let albumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageAlbumTrack: UIImageView = {
        let imageView = UIImageView()
//        imageView.frame.size = CGSize(width: 60, height: 60)
        imageView.layer.cornerRadius = imageView.frame.size.height / 1.5
        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        addSubview(imageAlbumTrack)
        addSubview(trackLabel)
        addSubview(albumLabel)
        
        imageAlbumTrack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageAlbumTrack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        imageAlbumTrack.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        imageAlbumTrack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        imageAlbumTrack.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageAlbumTrack.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        trackLabel.leadingAnchor.constraint(equalTo: imageAlbumTrack.trailingAnchor, constant: 15).isActive = true
        trackLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        trackLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        trackLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        albumLabel.leadingAnchor.constraint(equalTo: imageAlbumTrack.trailingAnchor, constant: 15).isActive = true
        albumLabel.topAnchor.constraint(equalTo: trackLabel.bottomAnchor, constant: 1).isActive = true
        albumLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        albumLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        albumLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
    }

}

//
//  CustomHeaderTableView.swift
//  MusDZList
//
//  Created by Denis Selivanov on 05.10.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class CustomHeaderTableView: UITableViewHeaderFooterView {
    
    var screenHeight: CGFloat?
    
    var tracklistImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 10
        imageView.layer.shadowRadius = 9
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowOffset = CGSize(width: 5, height: 8)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setConsttraintTracklistImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CustomHeaderTableView {
    
    func setConsttraintTracklistImage() {
        guard let screenHeight = screenHeight else {return}
        contentView.addSubview(tracklistImage)

        tracklistImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        tracklistImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        tracklistImage.heightAnchor.constraint(equalToConstant: screenHeight / 1.8).isActive = true
        tracklistImage.widthAnchor.constraint(equalToConstant: screenHeight / 1.8).isActive = true
    }
//    func setConsttraintTracklistImage() {
//        guard let screenHeight = screenHeight else {return}
//        contentView.addSubview(imageViewTrack)
//        imageViewTrack.addSubview(tracklistImage)
//
//        imageViewTrack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        imageViewTrack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        imageViewTrack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        imageViewTrack.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
//
//        tracklistImage.centerXAnchor.constraint(equalTo: imageViewTrack.centerXAnchor).isActive = true
//        tracklistImage.topAnchor.constraint(equalTo: imageViewTrack.topAnchor, constant: 10).isActive = true
//        tracklistImage.heightAnchor.constraint(equalToConstant: screenHeight / 1.8).isActive = true
//        tracklistImage.widthAnchor.constraint(equalToConstant: screenHeight / 1.8).isActive = true
//    }
    
}

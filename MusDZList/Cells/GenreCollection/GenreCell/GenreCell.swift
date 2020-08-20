//
//  GenreCell.swift
//  MusDZList
//
//  Created by Denis Selivanov on 21.07.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class GenreCell: UICollectionViewCell {
    
    static var genreCellId = "GenreCell"
    
    var genreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = self.frame.size.height / 14
        
        backgroundColor = .red
        addSubview(genreLabel)
        setConstraints()
    }
    
    func setConstraints() {
        genreLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        genreLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        genreLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        genreLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

//
//  FavoritesMenuCell.swift
//  MusDZList
//
//  Created by Denis Selivanov on 29.09.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class FavoritesMenuCell: UITableViewCell {
    
    let favoriteMenuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 21)
        return label
    }()
    
    let rowInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(favoriteMenuLabel)
        addSubview(rowInfoLabel)
        setupCellConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error initializator cell")
    }
    
    func setupCellConstraints() {
        favoriteMenuLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        favoriteMenuLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        
        rowInfoLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        rowInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
    }

}

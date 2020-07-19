//
//  UserSettingsCell.swift
//  MusDZList
//
//  Created by Denis Selivanov on 14.07.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class UserSettingsCell: UITableViewCell {
    
    static let userSettingsCellId = "UserSettingsCell"
    
    let viewForRowImage: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 40, height: 40)
        view.tintColor = .white
        //view.backgroundColor = .gray
        view.layer.cornerRadius = view.frame.size.height / 4.5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let rowTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewForRowImage.addSubview(rowImageView)
        addSubview(viewForRowImage)
        addSubview(rowTitle)
        
        setConstaints()
    }
    
    func setConstaints() {
        viewForRowImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        viewForRowImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        viewForRowImage.heightAnchor.constraint(equalToConstant: viewForRowImage.frame.size.height).isActive = true
        viewForRowImage.widthAnchor.constraint(equalToConstant: viewForRowImage.frame.size.width).isActive = true
        
        rowImageView.centerXAnchor.constraint(equalTo: viewForRowImage.centerXAnchor).isActive = true
        rowImageView.centerYAnchor.constraint(equalTo: viewForRowImage.centerYAnchor).isActive = true
        
        rowTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rowTitle.leadingAnchor.constraint(equalTo: viewForRowImage.trailingAnchor, constant: 15).isActive = true
        rowTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

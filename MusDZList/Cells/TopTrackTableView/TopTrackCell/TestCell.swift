//
//  TestCell.swift
//  MusDZList
//
//  Created by Denis Selivanov on 12.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class TestCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        setupThings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let labelTest: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageTest: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        image.image = UIImage(named: "rock")
        
        return image
    }()
    
    func setupThings() {
        
        contentView.addSubview(labelTest)
        contentView.addSubview(imageTest)
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageTest]-50-[labelTest]-|", options: [], metrics: nil, views: ["labelTest": labelTest, "imageTest": imageTest]))
//        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageTest]-20-[labelTest]-|", options: [], metrics: nil, views: ["labelTest": labelTest, "imageTest": imageTest]))
    }
    
}

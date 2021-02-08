//
//  RecomendedCell.swift
//  MusDZList
//
//  Created by Denis Selivanov on 08.02.2021.
//  Copyright © 2021 Denis Selivanov. All rights reserved.
//

import UIKit

class RecomendedCell: UICollectionViewCell {

    @IBOutlet weak var recommendImageView: UIImageView!
    @IBOutlet weak var recomendNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        recommendImageView.layer.cornerRadius = recommendImageView.frame.width / 10
        recommendImageView.clipsToBounds = true
    }

}

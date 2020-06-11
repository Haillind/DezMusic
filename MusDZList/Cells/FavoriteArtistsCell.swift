//
//  FavoriteArtistsCell.swift
//  MusDZList
//
//  Created by Denis Selivanov on 09.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class FavoriteArtistsCell: UICollectionViewCell {

    @IBOutlet weak var artistIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        artistIcon.frame.size = CGSize(width: 110, height: 110)
        artistIcon.layer.cornerRadius = artistIcon.frame.size.height / 2
        artistIcon.clipsToBounds = true
    }

}

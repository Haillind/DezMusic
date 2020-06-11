//
//  RecomendedPlaylistsCell.swift
//  MusDZList
//
//  Created by Denis Selivanov on 11.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class RecomendedPlaylistsCell: UICollectionViewCell {

    @IBOutlet weak var recomendedPlaylistImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countOftrackLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        recomendedPlaylistImage.frame.size = CGSize(width: 185, height: 185)
        recomendedPlaylistImage.layer.cornerRadius = recomendedPlaylistImage.frame.size.height / 20
        recomendedPlaylistImage.clipsToBounds = true
    }

}

//
//  TestTableViewCell.swift
//  MusDZList
//
//  Created by Denis Selivanov on 03.02.2021.
//  Copyright © 2021 Denis Selivanov. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {

    @IBOutlet weak var testImageView: UIImageView!
    @IBOutlet weak var testLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var favoriteArtistItem: FavoritesArtistsData! {
        didSet {
            setArtist()
        }
    }

    private func setArtist() {
        testLabel.text = favoriteArtistItem.name
    }
    
}

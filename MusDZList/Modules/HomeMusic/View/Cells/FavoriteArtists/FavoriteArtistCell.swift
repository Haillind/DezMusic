//
//  FavoriteArtistCell.swift
//  MusDZList
//
//  Created by Denis Selivanov on 04.02.2021.
//  Copyright © 2021 Denis Selivanov. All rights reserved.
//

import UIKit

class FavoriteArtistCell: UICollectionViewCell {

    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var artistImageView: UIImageView!

    var artist: FavoriteArtistModel? {
        didSet {
            setCell()
        }
    }

    private func setCell() {
        testLabel.text = artist?.name
        guard let data = artist?.image else { return }
        artistImageView.image = UIImage(data: data)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        artistImageView.layer.cornerRadius = artistImageView.frame.width / 2
        artistImageView.clipsToBounds = true
    }

}

//
//  TopTrackCell.swift
//  MusDZList
//
//  Created by Denis Selivanov on 12.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class TopTrackCell: UITableViewCell {

    
    @IBOutlet weak var imageAlbumTrack: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageAlbumTrack.frame.size = CGSize(width: 60, height: 60)
        imageAlbumTrack.layer.cornerRadius = imageAlbumTrack.frame.size.height / 6
        imageAlbumTrack.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        let storyboard = UIStoryboard(name: "Player", bundle: nil)
//        let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerController") as! PlayerController
        
        
    }
    
}

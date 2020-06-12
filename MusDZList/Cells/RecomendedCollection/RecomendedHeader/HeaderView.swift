//
//  HeaderView.swift
//  MusDZList
//
//  Created by Denis Selivanov on 11.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var recomendedBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func recomendedPressed(_ sender: UIButton) {
        print("header")
    }
    
}

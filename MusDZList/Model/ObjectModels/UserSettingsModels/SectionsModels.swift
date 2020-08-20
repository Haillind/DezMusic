//
//  UserSettingsTableModel.swift
//  MusDZList
//
//  Created by Denis Selivanov on 14.07.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation
import UIKit

struct SectionWithUserFollowers {
    
    let currentSectionsModel: [CurentSectionModel]
    static var configurate = UIColor.white
    
    struct CurentSectionModel {
        let image: UIImage
        let title: String
        //let backgoundColor: UIColor
    }
}

struct SectionsModel {
    
    static var configurate = UIColor.white
    
    let currentSectionsModel: [CurentSectionModel]
    
    struct CurentSectionModel {
        let image: UIImage
        let title: String
        let backgoundColor: UIColor
    }
    
}





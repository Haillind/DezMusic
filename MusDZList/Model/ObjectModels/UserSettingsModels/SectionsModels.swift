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

struct SectionsModelOne {
    
    let currentSectionsModel: [CurentSectionModel]
    static var configurate = UIColor.white
    
    struct CurentSectionModel {
        let image: UIImage
        let title: String
        let backgoundColor: UIColor
    }
    
}

struct SectionsModelTwo {
    
    let currentSectionsModel: [CurentSectionModelTwo]
    
    struct CurentSectionModelTwo {
        let image: UIImage
        let title: String
        var backgoundColor: UIColor = .systemGray
    }
    
}

struct SectionsModelThree {
    
    let currentSectionsModel: [CurentSectionModelThree]
    
    struct CurentSectionModelThree {
        let image: UIImage
        let title: String
        let backgoundColor: UIColor
    }
    
}





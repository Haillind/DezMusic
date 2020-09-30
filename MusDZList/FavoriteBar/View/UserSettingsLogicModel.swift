//
//  UserSettingsLogicModel.swift
//  MusDZList
//
//  Created by Denis Selivanov on 19.07.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation
import UIKit

struct UserSettingsLogicModel {
    
    var tableUserSettings: [Any] = [
        SectionWithUserFollowers(currentSectionsModel: [
            .init(image: UIImage(named: "rock")!, title: "UserProfileName")
        ]),
        
        SectionsModel(currentSectionsModel: [
            .init(image: UIImage(systemName: "person.fill")!, title: "My account", backgoundColor: .systemBlue)
        ]),
        
        SectionsModel(currentSectionsModel: [
            .init(image: UIImage(systemName: "eye")!, title: "Display settings", backgoundColor: .systemGray),
            .init(image: UIImage(systemName: "slider.horizontal.3")!, title: "Audio settings", backgoundColor: .systemGray),
            .init(image: UIImage(systemName: "wrench")!, title: "App", backgoundColor: .systemGray),
            .init(image: UIImage(systemName: "desktopcomputer")!, title: "My connected devices", backgoundColor: .systemGray),
            .init(image: UIImage(systemName: "airplane")!, title: "Offline mode", backgoundColor: .systemGray)
        ]),
        
        SectionsModel(currentSectionsModel: [
            .init(image: UIImage(systemName: "triangle")!, title: "Deezer labs", backgoundColor: .systemBlue),
            .init(image: UIImage(systemName: "questionmark")!, title: "Help", backgoundColor: .systemGreen),
            .init(image: UIImage(systemName: "star.fill")!, title: "Rate the App", backgoundColor: .systemYellow),
            .init(image: UIImage(systemName: "pencil.and.outline")!, title: "About", backgoundColor: .systemGray)
        ])
    ]
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        let localSection = tableUserSettings[section]
        
        switch localSection {
            
        case let sectionType where sectionType as? SectionsModel != nil:
            return (localSection as! SectionsModel).currentSectionsModel.count
        
        default:
            
            return (localSection as! SectionWithUserFollowers).currentSectionsModel.count
        }
    }
    
    func settingsForEachCell(indexPath: IndexPath) -> (image: UIImage, color: UIColor?, title: String) {
        
        let localSection = tableUserSettings[indexPath.section]
        
        switch localSection {
            
        case let sectionType where sectionType as? SectionsModel != nil:
            
            let image = (localSection as! SectionsModel).currentSectionsModel[indexPath.row].image
            let title = (localSection as! SectionsModel).currentSectionsModel[indexPath.row].title
            let color = (localSection as! SectionsModel).currentSectionsModel[indexPath.row].backgoundColor
            
            return (image, color, title)
            
        default:
            
            let image = (localSection as! SectionWithUserFollowers).currentSectionsModel[indexPath.row].image
            let title = (localSection as! SectionWithUserFollowers).currentSectionsModel[indexPath.row].title
            
            return (image, nil, title)
        }
    }
}

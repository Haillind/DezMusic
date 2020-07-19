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
        SectionWithUserFollowers(currentSectionsModel: [.init(image: UIImage(named: "rock")!, title: "UserProfileName")]),
        
        SectionsModelOne(currentSectionsModel: [
            .init(image: UIImage(systemName: "person.fill")!, title: "My account", backgoundColor: .systemBlue)
        ]),
        
        SectionsModelTwo(currentSectionsModel: [
            .init(image: UIImage(systemName: "eye")!, title: "Display settings"),
            .init(image: UIImage(systemName: "slider.horizontal.3")!, title: "Audio settings"),
            .init(image: UIImage(systemName: "wrench")!, title: "App"),
            .init(image: UIImage(systemName: "desktopcomputer")!, title: "My connected devices"),
            .init(image: UIImage(systemName: "airplane")!, title: "Offline mode")
        ]),
        
        SectionsModelThree(currentSectionsModel: [
            .init(image: UIImage(systemName: "triangle")!, title: "Deezer labs", backgoundColor: .systemBlue),
            .init(image: UIImage(systemName: "questionmark")!, title: "Help", backgoundColor: .systemGreen),
            .init(image: UIImage(systemName: "star.fill")!, title: "Rate the App", backgoundColor: .systemYellow),
            .init(image: UIImage(systemName: "pencil.and.outline")!, title: "About", backgoundColor: .systemGray)
        ])
    ]
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        let localSection = tableUserSettings[section]
        
        switch localSection {
        case let object where object as? SectionsModelOne != nil:
            return (tableUserSettings[section] as! SectionsModelOne).currentSectionsModel.count
        case let object where object as? SectionsModelTwo != nil:
            return (tableUserSettings[section] as! SectionsModelTwo).currentSectionsModel.count
        case let object where object as? SectionsModelThree != nil:
            return (tableUserSettings[section] as! SectionsModelThree).currentSectionsModel.count
        
        default:
            
            return (tableUserSettings[section] as! SectionWithUserFollowers).currentSectionsModel.count
        }
    }
    
    func settingsForEachCell(indexPath: IndexPath) -> (image: UIImage, color: UIColor?, title: String) {
        
        let localSection = tableUserSettings[indexPath.section]
        
        switch localSection {
            
        case let object where object as? SectionsModelOne != nil:
            
            let image = (tableUserSettings[indexPath.section].self as! SectionsModelOne).currentSectionsModel[indexPath.row].image
            let title = (tableUserSettings[indexPath.section].self as! SectionsModelOne).currentSectionsModel[indexPath.row].title
            let color = (tableUserSettings[indexPath.section].self as! SectionsModelOne).currentSectionsModel[indexPath.row].backgoundColor
            
            return (image, color, title)
            
        case let object where object as? SectionsModelTwo != nil:
            
            let image = (tableUserSettings[indexPath.section].self as! SectionsModelTwo).currentSectionsModel[indexPath.row].image
            let title = (tableUserSettings[indexPath.section].self as! SectionsModelTwo).currentSectionsModel[indexPath.row].title
            let color = (tableUserSettings[indexPath.section].self as! SectionsModelTwo).currentSectionsModel[indexPath.row].backgoundColor
            
            return (image, color, title)
            
        case let object where object as? SectionsModelThree != nil:
            
            let image = (tableUserSettings[indexPath.section].self as! SectionsModelThree).currentSectionsModel[indexPath.row].image
            let title = (tableUserSettings[indexPath.section].self as! SectionsModelThree).currentSectionsModel[indexPath.row].title
            let color = (tableUserSettings[indexPath.section].self as! SectionsModelThree).currentSectionsModel[indexPath.row].backgoundColor
            
            return (image, color, title)
            
        default:
            
            let image = (tableUserSettings[indexPath.section].self as! SectionWithUserFollowers).currentSectionsModel[indexPath.row].image
            let title = (tableUserSettings[indexPath.section].self as! SectionWithUserFollowers).currentSectionsModel[indexPath.row].title
            
            return (image, nil, title)
        }
    }
}

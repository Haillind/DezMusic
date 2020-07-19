//
//  UserSettingsController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 11.07.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class UserSettingsController: UIViewController {
    
    var tableUserSettings: [Any] = [
        TestSection(currentSectionsModel: [.init(image: UIImage(named: "rock")!, title: "UserProfileName")]),
        
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
    
    var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.alpha = 1
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.topItem?.title = " "
        navigationItem.title = "Settings"
        
        let attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 22)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.frame, style: .grouped)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserSettingsCell.self, forCellReuseIdentifier: UserSettingsCell.userSettingsCellId)
        tableView.register(UserSettingInfoProfileCell.self, forCellReuseIdentifier: UserSettingInfoProfileCell.userSettingInfoProfileCellId)
        
        tableViewSettings()
    }
    
    func tableViewSettings() {
        view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        let tableViewHeader = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 18))
        tableViewHeader.backgroundColor = .clear
        tableView.tableHeaderView = tableViewHeader
        
        let tableViewFooter = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 18))
        tableViewFooter.backgroundColor = .clear
        tableView.tableFooterView  = tableViewFooter
    }
    

}

extension UserSettingsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableUserSettings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let set = tableUserSettings[section]
        
        switch set {
        case let object where object as? SectionsModelOne != nil:
            return (tableUserSettings[section] as! SectionsModelOne).currentSectionsModel.count
        case let object where object as? SectionsModelTwo != nil:
            return (tableUserSettings[section] as! SectionsModelTwo).currentSectionsModel.count
        case let object where object as? SectionsModelThree != nil:
            return (tableUserSettings[section] as! SectionsModelThree).currentSectionsModel.count
        
        default:
            
            return (tableUserSettings[section] as! TestSection).currentSectionsModel.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserSettingsCell.userSettingsCellId) as! UserSettingsCell
        let testcell = tableView.dequeueReusableCell(withIdentifier: UserSettingInfoProfileCell.userSettingInfoProfileCellId) as! UserSettingInfoProfileCell
        
        let set = tableUserSettings[indexPath.section]
        
        switch set {
        case let object where object as? SectionsModelOne != nil:
            
            let image = (tableUserSettings[indexPath.section].self as! SectionsModelOne).currentSectionsModel[indexPath.row].image
            let title = (tableUserSettings[indexPath.section].self as! SectionsModelOne).currentSectionsModel[indexPath.row].title
            let color = (tableUserSettings[indexPath.section].self as! SectionsModelOne).currentSectionsModel[indexPath.row].backgoundColor
            cell.rowImageView.image = image
            cell.viewForRowImage.backgroundColor = color
            cell.rowTitle.text = title
            
        case let object where object as? SectionsModelTwo != nil:
            
            let image = (tableUserSettings[indexPath.section].self as! SectionsModelTwo).currentSectionsModel[indexPath.row].image
            let title = (tableUserSettings[indexPath.section].self as! SectionsModelTwo).currentSectionsModel[indexPath.row].title
            let color = (tableUserSettings[indexPath.section].self as! SectionsModelTwo).currentSectionsModel[indexPath.row].backgoundColor
            cell.rowImageView.image = image
            cell.viewForRowImage.backgroundColor = color
            cell.rowTitle.text = title
            
        case let object where object as? SectionsModelThree != nil:
            
            let image = (tableUserSettings[indexPath.section].self as! SectionsModelThree).currentSectionsModel[indexPath.row].image
            let title = (tableUserSettings[indexPath.section].self as! SectionsModelThree).currentSectionsModel[indexPath.row].title
            let color = (tableUserSettings[indexPath.section].self as! SectionsModelThree).currentSectionsModel[indexPath.row].backgoundColor
            cell.rowImageView.image = image
            cell.viewForRowImage.backgroundColor = color
            cell.rowTitle.text = title
            
        default:
            
            let image = (tableUserSettings[indexPath.section].self as! TestSection).currentSectionsModel[indexPath.row].image
            let title = (tableUserSettings[indexPath.section].self as! TestSection).currentSectionsModel[indexPath.row].title
            
            testcell.iconImage.image = image
            testcell.profileName.text = title
            
            return testcell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 {
            return 130
        } else {
            return 60
        }

    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if (tableUserSettings[section] as? SectionsModelTwo) != nil {
            let view = UITableViewHeaderFooterView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: tableView.sectionHeaderHeight))
            //view.contentView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
            view.contentView.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 0)
            view.textLabel?.numberOfLines = 0
            view.textLabel?.text = "In oflline mode you can only listen to previously downloaded playlists and albums"
            return view
        }
        
        let view = UITableViewHeaderFooterView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: tableView.sectionHeaderHeight))
        return view

    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if (tableUserSettings[section] as? SectionsModelTwo) != nil {
            return 50
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}




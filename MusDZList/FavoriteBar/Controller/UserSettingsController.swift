//
//  UserSettingsController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 11.07.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class UserSettingsController: UIViewController {
    
    let userSettingsLogicModel = UserSettingsLogicModel()
    
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
        return userSettingsLogicModel.tableUserSettings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userSettingsLogicModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserSettingsCell.userSettingsCellId) as! UserSettingsCell
        let testcell = tableView.dequeueReusableCell(withIdentifier: UserSettingInfoProfileCell.userSettingInfoProfileCellId) as! UserSettingInfoProfileCell
        
        let currentRow = userSettingsLogicModel.settingsForEachCell(indexPath: indexPath)
        
        if currentRow.color != nil {
            cell.rowImageView.image = currentRow.image
            cell.viewForRowImage.backgroundColor = currentRow.color!
            cell.rowTitle.text = currentRow.title
            
            return cell
        } else {
            
            testcell.iconImage.image = currentRow.image
            testcell.profileName.text = currentRow.title
            
            return testcell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 {
            return 130
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        if section == 2 {
            let view = UITableViewHeaderFooterView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: tableView.sectionHeaderHeight))
            view.contentView.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 0)
            view.textLabel?.numberOfLines = 0
            view.textLabel?.text = "In oflline mode you can only listen to previously downloaded playlists and albums"
            return view
        }
        
        let view = UITableViewHeaderFooterView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: tableView.sectionHeaderHeight))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 2 {
            return 50
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}




//
//  TopTrackTableView.swift
//  MusDZList
//
//  Created by Denis Selivanov on 28.09.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit
import LNPopupController

class TopTrackTableView: UITableView {
    
    var topTracksInfoCells = [TopTracksSongModel]()
    
    init() {
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        
        delegate = self
        dataSource = self
        register(TopTrackListCell.self, forCellReuseIdentifier: String(describing: TopTrackListCell.self))
        
        showsVerticalScrollIndicator = true
        rowHeight = 100
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(cells: [TopTracksSongModel]) {
        topTracksInfoCells = cells
    }
    
}

extension TopTrackTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topTracksInfoCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TopTrackListCell.self), for: indexPath) as! TopTrackListCell
        
        cell.trackLabel.text = topTracksInfoCells[indexPath.item].nameOfSong
        cell.albumLabel.text = "\(topTracksInfoCells[indexPath.item].nameOFContributors) - \(topTracksInfoCells[indexPath.item].albumName)"
        cell.imageAlbumTrack.image = UIImage(data: topTracksInfoCells[indexPath.item].albumImage)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(topTracksInfoCells[indexPath.item].nameOfSong)
        //let mainTabBar = UITabBarController(nibName: "TabBarController", bundle: nil)
        let storyboard = UIStoryboard(name: "Player", bundle: nil)
        let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerController") as! PlayerController
        
        //mainTabBar.present(playerVC, animated: true, completion: nil)
        self.window?.rootViewController?.present(playerVC, animated: true, completion: nil)
//        topVC.present(playerVC, animated: true, completion: nil)
//        topVC.tabBarController?.presentPopupBar(withContentViewController: playerVC, openPopup: true, animated: true,  completion: nil)
    }
    
}

extension TopTrackTableView {
    func getTestPopUp(didSelectRowAt indexPath: IndexPath, completion: @escaping (PlayerController)->()) {
        let storyboard = UIStoryboard(name: "Player", bundle: nil)
        let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerController") as! PlayerController
        
        playerVC.artistName = topTracksInfoCells[indexPath.item].artistName
        playerVC.playlistOptional = topTracksInfoCells
        playerVC.indexPath = indexPath.item
        
        completion(playerVC)
    }
}

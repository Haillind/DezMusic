//
//  FavoritesTabController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 09.07.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

enum CellActionsDoing: Int {
    case Downloaded = 0,
         FavoriteTracks,
         Playlists,
         Albums,
         Artists,
         Mixes
}

class FavoritesTabController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .black
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let networkingGroup = DispatchGroup()
    
    private var tableView = FavoritesMenuTableView()
    
    private let networking = NetworkingFavoriteMenu()
    
    private var userFavoriteArtistData: [FavoritesArtistsData] {
        let navVC = tabBarController?.viewControllers![0] as! UINavigationController
        let musicVC = navVC.viewControllers[0] as! MusicController
        return musicVC.userFavoriteArtistData
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .gray
        navigationController?.navigationBar.barTintColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webSessionsForTableViewContent()
        
        tableViewSettings()
        setActivityIndicator()
        
        setNavBarButtons()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFavoriteTrackCount), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
    }
    
    @objc private func refreshFavoriteTrackCount() {

        networking.favoriteTracksList = []
        networking.favoriteTracksListData = []
        networking.countOfTracks = 0
        
        webSessionsForTableViewContent()
    }
    
    private func tableViewSettings() {
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        tableView.favoritesTableListEnum[CellActionsDoing.Artists.rawValue].countOfDataInfoForCurrentRow = userFavoriteArtistData.count
    }
    
    private func setActivityIndicator() {
        view.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setNavBarButtons() {
        let notificateBarBtn = UIBarButtonItem(image: UIImage(systemName: "bell.fill"), style: .plain, target: self, action: #selector(notificateSelector))
        
        let userSettingBarBtn = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(userProfileSelector))
        
        self.navigationItem.rightBarButtonItems = [userSettingBarBtn, notificateBarBtn]
    }
    
    @objc private func notificateSelector() {
//        print(TrackIsLiked.shared.userTrackIsLiked?.count)
        passToFavoriteTableViewAboutReloadTrackCount()
        tableView.reloadData()
    }
    
    @objc private func userProfileSelector() {
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    private func passToFavoriteTableViewAboutReloadTrackCount (){
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
    }

}

//MARK: - Web Sessions Methods For TableView

extension FavoritesTabController {
    
    private func webSessionsForTableViewContent() {
        
        networkingGroup.enter()
        self.networking.getCountOfUserFavoriteTrack {
            self.tableView.favoritesTableListEnum[CellActionsDoing.FavoriteTracks.rawValue].countOfDataInfoForCurrentRow = self.networking.favoriteTracksList.count
            self.networkingGroup.leave()
        }
        
        networkingGroup.enter()
        self.networking.getAndSetCountOfUserPlaylists { (countPlaylists) in
            self.tableView.favoritesTableListEnum[CellActionsDoing.Playlists.rawValue].countOfDataInfoForCurrentRow = countPlaylists
            self.networkingGroup.leave()
        }
        
        networkingGroup.enter()
        self.networking.getAndSetCountOfUserAlbums { (countAlbums) in
            self.tableView.favoritesTableListEnum[CellActionsDoing.Albums.rawValue].countOfDataInfoForCurrentRow = countAlbums
            self.networkingGroup.leave()
        }
        
        networkingGroup.notify(queue: DispatchQueue.main) {
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
}



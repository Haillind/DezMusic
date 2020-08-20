//
//  FavoritesTabController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 09.07.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class FavoritesTabController: UIViewController {
    
    var tableView: UITableView!
    
    var favoritesTableList = [
                                FavoriteControllerRowValue(titleOfTableRow: "Downloaded", countOfDataInfoForCurrentRow: 0),
                                FavoriteControllerRowValue(titleOfTableRow: "Favorite Tracks", countOfDataInfoForCurrentRow: 0),
                                FavoriteControllerRowValue(titleOfTableRow: "Playlists", countOfDataInfoForCurrentRow: 0),
                                FavoriteControllerRowValue(titleOfTableRow: "Albums", countOfDataInfoForCurrentRow: 0),
                                FavoriteControllerRowValue(titleOfTableRow: "Artists", countOfDataInfoForCurrentRow: 0),
                                FavoriteControllerRowValue(titleOfTableRow: "Mixes", countOfDataInfoForCurrentRow: 0)
    ]
    
    var userFavoriteArtistData: [FavoritesArtistsData] {
        let navVC = tabBarController?.viewControllers![0] as! UINavigationController
        let musicVC = navVC.viewControllers[0] as! MusicController
        return musicVC.userFavoriteArtistData
    }
    
    var favoriteTracksListData = [FavoriteTracksData]()
    var favoriteTracksList = [FavoriteTracksTabTableViewModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .gray
        navigationController?.navigationBar.barTintColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        
        webSessionsForTableCiewContent()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoritesTabCell.self, forCellReuseIdentifier: FavoritesTabCell.favoriteTabCellId)
        
        tableViewSettings()
        
        setNavBarButtons()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFavoriteTrackCount), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
    }
    
    @objc func refreshFavoriteTrackCount() {

        favoriteTracksList = []
        favoriteTracksListData = []
        webSessionsForTableCiewContent()
    }
    
    func tableViewSettings() {
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        
        self.favoritesTableList[4].countOfDataInfoForCurrentRow = userFavoriteArtistData.count
    }
    
    func setNavBarButtons() {
        let notificateBarBtn = UIBarButtonItem(image: UIImage(systemName: "bell.fill"), style: .plain, target: self, action: #selector(notificateSelector))
        
        let userSettingBarBtn = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(userProfileSelector))
        
        self.navigationItem.rightBarButtonItems = [userSettingBarBtn, notificateBarBtn]
    }
    
    @objc func notificateSelector() {
        print(TrackIsLiked.shared.userTrackIsLiked?.count)
        
    }
    
    @objc func userProfileSelector() {
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }

}

//MARK: - TableView Delegate Methods

extension FavoritesTabController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesTableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTabCell.favoriteTabCellId, for: indexPath) as! FavoritesTabCell
        cell.favoriteMenuLabel.text = favoritesTableList[indexPath.item].titleOfTableRow
        cell.rowInfoLabel.text = String(favoritesTableList[indexPath.item].countOfDataInfoForCurrentRow)
        return cell
    }
    
    
}

//MARK: - Web Sessions Methods For TableView

extension FavoritesTabController {
    
    private func webSessionsForTableCiewContent() {
        setFavoriteTracks()
        
        getUserPlaylists()
        getUserAlbums()
    }
    
    func setFavoriteTracks() {
        let urlFavoriteTracks = "https://api.deezer.com/user/me/tracks?access_token=\(UserDefaults.standard.string(forKey: "accessToken")!)"
        
        guard let url = URL(string: urlFavoriteTracks) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else {return}
            do {
                let safeData = try JSONDecoder().decode(FavoriteTracksData.self, from: data)
                self.favoriteTracksListData.append(safeData)
                
                if safeData.next != nil {
                    self.downloadNextTrackListForTrackModel(url: safeData.next)
                } else {
                    
                    self.setFavoriteTracksModels {
                        
                        self.favoritesTableList[1].countOfDataInfoForCurrentRow = self.favoriteTracksList.count
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                        return
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func setFavoriteTracksModels(completion: (() -> Void)?) {
        
        for listData in favoriteTracksListData {
            
            for track in listData.data {
                
                URLSession.shared.dataTask(with: track.album.coverBig) { (data, _, _) in
                    
                    guard let data = data else {return}
                    
                    let newTrack = FavoriteTracksTabTableViewModel(artistName: track.artist.name, nameOfSong: track.title, titleAlbum: track.album.title, imageAlbum: data)
                    self.favoriteTracksList.append(newTrack)
                    
                   completion!()
                }.resume()
            }
        }
    }
    
    func downloadNextTrackListForTrackModel(url: URL?) {
        
        guard let url = url else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else {return}
            
            do {
                let safeData = try JSONDecoder().decode(FavoriteTracksData.self, from: data)
                self.favoriteTracksListData.append(safeData)
                
                if safeData.next != nil {
                    self.downloadNextTrackListForTrackModel(url: safeData.next)
                } else {
                    
                    self.setFavoriteTracksModels {
                        self.favoritesTableList[1].countOfDataInfoForCurrentRow = self.favoriteTracksList.count
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    
                    return
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getUserPlaylists() {
        let urlString = "https://api.deezer.com/user/me/playlists?access_token=\(UserDefaults.standard.string(forKey: "accessToken")!)"
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else {return}
            do {
                let safeData = try JSONDecoder().decode(UserPlaylistsData.self, from: data)
                self.favoritesTableList[2].countOfDataInfoForCurrentRow = safeData.total
                
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getUserAlbums() {
        let urlString = "https://api.deezer.com/user/me/albums?access_token=\(UserDefaults.standard.string(forKey: "accessToken")!)"
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else {return}
            do {
                let safeData = try JSONDecoder().decode(UserAlbumsData.self, from: data)
                self.favoritesTableList[3].countOfDataInfoForCurrentRow = safeData.total
                
            } catch {
                print(error)
            }
        }.resume()
    }
}



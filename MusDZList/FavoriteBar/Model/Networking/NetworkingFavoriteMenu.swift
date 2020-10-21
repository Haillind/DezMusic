//
//  NetworkingFavoriteMenu.swift
//  MusDZList
//
//  Created by Denis Selivanov on 29.09.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

class NetworkingFavoriteMenu {
    
    let decoderJSON = DecoderJSON()
    
    var favoriteTracksListData = [FavoriteTracksData]()
    var favoriteTracksList = [FavoriteTracksTabTableViewModel]()
    
    var countOfTracks = 0
    private let tracksInOneStack = 25

    //MARK: - Count of favorite songs
    func getCountOfUserFavoriteTrack(completion: @escaping () -> ()) {
        let urlFavoriteTracks = "https://api.deezer.com/user/me/tracks?access_token=\(UserDefaults.standard.string(forKey: "accessToken")!)"
        guard let url = URL(string: urlFavoriteTracks) else {return}

        NetworkService.shared.getDataFromServer(url: url) { (data, _, _) in

            guard let data = data else {return}

            self.decoderJSON.decodeToJSON(data: data, toDecode: FavoriteTracksData.self) { (decoderData) in
                
                self.favoriteTracksListData.append(decoderData)
                
                if decoderData.next != nil {
                    self.downloadNextUserFavoriteTracksForFindingCount(url: decoderData.next) {
                        completion()
                    }
                } else {
                    self.setCountOfUserFavoriteTracksInMenu(allList: self.favoriteTracksListData) {
                        completion()
                    }
                }
            }
        }
    }
    
    func setCountOfUserFavoriteTracksInMenu(allList: [FavoriteTracksData], completion: @escaping () -> ()) {
        
        let finalTracksCount = tracksInOneStack * allList.count
        
        for trackList in allList  {
            for track in trackList.data {
                
                NetworkService.shared.getDataFromServer(url: track.album.coverBig) { (data, _, _) in
                    
                    guard let data = data else {return}
                    let newTrack = FavoriteTracksTabTableViewModel(artistName: track.artist.name, nameOfSong: track.title, titleAlbum: track.album.title, imageAlbum: data)
                    self.favoriteTracksList.append(newTrack)
                    self.countOfTracks += 1
                    
                    if self.countOfTracks == finalTracksCount - ( self.tracksInOneStack - trackList.data.count) {
                        completion()
                    }
                }
            }
        }
    }
    
    func downloadNextUserFavoriteTracksForFindingCount(url: URL?, completion: @escaping ()->()) {

        guard let url = url else {return}
        NetworkService.shared.getDataFromServer(url: url) { (data, _, _) in
            guard let data = data else {return}
            
            self.decoderJSON.decodeToJSON(data: data, toDecode: FavoriteTracksData.self) { (decoderData) in
                
                self.favoriteTracksListData.append(decoderData)
                
                if decoderData.next != nil {
                    self.downloadNextUserFavoriteTracksForFindingCount(url: decoderData.next) {
                        completion()
                    }
                } else {
                    self.setCountOfUserFavoriteTracksInMenu(allList: self.favoriteTracksListData) {
                        completion()
                    }
                }
            }
        }
    }
    
    //MARK: - Count user playlists
    
    func getAndSetCountOfUserPlaylists(completion: @escaping (Int) -> ()) {
        let urlString = "https://api.deezer.com/user/me/playlists?access_token=\(UserDefaults.standard.string(forKey: "accessToken")!)"
        
        guard let url = URL(string: urlString) else {return}
        
        NetworkService.shared.getDataFromServer(url: url) { (data, _, _) in
            guard let data = data else {return}
            
            self.decoderJSON.decodeToJSON(data: data, toDecode: UserPlaylistsData.self) { (decoderData) in
                completion(decoderData.total)
            }
        }
    }
    
    //MARK: - Count of user Albums
    
    func getAndSetCountOfUserAlbums(completion: @escaping (Int) -> ()) {
        
        let urlString = "https://api.deezer.com/user/me/albums?access_token=\(UserDefaults.standard.string(forKey: "accessToken")!)"
        
        guard let url = URL(string: urlString) else {return}
        
        NetworkService.shared.getDataFromServer(url: url) { (data, _, _) in
            guard let data = data else {return}
            
            self.decoderJSON.decodeToJSON(data: data, toDecode: UserAlbumsData.self) { (decoderData) in
                completion(decoderData.total)
            }
        }
    }
    
}

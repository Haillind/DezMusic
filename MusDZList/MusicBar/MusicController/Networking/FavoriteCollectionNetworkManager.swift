//
//  MusicBarNetworkManager.swift
//  MusDZList
//
//  Created by Denis Selivanov on 28.09.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

class FavoriteCollectionNetworkManager {
    
    static let shared = FavoriteCollectionNetworkManager()
    
    let decoderJSON = DecoderJSON()
    
    func getFavoriteArtistsUrlFromServer(accessToken: String?, completion: @escaping ([FavoritesArtistsData]) -> ()) {
        
        guard let accessToken = accessToken else {return}
        
        var artistData = [FavoritesArtistsData]()
        let urlUser = "https://api.deezer.com/user/me/artists?access_token=\(accessToken)"
        guard let url = URL(string: urlUser) else {return}
        
        NetworkService.shared.getDataFromServer(url: url) { (data, _, error) in
            guard let data = data else {return}
            
            self.decoderJSON.decodeToJSON(data: data, toDecode: UserFavoriteArtistsData.self) { (decodedData) in
                for artist in decodedData.data {
                    artistData.append(artist)
                }
                completion(artistData)
            }
        }
    }
    
    func getFavoriteArtistsInfoAndGettingImageForShowing(favoriteArtistsData array: [FavoritesArtistsData], completion: @escaping ([FavoriteArtistsModel]) -> ()) {
        
        var artistModels = [FavoriteArtistsModel]()
        
        for artist in array {
            
            let urlForImage = artist.pictureBig
            
            NetworkService.shared.getDataFromServer(url: urlForImage) { (data, _, _) in
                
                guard let data = data else {return}
                
                let artistInfo = FavoriteArtistsModel(id: artist.id, name: artist.name, picture_big: data)
                artistModels.append(artistInfo)
                
                completion(artistModels)
            }
        }
    }
    
}

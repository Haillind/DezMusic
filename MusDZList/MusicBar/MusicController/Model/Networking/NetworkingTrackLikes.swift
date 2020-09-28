//
//  NetworkingTrackLikes.swift
//  MusDZList
//
//  Created by Denis Selivanov on 28.09.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

class NetworkingTrackLikes {
    
    static let shared = NetworkingTrackLikes()
    
    let decoderJSON = DecoderJSON()
    
    func singletonForCheckFavoriteTracksIsLikedRefactoring() {
        
        TrackIsLiked.shared.userTrackIsLiked = Set.init()
        
        let urlFavoriteTracks = "https://api.deezer.com/user/me/tracks?access_token=\(UserDefaults.standard.string(forKey: "accessToken")!)"
        
        guard let url = URL(string: urlFavoriteTracks) else {return}
        
        NetworkService.shared.getDataFromServer(url: url) { (data, _, _) in
            
            guard let data = data else {return}
            self.decoderJSON.decodeToJSON(data: data, toDecode: FavoriteTracksData.self) { (decodedData) in
                
                for object in decodedData.data {
                    TrackIsLiked.shared.userTrackIsLiked?.insert(object.id)
                }
                if decodedData.next != nil {
                    self.downloadNextListOfFavoriteTrackForSingletonRefactoring(url: decodedData.next)
                } else {
                    return
                }
            }
        }
    }
    
    func downloadNextListOfFavoriteTrackForSingletonRefactoring(url: URL?) {
        
        guard let url = url else {return}
        
        NetworkService.shared.getDataFromServer(url: url) { (data, _, _) in
            
            guard let data = data else {return}
            self.decoderJSON.decodeToJSON(data: data, toDecode: FavoriteTracksData.self) { (decodedData) in
                
                for object in decodedData.data {
                    TrackIsLiked.shared.userTrackIsLiked?.insert(object.id)
                }
                
                if decodedData.next != nil {
                    self.downloadNextListOfFavoriteTrackForSingletonRefactoring(url: decodedData.next)
                } else {
                    return
                }
            }
        }
    }
    
}


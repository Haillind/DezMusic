//
//  RecommendedCollectionNetworkManager.swift
//  MusDZList
//
//  Created by Denis Selivanov on 28.09.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

class RecommendedCollectionNetworkManager {
    
    static let shared = RecommendedCollectionNetworkManager()
    
    let decoderJSON = DecoderJSON()
    
    func getRecomendedPlaylistsFromServer(accessToken: String?, userProfileId: String?, completion: @escaping ([RecomendedPlaylistInfo]) -> ()) {
        
        var count = 0
        
        guard let accessToken = accessToken, let userProfileId = userProfileId else {return}
        
        var recomendedPLData = [RecomendedPlaylistInfo]()
        
        let urlUser = "https://api.deezer.com/user/\(userProfileId)/recommendations/playlists?access_token=\(accessToken)"
        guard let url = URL(string: urlUser) else {return}
        
        NetworkService.shared.getDataFromServer(url: url) { (data, _, error) in
            
            guard let data = data else {return}
            
            self.decoderJSON.decodeToJSON(data: data, toDecode: RecomendedPlaylistsData.self) { (decodedData) in
                for recomendedData in decodedData.data {
                    
                    if count <= 3 {
                        recomendedPLData.append(recomendedData)
                        count += 1
                    }
                }
                completion(recomendedPLData)
            }
        }
    }
    
    func getRecommendedPlaylistsInfoAndGettingImageForShowing(recommendedPlaylistsData array: [RecomendedPlaylistInfo], completion: @escaping (Data) -> ()) {
        
        for playlistsInfo in array {
            
            NetworkService.shared.getDataFromServer(url: playlistsInfo.pictureBig) { (data, _, _) in
                guard let data = data else {return}
                completion(data)
            }
        }
    }
    
}

//
//  NetworkingChoosedRecommendedTrackList.swift
//  MusDZList
//
//  Created by Denis Selivanov on 14.10.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

class NetworkingChoosedRecommendedTrackList {
    
    let decoderJSON = DecoderJSON()
    
    var choosedTrackListData = [RecommendTracklistDataModel]()
    var choosedModelList = [ChoosedList]()
    
    var countOfTracks = 0
    private let tracksInOneStack = 25
    
//    func getTestChoosedListOfData(tracklistURL: URL, completion: @escaping () -> ()) {
//
//        NetworkService.shared.getDataFromServer(url: tracklistURL) { (data, _, _) in
//
//            guard let data = data else {return}
//
//            self.decoderJSON.decodeToJSON(data: data, toDecode: RecommendTracklistDataModel.self) { (decoderData) in
//                
//                self.choosedTrackListData.append(decoderData)
////                for object in decoderData.data {
////                    let newModel = ChoosedList(nameOfSong: object.title, artistName: object.artist.name, albumName: object.album.title, image: nil)
////                    self.choosedModelList.append(newModel)
////                }
//                completion()
//            }
//        }
//    }
//    
//    func getImageForChoosedTableAndCreateModel(dataModel: [RecommendTracklistDataModel], completion: @escaping () -> ()) {
//        for model in dataModel {
//            for infoFromModel in model.data {
//                NetworkService.shared.getDataFromServer(url: infoFromModel.album.coverBig) { (data, _, _) in
//                    guard let data = data else {return}
//                    
//                    let modelForTable = ChoosedList(nameOfSong: infoFromModel.title, artistName: infoFromModel.artist.name, albumName: infoFromModel.album.title, image: data)
//                    self.choosedModelList.append(modelForTable)
//                    completion()
//                }
//            }
//        }
//    }
    
    //MARK: - new functions
    
    func getTestChoosedListOfDataFinally(tracklistURL: URL, completion: @escaping () -> ()) {

        NetworkService.shared.getDataFromServer(url: tracklistURL) { (data, _, _) in
            
            guard let data = data else {return}
            
            self.decoderJSON.decodeToJSON(data: data, toDecode: RecommendTracklistDataModel.self) { (decoderData) in
                
                self.choosedTrackListData.append(decoderData)
                
                if decoderData.next != nil {
                    self.downloadNextTrackForChoosedList(url: decoderData.next) {
                        completion()
                    }
                } else {
                    self.setModelsForTableViewTracks(allList: self.choosedTrackListData) {
                        completion()
                    }
                }
            }
        }
    }
    
    func setModelsForTableViewTracks(allList: [RecommendTracklistDataModel], completion: @escaping () -> ()) {
        
        let finalTracksCount = tracksInOneStack * allList.count
        
        for trackList in allList  {
            for track in trackList.data {
                
                NetworkService.shared.getDataFromServer(url: track.album.coverBig) { (data, _, _) in
                    
                    guard let data = data else {return}
                    
                    let newModel = ChoosedList(nameOfSong: track.title, artistName: track.artist.name, albumName: track.album.title, image: data)
                    self.choosedModelList.append(newModel)
                    self.countOfTracks += 1
//                    completion()
                    if self.countOfTracks == finalTracksCount - ( self.tracksInOneStack - trackList.data.count) {
                        completion()
                    }
                }
            }
        }
    }
    
    func downloadNextTrackForChoosedList(url: URL?, completion: @escaping ()->()) {
        guard let url = url else {return}
        NetworkService.shared.getDataFromServer(url: url) { (data, _, _) in
            guard let data = data else {return}
            
            self.decoderJSON.decodeToJSON(data: data, toDecode: RecommendTracklistDataModel.self) { (decoderData) in
                
                self.choosedTrackListData.append(decoderData)
                
                if decoderData.next != nil {
                    self.downloadNextTrackForChoosedList(url: decoderData.next) {
                        completion()
                    }
                } else {
                    self.setModelsForTableViewTracks(allList: self.choosedTrackListData) {
                        completion()
                    }
                }
            }
        }
    }
    
}

//
//  TopTrackController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 12.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit
import AVKit
import LNPopupController

class TopTrackController: UIViewController {

    @IBOutlet weak var tableViewTopTrack: UITableView!
    
    let decoderJSON = DecoderJSON()
    
    var nameForTitle: String?
    var idArtistsForQuery: Int?
    
    var topTracksInfo = [TopTracksSongModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        
        guard let name = nameForTitle else {return}
        navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "\(name)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewTopTrack.delegate = self
        tableViewTopTrack.dataSource = self
        
        tableViewTopTrack.register(UINib(nibName: "TopTrackCell", bundle: nil), forCellReuseIdentifier: "topTrackCell")
        
        settingsForTableView()
        
        getTopTrackListOfArtistsRefactoring(idArtist: idArtistsForQuery) { (topTrackList) in
            self.getImageForTrackInTopListRefactoring(arrayOf: topTrackList) {
                self.tableViewTopTrack.reloadData()
            }
        }
    }
    
}


//MARK: - TableView Delegate Methods
extension TopTrackController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topTracksInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewTopTrack.dequeueReusableCell(withIdentifier: "topTrackCell", for: indexPath) as! TopTrackCell
        
        cell.trackLabel.text = topTracksInfo[indexPath.item].nameOfSong
        cell.albumLabel.text = "\(topTracksInfo[indexPath.item].nameOFContributors) - \(topTracksInfo[indexPath.item].albumName)"
        cell.imageAlbumTrack.image = UIImage(data: topTracksInfo[indexPath.item].albumImage)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Player", bundle: nil)
        let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerController") as! PlayerController
        
        playerVC.artistName = topTracksInfo[indexPath.item].artistName
        playerVC.playlistOptional = topTracksInfo
        playerVC.indexPath = indexPath.item
        
        tabBarController?.popupBar.progressViewStyle = .top
        tabBarController?.popupInteractionStyle = .drag
        tabBarController?.popupContentView.popupCloseButtonStyle = .round
        tabBarController?.presentPopupBar(withContentViewController: playerVC, openPopup: true, animated: true,  completion: nil)
    }
    
    func settingsForTableView() {
        tableViewTopTrack.rowHeight = 100
    }
    
}

extension TopTrackController {
    
    func getTopTrackListOfArtistsRefactoring(idArtist: Int?, completion: @escaping ([TopTracksList]) -> ()) {
        
        guard let idArtist = idArtist else {return}
        let urlForTopTrackList = "https://api.deezer.com/artist/\(idArtist)/top?limit=50"
        guard let url = URL(string: urlForTopTrackList) else {return}
        
        NetworkService.shared.getDataFromServer(url: url) { (data, _, _) in
            
            guard let data = data else {return}
            
            self.decoderJSON.decodeToJSON(data: data, toDecode: ListOfTopTracksData.self) { (decoderData) in
                var arrayOfTracks = [TopTracksList]()
                for topTrack in decoderData.data {
                    arrayOfTracks.append(topTrack)
                }
                completion(arrayOfTracks)
            }
        }
    }
    
    func getImageForTrackInTopListRefactoring(arrayOf topTrackList: [TopTracksList], completion: @escaping () -> ()) {
        
        for track in topTrackList {
            
            let contributString = ConstructOfString.shared.constructContributers(listOf: track.contributors)
            
            // Networking
            let urlForImage = track.album.coverBig
            
            NetworkService.shared.getDataFromServer(url: urlForImage) { (data, _, _) in
                
                guard let data = data else {return}
                let trackInfo = TopTracksSongModel(id: track.id, artistName: track.artist.name, albumName: track.album.title, albumImage: data, nameOfSong: track.title, nameOFContributors: contributString, totalDuration: "30", urlForSong: track
                    .preview)
                self.topTracksInfo.append(trackInfo)
                completion()
            }
        }
    }
    
}

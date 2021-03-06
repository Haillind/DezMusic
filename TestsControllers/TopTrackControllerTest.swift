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

class TopTrackControllerTest: UIViewController {
    
    var tableViewTopTrack = TopTrackTableView()
    
    var nameForTitle: String?
    var idArtistsForQuery: Int?
    
    var arrayOfDataTracks = [TopTracksList]()
    var topTracksInfo = [TopTracksSongModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preSettingController()
        setTableView()
        
        getTopTrackListOfArtists(idArtist: idArtistsForQuery){
            self.getImageForTrackInTopList() {
            }
        }
        
    }
    
    func setTableView() {
        view.addSubview(tableViewTopTrack)
        tableViewTopTrack.separatorStyle = .none
        
        tableViewTopTrack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableViewTopTrack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableViewTopTrack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableViewTopTrack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableViewTopTrack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableViewTopTrack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func preSettingController() {
        guard let name = nameForTitle else {return}
        navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "\(name)"
    }
    
}


//extension TopTrackControllerTest: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return topTracksInfo.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableViewTopTrack.dequeueReusableCell(withIdentifier: "topTrackCell", for: indexPath) as! TopTrackCell
//
//        cell.trackLabel.text = topTracksInfo[indexPath.item].nameOfSong
//        cell.albumLabel.text = "\(topTracksInfo[indexPath.item].nameOFContributors) - \(topTracksInfo[indexPath.item].albumName)"
//        cell.imageAlbumTrack.image = UIImage(data: topTracksInfo[indexPath.item].albumImage)
//
//        return cell
//
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let storyboard = UIStoryboard(name: "Player", bundle: nil)
//        let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerController") as! PlayerController
//
//        playerVC.artistName = topTracksInfo[indexPath.item].artistName
//        playerVC.playlistOptional = topTracksInfo
//        playerVC.indexPath = indexPath.item
//
//        tabBarController?.popupBar.progressViewStyle = .top
//        tabBarController?.popupInteractionStyle = .drag
//        tabBarController?.popupContentView.popupCloseButtonStyle = .round
//        tabBarController?.presentPopupBar(withContentViewController: playerVC, openPopup: true, animated: true,  completion: nil)
//    }
//
//    func settingForTableView() {
//        tableViewTopTrack.rowHeight = 100
//    }
//
//}
//
extension TopTrackControllerTest {

    func getTopTrackListOfArtists(idArtist: Int?, completion: (() -> Void)?) {

        guard let idArtist = idArtist else {return}
        let urlForTopTrackList = "https://api.deezer.com/artist/\(idArtist)/top?limit=50"
        guard let url = URL(string: urlForTopTrackList) else {return}

        URLSession.shared.dataTask(with: url) { (data, _, error) in

            guard let data = data else {return}

            do {

                let topTrackData = try JSONDecoder().decode(ListOfTopTracksData.self, from: data)
                for object in topTrackData.data {
                    self.arrayOfDataTracks.append(object)
                }

            } catch {
                print(error)
            }

            completion!()
        }.resume()
    }

    func getImageForTrackInTopList(completion: (() -> Void)?) {
        
        var arrayTest = [TopTracksSongModel]()
        for track in arrayOfDataTracks {
            var contributString = ""

            for (index, contribut) in track.contributors.enumerated() {
                if index != track.contributors.count - 1 {
                    contributString += "\(contribut.name), "
                } else {
                    contributString += "\(contribut.name)"
                }
            }

            // URL Sesion

            let urlForImage = track.album.coverBig

            URLSession.shared.dataTask(with: urlForImage) { (data, _, error) in
                
                guard let data = data else {return}
                
                let trackInfo = TopTracksSongModel(id: track.id, artistName: track.artist.name, albumName: track.album.title, albumImage: data, nameOfSong: track.title, nameOFContributors: contributString, totalDuration: "30", urlForSong: track
                    .preview)
                self.topTracksInfo.append(trackInfo)
                arrayTest.append(trackInfo)
                self.tableViewTopTrack.set(cells: arrayTest)
                DispatchQueue.main.async {
                    self.tableViewTopTrack.reloadData()
                }
                completion!()
            }.resume()
        }
    }
}

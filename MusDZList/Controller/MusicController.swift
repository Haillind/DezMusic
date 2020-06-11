//
//  MusicController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 09.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class MusicController: UIViewController {
    
    var accessToken: String?
    var userProfileId: String?
    var favoriteUrls = [URL]()
    var favoriteImageForScreen = [UIImage]()
    var recomendedPlaylistResults = [RecomendedPlaylistInfo]()
    var recomendedPlaylistImages = [UIImage]()
    
    @IBOutlet weak var collectionViewFavorArtists: UICollectionView!
    @IBOutlet weak var collectionViewRecomendedPlaylists: UICollectionView!
    @IBOutlet weak var musicLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewFavorArtists.dataSource = self
        collectionViewFavorArtists.delegate = self
        collectionViewRecomendedPlaylists.dataSource = self
        collectionViewRecomendedPlaylists.delegate = self
        
        settingCollectionView()
        
        collectionViewFavorArtists.register(UINib(nibName: "FavoriteArtistsCell", bundle: nil), forCellWithReuseIdentifier: "favArtistCell")
        collectionViewRecomendedPlaylists.register(UINib(nibName: "RecomendedPlaylistsCell", bundle: nil), forCellWithReuseIdentifier: "recomendListCell")
        
        accessToken = UserDefaults.standard.string(forKey: "accessToken")!
        userProfileId = UserDefaults.standard.string(forKey: "userProfileId")!
        
        getFavoriteArtistsUrl(){
            self.getFavoriteArtistImagesForScreen() {
                DispatchQueue.main.async {
                    self.collectionViewFavorArtists.reloadData()
                }
            }
        }
        
        getRecomendedPlaylists() {
            self.getImagesForRecomendedList() {
                DispatchQueue.main.async {
                    self.collectionViewRecomendedPlaylists.reloadData()
                    print(self.recomendedPlaylistImages)
                }
            }
        }
        
    }
    
    @IBAction func test(_ sender: UIButton) {
        collectionViewRecomendedPlaylists.reloadData()
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        
        UserDefaults.standard.set(nil, forKey: "accessToken")
        UserDefaults.standard.set(nil, forKey: "userProfileId")
        
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginScreen") else {return}
        loginVC.modalPresentationStyle = .fullScreen
        
        present(loginVC, animated: true, completion: nil)
    }
    
    func getFavoriteArtistsUrl(completion: (() -> Void)?) {
        
        let urlUser = "https://api.deezer.com/user/me/artists?access_token=\(accessToken!)"

        guard let url = URL(string: urlUser) else {return}

        URLSession.shared.dataTask(with: url) { (data, _, _) in

            guard let data = data else {return}
            
            do {
                let favoritesArtists = try JSONDecoder().decode(UserFavoriteArtistsData.self, from: data)
                for artist in favoritesArtists.data {
                    self.favoriteUrls.append(artist.picture_big)
                }
            } catch {
                print(error)
            }
            completion!()
        }.resume()
    }
    
    func getFavoriteArtistImagesForScreen(completion: (() -> Void)?) {
        
        for url in favoriteUrls {
            
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                
                guard let data = data else {return}
                guard let image = UIImage(data: data) else {return}
                
                self.favoriteImageForScreen.append(image)
                
                completion!()
            }.resume()
        }
    }
    
    func getRecomendedPlaylists(completion: (() -> Void)?) {
        
        let urlForRecomendedPlaylists = "https://api.deezer.com/user/\(userProfileId!)/recommendations/playlists?access_token=\(accessToken!)"
        
        guard let url = URL(string: urlForRecomendedPlaylists) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            guard let data = data else {return}
            
            do{
                let recomendedPlaylistInfo = try JSONDecoder().decode(RecomendedPlaylistsData.self, from: data)
                for object in recomendedPlaylistInfo.data {
                    self.recomendedPlaylistResults.append(object)
                }
                
            } catch {
                print(error)
            }
            completion!()
        }.resume()
    }
    
    func getImagesForRecomendedList(completion: (() -> Void)?) {
        
        for playlistInfo in recomendedPlaylistResults {
            
            URLSession.shared.dataTask(with: playlistInfo.picture_big) { (data, _, error) in
                
                guard let data = data else {return}
                guard let image = UIImage(data: data) else {return}
                self.recomendedPlaylistImages.append(image)
                
                completion!()
            }.resume()
        }
    }
    
    
}

//MARK: - Collection Methods

extension MusicController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewFavorArtists {
           return favoriteImageForScreen.count
        }
        
        return recomendedPlaylistImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewFavorArtists {
            let cell = collectionViewFavorArtists.dequeueReusableCell(withReuseIdentifier: "favArtistCell", for: indexPath) as! FavoriteArtistsCell
            
            cell.artistIcon.image = favoriteImageForScreen[indexPath.item]
            
            return cell
        } else {
            
            let cell = collectionViewRecomendedPlaylists.dequeueReusableCell(withReuseIdentifier: "recomendListCell", for: indexPath) as! RecomendedPlaylistsCell

            cell.recomendedPlaylistImage.image = recomendedPlaylistImages[indexPath.item]
            cell.nameLabel.text = recomendedPlaylistResults[indexPath.item].title
            cell.countOftrackLabel.text = String(recomendedPlaylistResults[indexPath.item].id)

            return cell
           
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewFavorArtists {
            let storyboard = UIStoryboard(name: "Player", bundle: nil)
            let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerController") as! PlayerController
            present(playerVC, animated: true, completion: nil)
        }
    }
    
    //MARK: - Collection Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionViewFavorArtists {
            return CGSize(width: 110, height: 110)
        } else {
            let width = (collectionViewRecomendedPlaylists.frame.width - 45) / 2 - 1
            return CGSize(width: width, height: 265)
        }

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collectionViewFavorArtists {
            return 15
        } else {
            return 15
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collectionViewFavorArtists {
            return 1
        } else {
            return 1
        }
    }
    
    
    //MARK: - Other setting of collection
    
    func settingCollectionView() {
        collectionViewFavorArtists.showsHorizontalScrollIndicator = false
    }
    
    
}

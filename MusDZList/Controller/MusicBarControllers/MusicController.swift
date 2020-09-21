//
//  MusicController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 09.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class TrackIsLiked {
    var userTrackIsLiked: Set<Int>?
    static let shared = TrackIsLiked()
    private init() {}
}

class MusicController: UIViewController {
    
    var accessToken: String?
    var userProfileId: String?
    
    var userFavoriteArtistData = [FavoritesArtistsData]()
    var userFavoriteArtistModels = [FavoriteArtistsModel]()
    
    var fourRecomendedPlaylistResults = [RecomendedPlaylistInfo]()
    var fourRecomendedPlaylistImages = [UIImage]()
    
    var recomendedPlaylistResults = [RecomendedPlaylistInfo]()
    var recomendedPlaylistImages = [UIImage]()
    
    var countForRecommendedList = 0
    
    var collectionViewGenre: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    @IBOutlet weak var collectionViewFavorArtists: UICollectionView!
    @IBOutlet weak var collectionViewRecomendedPlaylists: UICollectionView!
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var controllerScrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
//            print("Expires: \(UserDefaults.standard.value(forKey: "expiresToken"))")
//        }
        
//        print((collectionViewRecomendedPlaylists.frame.width - 45) / 2 - 1)
        
        collectionViewFavorArtists.dataSource = self
        collectionViewFavorArtists.delegate = self
        collectionViewRecomendedPlaylists.dataSource = self
        collectionViewRecomendedPlaylists.delegate = self
        collectionViewGenre.dataSource = self
        collectionViewGenre.delegate = self
        
        settingCollectionView()
        
        setGenreCollectionView()
        
        collectionViewFavorArtists.register(UINib(nibName: "FavoriteArtistsCell", bundle: nil), forCellWithReuseIdentifier: "favArtistCell")
        
        collectionViewRecomendedPlaylists.register(UINib(nibName: "RecomendedPlaylistsCell", bundle: nil), forCellWithReuseIdentifier: "recomendListCell")
        collectionViewRecomendedPlaylists.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionViewRecomendedPlaylists.register(UINib(nibName: "FooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        
        collectionViewGenre.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.genreCellId)
        
        accessToken = UserDefaults.standard.string(forKey: "accessToken")!
        userProfileId = UserDefaults.standard.string(forKey: "userProfileId")!
        
        getFavoriteArtistsUrl(){
            self.getFavoriteArtistsInfo() {
                DispatchQueue.main.async {
                    self.collectionViewFavorArtists.reloadData()
                }
            }
        }
        
        getRecomendedPlaylists() {
            self.getImagesForRecomendedList() {
                print(self.recomendedPlaylistResults)
                print(self.recomendedPlaylistImages)
                DispatchQueue.main.async {
                    self.collectionViewRecomendedPlaylists.reloadData()
                }
            }
        }
        
        singletonForCheckFavoriteTracksIsLiked()
    }
    
    private func setGenreCollectionView() {
        //self.view.addSubview(collectionViewGenre)
        controllerScrollView.addSubview(collectionViewGenre)
        
        collectionViewGenre.centerXAnchor.constraint(equalTo: controllerScrollView.centerXAnchor).isActive = true
        collectionViewGenre.topAnchor.constraint(equalTo: collectionViewRecomendedPlaylists.bottomAnchor, constant: 20).isActive = true
        collectionViewGenre.leadingAnchor.constraint(equalTo: controllerScrollView.leadingAnchor, constant: 10).isActive = true
        collectionViewGenre.trailingAnchor.constraint(equalTo: controllerScrollView.trailingAnchor, constant: -15).isActive = true
        collectionViewGenre.bottomAnchor.constraint(equalTo: controllerScrollView.bottomAnchor, constant: -15).isActive = true
        
        collectionViewGenre.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        
        UserDefaults.standard.set(nil, forKey: "accessToken")
        UserDefaults.standard.set(nil, forKey: "userProfileId")
        
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginScreen") else {return}
        loginVC.modalPresentationStyle = .fullScreen
        
        present(loginVC, animated: true, completion: nil)
    }
    
}

//MARK: - Collection Methods

extension MusicController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewFavorArtists {
            return userFavoriteArtistModels.count
        }
        
        if collectionView == collectionViewRecomendedPlaylists {
            return fourRecomendedPlaylistImages.count
        }
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewFavorArtists {
            let cell = collectionViewFavorArtists.dequeueReusableCell(withReuseIdentifier: "favArtistCell", for: indexPath) as! FavoriteArtistsCell
            
            cell.artistIcon.image = UIImage(data: userFavoriteArtistModels[indexPath.item].picture_big)
            
            return cell
            
        }
        
        if collectionView == collectionViewRecomendedPlaylists {
            let cell = collectionViewRecomendedPlaylists.dequeueReusableCell(withReuseIdentifier: "recomendListCell", for: indexPath) as! RecomendedPlaylistsCell
                
                cell.recomendedPlaylistImage.image = fourRecomendedPlaylistImages[indexPath.item]
                cell.nameLabel.text = fourRecomendedPlaylistResults[indexPath.item].title
                cell.countOftrackLabel.text = " \(String(fourRecomendedPlaylistResults[indexPath.item].numberOfTracks)) tracks"

                return cell
        }
        
        let cell = collectionViewGenre.dequeueReusableCell(withReuseIdentifier: GenreCell.genreCellId, for: indexPath) as! GenreCell
        cell.genreLabel.text = "TestText"
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewFavorArtists {
            
            performSegue(withIdentifier: "topTrackSegue", sender: self)
        }
        
        if collectionView == collectionViewRecomendedPlaylists {
            
            performSegue(withIdentifier: "recomendedPlaylistSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "topTrackSegue" {
            let topTrackVC = segue.destination as! TopTrackController
            
            if let indexPath = collectionViewFavorArtists.indexPathsForSelectedItems?.first {
                
                    topTrackVC.nameForTitle = userFavoriteArtistModels[indexPath.item].name
                    topTrackVC.idArtistsForQuery = userFavoriteArtistModels[indexPath.item].id
            }
        }
        
        if segue.identifier == "recomendedPlaylistSegue" {
            let recomendedPlaylistsVC = segue.destination as! RecomendedPlaylistController
            
            if let indexPath = collectionViewRecomendedPlaylists.indexPathsForSelectedItems?.first {
                
                recomendedPlaylistsVC.recomendedPlaylistOptional = self.recomendedPlaylistResults
            }
        }
        
        
    }
    
    //MARK: - Collection Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionViewFavorArtists {
            return CGSize(width: 110, height: 110)
        }
        
        if collectionView == collectionViewRecomendedPlaylists {
            let width = (collectionViewRecomendedPlaylists.frame.width - 45) / 2 - 1
            return CGSize(width: width, height: 265)
        }
        // Set size for new collection !!!!! next step
        let width = (collectionViewGenre.frame.width - 30) / 2
        let height = collectionViewGenre.frame.height - 10
        return CGSize(width: width, height: height)
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {

        case UICollectionView.elementKindSectionHeader:

            let headerView = collectionViewRecomendedPlaylists.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderView
            return headerView

        case UICollectionView.elementKindSectionFooter:
            
            let footerView = collectionViewRecomendedPlaylists.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as! FooterView
            return footerView

        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == collectionViewRecomendedPlaylists {
            return CGSize(width: collectionView.frame.width - 30, height: 50)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == collectionViewRecomendedPlaylists {
            return CGSize(width: collectionView.frame.width, height: 40)
        }
        return CGSize(width: 0, height: 0)
    }
    
    //MARK: - Other setting of collection
    
    func settingCollectionView() {
        collectionViewFavorArtists.showsHorizontalScrollIndicator = false
        collectionViewRecomendedPlaylists.showsVerticalScrollIndicator = false
    }
    
}

extension MusicController {
    
    func getFavoriteArtistsUrl(completion: (() -> Void)?) {
        
        let urlUser = "https://api.deezer.com/user/me/artists?access_token=\(accessToken!)"

        guard let url = URL(string: urlUser) else {return}

        URLSession.shared.dataTask(with: url) { (data, _, error) in

            guard let data = data else {return}
            
            do {
                let favoritesArtists = try JSONDecoder().decode(UserFavoriteArtistsData.self, from: data)
                for artist in favoritesArtists.data {
                    
                    self.userFavoriteArtistData.append(artist)
                }
            } catch {
                print(error)
            }
            completion!()
        }.resume()
    }
    
    func getFavoriteArtistsInfo(completion: (() -> Void)?) {
        
        for artist in userFavoriteArtistData {
            
            let urlForImage = artist.pictureBig
            
            URLSession.shared.dataTask(with: urlForImage) { (data, _, _) in
                
                guard let data = data else {return}
                
                let artistInfo = FavoriteArtistsModel(id: artist.id, name: artist.name, picture_big: data)
                self.userFavoriteArtistModels.append(artistInfo)
                
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
                    
                    if self.countForRecommendedList <= 3 {
                        self.fourRecomendedPlaylistResults.append(object)
                        self.countForRecommendedList += 1
                    }
                }
                
            } catch {
                print(error)
            }
            completion!()
        }.resume()
    }
    
    func getImagesForRecomendedList(completion: (() -> Void)?) {
        
        for playlistInfo in recomendedPlaylistResults {
            
            URLSession.shared.dataTask(with: playlistInfo.pictureBig) { (data, _, error) in
                
                guard let data = data else {return}
                guard let image = UIImage(data: data) else {return}
                self.recomendedPlaylistImages.append(image)
                
                completion!()
            }.resume()
        }
        
        for playlistInfo in fourRecomendedPlaylistResults {
            
            URLSession.shared.dataTask(with: playlistInfo.pictureBig) { (data, _, error) in
                
                guard let data = data else {return}
                guard let image = UIImage(data: data) else {return}
                self.fourRecomendedPlaylistImages.append(image)
                
                completion!()
            }.resume()
        }
    }
    
    // Check for Track Likes
    
    func singletonForCheckFavoriteTracksIsLiked() {
        
        TrackIsLiked.shared.userTrackIsLiked = Set.init()
        
        let urlFavoriteTracks = "https://api.deezer.com/user/me/tracks?access_token=\(UserDefaults.standard.string(forKey: "accessToken")!)"
        
        guard let url = URL(string: urlFavoriteTracks) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else {return}
            
            do {
                let safeData = try JSONDecoder().decode(FavoriteTracksData.self, from: data)
                
                for object in safeData.data {
                    TrackIsLiked.shared.userTrackIsLiked?.insert(object.id)
                }
                
                if safeData.next != nil {
                    self.downloadNextListOfFavoriteTrackForSingleton(url: safeData.next)
                } else {
                    return
                }
                
                
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func downloadNextListOfFavoriteTrackForSingleton(url: URL?) {
        
        guard let url = url else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else {return}
            
            do {
                let safeData = try JSONDecoder().decode(FavoriteTracksData.self, from: data)
                
                for object in safeData.data {
                    TrackIsLiked.shared.userTrackIsLiked?.insert(object.id)
                }
                
                if safeData.next != nil {
                    self.downloadNextListOfFavoriteTrackForSingleton(url: safeData.next)
                } else {
                    print(TrackIsLiked.shared.userTrackIsLiked?.count)
                    return
                }
                
            } catch {
                print(error)
            }
            
        }.resume()
    }
}

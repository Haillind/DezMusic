//
//  MusicController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 09.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class MusicController: UIViewController {
    
    var user: String?
    var favoriteUrls = [URL]()
    var favoriteImageForScreen = [UIImage]()
    
    @IBOutlet weak var collectionViewFavorArtists: UICollectionView!
    @IBOutlet weak var musicLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewFavorArtists.dataSource = self
        collectionViewFavorArtists.delegate = self
        settingCollectionView()
        //screenUISettings()
        
        collectionViewFavorArtists.register(UINib(nibName: "FavoriteArtistsCell", bundle: nil), forCellWithReuseIdentifier: "favArtistCell")
        
        user = UserDefaults.standard.string(forKey: "accessToken")!
        
        getFavoriteArtistsUrl(){
            self.getFavoriteArtistImagesForScreen() {
                DispatchQueue.main.async {
                    self.collectionViewFavorArtists.reloadData()
                }
            }
        }
        
    }
    
    func screenUISettings() {
        musicLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        
        UserDefaults.standard.set(nil, forKey: "accessToken")
        
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginScreen") else {return}
        loginVC.modalPresentationStyle = .fullScreen
        
        present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func testFav(_ sender: UIButton) {
        
        
        collectionViewFavorArtists.reloadData()
    }
    
    func getFavoriteArtistsUrl(completion: (() -> Void)?) {
        
        let urlUser = "https://api.deezer.com/user/me/artists?access_token=\(user!)"

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
    
    
    
}

//MARK: - Collection Methods

extension MusicController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteImageForScreen.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionViewFavorArtists.dequeueReusableCell(withReuseIdentifier: "favArtistCell", for: indexPath) as! FavoriteArtistsCell
        
        cell.artistIcon.image = favoriteImageForScreen[indexPath.item]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Player", bundle: nil)
        let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerController") as! PlayerController
        present(playerVC, animated: true, completion: nil)
    }
    
    //MARK: - Collection Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    //MARK: - Other setting of collection
    
    func settingCollectionView() {
        collectionViewFavorArtists.showsHorizontalScrollIndicator = false
    }
    
    
}

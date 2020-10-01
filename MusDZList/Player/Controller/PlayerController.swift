//
//  PlayerController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 10.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit
import AVKit
import LNPopupController

class PlayerManager {

    var player: AVPlayer?
    
    static let shared = PlayerManager()

    private init() {}
}

//protocol PlayerControllerFavoriteTableDelegate {
//    func updateInfoTableView()
//}

class PlayerController: UIViewController {
    
//    var delegate: PlayerControllerFavoriteTableDelegate?
    
    let playerManage = PlayerDurationLogic()
    
    var artistName: String?
    
    var playlistOptional: [TopTracksSongModel]?
    var playlist: [TopTracksSongModel] {
        get{
            guard let playlist = playlistOptional else {fatalError()}
            return playlist
        }
    }
    
    var indexPath: Int?
    var currentIndexPath = 0 {
        willSet{
        }
        didSet{
            if currentIndexPath < 0 {
                currentIndexPath = 0
            }
            if currentIndexPath > playlist.count - 1 {
                currentIndexPath = playlist.count - 1
            }
        }
    }
    
    var buttons = [UIBarButtonItem]()
    
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var songContributorsLabel: UILabel!
    @IBOutlet weak var currentDurationSongLabel: UILabel!
    @IBOutlet weak var totalDurationSongLabel: UILabel!
    @IBOutlet weak var progressOfSongLine: UISlider!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let popupPlayBtn = UIBarButtonItem(image: UIImage(named: "Pause"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(actionForPopupPlayBtn))
        popupPlayBtn.tintColor = .black
        buttons.append(popupPlayBtn)
        
        guard let artistName = artistName else {return}
        guard let indexPath = indexPath else {return}
        
        artistNameLabel.text = artistName
        
        currentIndexPath = indexPath
        
        PlayerManager.shared.player = nil
        
        play()
    }
    
    func passToFavoriteTableViewAboutReloadTrackCount (){
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
    }
    
    @objc func actionForPopupPlayBtn() {
        
        if PlayerManager.shared.player?.rate == 0 {
            
            PlayerManager.shared.player!.play()
            buttons[0].image = UIImage(named: "Pause")
            
        } else {
            
            PlayerManager.shared.player!.pause()
            buttons[0].image = UIImage(named: "Play")
        }
    }
    
    func setPlayerScreenInfo() {
        
        songLabel.text = playlist[currentIndexPath].nameOfSong
        songContributorsLabel.text = playlist[currentIndexPath].nameOFContributors
        
        albumImage.image = UIImage(data: playlist[currentIndexPath].albumImage)
        albumImage.layer.cornerRadius = albumImage.frame.size.height / 16
        albumImage.clipsToBounds = true
        
        checkTrackIsLiked()
        likeBtn.setTitle("", for: .normal)
        likeBtn.frame.size = CGSize(width: 40, height: 40)
    }
    
    func setPopupScreen() {
        popupItem.title = playlist[currentIndexPath].nameOfSong
        popupItem.subtitle = playlist[currentIndexPath].nameOFContributors
        popupItem.image = UIImage(data: playlist[currentIndexPath].albumImage)
        popupItem.rightBarButtonItems = buttons
    }
    
    @IBAction func playBtn(_ sender: UIButton) {
        
        if PlayerManager.shared.player?.rate == 0 {
            
            PlayerManager.shared.player!.play()
            playBtn.setImage(UIImage(named: "Pause"), for: .normal)
            
        } else {
            
            PlayerManager.shared.player!.pause()
            playBtn.setImage(UIImage(named: "Play"), for: .normal)
        }
    }
    
    @IBAction func previousTrackBtn(_ sender: UIButton) {
        
        PlayerManager.shared.player = nil
        currentIndexPath -= 1
        play()
    }
    
    @IBAction func nextTrackBtn(_ sender: UIButton) {
        
        PlayerManager.shared.player = nil
        currentIndexPath += 1
        play()
    }
    
    @IBAction func seekCurrentTrack(_ sender: UISlider) {
        
        print(sender.value)
        let currentDuration: CMTime = (PlayerManager.shared.player?.currentItem?.asset.duration)!
        let newCurrentTime: TimeInterval = Double(sender.value) * CMTimeGetSeconds(currentDuration)
        let seekToTime: CMTime = CMTimeMakeWithSeconds(Float64(Float(newCurrentTime)), preferredTimescale: 30)
        PlayerManager.shared.player?.seek(to: seekToTime)
    }
    
    //Like or unlike track with Add/Delete it into/from favorite user list
    @IBAction func likeOrUnlikeTrack(_ sender: UIButton) {
        
    if TrackIsLiked.shared.userTrackIsLiked?.contains(playlist[currentIndexPath].id) ?? false {
        unlikeTrackAndDeleteFromUserFavoriteTrackList{self.checkTrackIsLiked()}
    } else {
        likeTrackAndAddToUserFavoriteTrackList{self.checkTrackIsLiked()}
        }
    }
    
}

extension PlayerController {
    
    func play() {
        
        guard let url = URL.init(string: "\(playlist[currentIndexPath].urlForSong)") else {return}
        let playerItem = AVPlayerItem(url: url)
        
        if PlayerManager.shared.player == nil {
            PlayerManager.shared.player = AVPlayer.init(playerItem: playerItem)
        } else {
            PlayerManager.shared.player?.replaceCurrentItem(with: playerItem)
            PlayerManager.shared.player?.play()
        }
        
        PlayerManager.shared.player?.rate = 1
        playBtn.setImage(UIImage(named: "Pause"), for: .normal)
        setPlayerScreenInfo()
        setPopupScreen()
        
        guard let totalDuration = Int(playlist[currentIndexPath].totalDuration) else {return}
        drawSpinnerOfSong(totalDuration: Float(totalDuration))
        
        print("Current Index os Song = \(currentIndexPath)")
        
        NotificationCenter.default.addObserver(self, selector: #selector(finishTrackPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        progressOfSongLine.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
    }
    
    @objc func finishTrackPlaying(_ notificate: NSNotification) {
        
        PlayerManager.shared.player = nil
        currentIndexPath += 1
        play()
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
                
            case .began: PlayerManager.shared.player?.pause()
            case .moved: break
            case .ended: PlayerManager.shared.player?.play()
                
            default:
                break
            }
        }
    }
    
    func drawSpinnerOfSong(totalDuration: Float) {
        
        guard let safeTotalDuration = Int(playlist[currentIndexPath].totalDuration) else {return}
       
        progressOfSongLine.minimumValue = 0.0
        progressOfSongLine.value = 0.0
        
        self.currentDurationSongLabel.text = "00:00"
        self.totalDurationSongLabel.text = playerManage.setDurationLeft(totalDuration: safeTotalDuration, currentTimeSong: 0)
        
        let _ = PlayerManager.shared.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { (time) in
            
            let currentTimeSong = Float(CMTimeGetSeconds(time))
            
            print(currentTimeSong)
            
            self.progressOfSongLine.value = Float(currentTimeSong) / totalDuration
            self.popupItem.progress = Float(currentTimeSong) / totalDuration
            
            self.totalDurationSongLabel.text = self.playerManage.setDurationLeft(totalDuration: Int(totalDuration), currentTimeSong: Int(currentTimeSong))
            
            self.currentDurationSongLabel.text = self.playerManage.setCurrentDuration(currentTimeSong: Int(currentTimeSong))
        }
    }
    
}

//MARK: - Add and delete methods for favorite track(track likes on/off)

extension PlayerController {
    
    func likeTrackAndAddToUserFavoriteTrackList(complition: (() -> Void)?) {
        guard let urlRequest = URL(string: "https://api.deezer.com/user/\(UserDefaults.standard.value(forKey: "userProfileId")!)/tracks?&access_token=\(UserDefaults.standard.string(forKey: "accessToken")!)&request_method=post&track_id=\(playlist[currentIndexPath].id)") else {return}
        let request = URLRequest(url: urlRequest)
        
        URLSession.shared.dataTask(with: request) { (_, _, _) in
            TrackIsLiked.shared.userTrackIsLiked?.insert(self.playlist[self.currentIndexPath].id)
            self.passToFavoriteTableViewAboutReloadTrackCount()
            complition!()
        }.resume()
    }
    
    func unlikeTrackAndDeleteFromUserFavoriteTrackList(complition: (() -> Void)?) {
        guard let urlRequest = URL(string: "https://api.deezer.com/user/\(UserDefaults.standard.value(forKey: "userProfileId")!)/tracks?&access_token=\(UserDefaults.standard.string(forKey: "accessToken")!)&request_method=delete&track_id=\(playlist[currentIndexPath].id)") else {return}
        let request = URLRequest(url: urlRequest)
        
        URLSession.shared.dataTask(with: request) { (_, _, _) in
            TrackIsLiked.shared.userTrackIsLiked?.remove(self.playlist[self.currentIndexPath].id)
            self.passToFavoriteTableViewAboutReloadTrackCount()
            complition!()
        }.resume()
    }
    
    func checkTrackIsLiked() {
        if TrackIsLiked.shared.userTrackIsLiked?.contains(playlist[currentIndexPath].id) ?? false {
            let likeImage = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
            DispatchQueue.main.async {
                self.likeBtn.setImage(likeImage, for: .normal)
            }
            
        } else {
            let likeImage = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
            DispatchQueue.main.async {
                self.likeBtn.setImage(likeImage, for: .normal)
            }
        }
    }
    
}

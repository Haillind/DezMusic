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

class PlayerController: UIViewController {
    
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
    }
    
    @objc func finishTrackPlaying(_ notificate: NSNotification) {
        
        PlayerManager.shared.player = nil
        currentIndexPath += 1
        play()
    }
    
    func drawSpinnerOfSong(totalDuration: Float) {
        
        guard let safeTotalDuration = Int(playlist[currentIndexPath].totalDuration) else {return}
       
        progressOfSongLine.minimumValue = 0.0
        progressOfSongLine.value = 0.0
        //progressOfSongLine.maximumValue = Float(safeTotalDuration)
        
        self.currentDurationSongLabel.text = "00:00"
        self.totalDurationSongLabel.text = playerManage.setDurationLeft(totalDuration: safeTotalDuration, currentTimeSong: 0)
        
        let _ = PlayerManager.shared.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { (time) in
            
            let currentTimeSong = Float(CMTimeGetSeconds(time))
            
            print(currentTimeSong)
            
            //self.progressOfSongLine.progress = Float(currentTimeSong) / totalDuration
            self.progressOfSongLine.value = Float(currentTimeSong) / totalDuration
            self.popupItem.progress = Float(currentTimeSong) / totalDuration
            
            self.totalDurationSongLabel.text = self.playerManage.setDurationLeft(totalDuration: Int(totalDuration), currentTimeSong: Int(currentTimeSong))
            
            self.currentDurationSongLabel.text = self.playerManage.setCurrentDuration(currentTimeSong: Int(currentTimeSong))
            
        }
    }
    
    
}


// https://stackoverflow.com/questions/30881214/how-to-animate-an-object-vertically-with-touch-like-spotifys-music-player-does

// https://stackoverflow.com/questions/35917608/spotify-like-dragging-bottom-player-in-swift

// https://stackoverflow.com/questions/45786346/how-to-make-tab-bar-view-controller-animate-like-modal-transition-like-itunes


// https://stackoverflow.com/questions/26758029/how-do-i-make-a-now-playing-bar-like-in-media-player-apps-in-ios-with-xcode

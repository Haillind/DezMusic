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
    
    //var player: AVPlayer!
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
    
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var songContributorsLabel: UILabel!
    @IBOutlet weak var currentDurationSongLabel: UILabel!
    @IBOutlet weak var totalDurationSongLabel: UILabel!
    @IBOutlet weak var progressOfSongLine: UIProgressView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var albumImage: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let artistName = artistName else {return}
        guard let indexPath = indexPath else {return}
        
        artistNameLabel.text = artistName
        
        currentIndexPath = indexPath
        
        PlayerManager.shared.player = nil
        
        play()
        
        
    }
    
    func setPlayerScreenInfo() {
        
        songLabel.text = playlist[currentIndexPath].nameOfSong
        songContributorsLabel.text = playlist[currentIndexPath].nameOFContributors
        albumImage.image = UIImage(data: playlist[currentIndexPath].albumImage)
        
        albumImage.layer.cornerRadius = albumImage.frame.size.height / 16
        albumImage.clipsToBounds = true
    }
    
    func setPopupInfo() {
        guard let artistName = artistName else {return}
        self.popupItem.title = artistName
        self.popupItem.subtitle = playlist[currentIndexPath].nameOfSong
        self.popupItem.progress = 0.54
        
        navigationController?.popupBar.progressViewStyle = .bottom
        navigationController?.popupContentView.popupCloseButtonStyle = .round
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        
        //player = nil
        
        dismiss(animated: true, completion: nil)
        
//        let duration: TimeInterval = 0.75
//        let damping: CGFloat = 1
//        let velocity: CGFloat = 0.5
//
//        UIView.animate(withDuration: duration, delay: 0.5, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .curveLinear, animations: {
//            self.view.center.y = self.view.frame.height/2
//        }, completion: nil)
        
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
        setPopupInfo()
        
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
        progressOfSongLine.progress = 0.0
        self.currentDurationSongLabel.text = "00:00"
        self.totalDurationSongLabel.text = playerManage.setDurationLeft(totalDuration: safeTotalDuration, currentTimeSong: 0)
        
        let _ = PlayerManager.shared.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { (time) in
            
            let currentTimeSong = Float(CMTimeGetSeconds(time))
            
            print(currentTimeSong)
            
            self.progressOfSongLine.progress = Float(currentTimeSong) / totalDuration
            
            self.totalDurationSongLabel.text = self.playerManage.setDurationLeft(totalDuration: Int(totalDuration), currentTimeSong: Int(currentTimeSong))
            
            self.currentDurationSongLabel.text = self.playerManage.setCurrentDuration(currentTimeSong: Int(currentTimeSong))
            
        }
    }
}


// https://stackoverflow.com/questions/30881214/how-to-animate-an-object-vertically-with-touch-like-spotifys-music-player-does

// https://stackoverflow.com/questions/35917608/spotify-like-dragging-bottom-player-in-swift

// https://stackoverflow.com/questions/45786346/how-to-make-tab-bar-view-controller-animate-like-modal-transition-like-itunes


// https://stackoverflow.com/questions/26758029/how-do-i-make-a-now-playing-bar-like-in-media-player-apps-in-ios-with-xcode

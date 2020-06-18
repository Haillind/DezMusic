//
//  PlayerController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 10.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit
import AVKit

class PlayerController: UIViewController {
    
    var player: AVPlayer!
    let playerManage = PlayerDurationLogic()
    
    var artistName: String?
    
    var playlistOptional: [TopTracksSongModel]?
    var playlist: [TopTracksSongModel] {
        get{
            guard let playlist = playlistOptional else {fatalError()}
            return playlist
        }
    }
    var newPlayerItem: AVPlayerItem?
    
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
    
    var timer : Timer?
    
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
        
        play()
    }
    
    func setPlayerScreenInfo() {
        
        songLabel.text = playlist[currentIndexPath].nameOfSong
        songContributorsLabel.text = playlist[currentIndexPath].nameOFContributors
        albumImage.image = UIImage(data: playlist[currentIndexPath].albumImage)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        
        //player = nil
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playBtn(_ sender: UIButton) {
        
        if player?.rate == 0 {
            
            player!.play()
            playBtn.setImage(UIImage(named: "Pause"), for: .normal)
            
        } else {
            
            player!.pause()
            playBtn.setImage(UIImage(named: "Play"), for: .normal)
        }
    }
    
    @IBAction func previousTrackBtn(_ sender: UIButton) {
        
        currentIndexPath -= 1
        play()
    }
    
    @IBAction func nextTrackBtn(_ sender: UIButton) {
        
        currentIndexPath += 1
        play()
    }
}



extension PlayerController {
    
    func play() {
        
        guard let url = URL.init(string: "\(playlist[currentIndexPath].urlForSong)") else {return}
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        
        player.rate = 1
        playBtn.setImage(UIImage(named: "Pause"), for: .normal)
        setPlayerScreenInfo()
        
        guard let totalDuration = Int(playlist[currentIndexPath].totalDuration) else {return}
        drawSpinnerOfSong(totalDuration: Float(totalDuration))
        
        print("Current Index os Song = \(currentIndexPath)")
        
        NotificationCenter.default.addObserver(self, selector: #selector(finishTrackPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
    }
    
    @objc func finishTrackPlaying(_ notificate: NSNotification) {
        
        currentIndexPath += 1
        play()
    }
    
    func drawSpinnerOfSong(totalDuration: Float) {
        
        guard let safeTotalDuration = Int(playlist[currentIndexPath].totalDuration) else {return}
        progressOfSongLine.progress = 0.0
        self.currentDurationSongLabel.text = "0:00"
        self.totalDurationSongLabel.text = playerManage.setDurationLeft(totalDuration: safeTotalDuration, currentTimeSong: 0)
        
        let _ = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { (time) in
            
            let currentTimeSong = Float(CMTimeGetSeconds(time))
            
            print(currentTimeSong)
            
            self.progressOfSongLine.progress = Float(currentTimeSong) / totalDuration
            
            self.totalDurationSongLabel.text = self.playerManage.setDurationLeft(totalDuration: Int(totalDuration), currentTimeSong: Int(currentTimeSong))
            
            self.currentDurationSongLabel.text = self.playerManage.setCurrentDuration(currentTimeSong: Int(currentTimeSong))
            
        }
    }
    
}

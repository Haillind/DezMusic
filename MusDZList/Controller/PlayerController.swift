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
    
    var artistName: String?
    
    var playlistOptional: [TopTracksSongModel]?
    var playlist: [TopTracksSongModel] {
        get{
            guard let playlist = playlistOptional else {fatalError()}
            return playlist
        }
    }
    
    var indexPath: Int?
    var currentIndexPath = 0
    
    var timer : Timer?
    var currentDuration = 0
    var pausedDuration = 0
    
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
        setPlayerScreenInfo()
        
        play()
    }
    
    func setPlayerScreenInfo() {
        
        songLabel.text = playlist[currentIndexPath].nameOfSong
        songContributorsLabel.text = playlist[currentIndexPath].nameOFContributors
        albumImage.image = UIImage(data: playlist[currentIndexPath].albumImage)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        
        killTimer()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playBtn(_ sender: UIButton) {
        
        if player?.rate == 0 {
            
            player!.play()
            playBtn.setImage(UIImage(named: "Pause"), for: .normal)
            currentDuration = pausedDuration
            startTimer(with: playlist[currentIndexPath].totalDuration)
        } else {
            
            player!.pause()
            playBtn.setImage(UIImage(named: "Play"), for: .normal)
            pausedDuration = currentDuration
            killTimer()
        }
        
    }
    
    @IBAction func previousTrackBtn(_ sender: UIButton) {
        
        killTimer()
        currentIndexPath -= 1
        setPlayerScreenInfo()
        play()
    }
    
    @IBAction func nextTrackBtn(_ sender: UIButton) {
        
        killTimer()
        currentIndexPath += 1
        setPlayerScreenInfo()
        play()
    }
    
    func play() {
        guard let url = URL.init(string: "\(playlist[currentIndexPath].urlForSong)") else {return}
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        
        player.rate = 1
        playBtn.setImage(UIImage(named: "Pause"), for: .normal)
        
        print("Current Index os Song = \(currentIndexPath)")
        
        startTimer(with: playlist[currentIndexPath].totalDuration)
    }
    
    func killTimer() {
        currentDuration = 0
        timer?.invalidate()
        timer = nil
    }
    
    func startTimer(with totalDuration: String) {
        
        guard let totalDuration = Int(totalDuration) else {return}
        progressOfSongLine.progress = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            
            if Float(self.currentDuration) < Float(totalDuration) {
                self.currentDuration += 1
                print(self.currentDuration)
                self.progressOfSongLine.progress = Float(self.currentDuration) / Float(totalDuration)
            } else {
                self.killTimer()
                self.currentIndexPath += 1
                self.play()
            }
            
        })
    }
    
    
    
}

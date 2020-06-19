//
//  PlayerDurationLogic.swift
//  MusDZList
//
//  Created by Denis Selivanov on 18.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

struct PlayerDurationLogic {
    
    func setDurationLeft(totalDuration: Int, currentTimeSong: Int) -> String {
        
        let durationLeft = totalDuration - currentTimeSong
        let minutes = durationLeft/60
        let seconds = durationLeft - minutes * 60
        
        return String(format: "%02d:%02d", minutes,seconds)
    }
    
    func setCurrentDuration(currentTimeSong: Int) -> String {
        
        let minutes = currentTimeSong/60
        let seconds = currentTimeSong - minutes * 60
        
        return String(format: "%02d:%02d", minutes,seconds)
    }
    
}

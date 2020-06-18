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
        let minutes = durationLeft / 60
        let seconds = durationLeft - (60 * minutes)
        
        if seconds < 10 {
            return "\(minutes):0\(seconds)"
        } else {
            return "\(minutes):\(seconds)"
        }
    }
    
    func setCurrentDuration(currentTimeSong: Int) -> String {
        
        switch currentTimeSong {
            
        case let currentTimeSong where currentTimeSong < 10 && (currentTimeSong / 60) == 0 :
            
            return "0:0\(currentTimeSong)"
            
        case let currentTimeSong where currentTimeSong > 10 && (currentTimeSong / 60) == 0 :
            
            return "0:\(currentTimeSong)"
            
        default:
            let currentMinute = currentTimeSong / 60
            let currentSecond = currentTimeSong - (60 * currentMinute)
            
            if currentSecond < 10 {
                return "\(currentMinute):0\(currentSecond)"
            } else {
                return "\(currentMinute):\(currentSecond)"
            }
        }
    }
    
}

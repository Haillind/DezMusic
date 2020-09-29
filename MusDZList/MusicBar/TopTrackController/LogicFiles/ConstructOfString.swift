//
//  ConstructString.swift
//  MusDZList
//
//  Created by Denis Selivanov on 29.09.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

struct ConstructOfString {
    
    static let shared = ConstructOfString()
    
    func constructContributers(listOf contributers: [ContributorsOfTrack]) -> String {
        
        var contributString = ""
        
        for (index, contribut) in contributers.enumerated() {
            if index != contributers.count - 1 {
                contributString += "\(contribut.name), "
            } else {
                contributString += "\(contribut.name)"
            }
        }
        return contributString
    }
    
}

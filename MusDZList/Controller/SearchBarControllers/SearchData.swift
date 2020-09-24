//
//  SearchData.swift
//  MusDZList
//
//  Created by Denis Selivanov on 21.09.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

struct SearchData: Codable {
    let data: [SearchResult]
    
    struct SearchResult: Codable {
        let id: Int
        let title: String
        let artist: ArtistInfoOfSearchingResult
        
        struct ArtistInfoOfSearchingResult: Codable {
            let id: Int
            let name: String
        }
    }
    
}




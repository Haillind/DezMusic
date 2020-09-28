//
//  TrackIsLiked.swift
//  MusDZList
//
//  Created by Denis Selivanov on 24.09.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

class TrackIsLiked {
    var userTrackIsLiked: Set<Int>?
    static let shared = TrackIsLiked()
    private init() {}
}



//
//  Board.swift
//  soundboard
//
//  Created by Safwan on 26/04/2024.
//

import Foundation

struct Board: Codable {
    
    var title: String
    var tracks: [Track]
    
    init(title: String) {
        self.title = title
        self.tracks = []
    }
    
}

//
//  UserManager.swift
//  soundboard
//
//  Created by Safwan on 26/04/2024.
//

import UIKit

final class UserManager {
    
    static let shared = UserManager()
    
    var savedBoards: [Board] = []
    var premium: Bool = false
    
    var expireDate: Date?
    
    func initializeDataFromUserDefaults() {
        savedBoards = UserDefaultKeys.boards
        premium = UserDefaultKeys.premium
        expireDate = UserDefaultKeys.expireDate
    }
    
    func addNewBoard(newBoard: Board) {
        savedBoards.append(newBoard)
        updateBoardsInUserDefaults()
    }
    
    func updateBoardsInUserDefaults() {
        UserDefaultKeys.boards = savedBoards
    }
    
    func updateTrackSettings(board: Int, track: Int, title: String, volume: Float, loop: Bool, fadeIn: Double, fadeOut: Double) {
        savedBoards[board].tracks[track].title = title
        savedBoards[board].tracks[track].volume = volume
        savedBoards[board].tracks[track].loop = loop
        savedBoards[board].tracks[track].fadeIn = fadeIn
        savedBoards[board].tracks[track].fadeOut = fadeOut
        
        updateBoardsInUserDefaults()
    }
    
    func updatePremiumStatus(status: Bool, date: Date?) {
        premium = status
        UserDefaultKeys.premium = premium
        expireDate = date
        UserDefaultKeys.expireDate = expireDate
    }
}

//
//  UserDefaultKeys.swift
//  teleprompter
//
//  Created by Safwan on 25/04/2024.
//

import UIKit

struct UserDefaultKeys {
    
    private struct Key {
        static let boards = "boards"
        static let premium = "premium"
        static let expireDate = "expireDate"
    }
    
    
    static var boards: [Board] {
        get {
            guard let data = UserDefaults.standard.data(forKey: Key.boards) else { return [] }
            do {
                return try JSONDecoder().decode([Board].self, from: data)
            } catch {
                print("Failed to decode SavedScript: \(error)")
                return []
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: Key.boards)
            } catch {
                print("Failed to encode SavedScript: \(error)")
            }
        }
    }
    
    static var premium: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Key.premium)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.premium)
        }
    }
    
    static var expireDate: Date? {
        get {
            return UserDefaults.standard.object(forKey: Key.expireDate) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.expireDate)
        }
    }

}


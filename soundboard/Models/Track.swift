//
//  Track.swift
//  soundboard
//
//  Created by Safwan on 27/04/2024.
//

import Foundation

struct Track: Codable {
    
    var title: String
    private var bookmarkedPathData: Data?
    var volume: Float
    var loop: Bool
    var duration: Double
    var fadeIn: Double
    var fadeOut: Double

    // Computed property to handle the bookmarked URL
    var path: URL? {
        get {
            guard let bookmarkData = bookmarkedPathData else { return nil }
            var isStale = false
            do {
                let url = try URL(resolvingBookmarkData: bookmarkData, options: .withoutUI, relativeTo: nil, bookmarkDataIsStale: &isStale)
                if isStale {
                    // Handle the stale bookmark if needed
                    // Optionally update the bookmark here if it's critical to maintain access
                }
                return url
            } catch {
                print("Error resolving bookmark: \(error)")
                return nil
            }
        }
        set {
            guard let url = newValue else { bookmarkedPathData = nil; return }
            do {
                let bookmarkData = try url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
                bookmarkedPathData = bookmarkData
            } catch {
                print("Error creating bookmark: \(error)")
                bookmarkedPathData = nil
            }
        }
    }

    init(title: String, path: URL?, duration: Double) {
        self.title = title
        self.volume = 1.0
        self.loop = false
        self.duration = duration
        self.fadeIn = 0
        self.fadeOut = 0
        self.bookmarkedPathData = nil  // Ensure all non-optional properties are initialized before using `self`
        
        // Now `self` is fully initialized, `path` can be set
        self.path = path
    }
}


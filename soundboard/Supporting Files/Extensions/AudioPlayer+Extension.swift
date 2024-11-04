//
//  AudioPlayer+Extension.swift
//  soundboard
//
//  Created by Safwan on 28/04/2024.
//

import UIKit
import AVFoundation

extension AVAudioPlayer {
    func fadeIn(duration: TimeInterval, interval: TimeInterval = 0.1) {
        volume = 0
        play()
        
        let fadeInSteps = Int(duration / interval)
        let volumeIncrement = 1.0 / Double(fadeInSteps)
        
        for step in 0...fadeInSteps {
            let delay = Double(step) * interval
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.volume += Float(volumeIncrement)
                if self.volume >= 1.0 {
                    self.volume = 1.0
                }
            }
        }
    }
    
    func fadeOut(duration: TimeInterval, interval: TimeInterval = 0.1) {
        let fadeOutSteps = Int(duration / interval)
        let volumeDecrement = volume / Float(fadeOutSteps)
        
        for step in 0...fadeOutSteps {
            let delay = Double(step) * interval
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.volume -= volumeDecrement
                if self.volume <= 0 {
                    self.stop()
                    self.volume = 1.0 // Reset volume to avoid affecting next playback
                }
            }
        }
    }
}

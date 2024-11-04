//
//  Extensions.swift
//  soundboard
//
//  Created by Safwan on 28/04/2024.
//

import Foundation

extension Float {
    func toPercentageString(fractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = fractionDigits
        formatter.minimumFractionDigits = fractionDigits
        
        // Assuming the float value is already in decimal form (e.g., 0.23 for 23%)
        let percentageValue = self
        
        guard let formattedString = formatter.string(from: NSNumber(value: percentageValue)) else {
            return "N/A"
        }
        
        return formattedString
    }
    
    func rounded(toDecimalPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
    func secondsToTimeString() -> String {
        let totalSeconds = Int(ceil(self))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func rounded(toDecimalPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

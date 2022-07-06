//
//  TimerTimeConversion.swift
//  Discount Timer
//
//  Created by Maksim Velich on 5.07.22.
//

import Foundation

struct TimeConversion {
    static func timeToStringLiteral(for time: Int) -> String {
        if time < 10 {
            return "0\(time)"
        }
        
        return "\(time)"
    }
    
    static func timeToStringLiteral(hours: Int, minutes: Int, seconds: Int) -> String {
        let hour = timeToStringLiteral(for: hours)
        let minute = timeToStringLiteral(for: minutes)
        let second = timeToStringLiteral(for: seconds)
        
        return hours != 0 ? "\(hour):\(minute):\(second)" : "\(minute):\(second)"
    }
    
    static func secondsToHoursMinutesSeconds(for time: Int) -> (Int, Int, Int) {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return (hours, minutes, seconds)
    }
}

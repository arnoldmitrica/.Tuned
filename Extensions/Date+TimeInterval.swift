//
//  Date+TimeInterval.swift
//  bucovat
//
//  Created by Arnold Mitricã on 19.03.2021.
//

import Foundation

extension Date {

    static func timeFromLshToRhs (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}

extension TimeInterval {
    var formatted: String {
        let endingDate = Date()
        let startingDate = endingDate.addingTimeInterval(-self)
        let calendar = Calendar.current

        let componentsNow = calendar.dateComponents([.hour, .minute, .second], from: startingDate, to: endingDate)
        if let hour = componentsNow.hour, let minute = componentsNow.minute, let seconds = componentsNow.second {
            //return "\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", seconds))"
            if hour < 2{
                if minute < 2 {
                    if minute == 0 {
                        return "\(String(format: "%02d", seconds)) sec. ago "
                    }
                    return "\(String(format: "%02d", minute)) min., \(String(format: "%02d", seconds)) sec. ago "
                }
                if hour == 0 {
                    return "\(String(format: "%02d", minute)) min. ago "
                }
                return "\(String(format: "%02d", hour)) h ,\(String(format: "%02d", minute)) min. ago "
            }
            if hour > 24 {
                return "\(String(format: "%02d", hour/24)) days, \(hour % 24) h ago"
            }
            return " \(String(format: "%02d", hour + 1)) h. ago"
    
        } else {
            return ""
        }
    }
}

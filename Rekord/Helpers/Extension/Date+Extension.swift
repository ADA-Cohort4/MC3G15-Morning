//
//  Date+Extension.swift
//  Diabestie
//
//  Created by Dhiky Aldwiansyah on 01/04/21.
//


import Foundation

internal extension Date {
    
    enum ISO8601Format: String {
      case Hour             = "HH"                         // 19
      case DayMonth         = "EEEE, dd MMMM"                // Sun, 07 9
      case HourMinutes      = "HH:mm"                      // 19:20
      case Year             = "yyyy"                       // 1997
      case YearMonth        = "yyyy-MM"                    // 1997-07
      case Date             = "yyyy-MM-dd"                 // 1997-07-16
      case DateTime         = "yyyy-MM-dd'T'HH:mmZ"        // 1997-07-16T19:20+01:00
      case DateTimeSec      = "yyyy-MM-dd'T'HH:mm:ssZ"     // 1997-07-16T19:20:30+01:00
      case DateTimeMilliSec = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // 1997-07-16T19:20:30.45+01:00
    }

    var day: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self)
        return components.day ?? 1
    }
    
    var isToday: Bool {
        let gregorian = Calendar(identifier: .gregorian)
        let thisDate = gregorian.dateComponents([.day, .month, .year], from: self)
        let currentDate = gregorian.dateComponents([.day, .month, .year], from: Date())
        return thisDate == currentDate
    }
    
    var previousDay: Date {
        var components = DateComponents()
        components.day = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var nextDay: Date {
        var components = DateComponents()
        components.day = 1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
    
    var startOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return sunday!
    }
    
    var startOfNextWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .weekOfMonth, value: 1, to: sunday!)!
    }
    
    var startOfPreviousWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .weekOfMonth, value: -1, to: sunday!)!
    }
    
    var weekDates: [Date] {
        var dates: [Date] = []
        for i in 0..<7 {
            dates.append(Calendar.current.date(byAdding: .day, value: i, to: startOfWeek)!)
        }
        return dates
    }
    
    var dayOfTheWeek: Int {
         let dayNumber = Calendar.current.component(.weekday, from: self)
         // day number starts from 1 but array count from 0
         return dayNumber - 1
    }
    
    var iso8601: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return formatter.string(from: self)
    }
    
    func string(format: ISO8601Format) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    
}

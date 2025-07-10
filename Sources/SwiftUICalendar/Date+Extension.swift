//
//  Date+Extension.swift
//  ELEXIR_SwiftUI
//
//  Created by Himanshu Sharma on 28/02/24.
//

import Foundation


internal extension Date {
    static var capitalizedFirstLettersOfWeekdays: [String] {
        let calendar = Calendar.current
        let weekdays = calendar.shortWeekdaySymbols
        
        return weekdays.map { weekday in
            let trimmedWeekday = String(weekday.prefix(3))
            return trimmedWeekday.prefix(1).capitalized + trimmedWeekday.dropFirst().lowercased()
        }
    }
    
    static var fullMonthNames: [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        
        return (1...12).compactMap { month in
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
            let date = Calendar.current.date(from: DateComponents(year: 2000, month: month, day: 1))
            return date.map { dateFormatter.string(from: $0) }
        }
    }
    
    var startOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: self)!.start
    }
    
    var endOfMonth: Date {
        let lastDay = Calendar.current.dateInterval(of: .month, for: self)!.end
        return Calendar.current.date(byAdding: .day, value: -1, to: lastDay)!
    }
    
    var startOfQuarter: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        let quarter = ((components.month! - 1) / 3) + 1
        let startMonth = (quarter - 1) * 3 + 1
        var startComponents = DateComponents()
        startComponents.year = components.year
        startComponents.month = startMonth
        startComponents.day = 1
        return calendar.date(from: startComponents)!
    }
    
    var endOfQuarter: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        let quarter = ((components.month! - 1) / 3) + 1
        let endMonth = quarter * 3
        var endComponents = DateComponents()
        endComponents.year = components.year
        endComponents.month = endMonth + 1
        endComponents.day = 0
        return calendar.date(from: endComponents)!
    }
    
    var startOfYear: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self)
        return calendar.date(from: components)!
    }
    
    var endOfYear: Date {
        let calendar = Calendar.current
        let start = self.startOfYear
        let components = DateComponents(year: 1, day: -1)
        return calendar.date(byAdding: components, to: start)!
    }
    
    var startOfPreviousMonth: Date {
        let dayInPreviousMonth = Calendar.current.date(byAdding: .month, value: -1, to: self)!
        return dayInPreviousMonth.startOfMonth
    }
    
    var numberOfDaysInMonth: Int {
        Calendar.current.component(.day, from: endOfMonth)
    }
    
    var sundayBeforeStart: Date {
        let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
        let numberFromPreviousMonth = startOfMonthWeekday - 1
        return Calendar.current.date(byAdding: .day, value: -numberFromPreviousMonth, to: startOfMonth)!
    }
    
    var calendarDisplayDays: [Date] {
        var days: [Date] = []
        // Current month days
        for dayOffset in 0..<numberOfDaysInMonth {
            let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfMonth)
            days.append(newDay!)
        }
        // previous month days
        for dayOffset in 0..<startOfPreviousMonth.numberOfDaysInMonth {
            let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfPreviousMonth)
            days.append(newDay!)
        }
        
        return days.filter { $0 >= sundayBeforeStart && $0 <= endOfMonth }.sorted(by: <)
    }
    
    var monthInt: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var yearName:Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var monthName:String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM" // "MMMM" is the date format for the full month name.
        return dateFormatter.string(from: self)
    }
    
    var nextMonth:Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)!
    }
    
    var preMonth:Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
        
    }
    
    static func fromString(_ dateString: String, format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX") // Use a consistent locale
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Or your specific timezone
        return formatter.date(from: dateString)
    }
    
    // Week Calendar Functions
    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!
    }
    
    var endOfWeek: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
    }
    
    var calendarDisplayWeek: [Date] {
        var days: [Date] = []
        let startOfWeek = self.startOfWeek
        
        for dayOffset in 0..<7 {
            if let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfWeek) {
                days.append(newDay)
            }
        }
        
        return days
    }
    
    var nextWeek: Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: 1, to: self)!
    }
    
    var previousWeek: Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: -1, to: self)!
    }
}

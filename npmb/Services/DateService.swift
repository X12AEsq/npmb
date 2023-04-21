//
//  DateService.swift
//  npmb
//
//  Created by Morris Albers on 3/9/23.
//

import Foundation
struct DateService {
    
    public static var monthNames:[String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    public static func monthName(numMonth:Int) -> String {
        if numMonth < 1 || numMonth > 12 {
            return "Undefined"
        }
        return self.monthNames[numMonth - 1]
    }

    public static func trimStringDate(date:String) -> [String] {
        if date == "" { return ["", "", ""] }
        let trimmedDate = date.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedDate == "" { return ["", "", ""] }

        let pieces = trimmedDate.components(separatedBy: "-")
        if pieces.count == 3 { return pieces }
        if pieces.count == 2 { return [""] + pieces }
        if pieces.count == 1 { return ["",""] + pieces }
        return(["9999","99","99"])
    }
    
    public static func dateString2Date(inDate:String) -> Date {
        return dateString2Date(inDate: inDate, inTime: "120000")
    }

    public static func dateString2Date(inDate:String, inTime:String) -> Date {
        let trimmedDate = trimStringDate(date: inDate)
        var t0:String = "0"
        var t1:String = "0"
        var t2:String = "0"
        var t3:String = "0"
        if inTime.count > 0 {
            let i = inTime.index(inTime.startIndex, offsetBy: 0)
            t0 = String(inTime[i])
        }
        if inTime.count > 1 {
            let i = inTime.index(inTime.startIndex, offsetBy: 1)
            t1 = String(inTime[i])
        }
        if inTime.count > 2 {
            let i = inTime.index(inTime.startIndex, offsetBy: 2)
            t2 = String(inTime[i])
        }
        if inTime.count > 3 {
            let i = inTime.index(inTime.startIndex, offsetBy: 3)
            t3 = String(inTime[i])
        }
        var components = DateComponents()
        let work = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        var date = Date()

        components.calendar = Calendar.current
        components.year = trimmedDate[0] == "" ? work.year : Int(trimmedDate[0])
        components.month = trimmedDate[1] == "" ? work.month : Int(trimmedDate[1])
        components.day = trimmedDate[2] == "" ? work.day : Int(trimmedDate[2])
        
        let inHour = t0 + t1
        components.hour = inHour == "" ? 0 : Int(inHour)
        
        let inMinute = t2 + t3
        components.minute = inMinute == "" ? 0 : Int(inMinute)
        components.second = 0
        if components.isValidDate {
            date = components.date ?? Date()
        }
        return date
    }
    
    public static func dateDate2String(inYear:String, inMonth:String, inDay:String) -> Date {
        var components = DateComponents()
        let work = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        var date = Date()

        components.calendar = Calendar.current
        components.year = inYear == "" ? work.year : Int(inYear)
        components.month = inMonth == "" ? work.month : Int(inMonth)
        components.day = inDay == "" ? work.day : Int(inDay)
        components.hour = 0
        components.minute = 0
        components.second = 0
        if components.isValidDate {
            date = components.date ?? Date()
        }
        return date
    }
    
    public static func dateDate2String(inDate:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let returnDate = formatter.string(from: inDate)
        return returnDate
    }
    
    public static func dateTime2String(inDate:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm"
        let work = formatter.string(from: inDate)
        return work
    }
}

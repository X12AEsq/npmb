//
//  RepresentationExtension.swift
//  npmb
//
//  Created by Morris Albers on 4/1/23.
//

import Foundation
extension RepresentationModel {
    public var DateAssigned:Date {
        return DateService.dateString2Date(inDate: self.assignedDate)
    }
    
    public var DateDisposed:Date {
        return DateService.dateString2Date(inDate: self.dispositionDate)
    }
    
    public var MonthAssigned:String {
        let array = self.assignedDate.components(separatedBy: "-")
        if array.count > 1 {
            return array[1]
        } else {
            return "XX"
        }
    }

    public var YearAssigned:String {
        let array = self.assignedDate.components(separatedBy: "-")
        if array.count > 0 {
            return array[0]
        } else {
            return "XXXX"
        }
    }

    public var MonthDisposed:String {
        let array = self.dispositionDate.components(separatedBy: "-")
        if array.count > 1 {
            return array[1]
        } else {
            return "XX"
        }
    }

    public var YearDisposed:String {
        let array = self.dispositionDate.components(separatedBy: "-")
        if array.count > 0 {
            return array[0]
        } else {
            return "XXXX"
        }
    }
}

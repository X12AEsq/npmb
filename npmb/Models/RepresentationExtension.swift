//
//  RepresentationExtension.swift
//  npmb
//
//  Created by Morris Albers on 4/1/23.
//

import Foundation
extension RepresentationModel {
    public var sortField1:String {
        return FormattingService.rjf(base: String(self.internalID), len: 4, zeroFill: true) + assignedDate
    }
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
    
    public var printLine1:String {
        var pl:String = FormattingService.rjf(base: String(self.internalID), len: 4, zeroFill: true) + " "
        pl = pl + FormattingService.rjf(base: String(self.involvedClient), len: 4, zeroFill: true) + " "
        pl = pl + FormattingService.rjf(base: String(self.involvedCause), len: 4, zeroFill: true) + " "
        if active { pl = pl + "Active   " }
        else { pl = pl + "Inactive " }
        pl = pl + FormattingService.ljf(base: self.assignedDate, len:11) + " "
        pl = pl + FormattingService.ljf(base: self.dispositionDate, len:11) + " "
        pl = pl + FormattingService.ljf(base: self.dispositionType, len:5) + " "
        pl = pl + FormattingService.ljf(base: self.dispositionAction, len:5) + " "
        pl = pl + FormattingService.ljf(base: self.primaryCategory, len:5) + " "
        pl = pl + "Notes: "
        for not in self.involvedNotes {
            if not > 0 {
                pl = pl + FormattingService.rjf(base: String(not), len: 4, zeroFill: true) + " "
            }
        }
        if self.involvedAppearances.count < 7 {
            pl = pl + "Appr: "
            for not in self.involvedAppearances {
                if not > 0 {
                    pl = pl + FormattingService.rjf(base: String(not), len: 4, zeroFill: true) + " "
                }
            }
        }
        else {
            pl = pl + "\n                     Appr:"
            for not in self.involvedAppearances {
                if not > 0 {
                    pl = pl + FormattingService.rjf(base: String(not), len: 4, zeroFill: true) + " "
                }
            }
        }
        return pl
    }
    
    public var printLine1Count:Int {
        if self.involvedAppearances.count < 7 { return 1 }
        return 2
    }

    
    public var printHeader1:String {
        var pl:String = FormattingService.rjf(base: "ID", len: 4, zeroFill: false) + " "
        pl = pl + FormattingService.rjf(base: "Cli", len: 4, zeroFill: false) + " "
        pl = pl + FormattingService.rjf(base: "Cau", len: 4, zeroFill: false) + " "
        pl = pl + "Active?  "
        pl = pl + FormattingService.ljf(base: "Assigned", len:11) + " "
        pl = pl + FormattingService.ljf(base: "Disposed", len:11) + " "
        pl = pl + FormattingService.ljf(base: "Type", len:5) + " "
        pl = pl + FormattingService.ljf(base: "Act", len:5) + " "
        pl = pl + FormattingService.ljf(base: "Cat", len:5) + " "
        return pl
    }
}

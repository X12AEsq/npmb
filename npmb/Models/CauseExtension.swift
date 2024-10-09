//
//  CauseExtension.swift
//  npmb
//
//  Created by Morris Albers on 3/2/23.
//

import Foundation
extension CauseModel {
    public var sortFormat1:String {
        let part1:String = String(self.internalID)
        let part2:String = FormattingService.rjf(base: part1, len: 4, zeroFill: true)
        let part3:String = FormattingService.ljf(base: self.causeNo, len:9)
        let part4:String = FormattingService.ljf(base: self.originalCharge, len:12)
        let part5:String = part3 + "-" + part2 + "-" + part4
        let part6:String = FormattingService.ljf(base: part5, len:30)
        return part6
    }
    
    public var sortFormat2:String {
        let part1:String = String(self.internalID)
        let part2:String = FormattingService.rjf(base: part1, len: 4, zeroFill: true)
        let part3:String = FormattingService.ljf(base: self.causeNo, len:9)
        let part4:String = FormattingService.ljf(base: self.originalCharge, len:12)
        let part5 = part2 + "-" + part3 + "-" + part4
        let part6:String = FormattingService.ljf(base: part5, len:30)
        return part6
    }
    
    public var stdCauseNo:String {
        return FormattingService.ljf(base: self.causeNo, len:9)
    }
    
    public var printLine1:String {
        var pl:String = FormattingService.rjf(base: String(self.internalID), len: 4, zeroFill: true) + " "
        pl = pl + FormattingService.ljf(base: self.causeNo, len:9) + " "
        pl = pl + FormattingService.ljf(base: self.causeType, len:5) + " "
        pl = pl + FormattingService.ljf(base: String(self.involvedClient), len: 4) + " "
        pl = pl + FormattingService.ljf(base: self.level, len:5) + " "
        pl = pl + FormattingService.ljf(base: self.court, len:5) + " "
        pl = pl + FormattingService.ljf(base: self.originalCharge, len:12) + " "
        for rep in self.involvedRepresentations {
            if rep > 0 {
                pl = pl + FormattingService.rjf(base: String(rep), len: 4, zeroFill: true) + " "
            }
        }
        return pl
    }
    
    public var printHeader1:String {
        var pl:String = FormattingService.rjf(base: "ID", len: 4, zeroFill: false) + " "
        pl = pl + FormattingService.ljf(base: "Cause No", len:9) + " "
        pl = pl + FormattingService.ljf(base: "Type", len:5) + " "
        pl = pl + FormattingService.rjf(base: "Cli", len: 4, zeroFill: false) + " "
        pl = pl + FormattingService.ljf(base: "Level", len:5) + " "
        pl = pl + FormattingService.ljf(base: "Court", len:5) + " "
        pl = pl + FormattingService.ljf(base: "Charge", len:12) + " "
        pl = pl + "Representations"
        return pl
    }
}

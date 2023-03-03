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
        let part3:String = FormattingService.ljf(base: self.causeNo, len:8)
        let part4:String = FormattingService.ljf(base: self.originalCharge, len:12)
        return part3 + "-" + part2 + "-" + part4
    }
    
    public var sortFormat2:String {
        let part1:String = String(self.internalID)
        let part2:String = FormattingService.rjf(base: part1, len: 4, zeroFill: true)
        let part3:String = FormattingService.ljf(base: self.causeNo, len:8)
        let part4:String = FormattingService.ljf(base: self.originalCharge, len:12)
        return part2 + "-" + part3 + "-" + part4
    }
}

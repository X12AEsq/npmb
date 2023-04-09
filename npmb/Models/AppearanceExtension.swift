//
//  AppearanceExtension.swift
//  npmb
//
//  Created by Morris Albers on 4/6/23.
//

import Foundation
extension AppearanceModel {
    var stringLabel:String {
        var work:String = ""
        work = FormattingService.rjf(base: String(self.internalID), len: 4, zeroFill: true)
        work += "-"
        work += FormattingService.rjf(base: self.appearDate, len: 10, zeroFill: false)
        work += "-"
        work += FormattingService.rjf(base: self.appearTime, len: 4, zeroFill: false)
        work += "-"
        work += self.appearNote
        return work
   }
}

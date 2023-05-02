//
//  ExpandedAppearance.swift
//  npmb
//
//  Created by Morris Albers on 4/12/23.
//

import Foundation
class ExpandedAppearance {
    var appearance:AppearanceModel
    var cause:CauseModel
    var client:ClientModel
    var representation:RepresentationModel
    
    init() {
        self.appearance = AppearanceModel()
        self.cause = CauseModel()
        self.client = ClientModel()
        self.representation = RepresentationModel()
    }
    
    init(appearance:AppearanceModel, cause:CauseModel, client:ClientModel, representation:RepresentationModel) {
        self.appearance = appearance
        self.cause = cause
        self.client = client
        self.representation = representation
    }
    
    var printLine:String {
        var line:String = ""
        line = FormattingService.rjf(base: String(self.appearance.internalID), len: 4, zeroFill: true)
        line += " "
        line += FormattingService.rjf(base: self.appearance.appearDate, len: 10, zeroFill: false)
        line += " "
        line += FormattingService.rjf(base: self.appearance.appearTime, len: 4, zeroFill: false)
        line += " "
        line += FormattingService.ljf(base: self.cause.causeNo, len: 9)
        line += " "
        line += FormattingService.ljf(base: self.cause.originalCharge, len: 12)
        line += " "
        line += self.client.formattedName
       return line
    }
    
    var sortSequence:String {
        var work:String = ""
        work += FormattingService.rjf(base: self.appearance.appearDate, len: 10, zeroFill: false)
        work += FormattingService.rjf(base: self.appearance.appearTime, len: 4, zeroFill: false)
        work += " "
        work += self.client.formattedName
        return work
    }

}

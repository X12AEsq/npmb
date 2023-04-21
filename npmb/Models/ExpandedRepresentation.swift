//
//  ExpandedRepresentation.swift
//  npmb
//
//  Created by Morris Albers on 4/4/23.
//

import Foundation
class ExpandedRepresentation: Identifiable {
    static func == (lhs: ExpandedRepresentation, rhs: ExpandedRepresentation) -> Bool {
        lhs.representation.internalID == rhs.representation.internalID
    }
    var representation:RepresentationModel
    var xpcause:ExpandedCause
    var appearances:[AppearanceModel]
    var notes:[NotesModel]
    
    init() {
        self.representation = RepresentationModel()
        self.xpcause = ExpandedCause()
        self.appearances = [AppearanceModel]()
        self.notes = [NotesModel]()
    }
    
    var printLine:String {
        var line:String = ""
        line += FormattingService.ljf(base: self.xpcause.cause.causeNo, len: 11)
        line += FormattingService.ljf(base: self.xpcause.client.formattedName, len: 32)
        line += FormattingService.ljf(base: self.xpcause.cause.level, len: 4)
        line += FormattingService.ljf(base: self.xpcause.cause.court, len: 6)
        line += FormattingService.ljf(base: self.xpcause.cause.causeType, len: 5)
        if !self.representation.active {
            line += FormattingService.ljf(base: self.representation.dispositionType, len: 5)
            line += FormattingService.ljf(base: self.representation.dispositionAction, len: 5)
        } else {
            line += FormattingService.ljf(base: " ", len: 5)
            line += FormattingService.ljf(base: " ", len: 5)
        }
//        line += " "
//        line += FormattingService.rjf(base: self.appearance.appearDate, len: 10, zeroFill: false)
//        line += " "
//        line += FormattingService.rjf(base: self.appearance.appearTime, len: 4, zeroFill: false)
//        line += " "
//        line += FormattingService.ljf(base: self.cause.causeNo, len: 9)
//        line += " "
//        line += FormattingService.ljf(base: self.cause.originalCharge, len: 12)
//        line += " "
//        line += self.client.formattedName
       return line
    }

    var headerLine:String {
        var line:String = ""
        line += FormattingService.ljf(base: "Cause No", len: 11)
        line += FormattingService.ljf(base: "Client Name", len: 32)
        line += FormattingService.ljf(base: "Lev", len: 4)
        line += FormattingService.ljf(base: "Court", len: 6)
        line += FormattingService.ljf(base: "Proc", len: 5)
        line += FormattingService.ljf(base: "Disp", len: 5)
        line += "\n\n"
        return line
    }
    
    var printLine2:String {
        var line:String = ""
        line += FormattingService.ljf(base: self.xpcause.cause.causeNo, len: 11)
        line += FormattingService.ljf(base: self.xpcause.client.formattedName, len: 32)
        line += FormattingService.ljf(base: self.xpcause.cause.level, len: 4)
        line += FormattingService.ljf(base: self.xpcause.cause.court, len: 6)
        if !self.representation.active {
            line += FormattingService.ljf(base: self.representation.dispositionType, len: 5)
            line += FormattingService.ljf(base: self.representation.dispositionAction, len: 5)
        } else {
            line += FormattingService.ljf(base: " ", len: 5)
            line += FormattingService.ljf(base: " ", len: 5)
        }
       return line
    }

    var headerLine2:String {
        var line:String = ""
        line += FormattingService.ljf(base: "Cause No", len: 11)
        line += FormattingService.ljf(base: "Client Name", len: 32)
        line += FormattingService.ljf(base: "Lev", len: 4)
        line += FormattingService.ljf(base: "Court", len: 6)
        line += FormattingService.ljf(base: "Type", len: 5)
        line += FormattingService.ljf(base: "Proc", len: 5)
        line += FormattingService.ljf(base: "Disp", len: 5)
        line += "\n\n"
        return line
    }

    var sortSequence1:String {
        var line:String = ""
        line += FormattingService.ljf(base: self.xpcause.client.formattedName, len: 32)
        return line
    }
}

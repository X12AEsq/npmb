//
//  NotesExtension.swift
//  npmb
//
//  Created by Morris Albers on 4/10/23.
//

import Foundation
extension NotesModel {
    var stringLabel:String {
        var work:String = ""
        work = FormattingService.rjf(base: String(self.internalID), len: 4, zeroFill: true)
        work += "-"
        work += self.noteCategory
        work += "-"
        work += FormattingService.rjf(base: self.noteDate, len: 10, zeroFill: false)
        work += "-"
        work += FormattingService.rjf(base: self.noteTime, len: 4, zeroFill: false)
        work += "-"
        work += self.noteNote
        return work
    }
}


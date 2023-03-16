//
//  ClientExtension.swift
//  npmamain
//
//  Created by Morris Albers on 10/23/21.
//

import Foundation
extension ClientModel {
    public var formattedName:String {
        var part1:String = ""
        var part2:String = ""
        var part3:String = ""
        var part4:String = ""
        if self.lastName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            part1 = self.lastName.trimmingCharacters(in: .whitespacesAndNewlines) + ", "
        }
        if self.firstName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            part2 = self.firstName.trimmingCharacters(in: .whitespacesAndNewlines) + " "
        }
        if self.middleName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            part3 = self.middleName.trimmingCharacters(in: .whitespacesAndNewlines) + " "
        }
        if self.suffix.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            part4 = self.suffix.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return part1 + part2 + part3 + part4
    }
    
    public var sortFormat2:String {
        let part1:String = String(self.internalID)
        let part2:String = FormattingService.rjf(base: part1, len: 4, zeroFill: true)
        return part2 + "-" + self.formattedName
    }
    
    public var sortFormat3:String {
        let part1:String = self.formattedName
        let part2:String = String(self.internalID)
        let part3:String = FormattingService.rjf(base: part2, len: 4, zeroFill: true)
        let part4:String = part1 + "-" + part3
        return part4.trimmingCharacters(in: .whitespaces)
    }
}

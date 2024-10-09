//
//  ClientExtension.swift
//  npmamain
//
//  Created by Morris Albers on 10/23/21.
//

import Foundation
import CloudKit

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
    
    public var formattedAddr:String {
        var addr:String = ""
        let street:String = self.street.trimmingCharacters(in: .whitespacesAndNewlines)
        var city:String = self.city.trimmingCharacters(in: .whitespacesAndNewlines)
        if city != "" { city += ", " }
        city += self.state + " " + self.zip
        addr = street
        if addr != "" { addr += ", " }
        addr += city
        return addr
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
    
    public var printLine1:String {
        var pl:String = FormattingService.rjf(base: String(self.internalID), len: 4, zeroFill: true) + " "
        pl = pl + FormattingService.ljf(base: String(self.formattedName), len: 30)  + " "
        pl = pl + FormattingService.ljf(base: String(self.formattedAddr), len: 40)  + " "
        pl = pl + FormattingService.ljf(base: String(self.phone), len: 13)
        for rep in self.representation {
            if rep > 0 {
                pl = pl + FormattingService.rjf(base: String(rep), len: 4, zeroFill: true) + " "
            }
        }
        return pl
    }
    
    public var printHeader1:String {
        var pl:String = FormattingService.rjf(base: "ID", len: 4, zeroFill: false) + " "
        pl = pl + FormattingService.ljf(base: "Client name", len: 30)  + " "
        pl = pl + FormattingService.ljf(base: "Client address", len: 40)  + " "
        pl = pl + FormattingService.ljf(base: "Telephone", len: 13)
        pl = pl + "Representations"
        return pl
    }
}

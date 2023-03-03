//
//  FormattingService.swift
//  npmb
//
//  Created by Morris Albers on 2/25/23.
//

import Foundation

struct FormattingService {
    
    public static func rjf(base:String, len:Int, zeroFill:Bool) -> String {
        var workBase = base
        var workFill = " "
        if zeroFill {
            workFill = "0"
        }
        if workBase.count == len {
            return workBase
        }
        if workBase.count < len {
            while workBase.count < len {
                workBase = workFill + workBase
            }
        } else {
            while workBase.count > len {
                let work = workBase.dropLast(1)
                workBase = String(work)
            }
        }
        return workBase
    }

    public static func ljf(base:String, len:Int) -> String {
        var workBase = base
        if workBase.count == len {
            return workBase
        }
        if workBase.count < len {
            while workBase.count < len {
                workBase = workBase + " "
            }
        } else {
            while workBase.count > len {
                workBase = String(workBase.dropLast(1))
            }
        }
        return workBase
    }

    public static func fmtphone(area:String, exchange:String, number:String) -> String {
        let xa = self.rjf(base: area, len: 3, zeroFill: true)
        let xe = self.rjf(base: exchange, len: 3, zeroFill: true)
        let xn = self.rjf(base: number, len: 4, zeroFill: true)
        return xa + "-" + xe + "-" + xn
    }
    
    public static func deComposePhone(inpphone:String) -> [String] {
        if inpphone == "" { return ["", "", ""] }
        let trimmedPhone = inpphone.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedPhone == "" { return ["", "", ""] }

        let pieces = trimmedPhone.components(separatedBy: "-")
        if pieces.count == 3 { return pieces }
        if pieces.count == 2 { return [""] + pieces }
        if pieces.count == 1 { return ["",""] + pieces }
        return(["999","999","9999"])
    }

}


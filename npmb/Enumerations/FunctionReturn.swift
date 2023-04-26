//
//  FunctionReturn.swift
//  npmb
//
//  Created by Morris Albers on 3/16/23.
//

import Foundation
struct FunctionReturn {
    var status:ReturnType
    var message:String
    var additional:Int
    
    init() {
        status = .successful
        message = ""
        additional = 0
    }
    
    init(status:ReturnType, message:String, additional:Int) {
        self.status = status
        self.message = message
        self.additional = additional
    }
    
    func printLine() -> String {
        
        var pL:String = ""
        switch self.status {
        case .successful:
            pL = ".successful "
        case .empty:
            pL = ".empty"
        case .IOError:
            pL = ".IOError"
        }

        pL += ":"
        pL += self.message
        pL += ":"
        pL += String(self.additional)
        return pL
    }
}

enum ReturnType {
    case successful
    case IOError
    case empty
}

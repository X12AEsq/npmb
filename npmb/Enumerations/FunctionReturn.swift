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
}

enum ReturnType {
    case successful
    case IOError
    case empty
}

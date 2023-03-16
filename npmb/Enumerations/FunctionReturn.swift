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
    
    init() {
        status = .successful
        message = ""
    }
    
    init(status:ReturnType, message:String) {
        self.status = status
        self.message = message
    }
}

enum ReturnType {
    case successful
    case IOError
    case empty
}

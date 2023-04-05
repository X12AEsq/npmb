//
//  ExpandedCause.swift
//  npmb
//
//  Created by Morris Albers on 4/4/23.
//

import Foundation
class ExpandedCause {
    var cause:CauseModel
    var client:ClientModel
    
    init() {
        self.cause = CauseModel()
        self.client = ClientModel()
    }
    
    init(cause:CauseModel, client:ClientModel) {
        self.cause = cause
        self.client = client
    }
}

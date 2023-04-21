//
//  CauseTypeOptions.swift
//  npmb
//
//  Created by Morris Albers on 4/21/23.
//

import Foundation
struct CauseTypeOptions {
    var causeTypeOptions = ["Appt", "Priv", "Fam"]
    
    public static func defaultCauseTypeOption() -> String {
        return "Appt"
    }
}

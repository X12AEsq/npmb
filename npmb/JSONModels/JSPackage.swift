//
//  JSPackage.swift
//  npmb
//
//  Created by Morris Albers on 9/2/24.
//

import Foundation
import Foundation
import SwiftUI
//import SwiftData

class JSPackage: Identifiable, Codable, Hashable {
    static func == (lhs: JSPackage, rhs: JSPackage) -> Bool {
        lhs.JSPId == rhs.JSPId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(JSPId)
    }
    
    var JSPId:Int = 0
    var JSBUAppearances:[JSBUAppearance] = [JSBUAppearance]()
    var JSBUCauses:[JSBUCause] = [JSBUCause]()
    var JSBUClients:[JSBUClient] = [JSBUClient]()
    var JSBUNotes:[JSBUNote] = [JSBUNote]()
    var JSBURepresentations:[JSBURepresentation] = [JSBURepresentation]()
}

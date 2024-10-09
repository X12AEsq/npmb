//
//  JSBURepresentation.swift
//  npmb
//
//  Created by Morris Albers on 9/3/24.
//

import Foundation
import SwiftUI
//import SwiftData
class JSBURepresentation: Identifiable, Codable, Hashable {
    static func == (lhs: JSBURepresentation, rhs: JSBURepresentation) -> Bool {
            lhs.internalID == rhs.internalID
        }
    func hash(into hasher: inout Hasher) {
        hasher.combine(internalID)
    }
    var id: String
    var internalID: Int
    var involvedClient: Int
    var involvedCause: Int
    var involvedAppearances: [Int]
    var involvedNotes: [Int]
    var active: Bool
    var assignedDate: String
    var dispositionDate: String
    var dispositionType: String
    var dispositionAction:String
    var primaryCategory:String
    
    init (fsid:String, intid:Int, client:Int, cause:Int, appearances:[Int], notes:[Int], active:Bool, assigneddate:String, dispositiondate:String, dispositionaction:String, dispositiontype:String, primarycategory:String) {
        self.id = fsid
        self.internalID = intid
        self.involvedClient = client
        self.involvedCause = cause
        self.involvedAppearances = appearances
        self.involvedNotes = notes
        self.active = active
        self.assignedDate = assigneddate
        self.dispositionDate = dispositiondate
        self.dispositionAction = dispositionaction
        self.dispositionType = dispositiontype
        self.primaryCategory = primarycategory
    }

    init() {
        self.id = ""
        self.internalID = 0
        self.involvedClient = 0
        self.involvedCause = 0
        self.involvedAppearances = []
        self.involvedNotes = []
        self.active = false
        self.assignedDate = ""
        self.dispositionDate = ""
        self.dispositionType = "PB"
        self.dispositionAction = "DEF"
        self.primaryCategory = "ORIG"
    }
}

//
//  JSBUCause.swift
//  npmb
//
//  Created by Morris Albers on 9/3/24.
//

import Foundation
import SwiftUI
//import SwiftData
class JSBUCause: Identifiable, Codable, Hashable {
    static func == (lhs: JSBUCause, rhs: JSBUCause) -> Bool {
            lhs.internalID == rhs.internalID
        }
    func hash(into hasher: inout Hasher) {
        hasher.combine(internalID)
    }
    var id:String
    var internalID: Int
    var causeNo: String
    var causeType: String
    var involvedClient: Int
    var involvedRepresentations: [Int]
    var level: String
    var court: String
    var originalCharge: String
    
    init() {
        self.id = ""
        self.internalID = 0
        self.causeNo = ""
        self.involvedClient = 0
        self.involvedRepresentations = []
        self.level = ""
        self.court = ""
        self.originalCharge = ""
        self.causeType = CauseTypeOptions.defaultCauseTypeOption()
    }

    init (
        fsid:String,
        client:Int,
        causeno:String,
        representations:[Int],
        involvedClient:Int,
        level:String,
        court: String,
        originalcharge: String,
        causetype: String,
        intid:Int) {
            self.id = fsid
            self.internalID = intid
            self.causeNo = causeno
            self.involvedClient = client
            self.involvedRepresentations = representations
            self.level = level
            self.court = court
            self.originalCharge = originalcharge
            self.causeType = causetype
    }
}

//
//  CauseMirror.swift
//  npmb
//
//  Created by Morris Albers on 2/28/24.
//

import Foundation
struct CauseMirror: Codable {
    var id:String?
    var internalID: Int
    var causeNo: String
    var causeType: String
    var involvedClient: Int
    var involvedRepresentations: [Int]
    var level: String
    var court: String
    var originalCharge: String
    
    init(id: String? = nil, internalID: Int, causeNo: String, causeType: String, involvedClient: Int, involvedRepresentations: [Int], level: String, court: String, originalCharge: String) {
        self.id = id
        self.internalID = internalID
        self.causeNo = causeNo
        self.causeType = causeType
        self.involvedClient = involvedClient
        self.involvedRepresentations = involvedRepresentations
        self.level = level
        self.court = court
        self.originalCharge = originalCharge
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.internalID = try container.decode(Int.self, forKey: .internalID)
        self.causeNo = try container.decode(String.self, forKey: .causeNo)
        self.causeType = try container.decode(String.self, forKey: .causeType)
        self.involvedClient = try container.decode(Int.self, forKey: .involvedClient)
        self.involvedRepresentations = try container.decode([Int].self, forKey: .involvedRepresentations)
        self.level = try container.decode(String.self, forKey: .level)
        self.court = try container.decode(String.self, forKey: .court)
        self.originalCharge = try container.decode(String.self, forKey: .originalCharge)
    }
    
    init() {
        self.id = nil
        self.internalID = -1
        self.causeNo = ""
        self.causeType = ""
        self.involvedClient = -1
        self.involvedRepresentations = []
        self.level = ""
        self.court = ""
        self.originalCharge = ""
    }
    
    func mirrorCause(cause:CauseModel) -> CauseMirror {
        var mirror = CauseMirror(internalID: -1, causeNo: "", causeType: "", involvedClient: -1, involvedRepresentations: [], level: "", court: "", originalCharge: "")
        mirror.internalID = cause.internalID
        mirror.causeNo = cause.causeNo
        mirror.causeType = cause.causeType
        mirror.involvedClient = cause.involvedClient
        mirror.involvedRepresentations = cause.involvedRepresentations
        mirror.level = cause.level
        mirror.court = cause.court
        mirror.originalCharge = cause.originalCharge
        return mirror
    }
}

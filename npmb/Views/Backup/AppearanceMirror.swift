//
//  AppearanceMirror.swift
//  aLawPractice
//
//  Created by Morris Albers on 3/1/24.
//

import Foundation
struct AppearanceMirror: Codable {
    var internalID: Int
    var client: Int
    var cause: Int
    var representation: Int
    var appearDate: Date
    var appearNote: String
    var practice: Int
    
    init(internalID: Int, client: Int, cause: Int, representation: Int, appearDate: Date, appearNote: String, practice: Int) {
        self.internalID = internalID
        self.client = client
        self.cause = cause
        self.representation = representation
        self.appearDate = appearDate
        self.appearNote = appearNote
        self.practice = practice
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.internalID = try container.decode(Int.self, forKey: .internalID)
        self.client = try container.decode(Int.self, forKey: .client)
        self.cause = try container.decode(Int.self, forKey: .cause)
        self.representation = try container.decode(Int.self, forKey: .representation)
        self.practice = try container.decode(Int.self, forKey: .practice)
        self.appearDate = try container.decode(Date.self, forKey: .appearDate)
        self.representation = try container.decode(Int.self, forKey: .representation)
        self.appearNote = try container.decode(String.self, forKey: .appearNote)
    }
    
    init() {
        self.internalID = -1
        self.client = -1
        self.cause = -1
        self.representation = -1
        self.appearDate = Date.distantPast
        self.appearNote = ""
        self.practice = -1
    }
}

func mirrorAppearance(appearance: AppearanceModel) -> AppearanceMirror {
    var mirror:AppearanceMirror = AppearanceMirror(internalID: -1, client: -1, cause: -1, representation: -1, appearDate: Date.distantPast, appearNote: "", practice: -1)
    mirror.internalID = appearance.internalID
    mirror.client = appearance.involvedClient
    mirror.cause = appearance.involvedCause
    mirror.representation = appearance.involvedRepresentation
    mirror.practice = 2
    mirror.appearDate = DateService.dateString2Date(inDate:appearance.appearDate, inTime:"")
    mirror.appearNote = appearance.appearNote
    return mirror
}


//
//  PracticeMirror.swift
//  npmb
//
//  Created by Morris Albers on 2/18/24.
//

import Foundation
struct PracticeMirror: Codable {
    var addr1: String
    var addr2: String
    var city: String
    var internalId:Int
    var name: String
    var shortName: String
    var state: String
    var testing: Bool
    var zip: String
    var clients: [Int]
    var causes: [Int]
    var representations: [Int]
    var appearances: [Int]
    var notes: [Int]

    init(addr1: String, addr2: String, city: String, internalID:Int, name: String, shortName: String, state: String, testing: Bool, zip: String, clients: [Int], causes: [Int], representations: [Int], appearances: [Int], notes: [Int]) {
        self.addr1 = addr1
        self.addr2 = addr2
        self.city = city
        self.internalId = internalID
        self.name = name
        self.shortName = shortName
        self.state = state
        self.testing = testing
        self.zip = zip
        self.clients = clients
        self.causes = causes
        self.representations = representations
        self.appearances = appearances
        self.notes = notes
    }
}

func mirrorPractice(practice:Practice) -> PracticeMirror {
    var mirror:PracticeMirror = PracticeMirror(addr1: "", addr2: "", city: "", internalID: -1, name: "", shortName: "", state: "", testing: false, zip: "", clients: [], causes: [], representations: [], appearances: [], notes: [])
    mirror.addr1 = practice.addr1 ?? ""
    mirror.addr2 = practice.addr2 ?? ""
    mirror.city = practice.city ?? ""
    mirror.internalId = practice.internalId ?? -1
    mirror.name = practice.name ?? ""
    mirror.shortName = practice.shortName ?? ""
    mirror.state = practice.state ?? ""
    mirror.testing = practice.testing ?? true
    mirror.zip = practice.zip ?? ""
    
    return mirror
}

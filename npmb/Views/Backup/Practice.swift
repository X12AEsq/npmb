//
//  Practice.swift
//  npmb
//
//  Created by Morris Albers on 2/18/24.
//

import Foundation
class Practice {
    var internalId:Int?
    var addr1: String?
    var addr2: String?
    var city: String?
    var name: String?
    var shortName: String?
    var state: String?
    var testing: Bool?
    var zip: String?
//    @Relationship(deleteRule: .cascade, inverse: \Client.practice) var clients: [Client]? = [Client]()
//    @Relationship(deleteRule: .cascade, inverse: \Cause.practice) var causes: [Cause]? = [Cause]()
//    @Relationship(deleteRule: .cascade) var representations: [Representation]? = [Representation]()
//    @Relationship(deleteRule: .cascade, inverse: \Appearance.practice) var appearances: [Appearance]? = [Appearance]()
//    @Relationship(deleteRule: .cascade, inverse: \Note.practice) var notes: [Note]? = [Note]()
//    
//    @Transient var isInTest:Bool {
//        return ((self.testing) != nil)
//    }


    init(addr1: String = "", addr2: String = "", city: String = "", internalID: Int = -1, name: String = "", shortName: String = "", state: String = "", testing: Bool = true, zip: String = "") {
        self.addr1 = addr1
        self.addr2 = addr2
        self.city = city
        self.internalId = internalID
        self.name = name
        self.shortName = shortName
        self.state = state
        self.testing = testing
        self.zip = zip
    }
}

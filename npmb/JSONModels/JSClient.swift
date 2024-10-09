//
//  JSBUClient.swift
//  npmb
//
//  Created by Morris Albers on 9/3/24.
//

import Foundation
import SwiftUI
//import SwiftData
class JSBUClient: Identifiable, Codable, Hashable {
    static func == (lhs: JSBUClient, rhs: JSBUClient) -> Bool {
            lhs.internalID == rhs.internalID
        }
    func hash(into hasher: inout Hasher) {
        hasher.combine(internalID)
    }
    var id: String
    var internalID: Int
    var lastName: String
    var firstName: String
    var middleName: String
    var suffix: String
    var street: String
    var city: String
    var state: String
    var zip: String
    var phone: String
    var note: String
    var jail: String
    var miscDocketDate: String
    var representation: [Int]

    init() {
        self.id = ""
        self.internalID = 0
        self.lastName = ""
        self.firstName = ""
        self.middleName = ""
        self.suffix = ""
        self.street = ""
        self.city = ""
        self.state = StateOptions.defaultStateOption()
        self.zip = ""
        self.phone = ""
        self.note = ""
        self.jail = "N"
        self.miscDocketDate = ""
        self.representation = []
    }
    
    init (fsid:String, intid:Int, lastname:String, firstname: String, middlename: String, suffix: String, street: String, city: String, state: String, zip: String, phone: String, note: String, jail: String, miscDocketDate:String, representation: [Int]) {
        self.id = fsid
        self.internalID = intid
        self.lastName = lastname
        self.firstName = firstname
        self.middleName = middlename
        self.suffix = suffix
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
        self.phone = phone
        self.note = note
        self.jail = jail
        self.miscDocketDate = miscDocketDate
        self.representation = representation
    }
}

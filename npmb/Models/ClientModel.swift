//
//  ClientModel.swift
//  npm9y
//
//  Created by Morris Albers on 7/5/21.
//

import Foundation
import FirebaseFirestore

class ClientModel: Identifiable, Codable, ObservableObject {
    static func == (lhs: ClientModel, rhs: ClientModel) -> Bool {
            lhs.formattedName == rhs.formattedName
        }
    var id: String?
//    @DocumentID var id: String?
    var internalID: Int             // Firebase Integer
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
    var representation: [Int]      // Firebase Integer

    init() {
        self.id = ""
        self.internalID = 0
        self.lastName = ""
        self.firstName = ""
        self.middleName = ""
        self.suffix = ""
        self.street = ""
        self.city = ""
        self.state = ""
        self.zip = ""
        self.phone = ""
        self.note = ""
        self.jail = ""
        self.representation = []
    }
    
    init (fsid:String, intid:Int, lastname:String, firstname: String, middlename: String, suffix: String, street: String, city: String, state: String, zip: String, phone: String, note: String, jail: String, representation: [Int]) {
//        self.id = inid
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
        self.representation = representation
    }
    
    init(Test:Int) {
        self.id = ""
        self.internalID = Test
        self.lastName = "LastName" + String(Test)
        self.firstName = "FirstName" + String(Test)
        self.middleName = "MiddleName" + String(Test)
        self.suffix = ""
        self.street = String(Test) + "Street"
        self.city = "City" + String(Test)
        self.state = "TX"
        self.zip = "1234" + String(Test)
        self.phone = "123-456-789" + String(Test)
        self.note = ""
        self.jail = "N"
        self.representation = []
    }

}

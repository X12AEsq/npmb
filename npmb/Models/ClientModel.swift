//
//  ClientModel.swift
//  npm9y
//
//  Created by Morris Albers on 7/5/21.
//

import Foundation
import FirebaseFirestore
import CloudKit

class ClientModel: Identifiable, Hashable, Codable, ObservableObject {
    static func == (lhs: ClientModel, rhs: ClientModel) -> Bool {
            lhs.formattedName == rhs.formattedName
        }
    func hash(into hasher: inout Hasher) {
        hasher.combine(sortFormat2)
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
    var miscDocketDate: String
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
        self.miscDocketDate = ""
        self.representation = []
    }
    
//    init(ckrecord: CKRecord) {
//        self.id = ""
//        self.internalID = ckrecord[ClientRecordKeys.internalID.rawValue] as? Int ?? -1        self.internalID = ckrecord["internalID"] as Int
//        self.lastName = "LastName" + String(Test)
//        self.firstName = "FirstName" + String(Test)
//        self.middleName = "MiddleName" + String(Test)
//        self.suffix = ""
//        self.street = String(Test) + "Street"
//        self.city = "City" + String(Test)
//        self.state = "TX"
//        self.zip = "1234" + String(Test)
//        self.phone = "123-456-789" + String(Test)
//        self.note = ""
//        self.jail = "N"
//        self.miscDocketDate = ""
//        self.representation = []
//    }
}

extension ClientModel {
    
    enum ClientRecordKeys: String {
        case type = "Client"
        case internalID
        case dateAssigned
        case isCompleted
    }

    var record: CKRecord {
        let record = CKRecord(recordType: ClientRecordKeys.type.rawValue)
        record[ClientRecordKeys.internalID.rawValue] = internalID
//        record["internalID"] = internalID
        record["lastName"] = lastName
        record["firstName"] = firstName
        record["middleName"] = middleName
        record["suffix"] = suffix
        record["street"] = street
        record["city"] = city
        record["state"] = state
        record["zip"] = zip
        record["phone"] = phone
        record["note"] = note
        record["jail"] = jail == "Y" ? true : false
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyy-MM-dd"
        record["miscDocketDate"] = formatter3.date(from: miscDocketDate)
//        record["miscDocketDate"] = DateService.dateString2Date(inDate: miscDocketDate)
        record["representations"] = representation
        return record
    }
}

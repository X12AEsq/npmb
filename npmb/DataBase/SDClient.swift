//
//  SDClient.swift
//  npmb
//
//  Created by Morris Albers on 4/28/24.
//
/*
import Foundation
import SwiftData

@available(iOS 17, *)
@Model
class SDClient {
    var internalID: Int?
    var lastName: String?
    var firstName: String?
    var middleName: String?
    var suffix: String?
    var addr1: String?
    var addr2: String?
    var city: String?
    var state: String?
    var zip: String?
    var phone: String?
    var note: String?
    var miscDocketDate: Date?
    var practice: SDPractice?
    var representations: [Int]? = []
    
    @Transient var fullName:String {
        var workName:String = ""
        var trimName:String = self.lastName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let trimSuffix:String = self.suffix?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        workName = workName + trimName
        if trimSuffix != "" && workName != "" {
            workName = workName + trimSuffix
        }
        if workName != "" {
            workName = workName + ", "
        }
        trimName = self.firstName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        workName = workName + trimName
        if trimName != "" {
            workName = workName + ", "
        }
        trimName = self.middleName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        workName = workName + trimName
        return workName
    }
    
    init(internalID: Int = -1, lastName: String = "", firstName: String = "", middleName: String = "", suffix: String = "", addr1: String = "", addr2: String = "", city: String = "", state: String = "", zip: String = "", phone: String = "", note: String = "", miscDocketDate: Date = Date(), representations: [Int] = []) {
        self.internalID = internalID
        self.lastName = lastName
        self.firstName = firstName
        self.middleName = middleName
        self.suffix = suffix
        self.addr1 = addr1
        self.addr2 = addr2
        self.city = city
        self.state = state
        self.zip = zip
        self.phone = phone
        self.note = note
        self.miscDocketDate = miscDocketDate
        self.representations = representations
    }
}
*/

//
//  CauseModel.swift
//  npmb
//
//  Created by Morris Albers on 2/28/23.
//

import Foundation
import FirebaseFirestore

class CauseModel: Identifiable, Codable, ObservableObject {
//    static func == (lhs: ClientModel, rhs: ClientModel) -> Bool {
//            lhs.formattedName == rhs.formattedName
//        }
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
    var id:String?
    var internalID: Int             // Firebase Integer
    var causeNo: String
    var causeType: String           //  Appointed/Private/Family
    var involvedClient: Int
    var involvedRepresentations: [Int]
    var level: String
    var court: String
    var originalCharge: String
//    var client:ClientModel
    
    init() {
        self.id = ""
        self.internalID = 0
        self.causeNo = ""
        self.involvedClient = 0
        self.involvedRepresentations = []
        self.level = ""
        self.court = ""
        self.originalCharge = ""
        self.causeType = ""
//        self.client = ClientModel()
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
//        clientmodel:ClientModel) {
            self.id = fsid
            self.internalID = intid
            self.causeNo = causeno
            self.involvedClient = client
            self.involvedRepresentations = representations
            self.level = level
            self.court = court
            self.originalCharge = originalcharge
            self.causeType = causetype
//            self.client = clientmodel
    }
    
    init(Test:Int) {
        self.id = ""
        self.internalID = Test
        self.causeNo = "CauseNo" + String(Test)
        self.involvedClient = Test
        self.involvedRepresentations = []
        self.level = "Level" + String(Test)
        self.court = "Court"  + String(Test)
        self.originalCharge = "Charge"  + String(Test)
        self.causeType = "Type"  + String(Test)
//        self.client = ClientModel(Test:Test)
    }
        
}

    

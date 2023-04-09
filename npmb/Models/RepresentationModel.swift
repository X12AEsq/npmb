//
//  RepresentationModel.swift
//  npmb
//
//  Created by Morris Albers on 3/8/23.
//

import Foundation
class RepresentationModel: Identifiable, Codable, ObservableObject {
//    @DocumentID var id: String?
    var id: String?
    var internalID: Int
    var involvedClient: Int
    var involvedCause: Int
    var involvedAppearances: [Int]
    var involvedNotes: [Int]
    var active: Bool                // Open,Closed
    var assignedDate: String
    var dispositionDate: String
    var dispositionType: String     // PB, DISM, OTH ...
    var dispositionAction:String    // PROB, DEF, PTD, C ...
    var primaryCategory:String      // ORIG, MTA, MTR, ...
    var cause:CauseModel
    
    init (fsid:String, intid:Int, client:Int, cause:Int, appearances:[Int], notes:[Int], active:Bool, assigneddate:String, dispositiondate:String, dispositionaction:String, dispositiontype:String, primarycategory:String, causemodel:CauseModel) {
        self.id = fsid
        self.internalID = intid
        self.involvedClient = client
        self.involvedCause = cause
        self.involvedAppearances = appearances
        self.involvedNotes = notes
        self.active = active
        self.assignedDate = assigneddate
        self.dispositionDate = dispositiondate
        self.dispositionAction = dispositionaction
        self.dispositionType = dispositiontype
        self.primaryCategory = primarycategory
        self.cause = causemodel
    }

    init() {
        self.id = ""
        self.internalID = 0
        self.involvedClient = 0
        self.involvedCause = 0
        self.involvedAppearances = []
        self.involvedNotes = []
        self.active = false
        self.assignedDate = ""
        self.dispositionDate = ""
        self.dispositionType = "PB"
        self.dispositionAction = "DEF"
        self.primaryCategory = "ORIG"
        self.cause = CauseModel()
    }
}

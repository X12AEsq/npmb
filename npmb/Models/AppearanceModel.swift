//
//  AppearanceModel.swift
//  npmb
//
//  Created by Morris Albers on 3/8/23.
//

import Foundation
class AppearanceModel: Identifiable, Codable, Hashable, ObservableObject {
    static func == (lhs: AppearanceModel, rhs: AppearanceModel) -> Bool {
        lhs.internalID == rhs.internalID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(internalID)
    }

//    @DocumentID var id: String?
    var id: String?
    var internalID: Int
    var involvedClient: Int
    var involvedCause: Int
    var involvedRepresentation: Int
    var appearDate: String
    var appearTime: String
    var appearNote: String
    var client:ClientModel
 
    init (fsid:String, intid:Int, client:Int, cause:Int, representation:Int, appeardate:String, appeartime:String, appearnote:String, clientmodel:ClientModel) {
        self.id = fsid
        self.internalID = intid
        self.involvedClient = client
        self.involvedCause = cause
        self.involvedRepresentation = representation
        self.appearDate = appeardate
        self.appearTime = appeartime
        self.appearNote = appearnote
        self.client = clientmodel
    }

    init() {
        self.id = ""
        self.internalID = 0
        self.involvedClient = 0
        self.involvedCause = 0
        self.involvedRepresentation = 0
        self.appearDate = ""
        self.appearTime = ""
        self.appearNote = ""
        self.client = ClientModel()
    }
}

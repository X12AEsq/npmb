//
//  JSBUNote.swift
//  npmb
//
//  Created by Morris Albers on 9/2/24.
//

import Foundation
import SwiftUI
//import SwiftData
class JSBUNote: Identifiable, Codable, Hashable {
    static func == (lhs: JSBUNote, rhs: JSBUNote) -> Bool {
        lhs.internalID == rhs.internalID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(internalID)
    }

    var id: String
    var internalID: Int
    var involvedClient: Int
    var involvedCause: Int
    var involvedRepresentation: Int
    var noteDate: String
    var noteTime: String
    var noteNote: String
    var noteCategory: String
 
    init (fsid:String, intid:Int, client:Int, cause:Int, representation:Int, notedate:String, notetime:String, notenote:String, notecat:String) {
        self.id = fsid
        self.internalID = intid
        self.involvedClient = client
        self.involvedCause = cause
        self.involvedRepresentation = representation
        self.noteDate = notedate
        self.noteTime = notetime
        self.noteNote = notenote
        self.noteCategory = notecat
    }

    init() {
        self.id = ""
        self.internalID = 0
        self.involvedClient = 0
        self.involvedCause = 0
        self.involvedRepresentation = 0
        self.noteDate = ""
        self.noteTime = ""
        self.noteNote = ""
        self.noteCategory = ""
    }
}

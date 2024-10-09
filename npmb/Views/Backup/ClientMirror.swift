//
//  ClientMirror.swift
//  npmb
//
//  Created by Morris Albers on 2/16/24.
//

import Foundation

struct ClientMirror: Codable {
    var internalID: Int = -1
    var lastName: String = ""
    var firstName: String = ""
    var middleName: String = ""
    var suffix: String = ""
    var addr1: String = ""
    var addr2: String = ""
    var city: String = ""
    var state: String = ""
    var zip: String = ""
    var phone: String = ""
    var note: String = ""
    var miscDocketDate: Date = Date()
    var representations: [Int] = []
    var causes: [Int] = []
    var notes: [Int] = []
//    var practice: Int = -1
    
    init(internalID: Int, lastName: String, firstName: String, middleName: String, suffix: String, addr1: String, addr2: String, city: String, state: String, zip: String, phone: String, note: String, miscDocketDate: Date, representations: [Int], causes: [Int], notes: [Int], practice: Int) {
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
        self.causes = causes
        self.notes = notes
//        self.practice = practice
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.internalID = try container.decode(Int.self, forKey: .internalID)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.middleName = try container.decode(String.self, forKey: .middleName)
        self.suffix = try container.decode(String.self, forKey: .suffix)
        self.addr1 = try container.decode(String.self, forKey: .addr1)
        self.addr2 = try container.decode(String.self, forKey: .addr2)
        self.city = try container.decode(String.self, forKey: .city)
        self.state = try container.decode(String.self, forKey: .state)
        self.zip = try container.decode(String.self, forKey: .zip)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.note = try container.decode(String.self, forKey: .note)
        self.miscDocketDate = try container.decode(Date.self, forKey: .miscDocketDate)
        self.representations = try container.decode([Int].self, forKey: .representations)
        self.causes = try container.decode([Int].self, forKey: .causes)
        self.notes = try container.decode([Int].self, forKey: .notes)
//        self.practice = try container.decode(Int.self, forKey: .practice)
    }
    
    init() {
        self.internalID = -1
        self.lastName = ""
        self.firstName = ""
        self.middleName = ""
        self.suffix = ""
        self.addr1 = ""
        self.addr2 = ""
        self.city = ""
        self.state = ""
        self.zip = ""
        self.phone = ""
        self.note = ""
        self.miscDocketDate = Date()
        self.representations = []
        self.causes = []
        self.notes = []
//        self.practice = -1
    }
    
    func mirrorClient(client:ClientModel) -> ClientMirror {
        var mirror:ClientMirror = ClientMirror(internalID: -1, lastName: "", firstName: "", middleName: "", suffix: "", addr1: "", addr2: "", city: "", state: "", zip: "", phone: "", note: "", miscDocketDate: Date(), representations: [], causes: [], notes: [], practice: -1)
        mirror.internalID = client.internalID
        mirror.lastName = client.lastName
        mirror.firstName = client.firstName
        mirror.middleName = client.middleName
        mirror.suffix = client.suffix
        mirror.addr1 = client.street
        mirror.addr2 = ""
        mirror.city = client.city
        mirror.state = client.state
        mirror.zip = client.zip
        mirror.phone = client.phone
        mirror.note = client.note
        if client.miscDocketDate == "" {
            mirror.miscDocketDate = Date.distantPast
            
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            mirror.miscDocketDate = formatter.date(from: client.miscDocketDate) ?? Date.distantPast
        }
        mirror.representations = []
        mirror.causes = []
        mirror.notes = []
        
    //    mirror.miscDocketDate = client.miscDocketDate ?? Date()
    //    let reps:[Representation] = client.representations ?? []
    //    for rep in reps {
    //        mirror.representations.append(rep.internalID ?? -1)
    //    }
    //    let caus:[Cause] = client.causes ?? []
    //        for cau in caus {
    //        mirror.causes.append(cau.internalID ?? -1)
    //    }
    //    let nots = client.notes ?? []
    //    for not in nots {
    //        mirror.notes.append(not.internalID ?? -1)
    //    }
    //    mirror.practice = client.practice?.internalId ?? -1
        
    //    "2024-01-03"
         
        return mirror
     }

}

 


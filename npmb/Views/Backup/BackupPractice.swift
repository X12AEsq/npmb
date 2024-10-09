//
//  BackupPractice.swift
//  npmb
//
//  Created by Morris Albers on 2/18/24.
//

import SwiftUI

struct BackupPractice: View {
    @EnvironmentObject var CVModel:CommonViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                HStack {
                    Spacer()
                    ShareLink(item: backupData())
                    Spacer()
                    Button("Press to dismiss") {
                        dismiss()
                    }
                    .buttonStyle(CustomDismissButton())
                    .padding()
                    Spacer()
                }
            }
            .padding(.leading, 10.0)
        }.onAppear( perform: { initWorkArea() } )
    }
    func initWorkArea() {
    }
    
    func backupData() -> String {
        var returnString:String = ""
        var practiceMirrors:[PracticeMirror] = []
        var clientMirrors:[ClientMirror] = []
        var causeMirrors:[CauseMirror] = []
        var appearanceMirrors:[AppearanceMirror] = []
        
        practiceMirrors.append(PracticeMirror(addr1: "151 N. Washington St.", addr2: "PO Box 999", city: "Armpit", internalID: 1, name: "Test Practice", shortName: "Test Law Practice", state: "KY", testing: true, zip: "90909", clients: [], causes: [], representations: [], appearances: [], notes: []))
        practiceMirrors.append(PracticeMirror(addr1: "159 W. Crockett St.", addr2: "PO Box 653", city: "La Grange", internalID: 2, name: "Morris E. Albers II, Attorney and Counsellor at Law, PLLC", shortName: "Albers Law Practice", state: "TX", testing: false, zip: "78945", clients: [], causes: [], representations: [], appearances: [], notes: []))
        
        for cl in CVModel.clients {
            clientMirrors.append(mirrorClient(client: cl))
        }
        
        for ca in CVModel.causes {
            causeMirrors.append(mirrorCause(cause: ca))
        }
        
        for ap in CVModel.appearances {
            appearanceMirrors.append(mirrorAppearance(appearance: ap))
        }
        
        let backup:ComprehensiveMirror = ComprehensiveMirror(practicesBackup: practiceMirrors, clientsBackup: clientMirrors, causesBackup: causeMirrors, appearancesBackup: appearanceMirrors)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.outputFormatting.insert(.sortedKeys)
        if let encoded = try? encoder.encode(backup) {
//                            let work = String(data: encoded, encoding: .utf8)!
            if let jsonString = String(data: encoded, encoding: .utf8) {
                returnString = jsonString
            }
        }
        return returnString
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
        return mirror
     }
    
    func mirrorCause(cause:CauseModel) -> CauseMirror {
        var mirror = CauseMirror(internalID: -1, causeNo: "", causeType: "", involvedClient: -1, involvedRepresentations: [], level: "", court: "", originalCharge: "")
        mirror.internalID = cause.internalID
        mirror.causeNo = cause.causeNo
        mirror.causeType = cause.causeType
        mirror.involvedClient = cause.involvedClient
        mirror.involvedRepresentations = cause.involvedRepresentations
        mirror.level = cause.level
        mirror.court = cause.court
        mirror.originalCharge = cause.originalCharge
        return mirror
    }
}

//#Preview {
//    BackupPractice()
//}

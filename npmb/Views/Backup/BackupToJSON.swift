//
//  BackupToJSON.swift
//  npmb
//
//  Created by Morris Albers on 9/2/24.
//

import SwiftUI

struct BackupToJSON: View {
    @EnvironmentObject var CVModel:CommonViewModel
    @Environment(\.dismiss) var dismiss
    @State var backupDocument:String = ""
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                HStack {
                    Spacer()
                    ShareLink(item: backupDocument)
                    Spacer()
                    Button("Dump to JSON") {
                        dump2JSON()
                    }
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
//        var JSAppearances = [JSBUAppearance]()
    }
    func dump2JSON() {
        CVModel.BUPackage.append(JSPackage())
        CVModel.BUPackage[0].JSBUAppearances = [JSBUAppearance]()
        for appr in CVModel.appearances {
            let jsAppr:JSBUAppearance = JSBUAppearance(fsid: "", intid: appr.internalID, client: appr.involvedClient, cause: appr.involvedCause, representation: appr.involvedRepresentation, appeardate: appr.appearDate, appeartime: appr.appearTime, appearnote: appr.appearNote)
            CVModel.BUPackage[0].JSBUAppearances.append(jsAppr)
        }
        for note in CVModel.notes {
            let JSBUNote:JSBUNote = JSBUNote(fsid: "", intid: note.internalID, client: note.involvedClient, cause: note.involvedCause, representation: note.involvedRepresentation, notedate: note.noteDate, notetime: note.noteTime, notenote: note.noteNote, notecat: note.noteCategory)
            CVModel.BUPackage[0].JSBUNotes.append(JSBUNote)
        }
        for cli in CVModel.clients {
            let JSBUClient:JSBUClient = JSBUClient(fsid: "", intid: cli.internalID, lastname: cli.lastName, firstname: cli.firstName, middlename: cli.middleName, suffix: cli.suffix, street: cli.street, city: cli.city, state: cli.state, zip: cli.zip, phone: cli.phone, note: cli.note, jail: cli.jail, miscDocketDate: cli.miscDocketDate, representation: cli.representation)
            CVModel.BUPackage[0].JSBUClients.append(JSBUClient)
        }
        for cau in CVModel.causes {
            let JSBUCause:JSBUCause = JSBUCause(fsid: "", client: cau.involvedClient, causeno: cau.causeNo, representations: cau.involvedRepresentations, involvedClient: cau.involvedClient, level: cau.level, court: cau.court, originalcharge: cau.originalCharge, causetype: cau.causeType, intid: cau.internalID)
            CVModel.BUPackage[0].JSBUCauses.append(JSBUCause)
        }
        for rep in CVModel.representations {
            let JSBURepresentation:JSBURepresentation = JSBURepresentation(fsid: "", intid: rep.internalID, client: rep.involvedClient, cause: rep.involvedCause, appearances: rep.involvedAppearances, notes: rep.involvedNotes, active: rep.active, assigneddate: rep.assignedDate, dispositiondate: rep.dispositionDate, dispositionaction: rep.dispositionAction, dispositiontype: rep.dispositionType, primarycategory: rep.primaryCategory)
            CVModel.BUPackage[0].JSBURepresentations.append(JSBURepresentation)
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let url = URL.documentsDirectory.appending(path: "BackupPackage.json")
            let data = try encoder.encode(CVModel.BUPackage)
            try data.write(to: url, options: [.atomic, .completeFileProtection])
            backupDocument = String(decoding: data, as: UTF8.self)
        } catch {
            print(error.localizedDescription)
            backupDocument = ""
        }
    }
}

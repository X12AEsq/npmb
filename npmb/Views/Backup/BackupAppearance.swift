//
//  BackupAppearance.swift
//  npmb
//
//  Created by Morris Albers on 4/1/24.
//

import SwiftUI

struct BackupAppearance: View {
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
        backupDocument = "[\n"
        for ap in CVModel.convappearances {
            backupDocument = backupDocument + " {\n"
            backupDocument = backupDocument + "  \"internalID\": " + FormattingService.rjf(base: String(ap.internalID), len: 4, zeroFill: false) + ",\n"
            backupDocument = backupDocument + "  \"appearDate\": " + "\"" + ap.appearDate + "\",\n"
            backupDocument = backupDocument + "  \"appearTime\": " + "\"" + ap.appearTime + "\",\n"
            backupDocument = backupDocument + "  \"appearNote\": " + "\"" + ap.appearNote + "\",\n"
            backupDocument = backupDocument + "  \"practice\": " + FormattingService.rjf(base: "1", len: 4, zeroFill: false) + ",\n"
            backupDocument = backupDocument + "  \"cause\": " + FormattingService.rjf(base: String(ap.involvedCause), len: 4, zeroFill: false) + ",\n"
            backupDocument = backupDocument + "  \"client\": " + FormattingService.rjf(base: String(ap.involvedClient), len: 4, zeroFill: false) + ",\n"
            backupDocument = backupDocument + "  \"representation\": " + FormattingService.rjf(base: String(ap.involvedRepresentation), len: 4, zeroFill: false) + ",\n"
            backupDocument = backupDocument + " },\n"
        }
        backupDocument = backupDocument + "]\n"
    }
}
/*
 "appearancesBackup" : [
   {
     "appearDate" : 731944800,
     "appearNote" : "",
     "cause" : 11,
     "client" : 31,
     "internalID" : 1,
     "practice" : 1,
     "representation" : 1
   }
 ],

 for cl in CVModel.clients {
     backupDocument = backupDocument + " {\n"
     backupDocument = backupDocument + "  \"internalID\": " + FormattingService.rjf(base: String(cl.internalID), len: 4, zeroFill: true) + ",\n"
     backupDocument = backupDocument + "  \"lastName\": " + "\"" + cl.lastName + "\",\n"
     backupDocument = backupDocument + "  \"firstName\": " + "\"" + cl.firstName + "\",\n"
     backupDocument = backupDocument + "  \"middleName\": " + "\"" + cl.middleName + "\",\n"
     backupDocument = backupDocument + "  \"suffix\": " + "\"" + cl.suffix + "\",\n"
     backupDocument = backupDocument + "  \"street\": " + "\"" + cl.street + "\",\n"
     backupDocument = backupDocument + "  \"city\": " + "\"" + cl.city + "\",\n"
     backupDocument = backupDocument + "  \"state\": " + "\"" + cl.state + "\",\n"
     backupDocument = backupDocument + "  \"phone\": " + "\"" + cl.phone + "\",\n"
     backupDocument = backupDocument + "  \"note\": " + "\"" + cl.note + "\",\n"
     backupDocument = backupDocument + "  \"jail\": " + "\"" + cl.jail + "\",\n"
     backupDocument = backupDocument + "  \"miscDocketDate\": " + "\"" + cl.miscDocketDate + "\",\n"
     backupDocument = backupDocument + "  \"phone\": " + "\"" + cl.phone + "\",\n"
     backupDocument = backupDocument + "  \"representation\": " + "[" + fmtArray(intlist: cl.representation) + "]\n"
     backupDocument = backupDocument + " },\n"
 }

 */

//#Preview {
//    BackupAppearance()
//}

//
//  BackupClient.swift
//  npmb
//
//  Created by Morris Albers on 6/14/23.
//

import SwiftUI

struct BackupClient: View {
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
/*
 [
     {
         "internalID": 1,
         "lastName": "Aguilar",
         "firstName": "Adrian",
         "middleName": "",
         "suffix": "",
         "street": "",
         "city": "",
         "state": "",
         "zip": "",
         "phone": "",
         "note":"", "representationID": 0

         "meals": ["breakfast", "lunch", "dinner"]
 },

 */
    func initWorkArea() {
        backupDocument = "[\n"
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


//            backupDocument = backupDocument + cl.firstName + ","
//            backupDocument = backupDocument + cl.middleName + ","
//            backupDocument = backupDocument + cl.suffix + ","
//            backupDocument = backupDocument + cl.street + ","
//            backupDocument = backupDocument + cl.city + ","
//            backupDocument = backupDocument + cl.state + ","
//            backupDocument = backupDocument + cl.zip + ","
//            backupDocument = backupDocument + cl.phone + ","
//            backupDocument = backupDocument + cl.note + ","
//            backupDocument = backupDocument + cl.jail + ","
//            backupDocument = backupDocument + cl.miscDocketDate + ","
//            backupDocument = backupDocument + fmtArray(intlist: cl.representation) + "\n"
            backupDocument = backupDocument + " },\n"
        }
        backupDocument = backupDocument + "]\n"
    }
}

func fmtArray(intlist:[Int]) -> String {
    var rtnString:String = ""
    if intlist.count == 0 {
        return ""
    }
    for inr in intlist {
        if inr != 0 {
            if rtnString == "" {
                rtnString = FormattingService.rjf(base: String(inr), len: 4, zeroFill: true)
            } else {
                rtnString = rtnString + "," + FormattingService.rjf(base: String(inr), len: 4, zeroFill: true)
            }
        }
    }
//    if rtnString != "" {
//        rtnString = rtnString + "\""
//    }
    return rtnString
}

//struct BackupClient_Previews: PreviewProvider {
//    static var previews: some View {
//        BackupClient()
//    }
//}

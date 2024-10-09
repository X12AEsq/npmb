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
            backupDocument = backupDocument + "  \"internalID\": " + FormattingService.rjf(base: String(cl.internalID), len: 4, zeroFill: false) + ",\n"
            backupDocument = backupDocument + "  \"lastName\": " + "\"" + cl.lastName + "\",\n"
            backupDocument = backupDocument + "  \"firstName\": " + "\"" + cl.firstName + "\",\n"
            backupDocument = backupDocument + "  \"middleName\": " + "\"" + cl.middleName + "\",\n"
            backupDocument = backupDocument + "  \"suffix\": " + "\"" + cl.suffix + "\",\n"
            backupDocument = backupDocument + "  \"street\": " + "\"" + cl.street + "\",\n"
            backupDocument = backupDocument + "  \"city\": " + "\"" + cl.city + "\",\n"
            backupDocument = backupDocument + "  \"state\": " + "\"" + cl.state + "\",\n"
            backupDocument = backupDocument + "  \"zip\": " + "\"" + cl.zip + "\",\n"
            backupDocument = backupDocument + "  \"phone\": " + "\"" + cl.phone + "\",\n"
            backupDocument = backupDocument + "  \"note\": " + "\"" + cl.note + "\",\n"
            backupDocument = backupDocument + "  \"jail\": " + "\"" + cl.jail + "\",\n"
            backupDocument = backupDocument + "  \"miscDocketDate\": " + "\"" + cl.miscDocketDate + "\",\n"
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
        
        var backupMirror:[ClientMirror] = []
        for cl in CVModel.clients {
            backupMirror.append(mirrorClient(client:cl))
        }
        print("done")
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
                rtnString = FormattingService.rjf(base: String(inr), len: 4, zeroFill: false)
            } else {
                rtnString = rtnString + "," + FormattingService.rjf(base: String(inr), len: 4, zeroFill: false)
            }
        }
    }
//    if rtnString != "" {
//        rtnString = rtnString + "\""
//    }
    return rtnString
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


//struct BackupClient_Previews: PreviewProvider {
//    static var previews: some View {
//        BackupClient()
//    }
//}

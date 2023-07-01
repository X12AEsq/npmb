//
//  BackupRepresentation.swift
//  npmb
//
//  Created by Morris Albers on 6/16/23.
//

import SwiftUI

struct BackupRepresentation: View {
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
        for re in CVModel.representations {
            backupDocument = backupDocument + " {\n"
            backupDocument = backupDocument + "  \"internalID\": " + FormattingService.rjf(base: String(re.internalID), len: 4, zeroFill: true) + ",\n"
            backupDocument = backupDocument + "  \"involvedClient\": " + FormattingService.rjf(base: String(re.involvedClient), len: 4, zeroFill: true) + ",\n"
            backupDocument = backupDocument + "  \"involvedCause\": " + FormattingService.rjf(base: String(re.involvedCause), len: 4, zeroFill: true) + ",\n"
            backupDocument = backupDocument + "  \"involvedAppearances\": " + "[" + fmtArray(intlist: re.involvedAppearances) + "],\n"
            if re.active {
                backupDocument = backupDocument + "  \"active\": true,\n"
            } else {
                backupDocument = backupDocument + "  \"active\": false,\n"
            }
            backupDocument = backupDocument + "  \"assignedDate\": " + "\"" + re.assignedDate + "\",\n"
            backupDocument = backupDocument + "  \"dispositionDate\": " + "\"" + re.dispositionDate + "\",\n"
            backupDocument = backupDocument + "  \"dispositionType\": " + "\"" + re.dispositionType + "\",\n"
            backupDocument = backupDocument + "  \"dispositionAction\": " + "\"" + re.dispositionAction + "\",\n"
            backupDocument = backupDocument + "  \"primaryCategory\": " + "\"" + re.primaryCategory + "\"\n"
            backupDocument = backupDocument + " },\n"
        }
        backupDocument = backupDocument + "]\n"
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
        return rtnString
    }
}

//struct BackupRepresentation_Previews: PreviewProvider {
//  static var previews: some View {
//      BackupRepresentation()
//  }
//}

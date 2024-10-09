//
//  BackupCause.swift
//  npmb
//
//  Created by Morris Albers on 6/15/23.
//

import SwiftUI

struct BackupCause: View {
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
        for ca in CVModel.causes {
            backupDocument = backupDocument + " {\n"
            backupDocument = backupDocument + "  \"internalID\": " + FormattingService.rjf(base: String(ca.internalID), len: 4, zeroFill: false) + ",\n"
            backupDocument = backupDocument + "  \"causeNo\": " + "\"" + ca.causeNo + "\",\n"
            backupDocument = backupDocument + "  \"causeType\": " + "\"" + ca.causeType + "\",\n"
            backupDocument = backupDocument + "  \"involvedClient\": " + FormattingService.rjf(base: String(ca.involvedClient), len: 4, zeroFill: false) + ",\n"
            backupDocument = backupDocument + "  \"involvedRepresentations\": " + "[" + fmtArray(intlist: ca.involvedRepresentations) + "],\n"
            backupDocument = backupDocument + "  \"level\": " + "\"" + ca.level + "\",\n"
            backupDocument = backupDocument + "  \"court\": " + "\"" + ca.court + "\",\n"
            backupDocument = backupDocument + "  \"originalCharge\": " + "\"" + ca.originalCharge + "\"\n"
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
                    rtnString = FormattingService.rjf(base: String(inr), len: 4, zeroFill: false)
                } else {
                    rtnString = rtnString + "," + FormattingService.rjf(base: String(inr), len: 4, zeroFill: false)
                }
            }
        }
        return rtnString
    }
}


//struct BackupCause_Previews: PreviewProvider {
//  static var previews: some View {
//      BackupCause()
//  }
//}

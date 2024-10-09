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
        CVModel.convrepresentations = CVModel.representations
        CVModel.convappearances = CVModel.appearances
        CVModel.convnotes = CVModel.notes
        
        backupDocument = "[\n"
        for re in CVModel.convrepresentations {
            backupDocument = backupDocument + " {\n"
            backupDocument = backupDocument + "  \"internalID\": " + FormattingService.rjf(base: String(re.internalID), len: 4, zeroFill: false) + ",\n"
            backupDocument = backupDocument + "  \"involvedClient\": " + FormattingService.rjf(base: String(re.involvedClient), len: 4, zeroFill: false) + ",\n"
            
            backupDocument = backupDocument + "  \"involvedCause\": " + FormattingService.rjf(base: String(re.involvedCause), len: 4, zeroFill: false) + ",\n"
            
//            backupDocument = backupDocument + "  \"involvedAppearances\": " + "[" + fmtArray(intlist: re.involvedAppearances) + "],\n"
            
// Start appearance revision
            backupDocument = backupDocument + "  \"involvedAppearances\": " + "["
            var first:Bool = true
            for ap in CVModel.convappearances.filter( { $0.involvedRepresentation == re.internalID } ) {
                if !first {
                    backupDocument = backupDocument + ",\n"
                } else {
                    backupDocument = backupDocument + "\n"
                    first = false
                }
                backupDocument = backupDocument + "   {\n"
                backupDocument = backupDocument + "    \"internalID\": " + FormattingService.rjf(base: String(ap.internalID), len: 4, zeroFill: false) + ",\n"
                backupDocument = backupDocument + "    \"appearDate\": " + "\"" + ap.appearDate + "\",\n"
                backupDocument = backupDocument + "    \"appearTime\": " + "\"" + ap.appearTime + "\",\n"
                backupDocument = backupDocument + "    \"appearNote\": " + "\"" + ap.appearNote + "\",\n"
                backupDocument = backupDocument + "    \"practice\": " + FormattingService.rjf(base: "1", len: 4, zeroFill: false) + ",\n"
                backupDocument = backupDocument + "    \"cause\": " + FormattingService.rjf(base: String(ap.involvedCause), len: 4, zeroFill: false) + ",\n"
                backupDocument = backupDocument + "    \"client\": " + FormattingService.rjf(base: String(ap.involvedClient), len: 4, zeroFill: false) + ",\n"
                backupDocument = backupDocument + "    \"representation\": " + FormattingService.rjf(base: String(ap.involvedRepresentation), len: 4, zeroFill: false) + "\n"
                backupDocument = backupDocument + "   }\n"
            }
            backupDocument = backupDocument + "  ],\n"
            
            CVModel.convappearances = CVModel.convappearances .filter( { $0.involvedRepresentation != re.internalID } )
// end appearance revision
            
//            backupDocument = backupDocument + "  \"involvedNotes\": " + "[" + fmtArray(intlist: re.involvedNotes) + "],\n"
            
// Start note revision
            backupDocument = backupDocument + "  \"involvedNotes\": " + "["
            first = true
            for no in CVModel.convnotes.filter( { $0.involvedRepresentation == re.internalID } ) {
                if !first {
                    backupDocument = backupDocument + ",\n"
                } else {
                    backupDocument = backupDocument + "\n"
                    first = false
                }
                backupDocument = backupDocument + "     {\n"
                backupDocument = backupDocument + "    \"internalID\": " + FormattingService.rjf(base: String(no.internalID), len: 4, zeroFill: false) + ",\n"
                backupDocument = backupDocument + "    \"noteDate\": " + "\"" + no.noteDate + "\",\n"
                backupDocument = backupDocument + "    \"noteTime\": " + "\"" + no.noteTime + "\",\n"
                backupDocument = backupDocument + "    \"noteNote\": " + "\"" + no.noteNote + "\",\n"
                backupDocument = backupDocument + "    \"noteCategory\": " + "\"" + no.noteCategory + "\",\n"
                backupDocument = backupDocument + "    \"practice\": " + FormattingService.rjf(base: "1", len: 4, zeroFill: false) + ",\n"
                backupDocument = backupDocument + "    \"cause\": " + FormattingService.rjf(base: String(no.involvedCause), len: 4, zeroFill: false) + ",\n"
                backupDocument = backupDocument + "    \"client\": " + FormattingService.rjf(base: String(no.involvedClient), len: 4, zeroFill: false) + ",\n"
                backupDocument = backupDocument + "    \"representation\": " + FormattingService.rjf(base: String(no.involvedRepresentation), len: 4, zeroFill: false) + "\n"
                backupDocument = backupDocument + "     }\n"
            }
            backupDocument = backupDocument + "  ],\n"
            CVModel.convnotes = CVModel.convnotes .filter( { $0.involvedRepresentation != re.internalID } )

// End note revision

            if re.active {
                backupDocument = backupDocument + "  \"active\": \"Y\",\n"
            } else {
                backupDocument = backupDocument + "  \"active\": \"N\",\n"
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
                    rtnString = FormattingService.rjf(base: String(inr), len: 4, zeroFill: false)
                } else {
                    rtnString = rtnString + "," + FormattingService.rjf(base: String(inr), len: 4, zeroFill: false)
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
